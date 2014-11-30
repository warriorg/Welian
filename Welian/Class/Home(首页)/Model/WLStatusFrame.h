//
//  WLStatusFrame.h
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLContentCellFrame.h"
#import "FeedAndZanFrameM.h"
#import "CommentHomeViewFrame.h"
@class WLStatusM;

@interface WLStatusFrame : NSObject

- (instancetype)initWithWidth:(CGFloat)width;

/**  内容的frame   */
@property (nonatomic, strong, readonly)  WLContentCellFrame *contentFrame;

/**  赞和转发人 frame   */
@property (nonatomic, strong, readonly) FeedAndZanFrameM *feedAndZanFM;

/**  评论 frame   */
@property (nonatomic, strong, readonly) CommentHomeViewFrame *commentListFrame;

@property (nonatomic, assign, readonly) CGFloat cellHigh;

/**
 *  微博数据模型
 */
@property (nonatomic, strong) WLStatusM *status;

@end
