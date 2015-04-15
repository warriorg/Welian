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

////操作类型0：添加 1：接受  2:已添加 3：待验证   10:隐藏操作按钮
- (instancetype)initWithBaseUserM:(IBaseUserM *)iBaseUserModel OperateType:(NSNumber *)operateType HidRightBtn:(BOOL)hidRightBtn;

@end
