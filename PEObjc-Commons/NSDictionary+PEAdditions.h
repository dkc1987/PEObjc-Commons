//
//  NSDictionary+PEAdditions.h
//  PEObjc-Commons
//
//  Created by Paul Evans on 6/3/15.
//  Copyright (c) 2015 Paul Evans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (PEAdditions)

/**
 *  @param dictionary The dictionary containing the date value (as the number of milliseconds since 1970).
 *  @key key The key into the dictionary containing the value.
 *  @return NSDate representation of the date value.
 */
- (NSDate *)dateSince1970ForKey:(NSString *)key;

@end
