//
//  IBaseUserModel.h
//  Welian
//
//  Created by dong on 15/4/24.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface IBaseUserModel : IFBase

@property (nonatomic, strong) NSNumber *uid;    //uid唯一标示
@property (nonatomic, strong) NSString *name;   //用户姓名
@property (nonatomic, strong) NSString *avatar; //用户头像
@property (nonatomic, strong) NSString *company;//用户公司
@property (nonatomic, strong) NSString *position;//用户职务
/**  投资者认证  0 默认状态  1  认证成功  -2 正在审核  -1 认证失败 */
@property (nonatomic, strong) NSNumber *investorauth;
/**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
@property (nonatomic, strong) NSNumber *friendship;
@property (nonatomic, strong) NSNumber *checked;//手机号码是否验证

@end
