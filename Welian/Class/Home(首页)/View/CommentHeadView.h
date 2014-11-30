//
//  CommentHeadView.h
//  weLian
//
//  Created by dong on 14/11/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentHeadFrame.h"
#import "WLCellHead.h"

typedef void (^FeedAndZanBlock)(WLStatusM *starusM);

@interface CommentHeadView : UIView
 //** 头部view   *//
@property (nonatomic, strong) WLCellHead *cellHeadView;

@property (nonatomic, strong) CommentHeadFrame *commHeadFrame;

@property (nonatomic, copy) FeedAndZanBlock feezanBlock;

@property (nonatomic, strong) UIViewController *homeVC;

@end
