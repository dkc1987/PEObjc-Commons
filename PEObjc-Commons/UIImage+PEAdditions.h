//
//  UIImage+PEAdditions.h
//  PEObjc-Commons
//
//  Created by Paul Evans on 7/14/15.
//  Copyright (c) 2015 Paul Evans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (PEAdditions)

#pragma mark - Syncable Images

+ (UIImage *)syncable;

+ (UIImage *)syncableIcon;

+ (UIImage *)syncableMedIcon;

#pragma mark - Unsyncable Images

+ (UIImage *)unsyncable;

+ (UIImage *)unsyncableIcon;

+ (UIImage *)unsyncableMedIcon;

@end
