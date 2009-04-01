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

#import "Movie.h"

#import "StringUtilities.h"
#import "Utilities.h"

@interface Movie()
@property (copy) NSString* identifier;
@property (copy) NSString* canonicalTitle;
@property (copy) NSString* displayTitle;
@property (copy) NSString* rating;
@property NSInteger length;
@property (copy) NSString* imdbAddress;
@property (copy) NSString* poster;
@property (copy) NSString* synopsis;
@property (copy) NSString* studio;
@property (retain) NSDate* releaseDate;
@property (retain) NSArray* directors;
@property (retain) NSArray* cast;
@property (retain) NSArray* genres;
@property (copy) NSString* cachedRatingAndRuntimeString;
@property (retain) NSDictionary* additionalFields;
@end


@implementation Movie

property_definition(identifier);
property_definition(canonicalTitle);
property_definition(displayTitle);
property_definition(rating);
property_definition(length);
property_definition(releaseDate);
property_definition(imdbAddress);
property_definition(poster);
property_definition(synopsis);
property_definition(studio);
property_definition(directors);
property_definition(cast);
property_definition(genres);
property_definition(additionalFields);
@synthesize cachedRatingAndRuntimeString;

- (void) dealloc {
    self.identifier = nil;
    self.canonicalTitle = nil;
    self.rating = nil;
    self.length = 0;
    self.releaseDate = nil;
    self.imdbAddress = nil;
    self.poster = nil;
    self.synopsis = nil;
    self.displayTitle = nil;
    self.studio = nil;
    self.directors = nil;
    self.cast = nil;
    self.genres = nil;
    self.cachedRatingAndRuntimeString = nil;
    self.additionalFields = nil;

    [super dealloc];
}


static NSString* articles[] = {
@"Der", @"Das", @"Ein", @"Eine", @"The",
@"A", @"An", @"La", @"Las", @"Le",
@"Les", @"Los", @"El", @"Un", @"Une",
@"Una", @"Il", @"O", @"Het", @"De",
@"Os", @"Az", @"Den", @"Al", @"En",
@"L'"
};

+ (NSString*) makeCanonical:(NSString*) title {
    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    for (int i = 0; i < ArrayLength(articles); i++) {
        NSString* article = articles[i];
        if ([title hasSuffix:[NSString stringWithFormat:@", %@", article]]) {
            return [NSString stringWithFormat:@"%@ %@", article, [title substringToIndex:(title.length - article.length - 2)]];
        }
    }

    return title;
}


+ (NSString*) makeDisplay:(NSString*) title {
    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    for (int i = 0; i < ArrayLength(articles); i++) {
        NSString* article = articles[i];
        if ([title hasPrefix:[NSString stringWithFormat:@"%@ ", article]]) {
            return [NSString stringWithFormat:@"%@, %@", [title substringFromIndex:(article.length + 1)], article];
        }
    }

    return title;
}


- (id) initWithIdentifier:(NSString*) identifier_
           canonicalTitle:(NSString*) canonicalTitle_
             displayTitle:(NSString*) displayTitle_
                   rating:(NSString*) rating_
                   length:(NSInteger) length_
              releaseDate:(NSDate*) releaseDate_
              imdbAddress:(NSString*) imdbAddress_
                   poster:(NSString*) poster_
                 synopsis:(NSString*) synopsis_
                   studio:(NSString*) studio_
                directors:(NSArray*) directors_
                     cast:(NSArray*) cast_
                   genres:(NSArray*) genres_
         additionalFields:(NSDictionary*) additionalFields_ {
    if (self = [self init]) {
        self.identifier = [StringUtilities nonNilString:identifier_];
        self.canonicalTitle = [StringUtilities nonNilString:canonicalTitle_];
        self.displayTitle = [StringUtilities nonNilString:displayTitle_];
        self.rating = [StringUtilities nonNilString:rating_];
        self.length = length_;
        self.releaseDate = releaseDate_;
        self.imdbAddress = [StringUtilities nonNilString:imdbAddress_];
        self.poster = [StringUtilities nonNilString:poster_];
        self.synopsis = [StringUtilities nonNilString:synopsis_];
        self.studio = [StringUtilities nonNilString:studio_];
        self.directors = [Utilities nonNilArray:directors_];
        self.cast = [Utilities nonNilArray:cast_];
        self.genres = [Utilities nonNilArray:genres_];
        self.additionalFields = [Utilities nonNilDictionary:additionalFields_];
    }

    return self;
}


- (id) initWithCoder:(NSCoder*) coder {
    return [self initWithIdentifier:[coder decodeObjectForKey:identifier_key]
                     canonicalTitle:[coder decodeObjectForKey:canonicalTitle_key]
                       displayTitle:[coder decodeObjectForKey:displayTitle_key]
                             rating:[coder decodeObjectForKey:rating_key]
                             length:[coder decodeIntegerForKey:length_key]
                        releaseDate:[coder decodeObjectForKey:releaseDate_key]
                        imdbAddress:[coder decodeObjectForKey:imdbAddress_key]
                             poster:[coder decodeObjectForKey:poster_key]
                           synopsis:[coder decodeObjectForKey:synopsis_key]
                             studio:[coder decodeObjectForKey:studio_key]
                          directors:[coder decodeObjectForKey:directors_key]
                               cast:[coder decodeObjectForKey:cast_key]
                             genres:[coder decodeObjectForKey:genres_key]
                   additionalFields:[coder decodeObjectForKey:additionalFields_key]];
}


