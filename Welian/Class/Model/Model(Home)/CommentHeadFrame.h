//
//  CommentHeadFrame.h
//  weLian
//
//  Created by dong on 14/11/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLContentCellFrame.h"
#import "WLStatusM.h"


@interface CommentHeadFrame : NSObject


- (instancetype)initWithWidth:(CGFloat)width;

/**  内容的frame   */
@property (nonatomic, strong)  WLContentCellFrame *contentFrame;

@property (nonatomic, assign) CGFloat cellHigh;
/**
 *  微博数据模型
 */
@property (nonatomic, strong) WLStatusM *status;

@end
