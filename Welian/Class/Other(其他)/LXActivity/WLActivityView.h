//
//  WLActivityView.h
//  Welian
//
//  Created by dong on 15/3/4.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLActivityView : UIView

#pragma mark - Public method
- (id)initWithOneSectionArray:(NSArray *)oneArray andTwoArray:(NSArray *)twoArray;

- (void)show;

- (void)tappedCancel;
@end
