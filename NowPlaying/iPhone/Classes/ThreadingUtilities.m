//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

#import "ThreadingUtilities.h"

#import "BackgroundInvocation.h"

@implementation ThreadingUtilities


+ (void)       performSelector:(SEL) selector
                      onTarget:(id) target
      inBackgroundWithArgument:(id) argument
                          gate:(NSLock*) gate
                       visible:(BOOL) visible {
    [self performSelector:selector onTarget:target inBackgroundWithArgument:argument gate:gate visible:visible lowPriority:YES];
}


+ (void)       performSelector:(SEL) selector
                      onTarget:(id) target
      inBackgroundWithArgument:(id) argument
                          gate:(NSLock*) gate
                       visible:(BOOL) visible
                   lowPriority:(BOOL) lowPriority {
    BackgroundInvocation* invocation = [BackgroundInvocation invocationWithTarget:target
                                                                         selector:selector
                                                                         argument:argument
                                                                             gate:gate
                                                                          visible:visible
                                                                      lowPriority:lowPriority];
    [invocation performSelectorInBackground:@selector(run) withObject:nil];
}

@end