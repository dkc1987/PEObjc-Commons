//
//  PEHomeScreen.m
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
//

#import "PEHomeScreen.h"
#import "PEUIUtils.h"
#import "UIView+PERoundify.h"
#import "PEDataTableScreen.h"

@implementation PEHomeScreen

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setTitle:@"Demo App"];
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
  [PEUIUtils applyBorderToView:scrollView withColor:[UIColor orangeColor]];
  [scrollView setDelaysContentTouches:NO];
  [scrollView setScrollEnabled:YES];
  [scrollView setContentSize:CGSizeMake(320, 525)];
  UIView *topPnl = [self topPanel];
  [scrollView addSubview:topPnl];
  UIView *middlePnl = [self clusterPanel];
  [PEUIUtils applyBorderToView:middlePnl withColor:[UIColor blueColor]];
  [PEUIUtils placeView:middlePnl
                 below:topPnl
                  onto:scrollView
         withAlignment:PEUIHorizontalAlignmentTypeCenter
              vpadding:8
              hpadding:0];
  [PEUIUtils placeView:[self bottomPanel]
                 below:middlePnl
                  onto:scrollView
         withAlignment:PEUIHorizontalAlignmentTypeCenter
              vpadding:8
              hpadding:0];
  [[self view] addSubview:scrollView];
}

- (UIView *)bottomPanel {
  UIView *pnl = [PEUIUtils panelWithFixedWidth:300 fixedHeight:200];
  [PEUIUtils applyBorderToView:pnl withColor:[UIColor blackColor]];
  UILabel *lbl1 = [PEUIUtils labelWithKey:@"I am a label!"
                                     font:[UIFont boldSystemFontOfSize:18]
                          backgroundColor:[UIColor yellowColor]
                                textColor:[UIColor blueColor]
                      verticalTextPadding:4];
  UIView *lbl1Panel = [PEUIUtils leftPadView:lbl1 padding:20.0];
  [PEUIUtils placeView:lbl1Panel
            inMiddleOf:pnl
         withAlignment:PEUIHorizontalAlignmentTypeCenter
              hpadding:0];
  UILabel *lbl2 = [PEUIUtils labelWithKey:@"I am a longer label, and I'm happy."
                                     font:[UIFont systemFontOfSize:14]
                          backgroundColor:[UIColor yellowColor]
                                textColor:[UIColor blueColor]
                      verticalTextPadding:10];
  [PEUIUtils placeView:[PEUIUtils leftPadView:lbl2 padding:5.0]
               atTopOf:pnl
         withAlignment:PEUIHorizontalAlignmentTypeRight
              vpadding:0
              hpadding:0];
  UILabel *lbl2_1 = [PEUIUtils labelWithKey:@"ABC"
                                       font:[UIFont boldSystemFontOfSize:12]
                            backgroundColor:[UIColor yellowColor]
                                  textColor:[UIColor blueColor]
                        verticalTextPadding:10];
  
  UILabel *lbl2_2 = [PEUIUtils labelWithKey:@"This is a really long label."
                                       font:[UIFont boldSystemFontOfSize:12]
                            backgroundColor:[UIColor yellowColor]
                                  textColor:[UIColor blueColor]
                        verticalTextPadding:0.0
                                 fitToWidth:65.0];
  //[PEUIUtils applyBorderToView:lbl2_2 withColor:[UIColor greenColor] width:1.0];
  [PEUIUtils placeView:[PEUIUtils leftPadView:lbl2_1 padding:5.0]
               atTopOf:pnl
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              vpadding:5
              hpadding:5];
  [PEUIUtils placeView:lbl2_2
                 below:lbl2_1
                  onto:pnl
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              vpadding:10.0
              hpadding:0.0];
  UILabel *lbl3 = [PEUIUtils labelWithKey:@"Another!"
                                     font:[UIFont systemFontOfSize:24]
                          backgroundColor:[UIColor yellowColor]
                                textColor:[UIColor blueColor]
                      verticalTextPadding:20];
  [PEUIUtils placeView:[PEUIUtils leftPadView:lbl3 padding:15.0]
            atBottomOf:pnl
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              vpadding:0
              hpadding:0];
  UILabel *lbl3_1 = [PEUIUtils labelWithKey:@"Another at right!"
                                       font:[UIFont systemFontOfSize:16]
                            backgroundColor:[UIColor yellowColor]
                                  textColor:[UIColor blueColor]
                        verticalTextPadding:10];
  [PEUIUtils placeView:[PEUIUtils leftPadView:lbl3_1 padding:10.0]
            atBottomOf:pnl
         withAlignment:PEUIHorizontalAlignmentTypeRight
              vpadding:10
              hpadding:10];
  UILabel *lbl4 = [PEUIUtils labelWithKey:@"More!"
                                     font:[UIFont systemFontOfSize:18]
                          backgroundColor:[UIColor yellowColor]
                                textColor:[UIColor blueColor]
                      verticalTextPadding:20];
  [PEUIUtils placeView:[PEUIUtils leftPadView:lbl4 padding:15.0]
                 above:lbl1Panel
                  onto:pnl
         withAlignment:PEUIHorizontalAlignmentTypeRight
              vpadding:5
              hpadding:0];
  [PEUIUtils adjustHeightToFitSubviewsForView:pnl bottomPadding:20];
  return pnl;
}

