//
// PELangDummyCar.m
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

#import "PELangDummyCar.h"
#import "PEUtils.h"

@implementation PELangDummyCar

#pragma mark - Equality

- (BOOL)isEqualToDummyCar:(PELangDummyCar *)dummyCar {
  if (!dummyCar) { return NO; }
  return [PEUtils isString:[self paintColor] equalTo:[dummyCar paintColor]] &&
    [PEUtils isNumProperty:@selector(horsepower) equalFor:self and:dummyCar] &&
    [PEUtils isBoolProperty:@selector(cleanHistory) equalFor:self and:dummyCar] &&
    [PEUtils isDateProperty:@selector(productionDate) msprecisionEqualFor:self and:dummyCar];
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
  if (self == object) { return YES; }
  if (![object isKindOfClass:[PELangDummyCar class]]) { return NO; }
  return [self isEqualToDummyCar:object];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"paintColor: [%@], horsepower: [%@], cleanHistory: [%d], productionDate: [%@]",
          _paintColor, _horsepower, _cleanHistory, _productionDate];
}

@end
