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
- (NSDate *)dateSince1970FromDictionary:(NSDictionary *)dictionary
                                    key:(NSString *)key;

/**
 * @param dictionary The dictionary containing the NSDate object.
 * @param key The key into the dictionary containing the date.
 * @return The date value as the number of milliseconds since 1970.
 */
- (NSNumber *)dateAsNumberSince1970FromDictionary:(NSDictionary *)dictionary
                                              key:(NSString *)key;

@end