- (void)bluftoniButtonAction {
  [PEUIUtils showWarningAlertWithMsgs:nil //@[]
                                title:@"This is a warning dialog, and is a, a really long title."
                     alertDescription:[[NSAttributedString alloc] initWithString:@"Hi!  I am the alert description.  There are \
some things I need to tell you, and they \
are very important!"]
                             topInset:70.0
                          buttonTitle:@"Okay."
                         buttonAction:^{ NSLog(@"alert button tapped."); }
                       relativeToView:self.view];
}

- (void)oneButtonAction {
  [PEUIUtils showErrorAlertWithMsgs:nil //@[]
                              title:@"This is an error dialog."
                   alertDescription:[[NSAttributedString alloc] initWithString:@"Hi!  I am the alert description.  There are \
some things I need to tell you, and they \
are very important!"]
                           topInset:70.0
                        buttonTitle:@"Okay."
                       buttonAction:^{ NSLog(@"alert button tapped."); }
                     relativeToView:self.view];
}

- (void)twoButtonAction {
  [PEUIUtils showSuccessAlertWithMsgs:nil //@[]
                                title:@"This is a success dialog."
                     alertDescription:[[NSAttributedString alloc] initWithString:@"Hi!  I am the alert description.  There are \
some things I need to tell you, and they \
are very important!"]
                             topInset:70.0
                          buttonTitle:@"Okay."
                         buttonAction:^{ NSLog(@"alert button tapped."); }
                       relativeToView:self.view];
}

- (void)aButtonAction {
  [PEUIUtils showWaitAlertWithMsgs:nil //@[]
                             title:@"Server Busy."
                  alertDescription:[[NSAttributedString alloc] initWithString:@"We apologize, but the server is currently \
busy.  Please retry your request shortly."]
                          topInset:70.0
                       buttonTitle:@"Okay."
                      buttonAction:^{ NSLog(@"alert button tapped."); }
                    relativeToView:self.view];
}

- (void)deterministicButtonAction {

}

- (void)cButtonAction {
  [PEUIUtils showWarningConfirmAlertWithMsgs:@[@"15 fuel purchase log records.", @"32 environment log records."]
                                       title:@"Are you sure?"
                            alertDescription:[[NSAttributedString alloc] initWithString:@"\
Deleting this entity will result in the \
following child-items being deleted.\n\n\
Are you sure you want to continue?"]
                                    topInset:70.0
                             okayButtonTitle:@"Yes, delete."
                            okayButtonAction:^{}
                           cancelButtonTitle:@"No, cancel."
                          cancelButtonAction:^{}
                              relativeToView:self.view];
}

