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
#import "UIImage+PEAdditions.h"
#import "PEObjcCommonsConstantsInternal.h"
#import <JGActionSheet/JGActionSheet.h>

typedef JGActionSheetSection *(^PEAlertSectionMaker)(void);

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
  NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
  CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName : font,
                                               NSParagraphStyleAttributeName : paragraphStyle}];
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
                          withAlignment:PEUIVerticalAlignmentTypeMiddle
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
    UIView *notificationMsgLbl = labelMaker(messageOrKey);
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
  view.layer.borderWidth = 1.0f;
}

#pragma mark - Label maker helper

+ (UILabel *)labelWithText:(NSString *)text
                      font:(UIFont *)font
           backgroundColor:(UIColor *)backgroundColor
                 textColor:(UIColor *)textColor
       verticalTextPadding:(CGFloat)verticalTextPadding {
  CGSize textSize = [PEUIUtils sizeOfText:text withFont:font];
  textSize = CGSizeMake(textSize.width, textSize.height + verticalTextPadding);
  UILabel *label =
  [[UILabel alloc]
   initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
  [label setNumberOfLines:0];
  [label setBackgroundColor:backgroundColor];
  [label setLineBreakMode:NSLineBreakByWordWrapping];
  [label setTextColor:textColor];
  [label setFont:font];
  return label;
}

#pragma mark - Labels

+ (UILabel *)labelWithKey:(NSString *)key
                     font:(UIFont *)font
          backgroundColor:(UIColor *)backgroundColor
                textColor:(UIColor *)textColor
      verticalTextPadding:(CGFloat)verticalTextPadding {
  NSString *text = LS(key);
  UILabel *label = [PEUIUtils labelWithText:text
                                       font:font
                            backgroundColor:backgroundColor
                                  textColor:textColor
                        verticalTextPadding:verticalTextPadding];
  [label setText:text];
  return label;
}

+ (UILabel *)labelWithAttributeText:(NSAttributedString *)attributedText
                               font:(UIFont *)font
                    backgroundColor:(UIColor *)backgroundColor
                          textColor:(UIColor *)textColor
                verticalTextPadding:(CGFloat)verticalTextPadding {
  UILabel *label = [PEUIUtils labelWithText:[attributedText string]
                                       font:font
                            backgroundColor:backgroundColor
                                  textColor:textColor
                        verticalTextPadding:verticalTextPadding];
  [label setAttributedText:attributedText];
  return label;
}

+ (UIView *)leftPadView:(UIView *)view
                padding:(CGFloat)padding {
  UIView *panel = [PEUIUtils panelWithFixedWidth:padding + view.frame.size.width
                                     fixedHeight:view.frame.size.height];
  UIView *paddingPanel = [PEUIUtils panelWithFixedWidth:padding fixedHeight:view.frame.size.height];
  [paddingPanel setBackgroundColor:[UIColor clearColor]];
  [PEUIUtils placeView:paddingPanel inMiddleOf:panel withAlignment:PEUIHorizontalAlignmentTypeLeft hpadding:0.0];
  [PEUIUtils placeView:view toTheRightOf:paddingPanel onto:panel withAlignment:PEUIVerticalAlignmentTypeMiddle hpadding:0.0];
  return panel;
}

+ (UIView *)rightPadView:(UIView *)view
                 padding:(CGFloat)padding {
  UIView *panel = [PEUIUtils panelWithFixedWidth:padding + view.frame.size.width
                                     fixedHeight:view.frame.size.height];
  UIView *paddingPanel = [PEUIUtils panelWithFixedWidth:padding fixedHeight:view.frame.size.height];
  [paddingPanel setBackgroundColor:[UIColor clearColor]];
  [PEUIUtils placeView:paddingPanel inMiddleOf:panel withAlignment:PEUIHorizontalAlignmentTypeRight hpadding:0.0];
  [PEUIUtils placeView:view toTheLeftOf:paddingPanel onto:panel withAlignment:PEUIVerticalAlignmentTypeMiddle hpadding:0.0];
  return panel;
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
  if (val && ![val isEqual:[NSNull null]]) {
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
                                   withAlignment:PEUIVerticalAlignmentTypeMiddle
                                  relativeToView:mainPanel
                                        vpadding:0]];
  [PEUIUtils placeView:rtColContainerPnl
          toTheRightOf:ltColContainerPnl
                  onto:mainPanel
         withAlignment:PEUIVerticalAlignmentTypeMiddle
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

+ (UIView *)panelWithTitle:(NSString *)title
                titleImage:(UIImage *)titleImage
               description:(NSAttributedString *)description
            relativeToView:(UIView *)relativeToView {
  return [PEUIUtils panelWithMsgs:nil
                            title:title
                       titleImage:titleImage
                      description:description
                      messageIcon:nil
                   relativeToView:relativeToView];
}

+ (UIView *)panelWithMsgs:(NSArray *)msgs
                    title:(NSString *)title
               titleImage:(UIImage *)titleImage
              description:(NSAttributedString *)description
              messageIcon:(UIImage *)messageIcon
           relativeToView:(UIView *)relativeToView {
  return [PEUIUtils panelWithMsgs:msgs
                            title:title
                       titleImage:titleImage
                      description:description
                  descriptionFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]
                      messageIcon:messageIcon
                   relativeToView:relativeToView];
}

+ (UIView *)panelWithMsgs:(NSArray *)msgs
                    title:(NSString *)title
               titleImage:(UIImage *)titleImage
              description:(NSAttributedString *)description
          descriptionFont:(UIFont *)descriptionFont
              messageIcon:(UIImage *)messageIcon
           relativeToView:(UIView *)relativeToView {
  return [PEUIUtils panelWithMsgs:msgs
                            title:title
                       titleImage:titleImage
                    topRightImage:nil
                      description:description
                  descriptionFont:descriptionFont
                      messageIcon:messageIcon
                   relativeToView:relativeToView];
}

+ (UIView *)panelWithMsgs:(NSArray *)msgs
                    title:(NSString *)title
               titleImage:(UIImage *)titleImage
            topRightImage:(UIImage *)topRightImage
              description:(NSAttributedString *)description
          descriptionFont:(UIFont *)descriptionFont
              messageIcon:(UIImage *)messageIcon
           relativeToView:(UIView *)relativeToView {
  UIView *contentView = [PEUIUtils panelWithWidthOf:0.905
                                     relativeToView:relativeToView
                                        fixedHeight:0];
  UIView *topPanel;
  CGFloat topViewHeight;
  if (title) {
    UIImageView *titleImageView = nil;
    UILabel *titleLbl = [PEUIUtils labelWithKey:title
                                           font:[UIFont boldSystemFontOfSize:16]
                                backgroundColor:[UIColor clearColor]
                                      textColor:[UIColor blackColor]
                            verticalTextPadding:0.0];
    if (titleImage) {
      titleImageView = [[UIImageView alloc] initWithImage:titleImage];
      topViewHeight = (titleImageView.frame.size.height > titleLbl.frame.size.height
                       ? titleImageView.frame.size.height : titleLbl.frame.size.height);
      topPanel = [PEUIUtils panelWithWidthOf:1.0 relativeToView:contentView fixedHeight:topViewHeight];
      [PEUIUtils placeView:titleImageView
                inMiddleOf:topPanel
             withAlignment:PEUIHorizontalAlignmentTypeLeft
                  hpadding:2.0];
      [PEUIUtils placeView:titleLbl
              toTheRightOf:titleImageView
                      onto:topPanel
             withAlignment:PEUIVerticalAlignmentTypeMiddle
                  hpadding:8.0];
    } else {
      topViewHeight = titleLbl.frame.size.height;
      topPanel = [PEUIUtils panelWithWidthOf:1.0 relativeToView:contentView fixedHeight:topViewHeight];
      [PEUIUtils placeView:titleLbl
                inMiddleOf:topPanel
             withAlignment:PEUIHorizontalAlignmentTypeLeft
                  hpadding:2.0];
    }
  } else {
    topViewHeight = 0.0;
    topPanel = [PEUIUtils panelWithFixedWidth:0.0 fixedHeight:topViewHeight];
  }
  UILabel *descriptionLbl = [PEUIUtils labelWithAttributeText:description
                                                         font:descriptionFont
                                              backgroundColor:[UIColor clearColor]
                                                    textColor:[UIColor blackColor]
                                          verticalTextPadding:0.0];
  UIImageView *topRightImageView = nil;
  if (topRightImage) {
    topRightImageView = [[UIImageView alloc] initWithImage:topRightImage];
  }
  UIView *alertPanelsColumn = nil;
  if ([msgs count] > 0) {
    alertPanelsColumn = [PEUIUtils panelWithColumnOfViews:[PEUIUtils alertPanelsForMessages:msgs
                                                                                      width:contentView.frame.size.width
                                                                                leftImgIcon:messageIcon]
                              verticalPaddingBetweenViews:1.0
                                           viewsAlignment:PEUIHorizontalAlignmentTypeLeft];
  }
  CGFloat topPanelVpadding = 3.0;
  CGFloat panelsVpadding = alertPanelsColumn != nil ? 13.0 : 0.0;
  CGFloat contentViewHeight = topViewHeight + descriptionLbl.frame.size.height + alertPanelsColumn.frame.size.height;
  CGFloat descriptionVpadding = 13.0;
  contentViewHeight += topPanelVpadding + descriptionVpadding + panelsVpadding;
  // now add a little bit more height so there's some nice bottom-padding; we'll have more
  // padding for when we have no messages panel-column.
  if ([msgs count] > 0) {
    contentViewHeight += 3.0;
  } else {
    contentViewHeight += 10.0;
  }
  [PEUIUtils setFrameHeight:contentViewHeight ofView:contentView];
  if (topRightImageView) {
    [PEUIUtils placeView:topRightImageView atTopOf:contentView withAlignment:PEUIHorizontalAlignmentTypeRight vpadding:3.0 hpadding:3.0];
  }
  [PEUIUtils placeView:topPanel
               atTopOf:contentView
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              vpadding:topPanelVpadding
              hpadding:0.0];
  [PEUIUtils placeView:descriptionLbl
                 below:topPanel
                  onto:contentView
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              vpadding:descriptionVpadding
              hpadding:3.0];
  if (alertPanelsColumn) {
    [PEUIUtils placeView:alertPanelsColumn
                   below:descriptionLbl
                    onto:contentView
           withAlignment:PEUIHorizontalAlignmentTypeLeft
                vpadding:panelsVpadding
                hpadding:0.0];
  }
  return contentView;
}

+ (UIView *)failuresPanelWithFailures:(NSArray *)failures
                                width:(CGFloat)width {
  NSMutableArray *failurePanels = [NSMutableArray arrayWithCapacity:[failures count]];
  for (NSArray *failure in failures) {
    NSString *failureTitle = failure[0];
    //BOOL isFailureFixableByUser = [failure[1] boolValue];
    NSArray *failureReasons = failure[2];
    UIView *failureReasonsPanel = [PEUIUtils panelWithColumnOfViews:[PEUIUtils alertPanelsForMessages:failureReasons
                                                                                                width:(width - (width * 0.05))
                                                                                          leftImgIcon:[PEUIUtils bundleImageWithName:@"black-dot"]]
                                        verticalPaddingBetweenViews:0.0
                                                     viewsAlignment:PEUIHorizontalAlignmentTypeLeft];
    UIView *failurePanel = [PEUIUtils messagePanelWithTitle:failureTitle
                                                leftImgIcon:[PEUIUtils bundleImageWithName:@"error-icon"]
                                                      width:width];
    [PEUIUtils setFrameHeight:(failurePanel.frame.size.height + failureReasonsPanel.frame.size.height)
                       ofView:failurePanel];
    [PEUIUtils placeView:failureReasonsPanel
              atBottomOf:failurePanel
           withAlignment:PEUIHorizontalAlignmentTypeLeft
                vpadding:0.0
                hpadding:(width * 0.05)];
    [failurePanels addObject:failurePanel];
  }
  return [PEUIUtils panelWithColumnOfViews:failurePanels
               verticalPaddingBetweenViews:1.0
                            viewsAlignment:PEUIHorizontalAlignmentTypeLeft];
}

+ (UIView *)failuresPanelWithFailures:(NSArray *)failures
                          description:(NSAttributedString *)description
                      descriptionFont:(UIFont *)descriptionFont
                       relativeToView:(UIView *)relativeToView {
  return [PEUIUtils failuresPanelWithFailures:failures
                                        title:nil
                                  description:description
                              descriptionFont:descriptionFont
                               relativeToView:relativeToView];
}

+ (UIView *)failuresPanelWithFailures:(NSArray *)failures
                                title:(NSString *)title
                          description:(NSAttributedString *)description
                      descriptionFont:(UIFont *)descriptionFont
                       relativeToView:(UIView *)relativeToView {
  UIView *contentView = [PEUIUtils panelWithMsgs:nil
                                           title:title
                                      titleImage:(title != nil ? [PEUIUtils bundleImageWithName:@"error"] : nil)
                                     description:description
                                 descriptionFont:descriptionFont
                                     messageIcon:nil
                                  relativeToView:relativeToView];
  UIView *failuresPanel = [PEUIUtils failuresPanelWithFailures:failures
                                                         width:contentView.frame.size.width];
  return [PEUIUtils panelWithColumnOfViews:@[contentView, failuresPanel]
               verticalPaddingBetweenViews:0.0
                            viewsAlignment:PEUIHorizontalAlignmentTypeLeft];
}

+ (UIView *)mixedResultsPanelWithSuccessMsgs:(NSArray *)successMsgs
                                       title:(NSString *)title
                                 description:(NSAttributedString *)description
                         failuresDescription:(NSAttributedString *)failuresDescription
                                    failures:(NSArray *)failures
                              relativeToView:(UIView *)relativeToView {
  UIView *successesContent = [PEUIUtils panelWithMsgs:successMsgs
                                                title:title
                                           titleImage:[PEUIUtils bundleImageWithName:@"warning"]
                                          description:description
                                          messageIcon:[PEUIUtils bundleImageWithName:@"success-icon"]
                                       relativeToView:relativeToView];
  UIView *failuresContent = [PEUIUtils failuresPanelWithFailures:failures
                                                     description:failuresDescription
                                                 descriptionFont:[UIFont boldSystemFontOfSize:16.0]
                                                  relativeToView:relativeToView];
  return [PEUIUtils panelWithColumnOfViews:@[successesContent, failuresContent]
               verticalPaddingBetweenViews:0.0
                            viewsAlignment:PEUIHorizontalAlignmentTypeLeft];
}

+ (UIView *)loginSuccessPanelWithTitle:(NSString *)title
                           description:(NSAttributedString *)description
                       descriptionFont:(UIFont *)descriptionFont
                       syncIconMessage:(NSAttributedString *)syncIconMessage
                         syncImageIcon:(UIImage *)syncImageIcon
                        relativeToView:(UIView *)relativeToView {
  UIView *contentView = [PEUIUtils panelWithWidthOf:0.905
                                     relativeToView:relativeToView
                                        fixedHeight:0];
  UIView *topPanel;
  CGFloat topViewHeight;
  UIImageView *titleImageView = nil;
  UILabel *titleLbl = [PEUIUtils labelWithKey:title
                                         font:[UIFont boldSystemFontOfSize:16]
                              backgroundColor:[UIColor clearColor]
                                    textColor:[UIColor blackColor]
                          verticalTextPadding:0.0];
  titleImageView = [[UIImageView alloc] initWithImage:[PEUIUtils bundleImageWithName:@"success"]];
  topViewHeight = (titleImageView.frame.size.height > titleLbl.frame.size.height
                   ? titleImageView.frame.size.height : titleLbl.frame.size.height);
  topPanel = [PEUIUtils panelWithWidthOf:1.0 relativeToView:contentView fixedHeight:topViewHeight];
  [PEUIUtils placeView:titleImageView
            inMiddleOf:topPanel
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              hpadding:2.0];
  [PEUIUtils placeView:titleLbl
          toTheRightOf:titleImageView
                  onto:topPanel
         withAlignment:PEUIVerticalAlignmentTypeMiddle
              hpadding:8.0];
  UILabel *descriptionLbl = [PEUIUtils labelWithAttributeText:description
                                                         font:descriptionFont
                                              backgroundColor:[UIColor clearColor]
                                                    textColor:[UIColor blackColor]
                                          verticalTextPadding:0.0];
  UILabel *syncIconMessageLbl = [PEUIUtils labelWithAttributeText:syncIconMessage
                                                             font:descriptionFont
                                                  backgroundColor:[UIColor clearColor]
                                                        textColor:[UIColor blackColor]
                                              verticalTextPadding:0.0];
  UIImageView *syncMsgIconImageView = [[UIImageView alloc] initWithImage:syncImageIcon];
  CGFloat topPanelVpadding = 3.0;
  CGFloat contentViewHeight = topViewHeight + descriptionLbl.frame.size.height + syncIconMessageLbl.frame.size.height + syncMsgIconImageView.frame.size.height;
  CGFloat descriptionVpadding = 13.0;
  CGFloat syncIconMessageVpadding = 15.0;
  CGFloat syncMsgIconImageVpadding = 7.0;
  contentViewHeight += topPanelVpadding + descriptionVpadding + syncIconMessageVpadding + syncMsgIconImageVpadding;
  // now add a little bit more height so there's some nice bottom-padding; we'll have more
  // padding for when we have no messages panel-column.
  contentViewHeight += 5.0;
  [PEUIUtils setFrameHeight:contentViewHeight ofView:contentView];
  [PEUIUtils placeView:topPanel
               atTopOf:contentView
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              vpadding:topPanelVpadding
              hpadding:0.0];
  [PEUIUtils placeView:descriptionLbl
                 below:topPanel
                  onto:contentView
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              vpadding:descriptionVpadding
              hpadding:3.0];
  [PEUIUtils placeView:syncIconMessageLbl
                 below:descriptionLbl
                  onto:contentView
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              vpadding:syncIconMessageVpadding
              hpadding:0.0];
  [PEUIUtils placeView:syncMsgIconImageView
                 below:syncIconMessageLbl
                  onto:contentView
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              vpadding:syncMsgIconImageVpadding
              hpadding:7.0];
  return contentView;
}

#pragma mark - Private Alert Helpers

+ (UIView *)messagePanelWithTitle:(NSString *)title
                      leftImgIcon:(UIImage *)leftImgIcon
                            width:(CGFloat)width {
  UIView *errorPanel = [PEUIUtils panelWithFixedWidth:width fixedHeight:25.0];
  UIImageView *errImgView = [[UIImageView alloc] initWithImage:leftImgIcon];
  UILabel *errorMsgLbl = [PEUIUtils labelWithKey:title
                                            font:[UIFont systemFontOfSize:[UIFont systemFontSize]]
                                 backgroundColor:[UIColor clearColor]
                                       textColor:[UIColor blackColor]
                             verticalTextPadding:0.0];
  // TODO pad label with 3.0?
  [PEUIUtils placeView:errImgView
            inMiddleOf:errorPanel
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              hpadding:0.0];
  [PEUIUtils placeView:errorMsgLbl
          toTheRightOf:errImgView
                  onto:errorPanel
         withAlignment:PEUIVerticalAlignmentTypeMiddle
              hpadding:5.0];
  return errorPanel;
}

+ (NSArray *)alertPanelsForMessages:(NSArray *)messages
                              width:(CGFloat)width
                        leftImgIcon:(UIImage *)leftImgIcon {
  NSMutableArray *alertPanels = [NSMutableArray arrayWithCapacity:[messages count]];
  for (NSString *message in messages) {
    UIView *errorPanel = [PEUIUtils messagePanelWithTitle:message
                                              leftImgIcon:leftImgIcon
                                                    width:width];
    [alertPanels addObject:errorPanel];
  }
  return alertPanels;
}

#pragma mark - Bundle Image Fetch

+ (UIImage *)bundleImageWithName:(NSString *)imageName {
  UIImage *image;
  if (PE_IS_IOS8_OR_GREATER) {
    NSBundle *mainBundle = [NSBundle bundleForClass:[PEUIUtils class]];
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"PEObjc-Commons" ofType:@"bundle"]];
    if (resourcesBundle == nil) {
      resourcesBundle = mainBundle;
    }
    image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];
  } else {
    image = [UIImage imageNamed:[NSString stringWithFormat:@"PEObjc-Commons.bundle/%@", imageName]];
  }
  return image;
}

