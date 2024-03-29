// Copyright 2010 Cyrus Najmabadi
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

#import "Person.h"

Person* person(NSString* name, NSString* link) {
  return [Person personWithName:name link:link];
}

@interface Person()
@property (copy) NSString* name;
@property (copy) NSString* link;
@end


@implementation Person

@synthesize name;
@synthesize link;

- (void) dealloc {
  self.name = nil;
  self.link = nil;

  [super dealloc];
}


- (id) initWithName:(NSString*) name_
               link:(NSString*) link_ {
  if ((self = [super init])) {
    self.name = name_;
    self.link = link_;
  }

  return self;
}


+ (Person*) personWithName:(NSString*) name link:(NSString*) link {
  return [[[Person alloc] initWithName:name link:link] autorelease];
}

@end
