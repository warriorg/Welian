//
//  WLStatusDock.h
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLStatusM;


@interface WLStatusDock : UIImageView

//* 转发*//
@property (nonatomic, strong) UIButton *repostBtn;

//* 评论*//
@property (nonatomic, strong) UIButton *commentBtn;

//* 赞*//
@property (nonatomic, strong) UIButton *attitudeBtn;

@property (nonatomic, strong) WLStatusM *status;

@end
