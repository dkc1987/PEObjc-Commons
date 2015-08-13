//
// PEUtils.m
//
// Copyright (c) 2014-2015 PEObjc-Commons
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PEUtils.h"
#import "NSString+PEAdditions.h"
#import <sys/types.h>
#import <sys/sysctl.h>

@implementation PEUtils

#pragma mark - System

+ (NSString *)deviceMake {
  size_t size;
  sysctlbyname("hw.machine", NULL, &size, NULL, 0);
  char *model = malloc(size);
  sysctlbyname("hw.machine", model, &size, NULL, 0);
  NSString *deviceMake = [NSString stringWithCString:model
                                            encoding:NSUTF8StringEncoding];
  free(model);
  return deviceMake;
}

#pragma mark - String

+ (NSString *)concat:(NSArray *)msgs {
  NSString *fullMsg = @"";
  NSUInteger numMsgs = [msgs count];
  for (int i = 0; i < numMsgs; i++) {
    fullMsg = [fullMsg stringByAppendingString:[msgs objectAtIndex:i]];
    if (i + 1 < numMsgs) {
      fullMsg = [fullMsg stringByAppendingString:@"\n"];
    }
  }
  return fullMsg;
}

+ (NSNumber *)nullSafeNumberFromString:(NSString *)value {
  NSNumber *numVal = nil;
  if (value && ![value isBlank]) {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    numVal = [f numberFromString:value];
  }
  return numVal;
}

+ (NSDecimalNumber *)nullSafeDecimalNumberFromString:(NSString *)value {
  NSDecimalNumber *decNum = nil;
  if (value && ![value isBlank]) {
    decNum = [NSDecimalNumber decimalNumberWithString:value];
  }
  return decNum;
}

+ (NSString *)emptyIfNil:(NSString *)value {
  if (value) {
    return value;
  }
  return @"";
}

#pragma mark - Notifications

+ (void)observeIfNotNilNotificationName:(NSString *)notificationName
                               observer:(id)observer
                               selector:(SEL)selector {
  if (notificationName) {
    [[NSNotificationCenter defaultCenter]
      addObserver:observer selector:selector name:notificationName object:nil];
  }
}

#pragma mark - Timer

+ (NSTimer *)startNewTimerWithTargetObject:(NSObject *)object
                                  selector:(SEL)selector
                                  interval:(NSInteger)timerInterval
                                  oldTimer:(NSTimer *)oldTimer {
  if (oldTimer && [oldTimer isValid]) {
    return oldTimer;
  }
  NSTimer *newTimer =
    [NSTimer timerWithTimeInterval:timerInterval
                            target:object
                          selector:selector
                          userInfo:nil
                           repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:newTimer
                            forMode:NSDefaultRunLoopMode];
  return newTimer;
}

+ (void)stopTimer:(NSTimer *)timer {
  if (timer && [timer isValid]) {
    [timer invalidate];
  }
}

#pragma mark - Collections

+ (PEDictionaryPutter)dictionaryPutterForDictionary:(NSMutableDictionary *)dictionary {
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  return ^(id target, SEL selector, NSString *key) {
    id value = [target performSelector:selector];
    if (value) {
      [dictionary setObject:value forKey:key];
    }
  };
  #pragma clang diagnostic pop
}

+ (NSDictionary *)dictionaryFromArray:(NSArray *)array
                        selectorAsKey:(SEL)selector {
  __block NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]
                                             initWithCapacity:[array count]];
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  [array enumerateObjectsUsingBlock:^ (id obj, NSUInteger idx, BOOL *stop) {
    [dictionary setObject:obj forKey:[obj performSelector:selector]];
  }];
  #pragma clang diagnostic pop
  return dictionary;
}

#pragma mark - Address Helpers

+ (NSString *)addressStringFromStreet:(NSString *)street
                                 city:(NSString *)city
                                state:(NSString *)state
                                  zip:(NSString *)zip {
  NSMutableString *address = [NSMutableString string];
  void (^append)(NSString *) = ^(NSString *str) {
    [address appendFormat:@"%@", str];
  };
  void (^appendComma)(void) = ^{
    append(@", ");
  };
  if (street) {
    append(street);
    if (city || state || zip) {
      appendComma();
    }
  }
  if (city) {
    append(city);
    if (state || zip) {
      appendComma();
    }
  }
  if (state) {
    append(state);
    if (zip) {
      appendComma();
    }
  }
  if (zip) {
     append(zip);
  }
  return address;
}

#pragma mark - Conversions

+ (NSNumber *)millisecondsFromDate:(NSDate *)date { 
  if (date) {
    return @([date timeIntervalSince1970] * 1000);
  }
  return nil;
}

+ (NSDecimalNumber *)decimalNumberFromDouble:(double)doubleVal {
  return [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:doubleVal] decimalValue]];
}

