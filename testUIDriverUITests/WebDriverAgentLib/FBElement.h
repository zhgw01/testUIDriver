/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

/**
 Function that returns property name defined by this protocol for given WebDriver Spec property name
 */
NSString *wdAttributeNameForAttributeName(NSString *name);

/**
 Protocol that should be implemented by class that can return element properties defined in WebDriver Spec
 */
@protocol FBElement <NSObject>

/*! Element's frame in CGRect format */
@property (nonatomic, readonly, assign) CGRect wdFrame;

/*! Element's frame in NSDictionary format */
@property (nonatomic, readonly, copy) NSDictionary *wdRect;

/*! Element's size */
@property (nonatomic, readonly, copy) NSDictionary *wdSize;

/*! Element's origin */
@property (nonatomic, readonly, copy) NSDictionary *wdLocation;

/*! Element's name */
@property (nonatomic, readonly, copy) NSString *wdName;

/*! Element's label */
@property (nonatomic, readonly, copy) NSString *wdLabel;

/*! Element's type */
@property (nonatomic, readonly, copy) NSString *wdType;

/*! Element's value */
@property (nonatomic, readonly, strong) id wdValue;

/*! Whether element is enabled */
@property (nonatomic, readonly, getter = isWDEnabled) BOOL wdEnabled;

/*! Whether element is visible */
@property (nonatomic, readonly, getter = isWDVisible) BOOL wdVisible;

/*! Whether element is accessible */
@property (nonatomic, readonly, getter = isWDAccessible) BOOL wdAccessible;

/**
 Returns value of given property specified in WebDriver Spec

 @param name name of property defined in WebDriver Spec
 */
- (id)fb_valueForWDAttributeName:(NSString *)name;

@end
