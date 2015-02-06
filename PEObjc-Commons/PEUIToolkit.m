//
// PEUIToolkit.m
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

#import "PEUIUtils.h"
#import "PEUIToolkit.h"

@implementation PEUIToolkit

#pragma mark - Initializers

-(id)initWithColorForContentPanels:(UIColor *)colorForContentPanels
        colorForNotificationPanels:(UIColor *)colorForNotificationPanels
                   colorForWindows:(UIColor *)colorForWindows
  topBottomPaddingForContentPanels:(CGFloat)topBottomPaddingForContentPanels
                       accentColor:(UIColor *)accentColor
                    fontForButtons:(UIFont *)fontForButtons
            cornerRadiusForButtons:(CGFloat)cornerRadiusForButtons
         verticalPaddingForButtons:(CGFloat)verticalPaddingForButtons
       horizontalPaddingForButtons:(CGFloat)horizontalPaddingForButtons
          bgColorForWarningButtons:(UIColor *)bgColorForWarningButtons
        textColorForWarningButtons:(UIColor *)textColorForWarningButtons
          bgColorForPrimaryButtons:(UIColor *)bgColorForPrimaryButtons
        textColorForPrimaryButtons:(UIColor *)textColorForPrimaryButtons
           bgColorForDangerButtons:(UIColor *)bgColorForDangerButtons
         textColorForDangerButtons:(UIColor *)textColorForDangerButtons
              fontForHeader1Labels:(UIFont *)fontForHeader1Labels
             colorForHeader1Labels:(UIColor *)colorForHeader1Labels
             fontForHeaders2Labels:(UIFont *)fontForHeader2Labels
             colorForHeader2Labels:(UIColor *)colorForHeader2Labels
                 fontForTextfields:(UIFont *)fontForTextfields
                colorForTextfields:(UIColor *)colorForTextfields
         heightFactorForTextfields:(CGFloat)heightFactorForTextfields
      leftViewPaddingForTextfields:(CGFloat)leftViewPaddingForTextfields
            fontForTableCellTitles:(UIFont *)fontForTableCellTitles
           colorForTableCellTitles:(UIColor *)colorForTableCellTitles
         fontForTableCellSubtitles:(UIFont *)fontForTableCellSubtitles
        colorForTableCellSubtitles:(UIColor *)colorForTableCellSubtitles
         durationForFrameAnimation:(NSTimeInterval)durationForFrameAnimation
       durationForFadeOutAnimation:(NSTimeInterval)durationForFadeOutAnimation
        downToYForFromTopAnimation:(CGFloat)downToYForFromTopAnimation {
  self = [super init];
  if (self) {
    _colorForContentPanels = colorForContentPanels;
    _colorForNotificationPanels = colorForNotificationPanels;
    _colorForWindows = colorForWindows;
    _topBottomPaddingForContentPanels = topBottomPaddingForContentPanels;
    _accentColor = accentColor;
    _fontForButtons = fontForButtons;
    _cornerRadiusForButtons = cornerRadiusForButtons;
    _verticalPaddingForButtons = verticalPaddingForButtons;
    _horizontalPaddingForButtons = horizontalPaddingForButtons;
    _bgColorForWarningButtons = bgColorForWarningButtons;
    _textColorForWarningButtons = textColorForWarningButtons;
    _bgColorForPrimaryButtons = bgColorForPrimaryButtons;
    _textColorForPrimaryButtons = textColorForPrimaryButtons;
    _bgColorForDangerButtons = bgColorForDangerButtons;
    _textColorForDangerButtons = textColorForDangerButtons;
    _fontForHeader1Labels = fontForHeader1Labels;
    _colorForHeader1Labels = colorForHeader1Labels;
    _fontForHeader2Labels = fontForHeader2Labels;
    _colorForHeader2Labels = colorForHeader2Labels;
    _fontForTextfields = fontForTextfields;
    _colorForTextfields = colorForTextfields;
    _leftViewPaddingForTextfields = leftViewPaddingForTextfields;
    _heightFactorForTextfields = heightFactorForTextfields;
    _fontForTableCellTitles = fontForTableCellTitles;
    _colorForTableCellTitles = colorForTableCellTitles;
    _fontForTableCellSubtitles = fontForTableCellSubtitles;
    _colorForTableCellSubtitles = colorForTableCellSubtitles;
    _durationForFrameAnimation = durationForFrameAnimation;
    _durationForFadeOutAnimation = durationForFadeOutAnimation;
    _downToYForFromTopAnimation = downToYForFromTopAnimation;
  }
  return self;
}

