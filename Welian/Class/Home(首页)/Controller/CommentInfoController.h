//
//  CommentInfoController.h
//  weLian
//
//  Created by dong on 14-10-12.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLStatusM.h"

typedef void(^WLFeedAndZanBlock)(WLStatusM *statusM);

typedef void (^WLFeedTuiBlock)(WLStatusM *starusM);

typedef void(^WLDeleteStustBlock) (WLStatusM *statusM);

@class CommentInfoController;

@interface CommentInfoController : UIViewController

@property (nonatomic, assign) BOOL beginEdit;

@property (nonatomic, copy) WLFeedAndZanBlock feedzanBlock;

@property (nonatomic, copy) WLFeedTuiBlock feedTuiBlock;

@property (nonatomic, copy) WLDeleteStustBlock deleteStustBlock;

@property (nonatomic, strong) WLStatusM *statusM;

@end