+ (BOOL) isStringDictionary:(id) dictionary {
    if (dictionary == nil) {
        return YES;
    }

    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return NO;
    }

    for (id key in dictionary) {
        if (![key isKindOfClass:[NSString class]]) {
            return NO;
        }

        id value = [dictionary objectForKey:key];
        if (![value isKindOfClass:[NSString class]]) {
            return NO;
        }
    }

    return YES;
}


+ (BOOL) isStringArray:(id) array {
    if (array == nil) {
        return YES;
    }

    if (![array isKindOfClass:[NSArray class]]) {
        return NO;
    }

    for (id value in array) {
        if (![value isKindOfClass:[NSString class]]) {
            return NO;
        }
    }

    return YES;
}


+ (BOOL) canReadDictionary:(NSDictionary*) dictionary {
    return
    [[dictionary objectForKey:identifier_key] isKindOfClass:[NSString class]] &&
    [[dictionary objectForKey:canonicalTitle_key] isKindOfClass:[NSString class]] &&
    [[dictionary objectForKey:displayTitle_key] isKindOfClass:[NSString class]] &&
    [[dictionary objectForKey:rating_key] isKindOfClass:[NSString class]] &&
    [[dictionary objectForKey:imdbAddress_key] isKindOfClass:[NSString class]] &&
    [[dictionary objectForKey:poster_key] isKindOfClass:[NSString class]] &&
    [[dictionary objectForKey:synopsis_key] isKindOfClass:[NSString class]] &&
    [[dictionary objectForKey:studio_key] isKindOfClass:[NSString class]] &&
    [[dictionary objectForKey:releaseDate_key] isKindOfClass:[NSDate class]] &&
    [[dictionary objectForKey:length_key] isKindOfClass:[NSNumber class]] &&
          [self isStringArray:[dictionary objectForKey:directors_key]] &&
          [self isStringArray:[dictionary objectForKey:cast_key]] &&
          [self isStringArray:[dictionary objectForKey:genres_key]] &&
     [self isStringDictionary:[dictionary objectForKey:additionalFields_key]];
}


+ (Movie*) movieWithIdentifier:(NSString*) identifier
                         title:(NSString*) title
                        rating:(NSString*) rating
                        length:(NSInteger) length
                   releaseDate:(NSDate*) releaseDate
                   imdbAddress:(NSString*) imdbAddress
                        poster:(NSString*) poster
                      synopsis:(NSString*) synopsis
                        studio:(NSString*) studio
                     directors:(NSArray*) directors
                          cast:(NSArray*) cast
                        genres:(NSArray*) genres
              additionalFields:(NSDictionary*) additionalFields {
    rating = [rating stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (rating.length == 0) {
        rating = @"NR";
    }

    return [[[Movie alloc] initWithIdentifier:identifier
                               canonicalTitle:[self makeCanonical:title]
                                 displayTitle:[self makeDisplay:title]
                                       rating:rating
                                       length:length
                                  releaseDate:releaseDate
                                  imdbAddress:imdbAddress
                                       poster:poster
                                     synopsis:[StringUtilities stripHtmlCodes:synopsis]
                                       studio:studio
                                    directors:directors
                                         cast:cast
                                       genres:genres
                             additionalFields:additionalFields] autorelease];
}


+ (Movie*) movieWithIdentifier:(NSString*) identifier
                         title:(NSString*) title
                        rating:(NSString*) rating
                        length:(NSInteger) length
                   releaseDate:(NSDate*) releaseDate
                   imdbAddress:(NSString*) imdbAddress
                        poster:(NSString*) poster
                      synopsis:(NSString*) synopsis
                        studio:(NSString*) studio
                     directors:(NSArray*) directors
                          cast:(NSArray*) cast
                        genres:(NSArray*) genres {
    return [Movie movieWithIdentifier:identifier
                                title:title
                               rating:rating
                               length:length
                          releaseDate:releaseDate
                          imdbAddress:imdbAddress
                               poster:poster
                             synopsis:synopsis
                               studio:studio
                            directors:directors
                                 cast:cast
                               genres:genres
                     additionalFields:nil];
}


+ (Movie*) movieWithDictionary:(NSDictionary*) dictionary {
    return [[[Movie alloc] initWithIdentifier:[dictionary objectForKey:identifier_key]
                               canonicalTitle:[dictionary objectForKey:canonicalTitle_key]
                                 displayTitle:[dictionary objectForKey:displayTitle_key]
                                       rating:[dictionary objectForKey:rating_key]
                                       length:[[dictionary objectForKey:length_key] intValue]
                                  releaseDate:[dictionary objectForKey:releaseDate_key]
                                  imdbAddress:[dictionary objectForKey:imdbAddress_key]
                                       poster:[dictionary objectForKey:poster_key]
                                     synopsis:[dictionary objectForKey:synopsis_key]
                                       studio:[dictionary objectForKey:studio_key]
                                    directors:[dictionary objectForKey:directors_key]
                                         cast:[dictionary objectForKey:cast_key]
                                       genres:[dictionary objectForKey:genres_key]
                             additionalFields:[dictionary objectForKey:additionalFields_key]] autorelease];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:identifier                         forKey:identifier_key];
    [dictionary setValue:canonicalTitle                     forKey:canonicalTitle_key];
    [dictionary setValue:displayTitle                       forKey:displayTitle_key];
    [dictionary setValue:rating                             forKey:rating_key];
    [dictionary setValue:[NSNumber numberWithInt:length]    forKey:length_key];
    [dictionary setValue:releaseDate                        forKey:releaseDate_key];
    [dictionary setValue:imdbAddress                        forKey:imdbAddress_key];
    [dictionary setValue:poster                             forKey:poster_key];
    [dictionary setValue:synopsis                           forKey:synopsis_key];
    [dictionary setValue:studio                             forKey:studio_key];
    [dictionary setValue:directors                          forKey:directors_key];
    [dictionary setValue:cast                               forKey:cast_key];
    [dictionary setValue:genres                             forKey:genres_key];
    [dictionary setValue:additionalFields                   forKey:additionalFields_key];
    return dictionary;
}