#pragma mark - Animator makers

- (FromTopAnimatorWithFadeOut)fromTopWithFadeOutAnimatorMaker {
  return ^(UIView *view, UIView *relativeToView, CGFloat extraDownToY, CGFloat addlFadeOutDuration) {
    [PEUIUtils placeAndAnimateView:view
                     fromTopOfView:relativeToView
                           downToY:([self downToYForFromTopAnimation] + extraDownToY)
                     withAlignment:PEUIHorizontalAlignmentTypeCenter
                          hpadding:0
                          duration:[self durationForFrameAnimation]
                   fadeOutDuration:([self durationForFadeOutAnimation] + addlFadeOutDuration)];
  };
}

#pragma mark - Panel makers

- (PanelMaker)contentPanelMakerRelativeTo:(UIView *)relativeToView {
  return ^(CGFloat ofWidth) {
    UIView *panel = [PEUIUtils panelWithWidthOf:ofWidth
                                 relativeToView:relativeToView
                                    fixedHeight:0];
    [panel setBackgroundColor:[self colorForContentPanels]];
    return panel;
  };
}

- (PanelMaker)notificationPanelMakerRelativeTo:(UIView *)relativeToView {
  return ^(CGFloat ofWidth) {
    UIView *panel = [PEUIUtils panelWithWidthOf:ofWidth
                                 relativeToView:relativeToView
                                    fixedHeight:0];
    [panel setBackgroundColor:[self colorForNotificationPanels]];
    return panel;
  };
}

- (PanelMaker)accentPanelMakerRelativeTo:(UIView *)relativeToView {
  return ^(CGFloat ofWidth) {
    UIView *panel = [PEUIUtils panelWithWidthOf:ofWidth
                                 relativeToView:relativeToView
                                    fixedHeight:0];
    [panel setBackgroundColor:[self accentColor]];
    return panel;
  };
}

#pragma mark - Button makers

- (ButtonMaker)systemButtonMaker {
  return ^(NSString *key, id target, SEL action) {
    return [PEUIUtils buttonWithKey:key
                               font:[self fontForButtons]
                    backgroundColor:[UIColor whiteColor]
                          textColor:[UIColor darkTextColor]
       disabledStateBackgroundColor:[UIColor whiteColor]
             disabledStateTextColor:[UIColor grayColor]
                    verticalPadding:[self verticalPaddingForButtons]
                  horizontalPadding:[self horizontalPaddingForButtons]
                       cornerRadius:0.0
                             target:target
                             action:action];
  };
}

- (ButtonMaker)warningButtonMaker {
  return ^(NSString *key, id target, SEL action) {
    return [PEUIUtils buttonWithKey:key
                               font:[self fontForButtons]
                    backgroundColor:[self bgColorForWarningButtons]
                          textColor:[self textColorForWarningButtons]
       disabledStateBackgroundColor:[UIColor grayColor]
             disabledStateTextColor:[UIColor grayColor]
                    verticalPadding:[self verticalPaddingForButtons]
                  horizontalPadding:[self horizontalPaddingForButtons]
                       cornerRadius:[self cornerRadiusForButtons]
                             target:target
                             action:action];
  };
}

- (ButtonMaker)dangerButtonMaker {
  return ^(NSString *key, id target, SEL action) {
    return [PEUIUtils buttonWithKey:key
                               font:[self fontForButtons]
                    backgroundColor:[self bgColorForDangerButtons]
                          textColor:[self textColorForDangerButtons]
                      disabledStateBackgroundColor:[UIColor grayColor]
             disabledStateTextColor:[UIColor grayColor]
                    verticalPadding:[self verticalPaddingForButtons]
                  horizontalPadding:[self horizontalPaddingForButtons]
                       cornerRadius:[self cornerRadiusForButtons]
                             target:target
                             action:action];
  };
}

