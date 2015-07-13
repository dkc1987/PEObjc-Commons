//
// PEUIToolkit.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef UIButton * (^ButtonMaker)(NSString *, id, SEL);
typedef UIView * (^LabelMaker)(NSString *);
typedef UITextField * (^TextfieldMaker)(NSString *);
typedef UITextField * (^TaggedTextfieldMaker)(NSString *, NSInteger);
typedef UIView * (^PanelMaker)(CGFloat);
typedef void (^FromTopAnimatorWithFadeOut)(UIView *, UIView *, CGFloat, CGFloat);

/**
 A simple container-like abstraction for encapsulating styling information that
 would be used within the scope of an iOS application.  An instance of this class
 is intended to be instantiated once (within an application delegate), and passed
 along as a parameter to each instantiated view controller, so the view controller
 can use it when styling its views.
 */
@interface PEUIToolkit : NSObject

///------------------------------------------------
/// @name Initialization
///------------------------------------------------
#pragma mark - Initialization

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
        downToYForFromTopAnimation:(CGFloat)downToYForFromTopAnimation;

#pragma mark - Color Properties

@property (nonatomic, readonly) UIColor *colorForContentPanels;

@property (nonatomic, readonly) UIColor *colorForNotificationPanels;

@property (nonatomic, readonly) UIColor *colorForWindows;

@property (nonatomic, readonly) UIColor *accentColor;

@property (nonatomic, readonly) UIColor *bgColorForWarningButtons;

@property (nonatomic, readonly) UIColor *textColorForWarningButtons;

@property (nonatomic, readonly) UIColor *bgColorForPrimaryButtons;

@property (nonatomic, readonly) UIColor *textColorForPrimaryButtons;

@property (nonatomic, readonly) UIColor *bgColorForDangerButtons;

@property (nonatomic, readonly) UIColor *textColorForDangerButtons;

@property (nonatomic, readonly) UIColor *colorForHeader1Labels;

@property (nonatomic, readonly) UIColor *colorForHeader2Labels;

@property (nonatomic, readonly) UIColor *colorForTextfields;

@property (nonatomic, readonly) UIColor *colorForTableCellTitles;

@property (nonatomic, readonly) UIColor *colorForTableCellSubtitles;

#pragma mark - Button-specific Properties

@property (nonatomic, readonly) CGFloat cornerRadiusForButtons;

@property (nonatomic, readonly) CGFloat verticalPaddingForButtons;

@property (nonatomic, readonly) CGFloat horizontalPaddingForButtons;

#pragma mark - Font Properties

@property (nonatomic, readonly) UIFont *fontForButtons;

@property (nonatomic, readonly) UIFont *fontForHeader1Labels;

@property (nonatomic, readonly) UIFont *fontForHeader2Labels;

@property (nonatomic, readonly) UIFont *fontForTextfields;

@property (nonatomic, readonly) UIFont *fontForTableCellTitles;

@property (nonatomic, readonly) UIFont *fontForTableCellSubtitles;

#pragma mark - Padding Properties

@property (nonatomic, readonly) CGFloat topBottomPaddingForContentPanels;

@property (nonatomic, readonly) CGFloat leftViewPaddingForTextfields;

@property (nonatomic, readonly) CGFloat heightFactorForTextfields;

#pragma mark - Animation Properties

@property (nonatomic, readonly) NSTimeInterval durationForFrameAnimation;

@property (nonatomic, readonly) NSTimeInterval durationForFadeOutAnimation;

@property (nonatomic, readonly) CGFloat downToYForFromTopAnimation;

#pragma mark - Animator makers

- (FromTopAnimatorWithFadeOut)fromTopWithFadeOutAnimatorMaker;

#pragma mark - Panel makers

- (PanelMaker)contentPanelMakerRelativeTo:(UIView *)relativeToView;

- (PanelMaker)notificationPanelMakerRelativeTo:(UIView *)relativeToView;

- (PanelMaker)accentPanelMakerRelativeTo:(UIView *)relativeToView;

#pragma mark - Button makers

- (ButtonMaker)systemButtonMaker;

- (ButtonMaker)primaryButtonMaker;

- (ButtonMaker)warningButtonMaker;

- (ButtonMaker)dangerButtonMaker;

#pragma mark - Label makers

- (LabelMaker)header1Maker;

- (LabelMaker)header2Maker;

- (LabelMaker)tableCellTitleMaker;

- (LabelMaker)tableCellSubtitleMaker;

#pragma mark - Text TextField makers

- (TextfieldMaker)textfieldMakerForFixedWidth:(CGFloat)width;

- (TextfieldMaker)textfieldMakerForWidthOf:(CGFloat)percentage
                                relativeTo:(UIView *)relativeToView;

- (TaggedTextfieldMaker)taggedTextfieldMakerForFixedWidth:(CGFloat)width;

- (TaggedTextfieldMaker)taggedTextfieldMakerForWidthOf:(CGFloat)percentage
                                            relativeTo:(UIView *)relativeToView;

#pragma mark - Resizing

- (void)adjustHeightToFitSubviewsForContentPanel:(UIView *)panel;

@end