- (void) encodeWithCoder:(NSCoder*) coder {
    [coder encodeObject:identifier          forKey:identifier_key];
    [coder encodeObject:canonicalTitle      forKey:canonicalTitle_key];
    [coder encodeObject:displayTitle        forKey:displayTitle_key];
    [coder encodeObject:rating              forKey:rating_key];
    [coder encodeInteger:length             forKey:length_key];
    [coder encodeObject:releaseDate         forKey:releaseDate_key];
    [coder encodeObject:imdbAddress         forKey:imdbAddress_key];
    [coder encodeObject:poster              forKey:poster_key];
    [coder encodeObject:synopsis            forKey:synopsis_key];
    [coder encodeObject:studio              forKey:studio_key];
    [coder encodeObject:directors           forKey:directors_key];
    [coder encodeObject:cast                forKey:cast_key];
    [coder encodeObject:genres              forKey:genres_key];
    [coder encodeObject:additionalFields    forKey:additionalFields_key];
}


- (NSString*) description {
    return self.dictionary.description;
}


- (BOOL) isEqual:(id) anObject {
    Movie* other = anObject;

    return [canonicalTitle isEqual:other.canonicalTitle];
}


- (NSUInteger) hash {
    return canonicalTitle.hash;
}


- (id) copyWithZone:(NSZone*) zone {
    return [self retain];
}


- (BOOL) isUnrated {
    return rating.length == 0 ||
    [rating isEqual:@"NR"] ||
    [rating isEqual:@"UR"] ||
    [rating isEqual:@"Not Rated"];
}


- (NSString*) ratingString {
    if (self.isUnrated) {
        return NSLocalizedString(@"Unrated", nil);
    }  else {
        return [NSString stringWithFormat:NSLocalizedString(@"Rated %@", nil), rating];
    }
}


- (NSString*) runtimeString {
    NSString* hoursString = @"";
    NSString* minutesString = @"";

    if (length > 0) {
        NSInteger hours = length / 60;
        NSInteger minutes = length % 60;

        if (hours == 1) {
            hoursString = NSLocalizedString(@"1 hour", nil);
        } else if (hours > 1) {
            hoursString = [NSString stringWithFormat:NSLocalizedString(@"%d hours", nil), hours];
        }

        if (minutes == 1) {
            minutesString = NSLocalizedString(@"1 minute", nil);
        } else if (minutes > 1) {
            minutesString = [NSString stringWithFormat:NSLocalizedString(@"%d minutes", nil), minutes];
        }
    }

    return [NSString stringWithFormat:NSLocalizedString(@"%@ %@", "2 hours 34 minutes"), hoursString, minutesString];
}


- (NSString*) ratingAndRuntimeString {
    if (cachedRatingAndRuntimeString == nil) {
        self.cachedRatingAndRuntimeString =
        [NSString stringWithFormat:NSLocalizedString(@"%@. %@", "Rated R. 2 hours 34 minutes"), self.ratingString, self.runtimeString];
    }

    return cachedRatingAndRuntimeString;
}


+ (NSArray*) encodeArray:(NSArray*) array {
    if (array.count == 0) {
        return [NSArray array];
    }

    NSMutableArray* result = [NSMutableArray array];

    for (Movie* movie in array) {
        [result addObject:movie.dictionary];
    }

    return result;
}


+ (NSArray*) decodeArray:(NSArray*) array {
    if (array.count == 0) {
        return [NSArray array];
    }

    NSMutableArray* result = [NSMutableArray array];

    for (NSDictionary* dictionary in array) {
        [result addObject:[Movie movieWithDictionary:dictionary]];
    }

    return result;
}


- (BOOL) isNetflix {
    return [identifier hasPrefix:@"http://"];
}

@end