#pragma mark - Alert Section Makers

+ (JGActionSheetSection *)alertSectionWithTitle:(NSString *)title
                                     titleImage:(UIImage *)titleImage
                               alertDescription:(NSAttributedString *)alertDescription
                                 relativeToView:(UIView *)relativeToView {
  return [JGActionSheetSection sectionWithTitle:nil
                                        message:nil
                                    contentView:[PEUIUtils panelWithTitle:title
                                                               titleImage:titleImage
                                                              description:alertDescription
                                                           relativeToView:relativeToView]];
}

+ (JGActionSheetSection *)warningAlertSectionWithMsgs:(NSArray *)msgs
                                                title:(NSString *)title
                                     alertDescription:(NSAttributedString *)alertDescription
                                       relativeToView:(UIView *)relativeToView {
  return [JGActionSheetSection sectionWithTitle:nil
                                        message:nil
                                    contentView:[PEUIUtils panelWithMsgs:msgs
                                                                   title:title
                                                              titleImage:[PEUIUtils bundleImageWithName:@"warning"]
                                                             description:alertDescription
                                                             messageIcon:[PEUIUtils bundleImageWithName:@"black-dot"]
                                                          relativeToView:relativeToView]];
}

+ (JGActionSheetSection *)successAlertSectionWithTitle:(NSString *)title
                                      alertDescription:(NSAttributedString *)alertDescription
                                        relativeToView:(UIView *)relativeToView {
  return [PEUIUtils successAlertSectionWithMsgs:nil
                                          title:title
                               alertDescription:alertDescription
                                 relativeToView:relativeToView];
}

