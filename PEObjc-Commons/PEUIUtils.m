//
// PEUIUtils.m
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
#import "PEUIUtils.h"
#import "NSString+PEAdditions.h"

@implementation PEUIUtils

#pragma mark - Validation Utils

+ (PEMessageCollector)newTfCannotBeEmptyBlkForMsgs:(NSMutableArray *)errMsgs
                                       entityPanel:(UIView *)entityPanel {
  return ^(NSUInteger tag, NSString *errMsg) {
    if ([[PEUIUtils stringFromTextFieldWithTag:tag fromView:entityPanel] isBlank]) {
      [errMsgs addObject:errMsg];
    }
  };
}

#pragma mark - Position Utils

+ (CGFloat)XForWidth:(CGFloat)width
       withAlignment:(PEUIHorizontalAlignmentType)alignment
      relativeToView:(UIView *)relativeToView
            hpadding:(CGFloat)hpadding {
  switch (alignment) {
  case PEUIHorizontalAlignmentTypeLeft:
    return relativeToView.frame.origin.x + hpadding;
  case PEUIHorizontalAlignmentTypeRight:
    return ((relativeToView.frame.size.width - width) +
            relativeToView.frame.origin.x) - hpadding;
  default: // center
    return relativeToView.frame.origin.x -
      ((width - relativeToView.frame.size.width) / 2);
  }
}

+ (CGFloat)YForHeight:(CGFloat)height
        withAlignment:(PEUIVerticalAlignmentType)alignment
       relativeToView:(UIView *)relativeToView
             vpadding:(CGFloat)vpadding {
  switch (alignment) {
  case PEUIVerticalAlignmentTypeTop:
    return relativeToView.frame.origin.y + vpadding;
  case PEUIVerticalAlignmentTypeBottom:
    return ((relativeToView.frame.size.height - height) +
            relativeToView.frame.origin.y) - vpadding;
  default: // center
    return relativeToView.frame.origin.y -
      ((height - relativeToView.frame.size.height) / 2);
  }
}

+ (CGPoint)pointToTheRightOf:(UIView *)view
               withAlignment:(PEUIVerticalAlignmentType)alignment
                    hpadding:(CGFloat)hpadding
                forBoxOfSize:(CGSize)size {
  CGRect viewRect = [view frame];
  return CGPointMake(viewRect.origin.x + viewRect.size.width + hpadding,
                     [PEUIUtils YForHeight:size.height
                             withAlignment:alignment
                            relativeToView:view
                                  vpadding:0]);
}

+ (CGPoint)pointToTheLeftOf:(UIView *)view
              withAlignment:(PEUIVerticalAlignmentType)alignment
                   hpadding:(CGFloat)hpadding
               forBoxOfSize:(CGSize)size {
  CGRect viewRect = [view frame];
  return CGPointMake(viewRect.origin.x - (size.width + hpadding),
                     [PEUIUtils YForHeight:size.height
                             withAlignment:alignment
                            relativeToView:view
                                  vpadding:0]);
}

+ (CGPoint)pointAbove:(UIView *)view
        withAlignment:(PEUIHorizontalAlignmentType)alignment
             vpadding:(CGFloat)vpadding
             hpadding:(CGFloat)hpadding
         forBoxOfSize:(CGSize)size {
  CGRect viewRect = [view frame];
  return CGPointMake([PEUIUtils XForWidth:size.width
                            withAlignment:alignment
                           relativeToView:view
                                 hpadding:hpadding],
                     viewRect.origin.y - (size.height + vpadding));
}

+ (CGPoint)pointBelow:(UIView *)view
        withAlignment:(PEUIHorizontalAlignmentType)alignment
             vpadding:(CGFloat)vpadding
             hpadding:(CGFloat)hpadding
         forBoxOfSize:(CGSize)size {
  CGRect viewRect = [view frame];
  return CGPointMake([PEUIUtils XForWidth:size.width
                            withAlignment:alignment
                           relativeToView:view
                                 hpadding:hpadding],
                     viewRect.origin.y + (viewRect.size.height + vpadding));
}

#pragma mark - Dimension Utils

