//
//  CardAlertView.h
//  Welian
//
//  Created by weLian on 15/3/20.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sendCardSuccessBlock)(void);

@interface CardAlertView : UIView

@property (strong,nonatomic) sendCardSuccessBlock sendSuccessBlock;

- (instancetype)initWithCardModel:(CardStatuModel *)cardModel Friend:(MyFriendUser *)friendUser;

//显示
- (void)show;

@end
