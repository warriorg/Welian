//
//  WLBasicTrends.h
//  Welian
//
//  Created by dong on 14-9-23.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WLVerifiedTypeNone = 0,
    WLVerifiedTypeInvestor = 1,  // 投资人
    WLVerifiedTypeCarver = 2, // 创业者
    WLVerifiedTypeInvestorAndCarver = 3, //投资人，创业者，
} WLVerifiedType;

typedef enum {
    WLRelationTypeNone = 0,
    WLRelationTypeFriend = 1,  // 朋友
    WLRelationTypeFriendsFriend = 2, // 朋友的朋友
} WLRelationType;

@interface WLBasicTrends : NSObject


/**   姓名  */
@property (nonatomic, strong) NSString *name;

/**  头像图片   */
@property (nonatomic, strong) NSString *avatar;
/**  uid   */
@property (nonatomic, strong) NSString *uid;

/**  0 非，1 投资人，2 创业者，3 兼   */
@property (nonatomic, assign) WLVerifiedType status;

/**  关系 0非，1好友，2好友的好友  */
@property (nonatomic, assign) WLRelationType relation;


@end