+ (JGActionSheetSection *)successAlertSectionWithMsgs:(NSArray *)msgs
                                                title:(NSString *)title
                                     alertDescription:(NSAttributedString *)alertDescription
                                       relativeToView:(UIView *)relativeToView {
  return [JGActionSheetSection sectionWithTitle:nil
                                        message:nil
                                    contentView:[PEUIUtils panelWithMsgs:msgs
                                                                   title:title
                                                              titleImage:[PEUIUtils bundleImageWithName:@"success"]
                                                             description:alertDescription
                                                             messageIcon:[PEUIUtils bundleImageWithName:@"success-icon"]
                                                          relativeToView:relativeToView]];
}

+ (JGActionSheetSection *)waitAlertSectionWithMsgs:(NSArray *)msgs
                                             title:(NSString *)title
                                  alertDescription:(NSAttributedString *)alertDescription
                                    relativeToView:(UIView *)relativeToView {
  return [JGActionSheetSection sectionWithTitle:nil
                                        message:nil
                                    contentView:[PEUIUtils panelWithMsgs:msgs
                                                                   title:title
                                                              titleImage:[PEUIUtils bundleImageWithName:@"wait"]
                                                             description:alertDescription
                                                             messageIcon:[PEUIUtils bundleImageWithName:@"black-dot"]
                                                          relativeToView:relativeToView]];
}

