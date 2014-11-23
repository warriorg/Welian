//
//  WLStatusM.h
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WLBasicTrends.h"


@interface WLStatusM : NSObject

/**  微博UID   */
@property (nonatomic, assign) int fid;

/**  微博信息内容   */
@property (nonatomic, strong) NSString *content;
/**  微博创建时间   */
@property (nonatomic, strong) NSString *created;

/** int	转发数 */
@property (nonatomic, assign) int forwardcount;
/** int	评论数 */
@property (nonatomic, assign) int commentcount;
/** int	表态数 */
@property (nonatomic, assign) int zan;

/**  1已赞 0未赞  */
@property (nonatomic, assign) int iszan;

/**  纬度   */
@property (nonatomic, assign) float  x;
/**  经度   */
@property (nonatomic, assign) float  y;

/** object	微博作者的用户信息字段 详细 */
@property (nonatomic, strong) WLBasicTrends *user;

/** object	被转发的原微博信息字段，当该微博为转发微博时返回 详细 */
@property (nonatomic, strong) WLStatusM *relationfeed;


/** object 	微博配图地址。多图时返回多图链接。无配图返回“[]”  */
@property (nonatomic, strong) NSArray *photos;

//** 分享URL *//
@property (nonatomic, strong) NSString *shareurl;

/**  评论列表   */
@property (nonatomic, strong) NSArray *commentsArray;

/**  赞 列表   */
@property (nonatomic, strong) NSArray *zansArray;

/**  转发列表   */
@property (nonatomic, strong) NSArray *forwardsArray;

/**  和谁一起   */
//@property (nonatomic, strong) NSArray *with;

@end