+ (CGFloat)heightForText:(NSString *)text forWidth:(CGFloat)width {
  NSMutableAttributedString *attrStr =
    [[NSMutableAttributedString alloc] initWithString:text];
  CGRect bounds =
    [attrStr boundingRectWithSize:CGSizeMake(width * 0.5, 0)
                          options:(NSLineBreakByWordWrapping |
                                   NSStringDrawingUsesLineFragmentOrigin)
                          context:nil];
  return bounds.size.height;
}

+ (CGSize)sizeOfText:(NSString *)text withFont:(UIFont *)font {
  CGSize textSize =
    [text sizeWithAttributes:
            [NSDictionary dictionaryWithObject:font
                                        forKey:NSFontAttributeName]];
  return CGSizeMake(textSize.width, textSize.height);
}

+ (CGFloat)widthWidestAmong:(NSArray *)views {
  __block CGFloat largestWidth = 0;
  [views enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
      if (obj.frame.size.width > largestWidth) {
        largestWidth = obj.frame.size.width;
      }
    }];
  return largestWidth;
}

#pragma mark - View Placement

+ (void)setFrameX:(CGFloat)xcoord andY:(CGFloat)ycoord ofView:(UIView *)view {
  CGRect frame = [view frame];
  CGRect newFrame =
    CGRectMake(xcoord, ycoord, frame.size.width, frame.size.height);
  [view setFrame:newFrame];
}

+ (void)setFrameOrigin:(CGPoint)origin ofView:(UIView *)view {
  [PEUIUtils setFrameX:origin.x andY:origin.y ofView:view];
}

+ (void)setFrameX:(CGFloat)xcoord ofView:(UIView *)view {
  [PEUIUtils setFrameX:xcoord andY:view.frame.origin.y ofView:view];
}

+ (void)setFrameY:(CGFloat)ycoord ofView:(UIView *)view {
  [PEUIUtils setFrameX:view.frame.origin.x andY:ycoord ofView:view];
}

+ (void)adjustXOfView:(UIView *)view withValue:(CGFloat)adjust {
  [PEUIUtils setFrameX:([view frame].origin.x + adjust) ofView:view];
}

+ (void)adjustYOfView:(UIView *)view withValue:(CGFloat)adjust {
  [PEUIUtils setFrameY:([view frame].origin.y + adjust) ofView:view];
}

+ (void)placeView:(UIView *)view
          atTopOf:(UIView *)ontoView
    withAlignment:(PEUIHorizontalAlignmentType)alignment
         vpadding:(CGFloat)vpadding
         hpadding:(CGFloat)hpadding {
  [ontoView addSubview:view];
  [PEUIUtils
    setFrameOrigin:CGPointMake([PEUIUtils XForWidth:[view frame].size.width
                                      withAlignment:alignment
                                     relativeToView:ontoView
                                           hpadding:hpadding],
                               vpadding)
            ofView:view];
}

+ (void)placeView:(UIView *)view
       atBottomOf:(UIView *)ontoView
    withAlignment:(PEUIHorizontalAlignmentType)alignment
         vpadding:(CGFloat)vpadding
         hpadding:(CGFloat)hpadding {
  [ontoView addSubview:view];
  [PEUIUtils
    setFrameOrigin:
      CGPointMake([PEUIUtils XForWidth:[view frame].size.width
                         withAlignment:alignment
                        relativeToView:ontoView
                              hpadding:hpadding],
                  [PEUIUtils YForHeight:[view frame].size.height
                          withAlignment:PEUIVerticalAlignmentTypeBottom
                         relativeToView:ontoView
                               vpadding:vpadding])
            ofView:view];
}

+ (void)placeView:(UIView *)view
       inMiddleOf:(UIView *)ontoView
    withAlignment:(PEUIHorizontalAlignmentType)alignment
         hpadding:(CGFloat)hpadding {
  [ontoView addSubview:view];
  [PEUIUtils
    setFrameOrigin:
      CGPointMake([PEUIUtils XForWidth:[view frame].size.width
                         withAlignment:alignment
                        relativeToView:ontoView
                              hpadding:hpadding],
                  [PEUIUtils YForHeight:[view frame].size.height
                          withAlignment:PEUIVerticalAlignmentTypeCenter
                         relativeToView:ontoView
                               vpadding:0])
            ofView:view];
}