- (UIView *)clusterPanel {
  NSArray *leftBtns = @[[self btnWithKey:@"A Btn"],
                        [self btnWithKey:@"Bluftoni Button"],
                        [self squareBtnWithKey:@"C Button"],
                        [self btnWithKey:@"Deterministic Button"],
                        [self btnWithKey:@"Display Data Table"]];
  [leftBtns[2] addRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft withRadii:CGSizeMake(20.0, 20.0)];
  [leftBtns[3] addTarget:self action:@selector(deterministicButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [leftBtns[4] addTarget:self action:@selector(displayDataTableAction) forControlEvents:UIControlEventTouchUpInside];
  [leftBtns[0] addTarget:self action:@selector(aButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [leftBtns[1] addTarget:self action:@selector(bluftoniButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [leftBtns[2] addTarget:self action:@selector(cButtonAction) forControlEvents:UIControlEventTouchUpInside];
  
  NSArray *rtBtns = @[[self btnWithKey:@"1 Btn"],
                      [self btnWithKey:@"Two Button"],
                      [self btnWithKey:@"thrice Button"],
                      [self btnWithKey:@"quince Button"],
                      [self btnWithKey:@"6 Button"],
                      [self btnWithKey:@"7 btn"]];
  [rtBtns[0] addTarget:self action:@selector(oneButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [rtBtns[1] addTarget:self action:@selector(twoButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [rtBtns[2] addTarget:self action:@selector(thriceButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [rtBtns[3] addTarget:self action:@selector(quinceButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [rtBtns[4] addTarget:self action:@selector(sixButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [rtBtns[5] addTarget:self action:@selector(sevenButtonAction) forControlEvents:UIControlEventTouchUpInside];
  return [PEUIUtils twoColumnViewCluster:leftBtns
                         withRightColumn:rtBtns
             verticalPaddingBetweenViews:5
         horizontalPaddingBetweenColumns:8];
}

- (void)displayDataTableAction {
  [self.navigationController pushViewController:[[PEDataTableScreen alloc] initWithNibName:nil bundle:nil]
                                       animated:YES];
}

- (void)sevenButtonAction {
  [PEUIUtils showWarningConfirmAlertWithTitle:@"You have unsynced edits."
                             alertDescription:[[NSAttributedString alloc] initWithString:@"You have unsynced edits.  If you log out, \
they will be permanently deleted.\n\nAre you sure you want to do continue?"]
                                     topInset:70.0
                              okayButtonTitle:@"Yes.  Log me out."
                             okayButtonAction:^{ NSLog(@"logging out");}
                            cancelButtonTitle:@"Cancel."
                           cancelButtonAction:^{ NSLog(@"Canceled.");}
                               relativeToView:self.view];
}

- (void)quinceButtonAction {
  [PEUIUtils showMultiErrorAlertWithFailures:@[@[@"Fuel purchase log not saved.", @(YES), @[@"Server error.  Yes, crazy, right!?  A major SERVER Error!"]],
                                               @[@"Pre-fillup environment log not saved.  What are we going to do!?", @(YES), @[@"Server error.", @"Client error."]],
                                               @[@"Post-fillup environment log not saved.  A major. (huh?)", @(YES), @[@"Server error."]],
                                               @[@"Post-fillup environment log not saved.  A major. (huh?)", @(YES), @[@"Server error."]],
                                               @[@"Post-fillup environment log not saved.  A major. (huh?)", @(YES), @[@"Server error."]],
                                               @[@"Post-fillup environment log not saved.  A major. (huh?)", @(YES), @[@"Server error."]]]
                                       title:@"Multiple Errors.  Yes, you read that right.  MULTIPLE ERRORS!"
                            alertDescription:[[NSAttributedString alloc] initWithString:@"None of your entities could be saved."]
                                    topInset:70.0
                                 buttonTitle:@"Okay."
                                buttonAction:^{ NSLog(@"alert button tapped."); }
                              relativeToView:self.view];
}

- (void)sixButtonAction {
  NSMutableAttributedString *description = [[NSMutableAttributedString alloc] initWithString:@"\
Because the results are mixed, you need to \
fix the errors on the individual affected \
records.  The successful syncs are:"];
  NSDictionary *messageAttrs = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:16] };
  NSRange messageAttrsRange = NSMakeRange(2, 9);
  [description setAttributes:messageAttrs range:messageAttrsRange];
  [PEUIUtils showMixedResultsAlertSectionWithSuccessMsgs:@[@"Fuel purchase log saved.", @"Fuel station saved."]
                                                   title:@"Mixed results saving fuel purchase and environment logs."
                                        alertDescription:description
                                     failuresDescription:[[NSAttributedString alloc] initWithString:@"The failures are:"]
                                                failures:@[@[@"Fuel purchase log not saved.", @(YES), @[@"Server error."]],
                                                           @[@"Pre-fillup environment log not saved.", @(YES), @[@"Server error.", @"Client error."]],
                                                           @[@"Post-fillup environment log not saved.", @(YES), @[@"Server error."]]]
                                                topInset:70.0
                                             buttonTitle:@"Okay."
                                            buttonAction:^{ NSLog(@"alert button tapped."); }
                                          relativeToView:self.view];
}

- (void)thriceButtonAction {
  [PEUIUtils showWarningAlertWithMsgs:@[@"message 1"]
                                title:@"This is a warning dialog."
                     alertDescription:[[NSAttributedString alloc] initWithString:@"There are some validation errors:"]
                             topInset:70.0
                          buttonTitle:@"Okey Dokey"
                         buttonAction:^{ NSLog(@"alert button tapped."); }
                       relativeToView:self.view];
}

- (void)thirdButtonAction {
  [PEUIUtils showWarningAlertWithMsgs:@[@"message 1", @"Hello, I am message 2."]
                                title:@"This is a warning dialog."
                     alertDescription:[[NSAttributedString alloc] initWithString:@"Hi!  I am the alert description.  There are \
some things I need to tell you, and they \
are as follows:"]
                             topInset:70.0
                          buttonTitle:@"Okey Dokey"
                         buttonAction:^{ NSLog(@"alert button tapped."); }
                       relativeToView:self.view];
}

- (void)fourthButtonAction {
  [PEUIUtils showErrorAlertWithMsgs:@[@"message 1", @"Hello, I am message 2.  This is a very long message 2 I should say!", @"error sub-msg 3"]
                              title:@"This is an error dialog."
                   alertDescription:[[NSAttributedString alloc] initWithString:@"Hi!  I am the alert description.  There are \
some things I need to tell you, and they \
are as follows:"]
                           topInset:70.0
                        buttonTitle:@"Okay."
                       buttonAction:^{ NSLog(@"alert button tapped."); }
                     relativeToView:self.view];
}

- (void)secondButtonAction {
  [PEUIUtils showSuccessAlertWithMsgs:@[@"message 1", @"Hello, I am message 2.", @"success sub-msg 3"]
                                title:@"This is a success dialog."
                     alertDescription:[[NSAttributedString alloc] initWithString:@"Hi!  I am the alert description.  There are \
some things I need to tell you, and they \
are as follows:"]
                             topInset:70.0
                          buttonTitle:@"Okay."
                         buttonAction:^{ NSLog(@"alert button tapped."); }
                       relativeToView:self.view];
}

- (void)firstButtonAction {
  NSLog(@"font size: %f", [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline].pointSize);
  [PEUIUtils showSuccessAlertWithMsgs:@[@"Message 1"]
                                title:@"This is a success dialog."
                     alertDescription:[[NSAttributedString alloc] initWithString:@"Hi!  I am the alert description.  There are \
some things I need to tell you, and they \
are as follows:"]
                             topInset:70.0
                          buttonTitle:@"Okay."
                         buttonAction:^{ NSLog(@"alert button tapped."); }
                       relativeToView:self.view];
}

- (void)instructional {
  [PEUIUtils showInstructionalAlertWithTitle:@"Enable location services."
                        alertDescriptionText:@"It would appear you've been asked before to enable \
location services but you declined.  In order to enable location services, do the following:\n\n"
                             instructionText:@"Exit Gas Jot \u2794 go to the Settings app \u2794 Privacy \u2794 Location Services"
                                    topInset:70.0
                                 buttonTitle:@"Okay."
                                buttonAction:^{}
                              relativeToView:self.view];
}

- (UIView *)topPanel {
  UIView *p1 = [PEUIUtils panelWithFixedWidth:275 fixedHeight:110];
  [PEUIUtils setFrameOrigin:CGPointMake(25, 25) ofView:p1];
  [PEUIUtils applyBorderToView:p1 withColor:[UIColor redColor]];
  UIButton *b1 = [self btnWithKey:@"First Btn"];
  [b1 addTarget:self action:@selector(firstButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [PEUIUtils setFrameOrigin:CGPointMake(5, 5) ofView:b1];
  [p1 addSubview:b1];
  UIButton *b2 = [self btnWithKey:@"2nd Btn"];
  [b2 addTarget:self action:@selector(secondButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [PEUIUtils placeView:b2
                 below:b1
                  onto:p1
         withAlignment:PEUIHorizontalAlignmentTypeCenter
              vpadding:8
              hpadding:0];
  UITextField *tf1 = [PEUIUtils textfieldWithPlaceholderTextKey:@"This is a text field"
                                                           font:[UIFont systemFontOfSize:14]
                                                backgroundColor:[UIColor grayColor]
                                                leftViewPadding:10
                                                        ofWidth:.5
                                                     relativeTo:p1];
  [tf1 addRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft withRadii:CGSizeMake(20.0, 20.0)];
  [PEUIUtils placeView:tf1
          toTheRightOf:b1
                  onto:p1
         withAlignment:PEUIVerticalAlignmentTypeMiddle
              hpadding:8];
  UIButton *b3 = [self btnWithKey:@"3rd Btn"];
  [b3 addTarget:self action:@selector(thirdButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [PEUIUtils placeView:b3
                 below:tf1
                  onto:p1
         withAlignment:PEUIHorizontalAlignmentTypeRight
              vpadding:8
              hpadding:0];
  UIButton *instructionBtn = [self btnWithKey:@"Instr"];
  [instructionBtn addTarget:self action:@selector(instructional) forControlEvents:UIControlEventTouchUpInside];
  [PEUIUtils placeView:instructionBtn toTheRightOf:b3 onto:p1 withAlignment:PEUIVerticalAlignmentTypeMiddle hpadding:3.0];
  UIButton *editConflictBtn = [self btnWithKey:@"Edit Conflict"];
  [editConflictBtn addTarget:self action:@selector(editConflict) forControlEvents:UIControlEventTouchUpInside];
  [PEUIUtils placeView:editConflictBtn
                 below:b3
                  onto:p1
         withAlignment:PEUIHorizontalAlignmentTypeRight
              vpadding:8
              hpadding:0];
  UIButton *b4 = [self btnWithKey:@"4th Btn"];
  [b4 addTarget:self action:@selector(fourthButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [PEUIUtils placeView:b4
                 below:b2
                  onto:p1
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              vpadding:8
              hpadding:15];
  UIView *square = [PEUIUtils panelWithFixedWidth:20.0 fixedHeight:20.0];
  [square setBackgroundColor:[UIColor redColor]];
  /*[PEUIUtils placeView:square
                  onto:p1
       inMiddleBetween:tf1
                   and:editConflictBtn
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              hpadding:75.0];*/
  /*[PEUIUtils placeView:square
                  onto:p1
       inMiddleBetween:tf1
             andYCoord:p1.frame.size.height
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              hpadding:75.0];*/
  [PEUIUtils placeView:square
                  onto:p1
 inMiddleBetweenYCoord:(tf1.frame.origin.y + tf1.frame.size.height)
             andYCoord:p1.frame.size.height
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              hpadding:75.0];
  return p1;
}

- (void)deleteConflict {
  
}

- (void)editConflict {
  NSAttributedString *desc = [PEUIUtils attributedTextWithTemplate:@"\
The remote copy of this entity has been \
updated since you downloaded it.  You have \
a few options:\n\n\%@. Yeah.  Retained."
                                                      textToAccent:@"If you cancel, your local edits will be retained"
                                                    accentTextFont:[UIFont italicSystemFontOfSize:14.0]
                                                   accentTextColor:[UIColor blueColor]];
  [PEUIUtils showEditConflictAlertWithTitle:@"Conflict."
                           alertDescription:desc
                                   topInset:70.0
                           mergeButtonTitle:@"Merge remote and local, then review."
                          mergeButtonAction:^ (UIView *alertSection) {
                            NSString *desc = @"\
Use the form below to resolve the \
merge conflicts.";
                            NSArray *fields;
                            fields = @[@[@"Name", @(16), @"300zx", @"Fairlady Z"],
                                       @[@"Default octane", @(17), @"19.1", @"19.2"]];
                            [PEUIUtils showConflictResolverWithTitle:@"Conflict resolver."
                                                    alertDescription:[[NSAttributedString alloc] initWithString:desc]
                                               conflictResolveFields:fields
                                                      withCellHeight:36.75
                                                   labelLeftHPadding:5.0
                                                  valueRightHPadding:8.0
                                                           labelFont:[UIFont systemFontOfSize:14]
                                                           valueFont:[UIFont systemFontOfSize:14]
                                                      labelTextColor:[UIColor darkGrayColor]
                                                      valueTextColor:[UIColor darkGrayColor]
                                      minPaddingBetweenLabelAndValue:10.0
                                                   includeTopDivider:NO
                                                includeBottomDivider:NO
                                                includeInnerDividers:YES
                                             innerDividerWidthFactor:0.967
                                                      dividerPadding:3.0
                                             rowPanelBackgroundColor:[UIColor clearColor]
                                                panelBackgroundColor:[UIColor whiteColor]
                                                        dividerColor:[UIColor lightGrayColor]
                                                            topInset:70.0
                                                     okayButtonTitle:@"Okay.  Merge 'em!"
                                                    okayButtonAction:^(NSArray *valueLabels) {
                                                      NSInteger numValueLabels = [valueLabels count];
                                                      for (int i = 0; i < numValueLabels; i++) {
                                                        NSArray *valueLabelPair = valueLabels[i];
                                                        UILabel *localValue = valueLabelPair[0];
                                                        UILabel *remoteValue = valueLabelPair[1];
                                                        NSLog(@"For field [%d], localValue text is: [%@] and tag is: [%ld]", i, localValue.text, (long)localValue.tag);
                                                        NSLog(@"For field [%d], remoteValue text is: [%@] and tag is: [%ld] ", i, remoteValue.text, (long)remoteValue.tag);
                                                      }
                                                    }
                                                   cancelButtonTitle:@"Cancel.  I'll deal with this later."
                                                  cancelButtonAction:^{}
                                             relativeToViewForLayout:alertSection
                                                relativeToViewForPop:self.view];
                          }
                         replaceButtonTitle:@"Replace local with remote, then review."
                        replaceButtonAction:^{}
                  forceSaveLocalButtonTitle:@"I don't care.  Force save my local copy."
                      forceSaveButtonAction:^{}
                          cancelButtonTitle:@"Cancel.  I'll deal with this later."
                         cancelButtonAction:^{}
                             relativeToView:self.view];
}

-(UIButton *)btnWithKey:(NSString *)key {
  return [PEUIUtils buttonWithKey:key
                             font:[UIFont systemFontOfSize:15]
                  backgroundColor:[UIColor blueColor]
                        textColor:[UIColor yellowColor]
     disabledStateBackgroundColor:[UIColor grayColor]
           disabledStateTextColor:[UIColor grayColor]
                  verticalPadding:10
                horizontalPadding:10
                     cornerRadius:3
                           target:self
                           action:@selector(buttonClick)];
}

-(UIButton *)squareBtnWithKey:(NSString *)key {
  return [PEUIUtils buttonWithKey:key
                             font:[UIFont systemFontOfSize:15]
                  backgroundColor:[UIColor blueColor]
                        textColor:[UIColor yellowColor]
     disabledStateBackgroundColor:[UIColor grayColor]
           disabledStateTextColor:[UIColor grayColor]
                  verticalPadding:10
                horizontalPadding:10
                     cornerRadius:0.0
                           target:self
                           action:@selector(buttonClick)];
}

- (void)buttonClick {
}


@end
