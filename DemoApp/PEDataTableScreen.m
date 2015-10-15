//
//  PEDataTableScreen.m
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

#import "PEDataTableScreen.h"
#import "PEUIUtils.h"
#import "PEUtils.h"

@implementation PEDataTableScreen

- (void)viewDidLoad {
  [super viewDidLoad];
  [[self view] setBackgroundColor:[UIColor whiteColor]];
  NSArray *rowData = @[@[@"Label 1", @"value 1"],
                       @[@"Label 2", @"value 2.  Yes, I am the value 2 value and I'm very long."],
                       @[@"Label 3", @"value 3"],
                       @[@"Label 4", [PEUtils emptyIfNil:nil]]];
  NSAttributedString *footerText = [PEUIUtils attributedTextWithTemplate:@"Hello.  I'm the footer text, and, for testing, I'm going to make this %@ message."
                                                            textToAccent:@"a really long"
                                                          accentTextFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
  UIView *dataTablePanel = [PEUIUtils tablePanelWithRowData:rowData
                                             withCellHeight:36.75
                                          labelLeftHPadding:15.0
                                         valueRightHPadding:15.0
                                                  labelFont:[UIFont systemFontOfSize:18]
                                                  valueFont:[UIFont systemFontOfSize:18]
                                             labelTextColor:[UIColor blackColor]
                                             valueTextColor:[UIColor grayColor]
                             minPaddingBetweenLabelAndValue:10.0
                                          includeTopDivider:YES
                                       includeBottomDivider:YES
                                       includeInnerDividers:YES
                                    innerDividerWidthFactor:0.95
                                             dividerPadding:3.0
                                    rowPanelBackgroundColor:[UIColor whiteColor]
                                       panelBackgroundColor:[UIColor whiteColor]
                                               dividerColor:[UIColor lightGrayColor]
                                       footerAttributedText:footerText
                                             relativeToView:self.view];
  [PEUIUtils placeView:dataTablePanel
               atTopOf:self.view
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              vpadding:80.0
              hpadding:0.0];
}

@end
