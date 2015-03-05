//
//  ListItem.h
//  POHorizontalList
//
//  Created by Polat Olu on 15/02/2013.
//  Copyright (c) 2013 Polat Olu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HMSegmentedControlSelectionStyleTextWidthStripe = 0, //
    HMSegmentedControlSelectionStyleFullWidthStripe, //
    HMSegmentedControlSelectionStyleBox, //
    HMSegmentedControlSelectionStyleArrow, //
    HMSegmentedControlSelectionStylexx, //
    HMSegmentedControlSelectionStyleA, //
    HMSegmentedControlSelectionStyleasd, //
    HMSegmentedControlSelectionStyleaSDE //
} HMSegmentedControlSelectionStyle;

typedef void (^WLActivityBlock)(HMSegmentedControlSelectionStyle duration);
typedef void (^ActivityCanleBlock)();

@interface ListItem : UIView {
    CGRect textRect;
    CGRect imageRect;
}

@property (nonatomic, retain) NSObject *objectTag;
@property (nonatomic, retain) NSString *imageTitle;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, copy)   WLActivityBlock activityBlock;
@property (nonatomic, copy)   ActivityCanleBlock canleBlock;
@property (nonatomic, assign) HMSegmentedControlSelectionStyle seleStyle;

- (id)initWithImage:(UIImage *)image text:(NSString *)imageTitle selectionStyle:(HMSegmentedControlSelectionStyle)style;

@end
