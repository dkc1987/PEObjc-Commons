//
//  UIImage+PEAdditions.m
//  PEObjc-Commons
//
//  Created by Paul Evans on 7/14/15.
//  Copyright (c) 2015 Paul Evans. All rights reserved.
//

#import "UIImage+PEAdditions.h"
#import "PEUIUtils.h"

@implementation UIImage (PEAdditions)

#pragma mark - Syncable Images

+ (UIImage *)syncable {
  return [PEUIUtils bundleImageWithName:@"sychronization"];
}

+ (UIImage *)syncableIcon {
  return [PEUIUtils bundleImageWithName:@"sychronization-icon"];
}

+ (UIImage *)syncableMedIcon {
  return [PEUIUtils bundleImageWithName:@"sychronization-med-icon"];
}

#pragma mark - Unsyncable Images

+ (UIImage *)unsyncable {
  return [PEUIUtils bundleImageWithName:@"unsychronization"];
}

+ (UIImage *)unsyncableIcon {
  return [PEUIUtils bundleImageWithName:@"unsychronization-icon"];
}

+ (UIImage *)unsyncableMedIcon {
  return [PEUIUtils bundleImageWithName:@"unsychronization-med-icon"];
}

@end