+ (void)placeView:(UIView *)view
            below:(UIView *)relativeTo
             onto:(UIView *)ontoView
    withAlignment:(PEUIHorizontalAlignmentType)alignment
         vpadding:(CGFloat)vpadding
         hpadding:(CGFloat)hpadding {
  [ontoView addSubview:view];
  [PEUIUtils setFrameOrigin:[PEUIUtils pointBelow:relativeTo
                                    withAlignment:alignment
                                         vpadding:vpadding
                                         hpadding:hpadding
                                     forBoxOfSize:[view frame].size]
                     ofView:view];
}

+ (void)placeView:(UIView *)view
            above:(UIView *)relativeTo
             onto:(UIView *)ontoView
    withAlignment:(PEUIHorizontalAlignmentType)alignment
         vpadding:(CGFloat)vpadding
         hpadding:(CGFloat)hpadding {
  [ontoView addSubview:view];
  [PEUIUtils setFrameOrigin:[PEUIUtils pointAbove:relativeTo
                                    withAlignment:alignment
                                         vpadding:vpadding
                                         hpadding:hpadding
                                     forBoxOfSize:[view frame].size]
                     ofView:view];
}

+ (void)placeView:(UIView *)view
      toTheLeftOf:(UIView *)relativeTo
             onto:(UIView *)ontoView
    withAlignment:(PEUIVerticalAlignmentType)alignment
         hpadding:(CGFloat)hpadding {
  [ontoView addSubview:view];
  [PEUIUtils setFrameOrigin:[PEUIUtils pointToTheLeftOf:relativeTo
                                          withAlignment:alignment
                                               hpadding:hpadding
                                           forBoxOfSize:[view frame].size]
                     ofView:view];
}

+ (void)placeView:(UIView *)view
     toTheRightOf:(UIView *)relativeTo
             onto:(UIView *)ontoView
    withAlignment:(PEUIVerticalAlignmentType)alignment
         hpadding:(CGFloat)hpadding {
  [ontoView addSubview:view];
  [PEUIUtils setFrameOrigin:[PEUIUtils pointToTheRightOf:relativeTo
                                           withAlignment:alignment
                                                hpadding:hpadding
                                            forBoxOfSize:[view frame].size]
                     ofView:view];
}

#pragma mark - Animations

+ (void)placeAndAnimateView:(UIView *)view
              fromTopOfView:(UIView *)relativeTo
                    downToY:(CGFloat)downToY
              withAlignment:(PEUIHorizontalAlignmentType)alignment
                   hpadding:(CGFloat)hpadding
                   duration:(NSTimeInterval)duration
            fadeOutDuration:(NSTimeInterval)fadeOutDuration {
  [PEUIUtils placeView:view
                 above:relativeTo
                  onto:relativeTo
         withAlignment:alignment
              vpadding:0
              hpadding:0];
  [UIView animateWithDuration:duration
                        delay:0.0f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
    CGPoint destPoint =
      CGPointMake([PEUIUtils XForWidth:[view frame].size.width
                         withAlignment:alignment
                        relativeToView:relativeTo
                              hpadding:hpadding], downToY);
    [PEUIUtils setFrameOrigin:destPoint ofView:view]; }
                   completion:^(BOOL finished) {
                     [UIView animateWithDuration:fadeOutDuration
                                           delay:0.0f
                                         options:UIViewAnimationOptionCurveEaseInOut
                                      animations:^{
                       [view setAlpha:0.0f]; }
                                      completion:^(BOOL finished){ [view removeFromSuperview]; }]; }];
}

#pragma mark - View Sizing

+ (void)setFrameWidth:(CGFloat)width ofView:(UIView *)view {
  CGRect frame = [view frame];
  CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, width,
                               frame.size.height);
  [view setFrame:newFrame];
}

+ (void)setFrameWidthOfView:(UIView *)view
                    ofWidth:(CGFloat)percentage
                 relativeTo:(UIView *)relativeToView {
  [PEUIUtils setFrameWidth:([relativeToView frame].size.width * percentage)
                    ofView:view];
}

+ (void)setFrameHeight:(CGFloat)height ofView:(UIView *)view {
  CGRect frame = [view frame];
  CGRect newFrame =
    CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
  [view setFrame:newFrame];
}

