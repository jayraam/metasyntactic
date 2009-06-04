// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

@class PBDescriptor;
@class PBEnumDescriptor;
@class PBEnumValueDescriptor;
@class PBFieldAccessorTable;
@class PBFileDescriptor;
@class PBGeneratedMessage_Builder;
@class ImportEnum;
@class ImportMessage;
@class ImportMessage_Builder;

@interface UnittestImportRoot : NSObject {
}
+ (PBFileDescriptor*) descriptor;
+ (PBFileDescriptor*) buildDescriptor;
@end

@interface ImportEnum : NSObject {
  @private
  int32_t index;
  int32_t value;
}
@property (readonly) int32_t index;
@property (readonly) int32_t value;
+ (ImportEnum*) newWithIndex:(int32_t) index value:(int32_t) value;
+ (ImportEnum*) IMPORT_FOO;
+ (ImportEnum*) IMPORT_BAR;
+ (ImportEnum*) IMPORT_BAZ;

- (int32_t) number;
+ (ImportEnum*) valueOf:(int32_t) value;
- (PBEnumValueDescriptor*) valueDescriptor;
- (PBEnumDescriptor*) descriptor;
+ (PBEnumDescriptor*) descriptor;

+ (ImportEnum*) valueOfDescriptor:(PBEnumValueDescriptor*) desc;
@end

@interface ImportMessage : PBGeneratedMessage {
  @private
  BOOL hasD:1;
  int32_t d;
}
- (BOOL) hasD;
@property (readonly) int32_t d;

+ (PBDescriptor*) descriptor;
- (PBDescriptor*) descriptor;
+ (ImportMessage*) defaultInstance;
- (ImportMessage*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (ImportMessage_Builder*) builder;
+ (ImportMessage_Builder*) builder;
+ (ImportMessage_Builder*) builderWithPrototype:(ImportMessage*) prototype;

+ (ImportMessage*) parseFromData:(NSData*) data;
+ (ImportMessage*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ImportMessage*) parseFromInputStream:(NSInputStream*) input;
+ (ImportMessage*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ImportMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (ImportMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface ImportMessage_Builder : PBGeneratedMessage_Builder {
  @private
  ImportMessage* result;
}

- (PBDescriptor*) descriptor;
- (ImportMessage*) defaultInstance;

- (ImportMessage_Builder*) clear;
- (ImportMessage_Builder*) clone;

- (ImportMessage*) build;
- (ImportMessage*) buildPartial;

- (ImportMessage_Builder*) mergeFromMessage:(id<PBMessage>) other;
- (ImportMessage_Builder*) mergeFromImportMessage:(ImportMessage*) other;
- (ImportMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (ImportMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasD;
- (int32_t) d;
- (ImportMessage_Builder*) setD:(int32_t) value;
- (ImportMessage_Builder*) clearD;
@end