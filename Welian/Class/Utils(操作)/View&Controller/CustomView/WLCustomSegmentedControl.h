//
//  WLCustomSegmentedControl.h
//  Welian
//
//  Created by weLian on 15/3/24.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IndexChangeBlock)(NSInteger index);

@interface WLCustomSegmentedControl : UIControl

@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray *sectionImages;
@property (nonatomic, strong) NSArray *sectionBadges;//角标
@property (nonatomic, strong) NSArray *sectionDetailTitles;//

/**
 Provide a block to be executed when selected index is changed.
 
 Alternativly, you could use `addTarget:action:forControlEvents:`
 */
@property (nonatomic, copy) IndexChangeBlock indexChangeBlock;

/**
 Font for segments names when segmented control type is `HMSegmentedControlTypeText`
 
 Default is `[UIFont fontWithName:@"STHeitiSC-Light" size:18.0f]`
 */
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIFont *detailLabelFont;

/**
 Text color for segments names when segmented control type is `HMSegmentedControlTypeText`
 
 Default is `[UIColor blackColor]`
 */
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *detailTextColor;

/**
 Text color for selected segment name when segmented control type is `HMSegmentedControlTypeText`
 
 Default is `[UIColor blackColor]`
 */
@property (nonatomic, strong) UIColor *selectedTextColor;

//是否显示分割线
@property (nonatomic, assign) BOOL showLine;
@property (nonatomic, assign) BOOL showBottomLine;
//标题和副标题排列方式  默认为横向
@property (nonatomic, assign) BOOL isShowVertical;//是否纵向排列
@property (nonatomic, assign) BOOL isAllowTouchEveryTime;//是否允许每次重复点击

/**
 Segmented control background color.
 
 Default is `[UIColor whiteColor]`
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 Color for the selection indicator stripe/box
 
 Default is `R:52, G:181, B:229`
 */
@property (nonatomic, strong) UIColor *selectionIndicatorColor;

/*
 Default is NO. Set to YES to allow for adding more tabs than the screen width could fit.
 
 When set to YES, segment width will be automatically set to the width of the biggest segment's text or image,
 otherwise it will be equal to the width of the control's frame divided by the number of segments.
 
 As of v 1.4 this is no longer needed. The control will manage scrolling automatically based on tabs sizes.
 */
@property(nonatomic, getter = isScrollEnabled) BOOL scrollEnabled DEPRECATED_ATTRIBUTE;

/**
 Default is YES. Set to NO to deny scrolling by dragging the scrollView by the user.
 */
@property(nonatomic, getter = isUserDraggable) BOOL userDraggable;

/**
 Default is YES. Set to NO to deny any touch events by the user.
 */
@property(nonatomic, getter = isTouchEnabled) BOOL touchEnabled;

/**
 Default is NO. Set to YES to show a vertical divider between the segments.
 */
@property(nonatomic, getter = isVerticalDividerEnabled) BOOL verticalDividerEnabled;

/**
 Index of the currently selected segment.
 */
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

/**
 Height of the selection indicator. Only effective when `HMSegmentedControlSelectionStyle` is either `HMSegmentedControlSelectionStyleTextWidthStripe` or `HMSegmentedControlSelectionStyleFullWidthStripe`.
 
 Default is 5.0
 */
@property (nonatomic, readwrite) CGFloat selectionIndicatorHeight;

/**
 Edge insets for the selection indicator.
 NOTE: This does not affect the bounding box of HMSegmentedControlSelectionStyleBox
 
 When HMSegmentedControlSelectionIndicatorLocationUp is selected, bottom edge insets are not used
 
 When HMSegmentedControlSelectionIndicatorLocationDown is selected, top edge insets are not used
 
 Defaults are top: 0.0f
 left: 0.0f
 bottom: 0.0f
 right: 0.0f
 */
@property (nonatomic, readwrite) UIEdgeInsets selectionIndicatorEdgeInsets;

/**
 Inset left and right edges of segments. Only effective when `scrollEnabled` is set to YES.
 
 Default is UIEdgeInsetsMake(0, 5, 0, 5)
 */
@property (nonatomic, readwrite) UIEdgeInsets segmentEdgeInset;

/**
 Default is YES. Set to NO to disable animation during user selection.
 */
@property (nonatomic) BOOL shouldAnimateUserSelection;


- (id)initWithSectionTitles:(NSArray *)sectiontitles;
- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setIndexChangeBlock:(IndexChangeBlock)indexChangeBlock;

@end
