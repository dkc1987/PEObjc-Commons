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

void (^mergeTest)(PELangDummyCar *, PELangDummyCar *, PELangDummyCar *, PELangDummyCar *, NSArray *) = ^ (PELangDummyCar *localMaster,
                                                                                                          PELangDummyCar *local,
                                                                                                          PELangDummyCar *remote,
                                                                                                          PELangDummyCar *expectedMergedResult,
                                                                                                          NSArray *expectedMergeConflictFields) {
  NSDictionary *mergeConflicts;
  mergeConflicts = [PEUtils mergeRemoteObject:remote
                              withLocalObject:local
                          previousLocalObject:localMaster
                  getterSetterKeysComparators:@[@[[NSValue valueWithPointer:@selector(paintColor)],
                                                  [NSValue valueWithPointer:@selector(setPaintColor:)],
                                                  ^(SEL getter, id obj1, id obj2) {return [PEUtils isStringProperty:getter equalFor:obj1 and:obj2];},
                                                  ^(PELangDummyCar * localObject, PELangDummyCar * remoteObject) { [localObject setPaintColor:[remoteObject paintColor]];},
                                                  PECarPaintColorField],
                                                @[[NSValue valueWithPointer:@selector(horsepower)],
                                                  [NSValue valueWithPointer:@selector(setHorsepower:)],
                                                  ^(SEL getter, id obj1, id obj2) {return [PEUtils isNumProperty:getter equalFor:obj1 and:obj2];},
                                                  ^(PELangDummyCar * localObject, PELangDummyCar * remoteObject) { [localObject setHorsepower:[remoteObject horsepower]];},
                                                  PECarHorsepowerField],
                                                @[[NSValue valueWithPointer:@selector(cleanHistory)],
                                                  [NSValue valueWithPointer:@selector(setCleanHistory:)],
                                                  ^(SEL getter, id obj1, id obj2) {return [PEUtils isBoolProperty:getter equalFor:obj1 and:obj2];},
                                                  ^(PELangDummyCar * localObject, PELangDummyCar * remoteObject) { [localObject setCleanHistory:[remoteObject cleanHistory]];},
                                                  PECarCleanHistoryField],
                                                @[[NSValue valueWithPointer:@selector(productionDate)],
                                                  [NSValue valueWithPointer:@selector(setProductionDate:)],
                                                  ^(SEL getter, id obj1, id obj2) {return [PEUtils isDateProperty:getter msprecisionEqualFor:obj1 and:obj2];},
                                                  ^(PELangDummyCar * localObject, PELangDummyCar * remoteObject) { [localObject setProductionDate:[remoteObject productionDate]];},
                                                  PECarProductionDateField]]];
  [[theValue([mergeConflicts count]) should] equal:theValue([expectedMergeConflictFields count])];
  for (NSString *expectedMergeConflictField in expectedMergeConflictFields) {
    NSNumber *mergeConflictField = mergeConflicts[expectedMergeConflictField];
    [mergeConflictField shouldNotBeNil];
  }
  [[local should] equal:expectedMergedResult];
};

context(@"Calendar helpers", ^{
  __block NSCalendar *calendar;
  __block NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"MM/dd/yyyy"];
  NSDate *(^d)(NSString *) = ^(NSString *dateStr) {
    return [dateFormatter dateFromString:dateStr];
  };
  beforeEach(^{
    calendar = [NSCalendar currentCalendar];
  });
  it(@"dateFromCalendar:day:month:fromYearOfDate: works", ^{
    NSDate *d1 = [PEUtils dateFromCalendar:calendar day:1 month:1 fromYearOfDate:d(@"06/13/2013")];
    [[d1 should] equal:d(@"01/01/2013")];
    d1 = [PEUtils dateFromCalendar:calendar day:13 month:4 fromYearOfDate:d(@"12/31/2001")];
    [[d1 should] equal:d(@"04/13/2001")];
  });
  it(@"firstDayOfYearOfDate:calendar:", ^{
    [[[PEUtils firstDayOfYearOfDate:d(@"03/16/1978") calendar:calendar] should] equal:d(@"01/01/1978")];
    [[[PEUtils firstDayOfYearOfDate:d(@"12/31/1979") calendar:calendar] should] equal:d(@"01/01/1979")];
    [[[PEUtils firstDayOfYearOfDate:d(@"01/01/1980") calendar:calendar] should] equal:d(@"01/01/1980")];
  });
  it(@"firstDayOfYear:month:calendar:", ^{
    [[[PEUtils firstDayOfYear:2011 month:4 calendar:calendar] should] equal:d(@"04/01/2011")];
    [[[PEUtils firstDayOfYear:2016 month:12 calendar:calendar] should] equal:d(@"12/01/2016")];
    [[[PEUtils firstDayOfYear:2000 month:1 calendar:calendar] should] equal:d(@"01/01/2000")];
  });
  it(@"firstDayOfMonth:ofYearOfDate:calendar:", ^{
    [[[PEUtils firstDayOfMonth:11 ofYearOfDate:d(@"04/03/2014") calendar:calendar] should] equal:d(@"11/01/2014")];
    [[[PEUtils firstDayOfMonth:1 ofYearOfDate:d(@"12/31/2012") calendar:calendar] should] equal:d(@"01/01/2012")];
  });
  it(@"lastDayOfMonthForDate:month:calendar:", ^{
    [[[PEUtils lastDayOfMonthForDate:d(@"07/18/2013") calendar:calendar] should] equal:d(@"07/31/2013")];
    [[[PEUtils lastDayOfMonthForDate:d(@"06/18/2015") calendar:calendar] should] equal:d(@"06/30/2015")];
  });
  it(@"lastYearRangeFromDate:calendar:", ^{
    NSArray *range = [PEUtils lastYearRangeFromDate:d(@"06/13/2013") calendar:calendar];
    [[range[0] should] equal:d(@"01/01/2012")];
    [[range[1] should] equal:d(@"01/01/2013")];
  });
});

context(@"Merging", ^{
  it(@"works when remote hasn't changed, but local has changed", ^{
    PELangDummyCar *localMaster = newCar(@"blue", @"300.50", @"01-23-1978", YES);
    PELangDummyCar *local = newCar(@"orange", @"300.50", @"01-23-1978", YES);
    PELangDummyCar *remote = newCar(@"blue", @"300.50", @"01-23-1978", YES);
    mergeTest(localMaster, local, remote,
              newCar(@"orange", @"300.50", @"01-23-1978", YES),
              @[]);
  });
  it(@"works when remote and local have both changed, but are still mergable", ^{
    PELangDummyCar *localMaster = newCar(@"blue", @"300.50", @"01-23-1978", YES);
    PELangDummyCar *local = newCar(@"orange", @"300.50", @"01-23-1978", NO);
    PELangDummyCar *remote = newCar(@"blue", @"302.75", @"01-23-1978", NO);
    mergeTest(localMaster, local, remote,
              newCar(@"orange", @"302.75", @"01-23-1978", NO),
              @[]);
  });
  it(@"works when remote and local have both changed, but are NOT fully mergable", ^{
    PELangDummyCar *localMaster = newCar(@"blue", @"300.50", @"01-23-1978", YES);
    PELangDummyCar *local = newCar(@"orange", @"225.85", @"01-23-1978", NO);
    PELangDummyCar *remote = newCar(@"blue", @"302.75", @"01-23-1978", NO);
    mergeTest(localMaster, local, remote,
              newCar(@"orange", @"225.85", @"01-23-1978", NO),
              @[PECarHorsepowerField]);
  });
});

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
