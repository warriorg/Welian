//
//  WLContentCellFrame.h
//  weLian
//
//  Created by dong on 14/11/21.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WLStatusM;

@interface WLContentCellFrame : NSObject

- (instancetype)initWithWidth:(CGFloat)width;

/** 内容 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;
/** 配图 */
@property (nonatomic, assign, readonly) CGRect photoListViewF;
///****项目和活动*****////
@property (nonatomic, assign, readonly) CGRect cellCardF;
/** 转发的整体 */
//@property (nonatomic, assign, readonly) CGRect retweetViewF;
/** 转发的昵称 */
//@property (nonatomic, assign, readonly) CGRect retweetNameLabelF;
/** 转发的配图 */
//@property (nonatomic, assign, readonly) CGRect retweetPhotoListViewF;
/** 转发的内容 */
//@property (nonatomic, assign, readonly) CGRect retweetContentLabelF;

/** 整体的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

/** dock Y  */
@property (nonatomic, assign, readonly) CGRect dockFrame;

/**
 *  微博数据模型
 */
@property (nonatomic, strong) WLStatusM *status;

@end
