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

@interface AbstractNavigationController : UINavigationController {
@protected
  BOOL visible;
  AbstractFullScreenImageListViewController* fullScreenImageListController;
}

- (void) majorRefresh;
- (void) minorRefresh;
- (void) onRotate;

- (void) pushBrowser:(NSString*) address animated:(BOOL) animated;
- (void) pushBrowser:(NSString*) address showSafariButton:(BOOL) showSafariButton animated:(BOOL) animated;

- (void) pushFullScreenImageList:(AbstractFullScreenImageListViewController*) controller;
- (void) popFullScreenImageList;

- (void) pushMapWithCenter:(id<MapPoint>) center animated:(BOOL) animated;
- (void) pushMapWithCenter:(id<MapPoint>) center locations:(NSArray*) locations animated:(BOOL) animated;
- (void) pushMapWithCenter:(id<MapPoint>) center locations:(NSArray*) locations delegate:(id<MapViewControllerDelegate>) delegate animated:(BOOL) animated;

@end