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

@interface SearchRequest : NSObject {
    NSInteger requestId;
    NSString* value;
    NSString* lowercaseValue;

    NSArray* movies;
    NSArray* theaters;
    NSArray* upcomingMovies;
    NSArray* dvds;
}

@property NSInteger requestId;
@property (copy) NSString* value;
@property (copy) NSString* lowercaseValue;
@property (retain) NSArray* movies;
@property (retain) NSArray* theaters;
@property (retain) NSArray* upcomingMovies;
@property (retain) NSArray* dvds;

+ (SearchRequest*) requestWithId:(NSInteger) requestId
                           value:(NSString*) value
                           model:(NowPlayingModel*) model;


@end