+ (JGActionSheetSection *)errorAlertSectionWithMsgs:(NSArray *)msgs
                                              title:(NSString *)title
                                   alertDescription:(NSAttributedString *)alertDescription
                                     relativeToView:(UIView *)relativeToView {
  return [JGActionSheetSection sectionWithTitle:nil
                                        message:nil
                                    contentView:[PEUIUtils panelWithMsgs:msgs
                                                                   title:title
                                                              titleImage:[PEUIUtils bundleImageWithName:@"error"]
                                                             description:alertDescription
                                                             messageIcon:[PEUIUtils bundleImageWithName:@"error-icon"]
                                                          relativeToView:relativeToView]];
}

+ (JGActionSheetSection *)dangerAlertSectionWithTitle:(NSString *)title
                                     alertDescription:(NSAttributedString *)alertDescription
                                       relativeToView:(UIView *)relativeToView {
  return [PEUIUtils alertSectionWithTitle:title
                               titleImage:[PEUIUtils bundleImageWithName:@"red-exclamation"]
                         alertDescription:alertDescription
                           relativeToView:relativeToView];
}

+ (JGActionSheetSection *)questionAlertSectionWithTitle:(NSString *)title
                                       alertDescription:(NSAttributedString *)alertDescription
                                         relativeToView:(UIView *)relativeToView {
  return [PEUIUtils alertSectionWithTitle:title
                               titleImage:[PEUIUtils bundleImageWithName:@"question"]
                         alertDescription:alertDescription
                           relativeToView:relativeToView];
}

