//
//  NewFriendModel.h
//  weLian
//
//  Created by dong on 14/10/26.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "IBaseUserM.h"

@interface NewFriendModel : IBaseUserM

/**  添加时间   */
@property (nonatomic, strong) NSString *created;

/**  是否已读   */
@property (nonatomic, strong) NSNumber *isLook;

/**  推送类型   */
@property (nonatomic, strong) NSString *type;

/**  请求信息   */
@property (nonatomic, strong) NSString *msg;

//** 是否通过*/
@property (nonatomic, strong) NSNumber *isAgree;

//操作类型
@property (nonatomic, retain) NSNumber * operateType;

@end
