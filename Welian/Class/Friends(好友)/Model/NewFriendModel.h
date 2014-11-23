//
//  NewFriendModel.h
//  weLian
//
//  Created by dong on 14/10/26.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewFriendModel : NSObject

/**  添加时间   */
@property (nonatomic, strong) NSString *created;

/**  是否已读   */
@property (nonatomic, strong) NSString *isLook;

/**  推送类型   */
@property (nonatomic, strong) NSString *type;

/**  uid   */
@property (nonatomic, strong) NSNumber *uid;

/**  姓名   */
@property (nonatomic, strong) NSString *name;

/**  公司   */
@property (nonatomic, strong) NSString *company;

/**  职务   */
@property (nonatomic, strong) NSString *position;

/**  头像   */
@property (nonatomic, strong) NSString *avatar;

/**  投资认证   */
//@property (nonatomic, strong) NSNumber *investorauth;

/**  创业认证   */
//@property (nonatomic, strong) NSNumber *startupauth;

/**  请求信息   */
@property (nonatomic, strong) NSString *msg;

//** 是否通过*/
@property (nonatomic, strong) NSString *isAgree;

@end
