/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "XCUIElement.h"

@interface XCUIElement (FBScrolling)

/**
 Scrolls receiver up by one screen height
 */
- (void)fb_scrollUp;

/**
 Scrolls receiver down by one screen height
 */
- (void)fb_scrollDown;

/**
 Scrolls receiver left by one screen width
 */
- (void)fb_scrollLeft;

/**
 Scrolls receiver right by one screen width
 */
- (void)fb_scrollRight;

/**
 Scrolls parent scroll view till receiver is visible.

 @param error If there is an error, upon return contains an NSError object that describes the problem.
 @return YES if the operation succeeds, otherwise NO.
 */
- (BOOL)fb_scrollToVisibleWithError:(NSError **)error;

/**
 Scrolls parent scroll view till receiver is visible. Whenever element is invisible it scrolls by normalizedScrollDistance
 in it's direction. Eg. if normalizedScrollDistance is equal to 0.5, each step will scroll by half of scroll view's size.

 @param normalizedScrollDistance single scroll step normalized (0.0 - 1.0) distance
 @param error If there is an error, upon return contains an NSError object that describes the problem.
 @return YES if the operation succeeds, otherwise NO.
 */
- (BOOL)fb_scrollToVisibleWithNormalizedScrollDistance:(CGFloat)normalizedScrollDistance error:(NSError **)error;

@end
