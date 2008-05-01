//
//  MovieDetailsViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MovieDetailsViewController.h"


@implementation MovieDetailsViewController

- (id) init
{
    if (self = [super init])
    {
        self.title = @"Movie Details";
        
        UIView* view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        //[view setBackgroundColor:_color];
        self.view = view;
    }
    
    return self;
}

- (void) dealloc
{
    self.view = nil;
    [super dealloc];
}

@end