+ (JGActionSheetSection *)multiErrorAlertSectionWithFailures:(NSArray *)failures
                                                       title:(NSString *)title
                                            alertDescription:(NSAttributedString *)alertDescription
                                              relativeToView:(UIView *)relativeToView {
  return [JGActionSheetSection sectionWithTitle:nil
                                        message:nil
                                    contentView:[PEUIUtils failuresPanelWithFailures:failures
                                                                               title:title
                                                                         description:alertDescription
                                                                     descriptionFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]
                                                                      relativeToView:relativeToView]];
}

+ (JGActionSheetSection *)mixedResultsAlertSectionWithSuccessMsgs:(NSArray *)successMsgs
                                                            title:(NSString *)title
                                                 alertDescription:(NSAttributedString *)alertDescription
                                              failuresDescription:(NSAttributedString *)failuresDescription
                                                         failures:(NSArray *)failures
                                                   relativeToView:(UIView *)relativeToView {
  return [JGActionSheetSection sectionWithTitle:nil
                                        message:nil
                                    contentView:[PEUIUtils mixedResultsPanelWithSuccessMsgs:successMsgs
                                                                                      title:title
                                                                                description:alertDescription
                                                                        failuresDescription:failuresDescription
                                                                                   failures:failures
                                                                             relativeToView:relativeToView]];
}

