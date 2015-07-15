//
//  AppDelegate.m
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

#import "AppDelegate.h"
#import "PEUIUtils.h"
#import "UIView+PERoundify.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window =
      [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    UIViewController *rootCtrl =
      [[UIViewController alloc] initWithNibName:nil bundle:nil];
    UIScrollView *scrollView =
      [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [scrollView setDelaysContentTouches:NO];
    [[rootCtrl view] addSubview:scrollView];

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
    [[self window] setRootViewController:rootCtrl];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
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
  [PEUIUtils placeView:[PEUIUtils leftPadView:lbl2_1 padding:5.0]
               atTopOf:pnl
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              vpadding:5
              hpadding:5];
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
                                title:@"This is a warning dialog."
                     alertDescription:[[NSAttributedString alloc] initWithString:@"Hi!  I am the alert description.  There are\n\
some things I need to tell you, and they\n\
are very important!"]
                          buttonTitle:@"Okay."
                         buttonAction:^{ NSLog(@"alert button tapped."); }
                       relativeToView:self.window.rootViewController.view];
}

- (void)oneButtonAction {
  [PEUIUtils showErrorAlertWithMsgs:nil //@[]
                              title:@"This is an error dialog."
                   alertDescription:[[NSAttributedString alloc] initWithString:@"Hi!  I am the alert description.  There are\n\
some things I need to tell you, and they\n\
are very important!"]
                        buttonTitle:@"Okay."
                       buttonAction:^{ NSLog(@"alert button tapped."); }
                     relativeToView:self.window.rootViewController.view];
}

- (void)twoButtonAction {
  [PEUIUtils showSuccessAlertWithMsgs:nil //@[]
                                title:@"This is a success dialog."
                     alertDescription:[[NSAttributedString alloc] initWithString:@"Hi!  I am the alert description.  There are\n\
some things I need to tell you, and they\n\
are very important!"]
                          buttonTitle:@"Okay."
                         buttonAction:^{ NSLog(@"alert button tapped."); }
                       relativeToView:self.window.rootViewController.view];
}

- (void)aButtonAction {
  [PEUIUtils showWaitAlertWithMsgs:nil //@[]
                             title:@"Server Busy."
                  alertDescription:[[NSAttributedString alloc] initWithString:@"We apologize, but the server is currently\n\
busy.  Please retry your request shortly."]
                       buttonTitle:@"Okay."
                      buttonAction:^{ NSLog(@"alert button tapped."); }
                    relativeToView:self.window.rootViewController.view];
}

- (void)deterministicButtonAction {
  [PEUIUtils showLoginSuccessAlertWithTitle:@"Login success."
                           alertDescription:[[NSAttributedString alloc] initWithString:@"\
You have been successfully logged in.\n\n\
Your remote account is now connected to\n\
this device.  Any fuel purchase data that\n\
you create and save will be synced to your\n\
remote account."]
                            syncIconMessage:[[NSAttributedString alloc] initWithString:@"\
The following icon will appear in the app\n\
indicating that your are currently logged\n\
into your remote account:"]
                                buttonTitle:@"Okay."
                               buttonAction:nil
                             relativeToView:self.window.rootViewController.view];
}