+ (void)setFrameHeightOfView:(UIView *)view
                    ofHeight:(CGFloat)percentage
                  relativeTo:(UIView *)relativeToView {
  [PEUIUtils setFrameHeight:([relativeToView frame].size.height * percentage)
                     ofView:view];
}

+ (void)adjustHeightToFitSubviewsForView:(UIView *)panel
                           bottomPadding:(CGFloat)bottomPadding {
  NSArray *subviews = [panel subviews];
  CGRect boundingRect = CGRectZero;
  for (UIView *view in subviews) {
    boundingRect = CGRectUnion(boundingRect, view.frame);
  }
  [PEUIUtils setFrameHeight:(boundingRect.size.height + bottomPadding)
                     ofView:panel];
}

#pragma mark - View Controller Commons

+ (UINavigationController *)navigationControllerWithController:(UIViewController *)viewController {
  return [PEUIUtils navigationControllerWithController:viewController
                                   navigationBarHidden:YES];
}

+ (UINavigationController *)navigationControllerWithController:(UIViewController *)viewController
                                           navigationBarHidden:(BOOL)navigationBarHidden {
  UINavigationController *navCtrl =
    [[UINavigationController alloc] initWithRootViewController:viewController];
  [navCtrl setNavigationBarHidden:navigationBarHidden];
  return navCtrl;
}

+ (void)displayController:(UIViewController *)controller
           fromController:(UIViewController *)fromController
                 animated:(BOOL)animated {
  UINavigationController *fromControllerParentNavCtrl =
    [fromController navigationController];
  if (fromControllerParentNavCtrl) {
    [fromControllerParentNavCtrl pushViewController:controller animated:animated];
  } else {
    [fromController presentViewController:controller animated:animated completion:nil];
  }
}

+ (UINavigationController *)navControllerWithRootController:(UIViewController *)viewController
                                        navigationBarHidden:(BOOL)navigationBarHidden
                                            tabBarItemTitle:(NSString *)tabBarItemTitle
                                            tabBarItemImage:(UIImage *)tabBarItemImage
                                    tabBarItemSelectedImage:(UIImage *)tabBarItemSelectedImage {
  UINavigationController *navCtrl =
    [PEUIUtils navigationControllerWithController:viewController
                              navigationBarHidden:navigationBarHidden];
  UITabBarItem *tabBarItem =
  [[UITabBarItem alloc] initWithTitle:tabBarItemTitle
                                image:tabBarItemImage
                        selectedImage:tabBarItemSelectedImage];
  [navCtrl setTabBarItem:tabBarItem];
  return navCtrl;
}

+ (void)displayTempNotification:(NSString *)messageOrKey
                  forController:(UIViewController *)viewController
                      uitoolkit:(PEUIToolkit *)uitoolkit {
  if (messageOrKey) {
    NSUInteger notificationPanelTag = 717;
    LabelMaker labelMaker = [uitoolkit header2Maker];
    UILabel *notificationMsgLbl = labelMaker(messageOrKey);
    PanelMaker notificationPanelMaker =
    [uitoolkit notificationPanelMakerRelativeTo:notificationMsgLbl];
    UIView *notificationPanel = notificationPanelMaker(1.10);
    [PEUIUtils setFrameHeightOfView:notificationPanel
                           ofHeight:1.20
                         relativeTo:notificationMsgLbl];
    [PEUIUtils placeView:notificationMsgLbl
              inMiddleOf:notificationPanel
           withAlignment:PEUIHorizontalAlignmentTypeCenter
                hpadding:0];
    CGFloat extraYForDest = 0.0;
    CGFloat addlFadeOutDuration = 0.0;
    UIView *existingNotificationPanel = [[viewController view] viewWithTag:notificationPanelTag];
    while (existingNotificationPanel) {
      notificationPanelTag++;
      extraYForDest += (existingNotificationPanel.frame.size.height + 3); // ('3' for padding)
      addlFadeOutDuration += [uitoolkit durationForFadeOutAnimation];
      existingNotificationPanel = [[viewController view] viewWithTag:notificationPanelTag];
    }
    [notificationPanel setTag:notificationPanelTag];
    UINavigationController *navCtrl = [viewController navigationController];
    if (navCtrl) {
      if (![[navCtrl navigationBar] isHidden]) {
        extraYForDest += 40;
      }
    }
    [uitoolkit fromTopWithFadeOutAnimatorMaker](notificationPanel,
                                                [viewController view],
                                                extraYForDest,
                                                addlFadeOutDuration);
  }
}