+ (NSString *)trueFalseFromBool:(BOOL)boolValue {
  return boolValue ? @"true" : @"false";
}

+ (NSString *)yesNoFromBool:(BOOL)boolValue {
  return boolValue ? @"yes" : @"no";
}

+ (NSDate *)dateFromString:(NSString *)dateValue
               withPattern:(NSString *)datePattern {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:datePattern];
  return [formatter dateFromString:dateValue];
}

+ (NSString *)stringFromDate:(NSDate *)dateValue
                 withPattern:(NSString *)datePattern {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:datePattern];
  return [formatter stringFromDate:dateValue];
}

#pragma mark - Equality

+ (BOOL)isNil:(id)object {
  return object == nil || [object isEqual:[NSNull null]];
}

+ (BOOL)nilSafeIs:(NSObject *)obj1 equalTo:(NSObject *)obj2 {
  if ([PEUtils isNil:obj1]) {
    return [PEUtils isNil:obj2];
  } else if ([PEUtils isNil:obj2]) {
    return false;
  } else {
    return [obj1 isEqual:obj2];
  }
}

+ (BOOL)isString:(NSString *)str1 equalTo:(NSString *)str2 {
  if ([PEUtils isNil:str1]) {
    return [PEUtils isNil:str2];
  } else if ([PEUtils isNil:str2]) {
    return false;
  } else {
    return [str1 isEqualToString:str2];
  }
}

+ (BOOL)isNumber:(NSNumber *)num1 equalTo:(NSNumber *)num2 {
  if ([PEUtils isNil:num1]) {
    return [PEUtils isNil:num2];
  } else if ([PEUtils isNil:num2]) {
    return false;
  } else {
    return [num1 isEqualToNumber:num2];
  }
}

+ (BOOL)isDate:(NSDate *)dt1 equalTo:(NSDate *)dt2 {
  if ([PEUtils isNil:dt1]) {
    return [PEUtils isNil:dt2];
  } else if ([PEUtils isNil:dt2]) {
    return false;
  } else {
    return [dt1 isEqualToDate:dt2];
  }
}

+ (BOOL)isDate:(NSDate *)dt1 msprecisionEqualTo:(NSDate *)dt2 {
  if ([PEUtils isNil:dt1]) {
    return [PEUtils isNil:dt2];
  } else if ([PEUtils isNil:dt2]) {
    return false;
  } else {
    return llround([dt1 timeIntervalSince1970] * 1000.0) ==
      llround([dt2 timeIntervalSince1970] * 1000.0);
  }
}

+ (BOOL)isNumProperty:(SEL)numProp equalFor:(id)object1 and:(id)object2 {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  NSNumber *object1Num = [object1 performSelector:numProp];
  NSNumber *object2Num = [object2 performSelector:numProp];
#pragma clang diagnostic pop
  return [PEUtils isNumber:object1Num equalTo:object2Num];
}

+ (BOOL)isStringProperty:(SEL)strProp equalFor:(id)object1 and:(id)object2 {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  NSString *object1Str = [object1 performSelector:strProp];
  NSString *object2Str = [object2 performSelector:strProp];
#pragma clang diagnostic pop
  return [PEUtils isString:object1Str equalTo:object2Str];
}

+ (BOOL)isDateProperty:(SEL)dtProp equalFor:(id)object1 and:(id)object2 {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  NSDate *object1Dt = [object1 performSelector:dtProp];
  NSDate *object2Dt = [object2 performSelector:dtProp];
#pragma clang diagnostic pop
  return [PEUtils isDate:object1Dt equalTo:object2Dt];
}

+ (BOOL)isDateProperty:(SEL)dtProp msprecisionEqualFor:(id)object1 and:(id)object2 {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  NSDate *object1Dt = [object1 performSelector:dtProp];
  NSDate *object2Dt = [object2 performSelector:dtProp];
#pragma clang diagnostic pop
  return [PEUtils isDate:object1Dt msprecisionEqualTo:object2Dt];
}

+ (BOOL)isBoolProperty:(SEL)boolProp equalFor:(id)object1 and:(id)object2 {
  NSInvocationOperation *invocationOp =
  [[NSInvocationOperation alloc] initWithTarget:object1
                                       selector:boolProp
                                         object:nil];
  NSInvocation *invocation1 = [invocationOp invocation];
  invocationOp = [[NSInvocationOperation alloc] initWithTarget:object2
                                                      selector:boolProp
                                                        object:nil];
  NSInvocation *invocation2 = [invocationOp invocation];
  BOOL boolVal1;
  BOOL boolVal2;
  [invocation1 invoke];
  [invocation1 getReturnValue:&boolVal1];
  [invocation2 invoke];
  [invocation2 getReturnValue:&boolVal2];
  return boolVal1 == boolVal2;
}

@end
