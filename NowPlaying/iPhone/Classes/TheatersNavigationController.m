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

#import "TheatersNavigationController.h"

#import "AllTheatersViewController.h"

@interface TheatersNavigationController()
@property (retain) AllTheatersViewController* allTheatersViewController_;
@end


@implementation TheatersNavigationController

@synthesize allTheatersViewController_;

property_wrapper(AllTheatersViewController*, allTheatersViewController, AllTheatersViewController);

- (void) dealloc {
    self.allTheatersViewController = nil;

    [super dealloc];
}


- (id) initWithTabBarController:(ApplicationTabBarController*) controller {
    if (self = [super initWithTabBarController:controller]) {
        self.title = NSLocalizedString(@"Theaters", nil);
        self.tabBarItem.title = self.title;
        self.tabBarItem.image = [UIImage imageNamed:@"Theaters.png"];
    }

    return self;
}


- (void) loadView {
    [super loadView];

    if (self.allTheatersViewController == nil) {
        self.allTheatersViewController = [[[AllTheatersViewController alloc] initWithNavigationController:self] autorelease];
        [self pushViewController:self.allTheatersViewController animated:NO];
    }
}

@end