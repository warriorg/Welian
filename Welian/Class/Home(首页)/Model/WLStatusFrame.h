//
//  WLStatusFrame.h
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WLStatusM;

@interface WLStatusFrame : NSObject

/** 头像 */
@property (nonatomic, assign, readonly) CGRect iconViewF;
/** 昵称 */
@property (nonatomic, assign, readonly) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign, readonly) CGRect timeLabelF;
/** 来源 */
@property (nonatomic, assign, readonly) CGRect sourceLabelF;
/** 内容 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;
/** 配图 */
@property (nonatomic, assign, readonly) CGRect photoListViewF;
/** 微博会员图标 */
@property (nonatomic, assign, readonly) CGRect mbViewF;

/** 转发微博的整体 */
@property (nonatomic, assign, readonly) CGRect retweetViewF;
/** 转发微博的昵称 */
@property (nonatomic, assign, readonly) CGRect retweetNameLabelF;
/** 转发微博的配图 */
@property (nonatomic, assign, readonly) CGRect retweetPhotoListViewF;
/** 转发微博的内容 */
@property (nonatomic, assign, readonly) CGRect retweetContentLabelF;


/** 转发微博的内容 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

/**
 *  微博数据模型
 */
@property (nonatomic, strong) WLStatusM *status;

@end
