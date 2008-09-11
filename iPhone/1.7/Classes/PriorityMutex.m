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

#import "PriorityMutex.h"


@implementation PriorityMutex

@synthesize gate;


- (void) dealloc {
    self.gate = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSCondition alloc] init] autorelease];

        highTaskRunning = NO;
        lowTaskRunning = NO;
        highTaskWaitCount = 0;
    }

    return self;
}


+ (PriorityMutex*) mutex {
    return [[[PriorityMutex alloc] init] autorelease];
}


- (void) lockHigh {
    [gate lock];
    {
        highTaskWaitCount++;
        while (highTaskRunning || lowTaskRunning) {
            [gate wait];
        }
        highTaskWaitCount--;
        highTaskRunning = YES;
    }
    [gate unlock];
}


- (void) unlockHigh {
    [gate lock];
    {
        highTaskRunning = NO;
        [gate broadcast];
    }
    [gate unlock];
}


- (void) lockLow {
    [gate lock];
    {
        while (lowTaskRunning || highTaskRunning || highTaskWaitCount > 0) {
            [gate wait];
        }
        lowTaskRunning = YES;
    }
    [gate unlock];
}


- (void) unlockLow {
    [gate lock];
    {
        lowTaskRunning = NO;
        [gate broadcast];
    }
    [gate unlock];
}


@end