#pragma mark - Showing Alert Helper

+ (void)showAlertWithButtonTitle:(NSString *)buttonTitle
                    buttonAction:(void(^)(void))buttonAction
                  relativeToView:(UIView *)relativeToView
             contentSectionMaker:(PEAlertSectionMaker)contentSectionMaker {
  JGActionSheetSection *contentSection = contentSectionMaker();
  JGActionSheetSection *buttonsSection = [JGActionSheetSection sectionWithTitle:nil
                                                                        message:nil
                                                                   buttonTitles:@[buttonTitle]
                                                                    buttonStyle:JGActionSheetButtonStyleDefault];
  JGActionSheet *alertSheet = [JGActionSheet actionSheetWithSections:@[contentSection, buttonsSection]];
  [alertSheet setInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
  [alertSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
    [sheet dismissAnimated:YES];
    if (buttonAction) {
      buttonAction();
    }
  }];
  [alertSheet showInView:relativeToView animated:YES];
}

#pragma mark - Showing Alerts

+ (void)showAlertWithTitle:(NSString *)title
                titleImage:(UIImage *)titleImage
          alertDescription:(NSAttributedString *)alertDescription
               buttonTitle:(NSString *)buttonTitle
              buttonAction:(void(^)(void))buttonAction
            relativeToView:(UIView *)relativeToView {
  [PEUIUtils showAlertWithButtonTitle:buttonTitle
                         buttonAction:buttonAction
                       relativeToView:relativeToView
                  contentSectionMaker:^{ return [PEUIUtils alertSectionWithTitle:title
                                                                      titleImage:titleImage
                                                                alertDescription:alertDescription
                                                                  relativeToView:relativeToView]; }];
}

