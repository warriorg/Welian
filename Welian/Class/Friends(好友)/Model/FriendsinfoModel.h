//
//  FriendsinfoModel.h
//  weLian
//
//  Created by dong on 14/10/30.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "IBaseUserM.h"

@interface FriendsinfoModel : IBaseUserM

/**  好友状态，0普通，1加星   */
@property (nonatomic, strong) NSNumber *status;

/**  共同好友数量   */
@property (nonatomic, strong) NSNumber *samefriendcount;

/**  共同好友，通过谁认识列表（对象格式同上）2个   */
@property (nonatomic, strong) NSArray *samefriends;

@end
