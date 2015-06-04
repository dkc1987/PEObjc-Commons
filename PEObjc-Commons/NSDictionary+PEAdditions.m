//
//  NSDictionary+PEAdditions.m
//  PEObjc-Commons
//
//  Created by Paul Evans on 6/3/15.
//  Copyright (c) 2015 Paul Evans. All rights reserved.
//

#import "NSDictionary+PEAdditions.h"

@implementation NSDictionary (PEAdditions)

- (NSDate *)dateSince1970FromDictionary:(NSDictionary *)dictionary
                                    key:(NSString *)key {
  NSDate *date = nil;
  NSNumber *dateNum = dictionary[key];
  if (dateNum) {
    date = [NSDate dateWithTimeIntervalSince1970:([dateNum doubleValue] / 1000)];
  }
  return date;
}

- (NSNumber *)dateAsNumberSince1970FromDictionary:(NSDictionary *)dictionary
                                              key:(NSString *)key {
  NSNumber *num = nil;
  NSDate *date = dictionary[key];
  if (date) {
    num = [NSNumber numberWithInteger:([date timeIntervalSince1970] * 1000)];
  }
  return num;
}

@end
