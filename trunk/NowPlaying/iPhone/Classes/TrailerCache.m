// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "TrailerCache.h"

#import "AppDelegate.h"
#import "Application.h"
#import "DifferenceEngine.h"
#import "FileUtilities.h"
#import "Model.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "OperationQueue.h"

@interface TrailerCache()
@property (retain) NSDictionary* index;
@property (retain) NSArray* indexKeys;
@end


@implementation TrailerCache

@synthesize index;
@synthesize indexKeys;

- (void) dealloc {
    self.index = nil;
    self.indexKeys = nil;

    [super dealloc];
}


+ (TrailerCache*) cache {
    return [[[TrailerCache alloc] init] autorelease];
}


- (NSString*) trailerFile:(Movie*) movie {
    NSString* name = [[FileUtilities sanitizeFileName:movie.canonicalTitle] stringByAppendingPathExtension:@"plist"];
    return [[Application trailersDirectory] stringByAppendingPathComponent:name];
}


- (BOOL) tooSoon:(NSDate*) date {
    return date.timeIntervalSinceNow < (3 * ONE_DAY);
}


- (void) updateMovieDetailsWorker:(Movie*) movie {
    NSDate* downloadDate = [FileUtilities modificationDate:[self trailerFile:movie]];
    if (downloadDate != nil) {
        if ([self tooSoon:downloadDate]) {
            return;
        }
    }

    DifferenceEngine* engine = [DifferenceEngine engine];
    NSInteger arrayIndex = [engine findClosestMatchIndex:movie.canonicalTitle.lowercaseString
                                                 inArray:indexKeys];
    if (arrayIndex == NSNotFound) {
        // no trailer for this movie.  record that fact.  we'll try again later
        [FileUtilities writeObject:[NSArray array]
                            toFile:[self trailerFile:movie]];
        return;
    }

    NSArray* studioAndLocation = [index objectForKey:[indexKeys objectAtIndex:arrayIndex]];
    NSString* studio = [studioAndLocation objectAtIndex:0];
    NSString* location = [studioAndLocation objectAtIndex:1];

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupTrailerListings?studio=%@&name=%@", [Application host], studio, location];
    NSString* trailersString = [NetworkUtilities stringWithContentsOfAddress:url];
    if (trailersString == nil) {
        // didn't get any data.  ignore this for now.
        return;
    }

    NSArray* trailers = [trailersString componentsSeparatedByString:@"\n"];
    NSMutableArray* final = [NSMutableArray array];
    for (NSString* trailer in trailers) {
        if (trailer.length > 0) {
            [final addObject:trailer];
        }
    }

    [FileUtilities writeObject:final toFile:[self trailerFile:movie]];

    if (final.count > 0) {
        [AppDelegate minorRefresh];
    }
}


- (void) generateIndexWorker:(NSString*) indexText {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];

    NSArray* rows = [indexText componentsSeparatedByString:@"\n"];
    for (NSString* row in rows) {
        NSArray* values = [row componentsSeparatedByString:@"\t"];
        if (values.count != 3) {
            continue;
        }

        NSString* fullTitle = [values objectAtIndex:0];
        NSString* studio = [values objectAtIndex:1];
        NSString* location = [values objectAtIndex:2];

        [result setObject:[NSArray arrayWithObjects:studio, location, nil]
                   forKey:fullTitle.lowercaseString];
    }

    self.index = result;
    self.indexKeys = index.allKeys;
}


- (BOOL) tryGenerateIndex {
    BOOL result;
    [dataGate lock];
    {
        if (index == nil) {
            NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupTrailerListings?q=index", [Application host]];
            NSString* indexText = [NetworkUtilities stringWithContentsOfAddress:url];
            if (indexText != nil) {
                [self generateIndexWorker:indexText];
                [self clearUpdatedMovies];
            }
        }

        result = index != nil;
    }
    [dataGate unlock];
    return result;
}


- (void) updateMovieDetails:(Movie*) movie {
    if ([self tryGenerateIndex]) {
        [self updateMovieDetailsWorker:movie];
    }
}


- (NSArray*) trailersForMovie:(Movie*) movie {
    NSArray* trailers = [FileUtilities readObject:[self trailerFile:movie]];
    if (trailers == nil) {
        return [NSArray array];
    }
    return trailers;
}

@end