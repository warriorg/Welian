//
//  CommentCellFrame.h
//  weLian
//
//  Created by dong on 14-10-13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentMode.h"

@interface CommentCellFrame : NSObject

/** 头像 */
@property (nonatomic, assign, readonly) CGRect iconViewF;
/** 昵称 */
@property (nonatomic, assign, readonly) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign, readonly) CGRect timeLabelF;

/** 内容 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;

/** cell高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

// * 评论数据模型 */
@property (nonatomic,strong) CommentMode *commentM;

@end
