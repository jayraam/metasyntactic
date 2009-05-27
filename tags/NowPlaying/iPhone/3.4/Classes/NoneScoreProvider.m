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

#import "NoneScoreProvider.h"

@implementation NoneScoreProvider

- (void) dealloc {
    [super dealloc];
}


- (id) initWithModel:(Model*) model_ {
    if (self = [super initWithModel:model_]) {
    }

    return self;
}


+ (NoneScoreProvider*) providerWithModel:(Model*) model; {
    return [[[NoneScoreProvider alloc] initWithModel:model] autorelease];
}


- (NSString*) providerName {
    return @"None";
}


- (NSString*) lookupServerHash {
    return @"0";
}


- (NSDictionary*) lookupServerScores {
    return [NSDictionary dictionary];
}

@end