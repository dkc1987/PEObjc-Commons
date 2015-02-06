//
// PEUtilsTests.m
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
#import "PELangDummyCar.h"
#import <Kiwi/Kiwi.h>

SPEC_BEGIN(PEUtilsSpec)

context(@"Address helpers", ^{
  it(@"is working", ^{
    [[[PEUtils addressStringFromStreet:@"5 Main St." city:@"Albany" state:@"NY" zip:@"12309"] should]
     equal:@"5 Main St., Albany, NY, 12309"];
    [[[PEUtils addressStringFromStreet:nil city:nil state:nil zip:@"12309"] should]
     equal:@"12309"];
    [[[PEUtils addressStringFromStreet:@"5 Main St." city:nil state:nil zip:@"12309"] should]
     equal:@"5 Main St., 12309"];
    [[[PEUtils addressStringFromStreet:nil city:@"Albany" state:nil zip:@"12309"] should]
     equal:@"Albany, 12309"];
    [[[PEUtils addressStringFromStreet:nil city:@"Albany" state:nil zip:nil] should]
     equal:@"Albany"];
    [[[PEUtils addressStringFromStreet:nil city:nil state:@"NY" zip:nil] should]
     equal:@"NY"];
  });
});

context(@"Equality Helpers", ^{
  PELangDummyCar * (^newCar)(NSString *, NSString *, NSString *, BOOL) =
  ^(NSString *paintColor,
    NSString *horsepower,
    NSString *prodDtStr,
    BOOL cleanHistory) {
    PELangDummyCar *car = [[PELangDummyCar alloc] init];
    [car setPaintColor:paintColor];
    [car setHorsepower:[NSDecimalNumber decimalNumberWithString:horsepower]];
    [car setProductionDate:[PEUtils
                            dateFromString:prodDtStr
                            withPattern:@"MM-dd-YYYY"]];
    [car setCleanHistory:cleanHistory];
    return car;
  };

  it(@"works when properties are non-nil and equal", ^{
    PELangDummyCar *car1 = newCar(@"blue", @"300.50", @"01-23-1978", YES);
    PELangDummyCar *car2 = newCar(@"blue", @"300.5", @"01-23-1978", YES);
    [[theValue([PEUtils isNumProperty:@selector(horsepower)
                             equalFor:car1
                                  and:car2]) should] beYes];
    [[theValue([PEUtils isStringProperty:@selector(paintColor)
                                equalFor:car1
                                     and:car2]) should] beYes];
    [[theValue([PEUtils isDateProperty:@selector(productionDate)
                              equalFor:car1
                                   and:car2]) should] beYes];
    [[theValue([PEUtils isDateProperty:@selector(productionDate)
                   msprecisionEqualFor:car1
                                   and:car2]) should] beYes];
    [[theValue([PEUtils isBoolProperty:@selector(cleanHistory)
                              equalFor:car1
                                   and:car2]) should] beYes];
    });

  it(@"works when properties are non-nil and not equal", ^{
      PELangDummyCar *car1 = newCar(@"blue", @"300.50", @"03-16-1978", YES);
      PELangDummyCar *car2 = newCar(@"yellow", @"200", @"03-28-1974", NO);
      [[theValue([PEUtils isNumProperty:@selector(horsepower)
                               equalFor:car1
                                    and:car2]) should] beNo];
      [[theValue([PEUtils isStringProperty:@selector(paintColor)
                                  equalFor:car1
                                       and:car2]) should] beNo];
      [[theValue([PEUtils isDateProperty:@selector(productionDate)
                                equalFor:car1
                                     and:car2]) should] beNo];
    [[theValue([PEUtils isDateProperty:@selector(productionDate)
                   msprecisionEqualFor:car1
                                   and:car2]) should] beNo];
      [[theValue([PEUtils isBoolProperty:@selector(cleanHistory)
                                equalFor:car1
                                     and:car2]) should] beNo];
    });

  it(@"works when properties are both nil", ^{
      PELangDummyCar *car1 = newCar(nil, nil, nil, NO);
      PELangDummyCar *car2 = newCar(nil, nil, nil, NO);
      [[theValue([PEUtils isNumProperty:@selector(horsepower)
                               equalFor:car1
                                    and:car2]) should] beYes];
      [[theValue([PEUtils isStringProperty:@selector(paintColor)
                                  equalFor:car1
                                       and:car2]) should] beYes];
      [[theValue([PEUtils isDateProperty:@selector(productionDate)
                                equalFor:car1
                                     and:car2]) should] beYes];
    [[theValue([PEUtils isDateProperty:@selector(productionDate)
                   msprecisionEqualFor:car1
                                   and:car2]) should] beYes];
      [[theValue([PEUtils isBoolProperty:@selector(cleanHistory)
                                equalFor:car1
                                     and:car2]) should] beYes];
    });

  it(@"works when one of the properties is nil", ^{
      PELangDummyCar *car1 = newCar(nil, nil, nil, NO);
      PELangDummyCar *car2 = newCar(@"red", @"200", @"03-16-1978", YES);
      [[theValue([PEUtils isNumProperty:@selector(horsepower)
                               equalFor:car1
                                    and:car2]) should] beNo];
      [[theValue([PEUtils isStringProperty:@selector(paintColor)
                                  equalFor:car1
                                       and:car2]) should] beNo];
      [[theValue([PEUtils isDateProperty:@selector(productionDate)
                                equalFor:car1
                                     and:car2]) should] beNo];
    [[theValue([PEUtils isDateProperty:@selector(productionDate)
                   msprecisionEqualFor:car1
                                   and:car2]) should] beNo];
      [[theValue([PEUtils isBoolProperty:@selector(cleanHistory)
                                equalFor:car1
                                     and:car2]) should] beNo];
    });
  });

context(@"dictionaryPutterForDictionary:", ^{
    it(@"works for normal inputs", ^{
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        PEDictionaryPutter dictPutter =
          [PEUtils dictionaryPutterForDictionary:dictionary];
        PELangDummyCar *car = [[PELangDummyCar alloc] init];
        [car setPaintColor:@"red"];
        [[dictionary objectForKey:@"color-key"] shouldBeNil];
        dictPutter(car, @selector(paintColor), @"color-key");
        [[dictionary objectForKey:@"color-key"] shouldNotBeNil];
        [[[dictionary objectForKey:@"color-key"] should] equal:@"red"];
      });
  });

context(@"dictionaryFromArray:selectorAsKey:", ^{
    it(@"works for normal inputs", ^{
        NSDictionary *dictionary =
          [PEUtils dictionaryFromArray:@[@"AbC", @"ddd", @"eFF"]
                         selectorAsKey:@selector(lowercaseString)];
        [dictionary shouldNotBeNil];
        [[theValue([dictionary count]) should] equal:theValue(3)];
        NSString *str = [dictionary objectForKey:@"abc"];
        [str shouldNotBeNil];
        [[str should] equal:@"AbC"];
        str = [dictionary objectForKey:@"ddd"];
        [str shouldNotBeNil];
        [[str should] equal:@"ddd"];
        str = [dictionary objectForKey:@"eff"];
        [str shouldNotBeNil];
        [[str should] equal:@"eFF"];
      });
  });

SPEC_END
