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

#import "ReviewsViewController.h"

#import "Application.h"
#import "GlobalActivityIndicator.h"
#import "MoviesNavigationController.h"
#import "NowPlayingModel.h"
#import "Review.h"
#import "ReviewBodyCell.h"
#import "ReviewTitleCell.h"
#import "Utilities.h"

@implementation ReviewsViewController

@synthesize navigationController;
@synthesize movie;
@synthesize reviews;

- (void) dealloc {
    self.navigationController = nil;
    self.movie = nil;
    self.reviews = nil;

    [super dealloc];
}


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_
                              movie:(Movie*) movie_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = navigationController_;
        self.movie = movie_;

        self.title = NSLocalizedString(@"Reviews", nil);

        self.reviews = [self.model reviewsForMovie:movie];
    }

    return self;
}


- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];
}


- (void) viewDidAppear:(BOOL) animated {
    [self.model saveNavigationStack:self.navigationController];
}


- (UITableViewCell*) reviewCellForRow:(NSInteger) row
                              section:(NSInteger) section {
    Review* review = [reviews objectAtIndex:section];

    if (row == 0) {
        static NSString* reuseIdentifier = @"ReviewTitleCellIdentifier";

        ReviewTitleCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[ReviewTitleCell alloc] initWithModel:self.model
                                                     frame:[UIScreen mainScreen].applicationFrame
                                           reuseIdentifier:reuseIdentifier] autorelease];
        }

        [cell setReview:review];

        return cell;
    } else {
        static NSString* reuseIdentifier = @"ReviewBodyCellIdentifier";

        ReviewBodyCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[ReviewBodyCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame reuseIdentifier:reuseIdentifier] autorelease];
        }

        [cell setReview:review];

        return cell;
    }
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < reviews.count) {
        return [self reviewCellForRow:indexPath.row section:indexPath.section];
    } else {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.model.rottenTomatoesScores) {
            cell.text = @"RottenTomatoes.com";
        } else if (self.model.metacriticScores) {
            cell.text = @"Metacritic.com";
        } else if (self.model.googleScores) {
            cell.text = @"Google.com";
        }
        return cell;
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == reviews.count) {
        return @"For movie reviews and more, visit";
    }

    return nil;
}


- (void)                            tableView:(UITableView*) tableView
     accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < reviews.count) {
        Review* review = [reviews objectAtIndex:indexPath.section];
        if (review.link) {
            [Application openBrowser:review.link];
        }
    } else {
        if (self.model.rottenTomatoesScores) {
            [Application openBrowser:@"http://www.rottentomatoes.com"];
        } else if (self.model.metacriticScores) {
            [Application openBrowser:@"http://www.metacritic.com"];
        } else if (self.model.googleScores) {
            [Application openBrowser:@"http://www.google.com/movies"];
        }
    }
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return reviews.count + 1;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    if (section < reviews.count) {
        return 2;
    } else {
        return 1;
    }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < reviews.count) {
        if (indexPath.row == 1) {
            Review* review = [reviews objectAtIndex:indexPath.section];

            return MAX([ReviewBodyCell height:review], self.tableView.rowHeight);
        }
    }

    return tableView.rowHeight;
}


- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < reviews.count) {
        if (indexPath.row == 1) {
            Review* review = [reviews objectAtIndex:indexPath.section];
            if (review.link.length != 0) {
                return UITableViewCellAccessoryDetailDisclosureButton;
            }
        }

        return UITableViewCellAccessoryNone;
    } else {
        return UITableViewCellAccessoryDetailDisclosureButton;
    }
}


- (void) refresh {
    [self.tableView reloadData];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self refresh];
}


@end