- (ButtonMaker)primaryButtonMaker {
  return ^(NSString *key, id target, SEL action) {
    return [PEUIUtils buttonWithKey:key
                               font:[self fontForButtons]
                    backgroundColor:[self bgColorForPrimaryButtons]
                          textColor:[self textColorForPrimaryButtons]
       disabledStateBackgroundColor:[UIColor grayColor]
             disabledStateTextColor:[UIColor grayColor]
                    verticalPadding:[self verticalPaddingForButtons]
                  horizontalPadding:[self horizontalPaddingForButtons]
                       cornerRadius:[self cornerRadiusForButtons]
                             target:target
                             action:action];
  };
}

#pragma mark - Label makers

- (LabelMaker)header1Maker {
  return ^(NSString *key) {
    return [PEUIUtils labelWithKey:key
                              font:[self fontForHeader1Labels]
                   backgroundColor:[UIColor clearColor]
                         textColor:[self colorForHeader1Labels]
             horizontalTextPadding:0
               verticalTextPadding:0];
  };
}

- (LabelMaker)header2Maker {
  return ^(NSString *key) {
    return [PEUIUtils labelWithKey:key
                              font:[self fontForHeader2Labels]
                   backgroundColor:[UIColor clearColor]
                         textColor:[self colorForHeader2Labels]
             horizontalTextPadding:0
               verticalTextPadding:0];
  };
}

- (LabelMaker) tableCellTitleMaker {
  return ^(NSString *key) {
    return [PEUIUtils labelWithKey:key
                              font:[self fontForTableCellTitles]
                   backgroundColor:[UIColor clearColor]
                         textColor:[self colorForTableCellTitles]
             horizontalTextPadding:0
               verticalTextPadding:0];
  };
}

- (LabelMaker) tableCellSubtitleMaker {
  return ^(NSString *key) {
    return [PEUIUtils labelWithKey:key
                              font:[self fontForTableCellSubtitles]
                   backgroundColor:[UIColor clearColor]
                         textColor:[self colorForTableCellSubtitles]
             horizontalTextPadding:0
               verticalTextPadding:5];
  };
}

#pragma mark - Text TextField makers

- (TextfieldMaker)textfieldMakerForFixedWidth:(CGFloat)width {
  return ^(NSString *key) {
    return [PEUIUtils
             textfieldWithPlaceholderTextKey:key
                                        font:[self fontForTextfields]
                             backgroundColor:[self colorForTextfields]
                             leftViewPadding:[self leftViewPaddingForTextfields]
                                  fixedWidth:width
                                heightFactor:[self heightFactorForTextfields]];
  };
}

- (TextfieldMaker)textfieldMakerForWidthOf:(CGFloat)percentage
                                relativeTo:(UIView *)relativeToView {
  CGFloat width = percentage * [relativeToView frame].size.width;
  return [self textfieldMakerForFixedWidth:width];
}

- (TaggedTextfieldMaker)taggedTextfieldMakerForFixedWidth:(CGFloat)width {
  return ^UITextField *(NSString *key, NSInteger tag) {
    UITextField *tf =
      [PEUIUtils textfieldWithPlaceholderTextKey:key
                                            font:[self fontForTextfields]
                                 backgroundColor:[self colorForTextfields]
                                 leftViewPadding:[self leftViewPaddingForTextfields]
                                      fixedWidth:width
                                    heightFactor:[self heightFactorForTextfields]];
    [tf setTag:tag];
    return tf;
  };
}

- (TaggedTextfieldMaker)taggedTextfieldMakerForWidthOf:(CGFloat)percentage
                                            relativeTo:(UIView *)relativeToView {
  CGFloat width = percentage * [relativeToView frame].size.width;
  return [self taggedTextfieldMakerForFixedWidth:width];
}

#pragma mark - Resizing

- (void)adjustHeightToFitSubviewsForContentPanel:(UIView *)panel {
  [PEUIUtils
    adjustHeightToFitSubviewsForView:panel
                       bottomPadding:[self topBottomPaddingForContentPanels]];
}

@end
