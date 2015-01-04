//
//  CommentInfoController.h
//  weLian
//
//  Created by dong on 14-10-12.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "BasicViewController.h"
#import "WLStatusM.h"

// 点赞
typedef void(^WLFeedAndZanBlock)(WLStatusM *statusM);

// 转推
typedef void (^WLFeedTuiBlock)(WLStatusM *starusM);

// 评论
typedef void (^WLCommentBlock)(WLStatusM *starusM);

// 删除
typedef void(^WLDeleteStustBlock) (WLStatusM *statusM);

@class CommentInfoController;


@interface CommentInfoController : BasicViewController

@property (nonatomic, assign) BOOL beginEdit;

@property (nonatomic, copy) WLFeedAndZanBlock feedzanBlock;

@property (nonatomic, copy) WLFeedTuiBlock feedTuiBlock;

@property (nonatomic, copy) WLDeleteStustBlock deleteStustBlock;

@property (nonatomic, copy) WLCommentBlock commentBlock;

@property (nonatomic, strong) WLStatusM *statusM;

@end