+ (void)showConfirmAlertWithTitle:(NSString *)title
                       titleImage:(UIImage *)titleImage
                 alertDescription:(NSAttributedString *)alertDescription
                  okaybuttonTitle:(NSString *)okayButtonTitle
                 okaybuttonAction:(void(^)(void))okayButtonAction
                  okayButtonStyle:(JGActionSheetButtonStyle)okayButtonStyle
                cancelbuttonTitle:(NSString *)cancelButtonTitle
               cancelbuttonAction:(void(^)(void))cancelButtonAction
                 cancelButtonSyle:(JGActionSheetButtonStyle)cancelButtonStyle
                   relativeToView:(UIView *)relativeToView {
  JGActionSheetSection *contentSection = [PEUIUtils alertSectionWithTitle:title
                                                               titleImage:titleImage
                                                         alertDescription:alertDescription
                                                           relativeToView:relativeToView];
  JGActionSheetSection *buttonsSection = [JGActionSheetSection sectionWithTitle:nil
                                                                        message:nil
                                                                   buttonTitles:@[okayButtonTitle, cancelButtonTitle]
                                                                    buttonStyle:JGActionSheetButtonStyleDefault];
  JGActionSheet *alertSheet = [JGActionSheet actionSheetWithSections:@[contentSection, buttonsSection]];
  [buttonsSection setButtonStyle:okayButtonStyle forButtonAtIndex:0];
  [buttonsSection setButtonStyle:cancelButtonStyle forButtonAtIndex:1];
  [alertSheet setInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
  [alertSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
    switch (indexPath.row) {
      case 0:  // okay
        okayButtonAction();
        break;
      case 1:  // cancel
        cancelButtonAction();
        break;
    }
    [sheet dismissAnimated:YES];
  }];
  [alertSheet showInView:relativeToView animated:YES];
}

+ (void)showWarningConfirmAlertWithTitle:(NSString *)title
                        alertDescription:(NSAttributedString *)alertDescription
                         okaybuttonTitle:(NSString *)okayButtonTitle
                        okaybuttonAction:(void(^)(void))okayButtonAction
                       cancelbuttonTitle:(NSString *)cancelButtonTitle
                      cancelbuttonAction:(void(^)(void))cancelButtonAction
                          relativeToView:(UIView *)relativeToView {
  [self showConfirmAlertWithTitle:title
                       titleImage:[PEUIUtils bundleImageWithName:@"warning"]
                 alertDescription:alertDescription
                  okaybuttonTitle:okayButtonTitle
                 okaybuttonAction:okayButtonAction
                  okayButtonStyle:JGActionSheetButtonStyleRed
                cancelbuttonTitle:cancelButtonTitle
               cancelbuttonAction:cancelButtonAction
                 cancelButtonSyle:JGActionSheetButtonStyleDefault
                   relativeToView:relativeToView];
}

+ (void)showWarningAlertWithMsgs:(NSArray *)msgs
                           title:(NSString *)title
                alertDescription:(NSAttributedString *)alertDescription
                     buttonTitle:(NSString *)buttonTitle
                    buttonAction:(void(^)(void))buttonAction
                  relativeToView:(UIView *)relativeToView {
  [PEUIUtils showAlertWithButtonTitle:buttonTitle
                         buttonAction:buttonAction
                       relativeToView:relativeToView
                  contentSectionMaker:^{ return [PEUIUtils warningAlertSectionWithMsgs:msgs
                                                                                 title:title
                                                                      alertDescription:alertDescription
                                                                        relativeToView:relativeToView]; }];
}

+ (void)showSuccessAlertWithTitle:(NSString *)title
                 alertDescription:(NSAttributedString *)alertDescription
                      buttonTitle:(NSString *)buttonTitle
                     buttonAction:(void(^)(void))buttonAction
                   relativeToView:(UIView *)relativeToView {
  [PEUIUtils showAlertWithButtonTitle:buttonTitle
                         buttonAction:buttonAction
                       relativeToView:relativeToView
                  contentSectionMaker:^{ return [PEUIUtils successAlertSectionWithTitle:title
                                                                       alertDescription:alertDescription
                                                                         relativeToView:relativeToView]; }];
}

+ (void)showLoginSuccessAlertWithTitle:(NSString *)title
                      alertDescription:(NSAttributedString *)alertDescription
                       syncIconMessage:(NSAttributedString *)syncIconMessage
                           buttonTitle:(NSString *)buttonTitle
                          buttonAction:(void(^)(void))buttonAction
                        relativeToView:(UIView *)relativeToView {
  PEAlertSectionMaker alertSectionMaker = ^ JGActionSheetSection * {
    UIView *contentView = [PEUIUtils loginSuccessPanelWithTitle:title
                                                    description:alertDescription
                                                descriptionFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]
                                                syncIconMessage:syncIconMessage
                                                  syncImageIcon:[UIImage syncableMedIcon]
                                                 relativeToView:relativeToView];
    return [JGActionSheetSection sectionWithTitle:nil
                                          message:nil
                                      contentView:contentView];
  };  
  [PEUIUtils showAlertWithButtonTitle:buttonTitle
                         buttonAction:buttonAction
                       relativeToView:relativeToView
                  contentSectionMaker:alertSectionMaker];
}

