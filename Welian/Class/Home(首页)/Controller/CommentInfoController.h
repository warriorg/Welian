//
//  CommentInfoController.h
//  weLian
//
//  Created by dong on 14-10-12.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLStatusCell.h"
@class CommentInfoController;

@protocol CommentInfoVCDelegate <NSObject>

- (void)commentInfoController:(CommentInfoController*)commentVC isDelete:(BOOL)isdelete withStatusFrame:(WLStatusFrame*)statusF;

@end

@interface CommentInfoController : UIViewController

@property (nonatomic, assign) BOOL beginEdit;
@property (nonatomic, strong) WLStatusFrame *statusFrame;

@property (nonatomic, weak) id<CommentInfoVCDelegate>delegate;

@end
