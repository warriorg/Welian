//
//  IFriend2InfoModel.h
//  Welian
//
//  Created by weLian on 15/4/28.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IBaseUserM.h"

@interface IFriend2InfoModel : IBaseUserM

//  共同好友数量
@property (nonatomic, strong) NSNumber *samefriendcount;

//  共同好友，通过谁认识列表（对象格式同上）2个
@property (nonatomic, strong) NSArray *samefriends;

@end
