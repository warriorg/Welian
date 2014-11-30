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

typedef void(^WLDeleteStustBlock) (WLStatusM *statusM);

@class CommentInfoController;

//@protocol CommentInfoVCDelegate <NSObject>
//
//- (void)commentInfoController:(CommentInfoController*)commentVC isDelete:(BOOL)isdelete withStatusFrame:(WLStatusM*)statusM;
//
//@end

@interface CommentInfoController : UIViewController

@property (nonatomic, assign) BOOL beginEdit;

@property (nonatomic, copy) WLFeedAndZanBlock feedzanBlock;

@property (nonatomic, copy) WLDeleteStustBlock deleteStustBlock;

@property (nonatomic, strong) WLStatusM *statusM;

//@property (nonatomic, weak) id<CommentInfoVCDelegate>delegate;

@end
