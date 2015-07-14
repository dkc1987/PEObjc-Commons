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
  return [PEUIUtils bundleImageWithName:@"synchronization"];
}

+ (UIImage *)syncableIcon {
  return [PEUIUtils bundleImageWithName:@"synchronization-icon"];
}

+ (UIImage *)syncableMedIcon {
  return [PEUIUtils bundleImageWithName:@"synchronization-med-icon"];
}

#pragma mark - Unsyncable Images

+ (UIImage *)unsyncable {
  return [PEUIUtils bundleImageWithName:@"unsynchronization"];
}

+ (UIImage *)unsyncableIcon {
  return [PEUIUtils bundleImageWithName:@"unsynchronization-icon"];
}

+ (UIImage *)unsyncableMedIcon {
  return [PEUIUtils bundleImageWithName:@"unsynchronization-med-icon"];
}

@end