+ (void)showSuccessAlertWithMsgs:(NSArray *)msgs
                           title:(NSString *)title
                alertDescription:(NSAttributedString *)alertDescription
                     buttonTitle:(NSString *)buttonTitle
                    buttonAction:(void(^)(void))buttonAction
                  relativeToView:(UIView *)relativeToView {
  [PEUIUtils showAlertWithButtonTitle:buttonTitle
                         buttonAction:buttonAction
                       relativeToView:relativeToView
                  contentSectionMaker:^{ return [PEUIUtils successAlertSectionWithMsgs:msgs
                                                                                 title:title
                                                                      alertDescription:alertDescription
                                                                        relativeToView:relativeToView]; }];
}

+ (void)showWaitAlertWithMsgs:(NSArray *)msgs
                        title:(NSString *)title
             alertDescription:(NSAttributedString *)alertDescription
                  buttonTitle:(NSString *)buttonTitle
                 buttonAction:(void(^)(void))buttonAction
               relativeToView:(UIView *)relativeToView {
  [PEUIUtils showAlertWithButtonTitle:buttonTitle
                         buttonAction:buttonAction
                       relativeToView:relativeToView
                  contentSectionMaker:^{ return [PEUIUtils waitAlertSectionWithMsgs:msgs
                                                                              title:title
                                                                   alertDescription:alertDescription
                                                                     relativeToView:relativeToView]; }];
}

+ (void)showErrorAlertWithMsgs:(NSArray *)msgs
                         title:(NSString *)title
              alertDescription:(NSAttributedString *)alertDescription
                   buttonTitle:(NSString *)buttonTitle
                  buttonAction:(void(^)(void))buttonAction
                relativeToView:(UIView *)relativeToView {
  [PEUIUtils showAlertWithButtonTitle:buttonTitle
                         buttonAction:buttonAction
                       relativeToView:relativeToView
                  contentSectionMaker:^{ return [PEUIUtils errorAlertSectionWithMsgs:msgs
                                                                               title:title
                                                                    alertDescription:alertDescription
                                                                      relativeToView:relativeToView]; }];
}

+ (void)showMultiErrorAlertWithFailures:(NSArray *)failures
                                  title:(NSString *)title
                       alertDescription:(NSAttributedString *)alertDescription
                            buttonTitle:(NSString *)buttonTitle
                           buttonAction:(void(^)(void))buttonAction
                         relativeToView:(UIView *)relativeToView {
  [PEUIUtils showAlertWithButtonTitle:buttonTitle
                         buttonAction:buttonAction
                       relativeToView:relativeToView
                  contentSectionMaker:^{ return [PEUIUtils multiErrorAlertSectionWithFailures:failures
                                                                                        title:title
                                                                             alertDescription:alertDescription
                                                                               relativeToView:relativeToView]; }];
}

+ (void)showMixedResultsAlertSectionWithSuccessMsgs:(NSArray *)successMsgs
                                              title:(NSString *)title
                                   alertDescription:(NSAttributedString *)alertDescription
                                failuresDescription:(NSAttributedString *)failuresDescription
                                           failures:(NSArray *)failures
                                        buttonTitle:(NSString *)buttonTitle
                                       buttonAction:(void(^)(void))buttonAction
                                     relativeToView:(UIView *)relativeToView {
  [PEUIUtils showAlertWithButtonTitle:buttonTitle
                         buttonAction:buttonAction
                       relativeToView:relativeToView
                  contentSectionMaker:^{ return [PEUIUtils mixedResultsAlertSectionWithSuccessMsgs:successMsgs
                                                                                             title:title
                                                                                  alertDescription:alertDescription
                                                                               failuresDescription:failuresDescription
                                                                                          failures:failures
                                                                                    relativeToView:relativeToView]; }];
}

+ (void)showAlertForNSURLErrorCode:(NSInteger)errorCode
                             title:(NSString *)title
                       buttonTitle:(NSString *)buttonTitle
                      buttonAction:(void(^)(void))buttonAction
                    relativeToView:(UIView *)relativeToView {
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
  [PEUIUtils showWarningAlertWithMsgs:errMsgs
                                title:title
                     alertDescription:[[NSAttributedString alloc] initWithString:@"There was a problem communicating with\n\
the server.  The error is as follows:"]
                          buttonTitle:buttonTitle
                         buttonAction:buttonAction
                       relativeToView:relativeToView];
}

@end
