//
//  UserInfoViewController.h
//  Welian
//
//  Created by weLian on 15/3/25.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BasicViewController.h"

@interface UserInfoViewController : BasicViewController

@property (nonatomic, copy) dispatch_block_t acceptFriendBlock;
@property (nonatomic, copy) dispatch_block_t addFriendBlock;

- (instancetype)initWithBaseUserM:(IBaseUserM *)iBaseUserModel OperateType:(NSNumber *)operateType;

@end