#pragma mark - Color Utils

+ (UIImage *)imageWithColor:(UIColor *)color {
  CGRect rect = CGRectMake(0, 0, 1, 1);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

+ (void)applyBorderToView:(UIView *)view withColor:(UIColor *)color {
  view.layer.borderColor = color.CGColor;
  view.layer.borderWidth = 3.0f;
}

#pragma mark - Labels

+ (UILabel *)labelWithKey:(NSString *)key
                     font:(UIFont *)font
          backgroundColor:(UIColor *)backgroundColor
                textColor:(UIColor *)textColor
    horizontalTextPadding:(CGFloat)horizontalTextPadding
      verticalTextPadding:(CGFloat)verticalTextPadding {
  NSString *text = LS(key);
  CGSize textSize = [PEUIUtils sizeOfText:text withFont:font];
  textSize = CGSizeMake(textSize.width + horizontalTextPadding,
                        textSize.height + verticalTextPadding);
  UILabel *label =
    [[UILabel alloc]
      initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
  [label setNumberOfLines:0];
  [label setBackgroundColor:backgroundColor];
  [label setTextColor:textColor];
  [label setText:text];
  [label setFont:font];
  return label;
}

+ (void)setTextAndResize:(NSString *)text forLabel:(UILabel *)label {
  CGSize textSize = [PEUIUtils sizeOfText:text withFont:[label font]];
  [label setText:text];
  [PEUIUtils setFrameHeight:textSize.height ofView:label];
  [PEUIUtils setFrameWidth:textSize.width ofView:label];
}

#pragma mark - Text Fields

+ (UITextField *)textfieldWithPlaceholderTextKey:(NSString *)key
                                            font:(UIFont *)font
                                 backgroundColor:(UIColor *)backgroundColor
                                 leftViewPadding:(CGFloat)leftViewPadding
                                      fixedWidth:(CGFloat)width {
  return [PEUIUtils textfieldWithPlaceholderTextKey:key
                                               font:font
                                    backgroundColor:backgroundColor
                                    leftViewPadding:leftViewPadding
                                         fixedWidth:width
                                       heightFactor:1.75]; // a reasonable default
}

+ (UITextField *)textfieldWithPlaceholderTextKey:(NSString *)key
                                            font:(UIFont *)font
                                 backgroundColor:(UIColor *)backgroundColor
                                 leftViewPadding:(CGFloat)leftViewPadding
                                      fixedWidth:(CGFloat)width
                                    heightFactor:(CGFloat)heightFactor {
  NSString *placeholderText = LS(key);
  CGFloat height = [PEUIUtils sizeOfText:placeholderText withFont:font].height *
    heightFactor;
  UITextField *tf =
    [[UITextField alloc]
      initWithFrame:CGRectMake(0, 0, width, height)];
  [tf setAutocorrectionType:UITextAutocorrectionTypeNo];
  [tf setAutocapitalizationType:UITextAutocapitalizationTypeNone];
  [tf setClearButtonMode:UITextFieldViewModeWhileEditing];
  UIView *paddingView =
    [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftViewPadding, height)];
  [tf setLeftView:paddingView];
  [tf setLeftViewMode:UITextFieldViewModeAlways];
  [tf setBackgroundColor:backgroundColor];
  [tf setFont:font];
  [tf setPlaceholder:placeholderText];
  return tf;
}

+ (UITextField *)textfieldWithPlaceholderTextKey:(NSString *)key
                                            font:(UIFont *)font
                                 backgroundColor:(UIColor *)backgroundColor
                                 leftViewPadding:(CGFloat)leftViewPadding
                                         ofWidth:(CGFloat)percentage
                                      relativeTo:(UIView *)relativeToView {
  CGFloat width = relativeToView.frame.size.width * percentage;
  return [PEUIUtils textfieldWithPlaceholderTextKey:key
                                               font:font
                                    backgroundColor:backgroundColor
                                    leftViewPadding:leftViewPadding
                                         fixedWidth:width];
}

+ (NSString *)stringFromTextFieldWithTag:(NSInteger)tag
                                fromView:(UIView *)view {
  return [(UITextField *)[view viewWithTag:tag] text];
}

+ (NSNumber *)numberFromTextFieldWithTag:(NSInteger)tag
                                fromView:(UIView *)view {
  return [PEUtils nullSafeNumberFromString:[(UITextField *)[view viewWithTag:tag] text]];
}

+ (NSDecimalNumber *)decimalNumberFromTextFieldWithTag:(NSInteger)tag
                                              fromView:(UIView *)view {
  return [PEUtils nullSafeDecimalNumberFromString:[(UITextField *)[view viewWithTag:tag] text]];
}

+ (void)bindToEntity:(id)entity
          withSetter:(SEL)setter
fromTextfieldWithTag:(NSInteger)tfTag
   stringTransformer:(id (^)(NSString *))stringTransformer
            fromView:(UIView *)view {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  NSString *strValue = [PEUIUtils stringFromTextFieldWithTag:tfTag
                                                    fromView:view];
  [entity performSelector:setter
               withObject:stringTransformer(strValue)];
#pragma clang diagnostic pop
}

+ (void)bindToEntity:(id)entity
    withStringSetter:(SEL)setter
fromTextfieldWithTag:(NSInteger)tfTag
            fromView:(UIView *)view {
  [PEUIUtils bindToEntity:entity
               withSetter:setter
     fromTextfieldWithTag:tfTag
        stringTransformer:^id(NSString *strValue){return strValue;}
                 fromView:view];
}

+ (void)bindToEntity:(id)entity
    withNumberSetter:(SEL)setter
fromTextfieldWithTag:(NSInteger)tfTag
            fromView:(UIView *)view {
  [PEUIUtils bindToEntity:entity
               withSetter:setter
     fromTextfieldWithTag:tfTag
        stringTransformer:^id(NSString *strValue){return [PEUtils nullSafeNumberFromString:strValue];}
                 fromView:view];
}

+ (void)bindToEntity:(id)entity
   withDecimalSetter:(SEL)setter
fromTextfieldWithTag:(NSInteger)tfTag
            fromView:(UIView *)view {
  [PEUIUtils bindToEntity:entity
               withSetter:setter
     fromTextfieldWithTag:tfTag
        stringTransformer:^id(NSString *strValue){return [PEUtils nullSafeDecimalNumberFromString:strValue];}
                 fromView:view];
}

+ (void)bindToTextControlWithTag:(NSInteger)tfTag
                        fromView:(UIView *)view
                      fromEntity:(id)entity
                      withGetter:(SEL)getter {
  UIView *textView = [view viewWithTag:tfTag];
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  NSObject *val = [entity performSelector:getter];
  NSString *valStr;
  if (val) {
    valStr = [val description];
  } else {
    valStr = @"";
  }
  [textView performSelector:@selector(setText:) withObject:valStr];
  #pragma clang diagnostic pop
}

+ (void)enableControlWithTag:(NSInteger)tag
                    fromView:(UIView *)view
                      enable:(BOOL)enable {
  UIControl *control = (UIControl *)[view viewWithTag:tag];
  [control setEnabled:enable];
}

#pragma mark - Buttons

+ (UIButton *)buttonWithKey:(NSString *)key
                       font:(UIFont *)font
            backgroundColor:(UIColor *)backgroundColor
                  textColor:(UIColor *)textColor
disabledStateBackgroundColor:(UIColor *)disabledStateBackgroundColor
     disabledStateTextColor:(UIColor *)disabledStateTextColor
            verticalPadding:(CGFloat)verticalPadding
          horizontalPadding:(CGFloat)horizontalPadding
               cornerRadius:(CGFloat)cornerRadius
                     target:(id)target
                     action:(SEL)action {
  NSString *buttonLabel = LS(key);
  CGSize textSize = [PEUIUtils sizeOfText:buttonLabel withFont:font];
  textSize = CGSizeMake(textSize.width + horizontalPadding,
                        textSize.height + verticalPadding);
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  UIImage *bgColorAsImgNormState = [PEUIUtils imageWithColor:backgroundColor];
  UIImage *bgColorAsImgDisState =
    [PEUIUtils imageWithColor:disabledStateBackgroundColor];
  [btn setBackgroundImage:bgColorAsImgNormState forState:UIControlStateNormal];
  [btn setTitleColor:textColor forState:UIControlStateNormal];
  [btn setBackgroundImage:bgColorAsImgDisState forState:UIControlStateDisabled];
  [btn setTitleColor:disabledStateTextColor forState:UIControlStateDisabled];
  [[btn layer] setCornerRadius:cornerRadius];
  [btn setClipsToBounds:YES];
  [btn setTitle:buttonLabel forState:UIControlStateNormal];
  [[btn titleLabel] setFont:font];
  [[btn titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
  [[btn titleLabel] setTextAlignment:NSTextAlignmentCenter];
  [btn setFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
  [btn addTarget:target
          action:action
       forControlEvents:UIControlEventTouchUpInside];
  return btn;
}

+ (void)addDisclosureIndicatorToButton:(UIButton *)button {
  // hacky, but works
  UITableViewCell *disclosure = [[UITableViewCell alloc] init];
  [button addSubview:disclosure];
  [disclosure setFrame:[button bounds]];
  [disclosure setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  [disclosure setUserInteractionEnabled:NO];
}

#pragma mark - Panels

+ (UIView *)panelWithFixedWidth:(CGFloat)width
                    fixedHeight:(CGFloat)height {
  return [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
}

+ (UIView *)panelWithWidthOf:(CGFloat)percentage
              relativeToView:(UIView *)relativeToView
                 fixedHeight:(CGFloat)height {
  CGFloat width = relativeToView.frame.size.width * percentage;
  return [PEUIUtils panelWithFixedWidth:width fixedHeight:height];
}

+ (UIView *)panelWithWidthOf:(CGFloat)widthPercentage
                 andHeightOf:(CGFloat)heightPercentage
              relativeToView:(UIView *)relativeToView {
  CGFloat width = relativeToView.frame.size.width * widthPercentage;
  CGFloat height = relativeToView.frame.size.height * heightPercentage;
  return [PEUIUtils panelWithFixedWidth:width fixedHeight:height];
}

+ (UIView *)panelWithColumnOfViews:(NSArray *)views
       verticalPaddingBetweenViews:(CGFloat)vpadding
                    viewsAlignment:(PEUIHorizontalAlignmentType)alignment {
  UIView *panel =
    [PEUIUtils panelWithFixedWidth:[PEUIUtils widthWidestAmong:views]
                       fixedHeight:0];
  __block UIView *currentView = nil;
  __block CGFloat height = ([views count] - 1) * vpadding;
  [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
      if (currentView) {
        [PEUIUtils placeView:view
                       below:currentView
                        onto:panel
               withAlignment:alignment
                    vpadding:vpadding
                    hpadding:0];
      } else {
        [panel addSubview:view];
        [PEUIUtils setFrameX:[PEUIUtils XForWidth:view.frame.size.width
                                    withAlignment:alignment
                                   relativeToView:panel
                                         hpadding:0]
                      ofView:view];
      }
      currentView = view;
      height += [currentView frame].size.height;
    }];
  [PEUIUtils setFrameHeight:height ofView:panel];
  return panel;
}

+ (UIView *)twoColumnViewCluster:(NSArray *)ltColViews
                 withRightColumn:(NSArray *)rtColViews
     verticalPaddingBetweenViews:(CGFloat)vpadding
 horizontalPaddingBetweenColumns:(CGFloat)hpadding {
  UIView *ltColContainerPnl =
    [PEUIUtils panelWithColumnOfViews:ltColViews
          verticalPaddingBetweenViews:vpadding
                       viewsAlignment:PEUIHorizontalAlignmentTypeRight];
  UIView *rtColContainerPnl =
    [PEUIUtils panelWithColumnOfViews:rtColViews
          verticalPaddingBetweenViews:vpadding
                       viewsAlignment:PEUIHorizontalAlignmentTypeLeft];
  UIView *mainPanel =
    [PEUIUtils panelWithFixedWidth:([ltColContainerPnl frame].size.width +
                                    [rtColContainerPnl frame].size.width +
                                    hpadding)
                       fixedHeight:(([ltColContainerPnl frame].size.height >
                                     [rtColContainerPnl frame].size.height) ?
                                    [ltColContainerPnl frame].size.height :
                                    [rtColContainerPnl frame].size.height)];
  [mainPanel addSubview:ltColContainerPnl];
  [PEUIUtils adjustYOfView:ltColContainerPnl
                 withValue:[PEUIUtils YForHeight:[ltColContainerPnl frame].size.height
                                   withAlignment:PEUIVerticalAlignmentTypeCenter
                                  relativeToView:mainPanel
                                        vpadding:0]];
  [PEUIUtils placeView:rtColContainerPnl
          toTheRightOf:ltColContainerPnl
                  onto:mainPanel
         withAlignment:PEUIVerticalAlignmentTypeCenter
              hpadding:hpadding];
  return mainPanel;
}

+ (UIView *)panelWithViews:(NSArray *)views
                   ofWidth:(CGFloat)percentage
      vertAlignmentOfViews:(PEUIVerticalAlignmentType)vertAlignment
       horAlignmentOfViews:(PEUIHorizontalAlignmentType)horAlignment
                relativeTo:(UIView *)relativeToView
                  vpadding:(CGFloat)vpadding
                  hpadding:(CGFloat)hpadding {
  UIView *viewHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  NSUInteger numViews = [views count];
  int tallestHeight = 0;
  if (numViews > 0) {
    UIView *view = [views objectAtIndex:0];
    [viewHolder addSubview:view];
    int runningWidth = [view frame].size.width;
    tallestHeight = [view frame].size.height;
    UIView *previousView = view;
    for (int i = 1; i < numViews; i++) {
      view = [views objectAtIndex:i];
      [PEUIUtils placeView:view
              toTheRightOf:previousView
                      onto:viewHolder
             withAlignment:vertAlignment
                  hpadding:hpadding];
      runningWidth += [view frame].size.width + hpadding;
      if ([view frame].size.height > tallestHeight) {
        tallestHeight = [view frame].size.height;
      }
      previousView = view;
    }
    [PEUIUtils setFrameWidth:runningWidth ofView:viewHolder];
    [PEUIUtils setFrameHeight:tallestHeight ofView:viewHolder];
  }
  UIView *outerPnl = [PEUIUtils panelWithWidthOf:percentage
                                  relativeToView:relativeToView
                                     fixedHeight:tallestHeight];
  [PEUIUtils placeView:viewHolder
            inMiddleOf:outerPnl
         withAlignment:horAlignment
              hpadding:0];
  return outerPnl;
}

#pragma mark - Alerts

+ (void)showAlertWithMsgs:(NSArray *)msgs
                    title:(NSString *)localizedTitle
              buttonTitle:(NSString *)localizedButtonTitle {
  UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:LS(localizedTitle)
                               message:[PEUtils concat:msgs]
                              delegate:self
                     cancelButtonTitle:LS(localizedButtonTitle)
                     otherButtonTitles:nil];
  [alert show];
}

+ (void)showAlertForNSURLErrorCode:(NSInteger)errorCode
                             title:(NSString *)localizedTitle
                 cancelButtonTitle:(NSString *)localizedCancelBtnTitle {
  NSMutableArray *errMsgs = [NSMutableArray arrayWithCapacity:1];
  switch (errorCode) {
  case NSURLErrorTimedOut:
    [errMsgs addObject:LS(@"nsurlerr.timeout")];
    break;
  case NSURLErrorCannotConnectToHost:
    [errMsgs addObject:LS(@"nsurlerr.serverdown")];
    break;
  case NSURLErrorNetworkConnectionLost:
    [errMsgs addObject:LS(@"nsurlerr.inetconnlost")];
    break;
  case NSURLErrorDNSLookupFailed:
    [errMsgs addObject:LS(@"nsurlerr.dnslkupfailed")];
    break;
  case NSURLErrorNotConnectedToInternet:
    [errMsgs addObject:LS(@"nsurlerr.noinetconn")];
    break;
  default:
    [errMsgs addObject:LS(@"nsurlerr.unknownerr")];
    break;
  }
  [PEUIUtils showAlertWithMsgs:errMsgs
                         title:localizedTitle
                   buttonTitle:localizedCancelBtnTitle];
}

@end
