/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "XCUIElement+Utilities.h"

#import "FBAlert.h"
#import "FBRunLoopSpinner.h"
#import "XCUIElement+WebDriverAttributes.h"

@implementation XCUIElement (Utilities)

- (BOOL)fb_waitUntilFrameIsStable
{
  __block CGRect frame;
  // Initial wait
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
  return
  [[[FBRunLoopSpinner new]
     timeout:5.]
   spinUntilTrue:^BOOL{
     [self resolve];
     const BOOL isSameFrame = CGRectEqualToRect(frame, self.wdFrame);
     frame = self.wdFrame;
     return isSameFrame;
   }];
}

- (BOOL)fb_isObstructedByAlert
{
  return [[FBAlert alertWithApplication:self.application].alertElement fb_obstructsElement:self];
}

- (BOOL)fb_obstructsElement:(XCUIElement *)element
{
  if (!self.exists) {
    return NO;
  }
  [self resolve];
  [element resolve];
  if ([self.lastSnapshot _isAncestorOfElement:element.lastSnapshot]) {
    return NO;
  }
  if ([self.lastSnapshot _matchesElement:element.lastSnapshot]) {
    return NO;
  }
  return YES;
}


@end