- (UIView *)clusterPanel {
  NSArray *leftBtns = @[[self btnWithKey:@"A Btn"],
                           [self btnWithKey:@"Bluftoni Button"],
                           [self squareBtnWithKey:@"C Button"],
                           [self btnWithKey:@"Deterministic Button"]];
  [leftBtns[2] addRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft withRadii:CGSizeMake(20.0, 20.0)];
  [leftBtns[3] addTarget:self action:@selector(deterministicButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [leftBtns[0] addTarget:self action:@selector(aButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [leftBtns[1] addTarget:self action:@selector(bluftoniButtonAction) forControlEvents:UIControlEventTouchUpInside];
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
  return [PEUIUtils twoColumnViewCluster:leftBtns
                         withRightColumn:rtBtns
             verticalPaddingBetweenViews:5
         horizontalPaddingBetweenColumns:8];
}

- (void)quinceButtonAction {
  [PEUIUtils showMultiErrorAlertWithFailures:@[@[@"Fuel purchase log not saved.", @(YES), @[@"Server error."]],
                                               @[@"Pre-fillup environment log not saved.", @(YES), @[@"Server error.", @"Client error."]],
                                               @[@"Post-fillup environment log not saved.", @(YES), @[@"Server error."]]]
                                       title:@"Multiple Errors."
                            alertDescription:[[NSAttributedString alloc] initWithString:@"None of your entities could be saved."]
                                 buttonTitle:@"Okay."
                                buttonAction:^{ NSLog(@"alert button tapped."); }
                              relativeToView:self.window.rootViewController.view];
}

- (void)sixButtonAction {
  
  NSMutableAttributedString *description = [[NSMutableAttributedString alloc] initWithString:@"\
Because the results are mixed, you need to\n\
fix the errors on the individual affected\n\
records.  The successful syncs are:"];
  NSDictionary *messageAttrs = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:16] };
  NSRange messageAttrsRange = NSMakeRange(2, 9);
  [description setAttributes:messageAttrs range:messageAttrsRange];  
  [PEUIUtils showMixedResultsAlertSectionWithSuccessMsgs:@[@"Fuel purchase log saved.", @"Fuel station saved."]
                                                   title:@"Mixed results saving fuel\npurchase and environment logs."
                                        alertDescription:description
                                     failuresDescription:[[NSAttributedString alloc] initWithString:@"The failures are:"]
                                                failures:@[@[@"Fuel purchase log not saved.", @(YES), @[@"Server error."]],
                                                           @[@"Pre-fillup environment log not saved.", @(YES), @[@"Server error.", @"Client error."]],
                                                           @[@"Post-fillup environment log not saved.", @(YES), @[@"Server error."]]]
                                             buttonTitle:@"Okay."
                                            buttonAction:^{ NSLog(@"alert button tapped."); }
                                          relativeToView:self.window.rootViewController.view];
}

- (void)thriceButtonAction {
  [PEUIUtils showWarningAlertWithMsgs:@[@"message 1"]
                                title:@"This is a warning dialog."
                     alertDescription:[[NSAttributedString alloc] initWithString:@"There are some validation errors:"]
                          buttonTitle:@"Okey Dokey"
                         buttonAction:^{ NSLog(@"alert button tapped."); }
                       relativeToView:self.window.rootViewController.view];
}

- (void)thirdButtonAction {
  [PEUIUtils showWarningAlertWithMsgs:@[@"message 1", @"Hello, I am message 2."]
                                title:@"This is a warning dialog."
                     alertDescription:[[NSAttributedString alloc] initWithString:@"Hi!  I am the alert description.  There are\n\
some things I need to tell you, and they\n\
are as follows:"]
                          buttonTitle:@"Okey Dokey"
                         buttonAction:^{ NSLog(@"alert button tapped."); }
                       relativeToView:self.window.rootViewController.view];
}

- (void)fourthButtonAction {
  [PEUIUtils showErrorAlertWithMsgs:@[@"message 1", @"Hello, I am message 2.", @"error sub-msg 3"]
                              title:@"This is an error dialog."
                   alertDescription:[[NSAttributedString alloc] initWithString:@"Hi!  I am the alert description.  There are\n\
some things I need to tell you, and they\n\
are as follows:"]
                        buttonTitle:@"Okay."
                       buttonAction:^{ NSLog(@"alert button tapped."); }
                     relativeToView:self.window.rootViewController.view];
}

- (void)secondButtonAction {
  [PEUIUtils showSuccessAlertWithMsgs:@[@"message 1", @"Hello, I am message 2.", @"success sub-msg 3"]
                                title:@"This is a success dialog."
                     alertDescription:[[NSAttributedString alloc] initWithString:@"Hi!  I am the alert description.  There are\n\
some things I need to tell you, and they\n\
are as follows:"]
                          buttonTitle:@"Okay."
                         buttonAction:^{ NSLog(@"alert button tapped."); }
                       relativeToView:self.window.rootViewController.view];
}

- (void)firstButtonAction {
  [PEUIUtils showSuccessAlertWithMsgs:@[@"Message 1"]
                                title:@"This is a success dialog."
                     alertDescription:[[NSAttributedString alloc] initWithString:@"Hi!  I am the alert description.  There are\n\
some things I need to tell you, and they\n\
are as follows:"]
                          buttonTitle:@"Okay."
                         buttonAction:^{ NSLog(@"alert button tapped."); }
                       relativeToView:self.window.rootViewController.view];
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
  UIButton *b4 = [self btnWithKey:@"4th Btn"];
  [b4 addTarget:self action:@selector(fourthButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [PEUIUtils placeView:b4
                 below:b2
                  onto:p1
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              vpadding:8
              hpadding:15];
  return p1;
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
