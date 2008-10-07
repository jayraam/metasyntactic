// Protocol Buffers - Google's data interchange format
// Copyright 2008 Google Inc.
// http://code.google.com/p/protobuf/
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

@interface PBUnknownFieldSet : NSObject {
    NSDictionary* fields;
}

@property (retain) NSDictionary* fields;

+ (PBUnknownFieldSet_Builder*) newBuilder:(PBUnknownFieldSet*) copyFrom;
+ (PBUnknownFieldSet*) setWithFields:(NSMutableDictionary*) fields;

+ (PBUnknownFieldSet*) defaultInstance;
+ (PBUnknownFieldSet_Builder*) newBuilder;

- (void) writeAsMessageSetTo:(PBCodedOutputStream*) output;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (NSData*) toData;

- (int32_t) serializedSize;
- (int32_t) serializedSizeAsMessageSet;

- (PBField*) getField:(int32_t) number;

@end
