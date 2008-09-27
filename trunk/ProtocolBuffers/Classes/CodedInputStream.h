// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

@interface CodedInputStream : NSObject {
    NSMutableData* buffer;
    int32_t bufferSize;
    int32_t bufferSizeAfterLimit;
    int32_t bufferPos;
    NSInputStream* input;
    int32_t lastTag;
    
    /**
     * The total number of bytes read before the current buffer.  The total
     * bytes read up to the current position can be computed as
     * {@code totalBytesRetired + bufferPos}.
     */
    int32_t totalBytesRetired;
    
    /** The absolute position of the end of the current message. */
    int32_t currentLimit;
    
    /** See setRecursionLimit() */
    int32_t recursionDepth;
    int32_t recursionLimit;
    
    /** See setSizeLimit() */
    int32_t sizeLimit;
}


@property (retain) NSMutableData* buffer;
@property (retain) NSInputStream* input;


- (int32_t) readTag;
- (BOOL) refillBuffer:(BOOL) mustSucceed;

- (Float64) readDouble;
- (Float32) readFloat;
- (int64_t) readUInt64;
- (int32_t) readUInt32;
- (int64_t) readInt64;
- (int32_t) readInt32;
- (int64_t) readFixed64;
- (int32_t) readFixed32;
- (int32_t) readEnum;
- (int32_t) readSFixed32;
- (int64_t) readSFixed64;
- (int32_t) readSInt32;
- (int64_t) readSInt64;

- (int8_t) readRawByte;
- (int32_t) readRawVarint32;
- (int64_t) readRawVarint64;
- (int32_t) readRawLittleEndian32;
- (int64_t) readRawLittleEndian64;
- (NSData*) readRawData:(int32_t) size;

- (void) skipRawBytes:(int32_t) size;
- (void) skipMessage;

- (int32_t) pushLimit:(int32_t) byteLimit;
- (void) recomputeBufferSizeAfterLimit;
- (void) popLimit:(int32_t) oldLimit;

int32_t decodeZigZag32(int32_t n);
int64_t decodeZigZag64(int64_t n);

#if 0
+ (CodedInputStream*) createFromInputStream:(NSInputStream*) input;
+ (CodedInputStream*) createFromData:(NSData*) data;
                    
- (void) checkLastTagWas:(int32_t) value;

- (BOOL) skipField:(int32_t) tag;



+ (int32_t) decodeZigZag32:(int32_t) n;
+ (int64_t) decodeZigZag64:(int64_t) n;

- (BOOL) readBool;
- (NSString*) readString;

- (void) readGroup:(int32_t) fieldNumber builder:(id<Message_Builder>) builder extensionRegistry:(ExtensionRegistry*) extensionRegistry;
- (void) readUnknownGroup:(int32_t) fieldNumber builder:(UnknownFieldSet_Builder*) builder;

- (void) readMessage:(id<Message_Builder>) builder extensionRegistry:(ExtensionRegistry*) extensionRegistry;
- (NSData*) readData;

- (id) readPrimitiveField:(Descriptors_FieldDescriptor_Type*) type;
#endif

@end
