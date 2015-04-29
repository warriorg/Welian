//
//  WLStatusM.h
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "IFBase.h"
//#import "WLBasicTrends.h"
#import "CardStatuModel.h"

@interface WLStatusM : IFBase

///* 自己发送  重新发送 0无状态  1 重新发送  2 发送中... *//
@property (nonatomic, assign) int sendType;

@property (nonatomic, strong) NSString *sendId;

/** 0 正常动态，1 转推的动态，2推荐的动态，3创建的活动，4 修改个人公司，5 参加的活动，6 修改学校资料，10创建项目，11 网页, 12点评项目  13 自己正在发布的动态*/
@property (nonatomic, assign) NSNumber *type;

/***  列表中动态最大id，用户新动态提示   */
@property (nonatomic, assign) NSNumber *topid;

/**  推荐理由（你的通讯录中有N个好友与TA是微链好友）   */
@property (nonatomic, strong) NSString *commandmsg;

/**  微博UID   */
@property (nonatomic, assign) NSNumber *fid;

/**  微博信息内容   */
@property (nonatomic, strong) NSString *content;
/**  微博创建时间   */
@property (nonatomic, strong) NSString *created;

/** int	转发数 */
@property (nonatomic, assign) NSNumber *forwardcount;
/** int	评论数 */
@property (nonatomic, assign) NSNumber *commentcount;
/** int	表态数 */
@property (nonatomic, assign) NSNumber *zan;

/**  1已赞 0未赞  */
@property (nonatomic, assign) NSNumber *iszan;

/**  是否推过 1已推 0未推  */
@property (nonatomic, assign) NSNumber *isforward;

/**  纬度   */
@property (nonatomic, assign) NSNumber  *x;
/**  经度   */
@property (nonatomic, assign) NSNumber  *y;

/** object	微博作者的用户信息字段 详细 */
@property (nonatomic, strong) IBaseUserM *user;

/**  转推的人   */
@property (nonatomic, strong) IBaseUserM *tuiuser;

/** object	被转发的原微博信息字段，当该微博为转发微博时返回 详细 */
//@property (nonatomic, strong) WLStatusM *relationfeed;


/** object 	微博配图地址。多图时返回多图链接。无配图返回“[]”  */
@property (nonatomic, strong) NSArray *photos;

//** 分享URL *//
@property (nonatomic, strong) NSString *shareurl;

/**  评论列表   */
@property (nonatomic, strong) NSArray *comments;

/**  赞 列表   */
@property (nonatomic, strong) NSArray *zans;

/**  转发列表   */
@property (nonatomic, strong) NSArray *forwards;

/**  和谁一起   */
//@property (nonatomic, strong) NSArray *with;

//** 动态卡片显示 **//
@property (nonatomic, strong) CardStatuModel *card;

// * 对项目的点评，活动参与人 *//
@property (nonatomic, strong) NSArray *joinedusers;

/*

 "card":{
 
 "cid":10086,
 
 "type":1，   //10 文章，11 活动，12 项目，13 话题，
 
 "title":"题目",
 
 “intro”:"简介",
 
 "url":"http://www.welian.com"
 
 }

*/

@end
