//
//  UserInfoBasicVC.h
//  weLian
//
//  Created by dong on 14/10/20.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "BasicTableViewController.h"

@interface UserInfoBasicVC : BasicTableViewController

@property (nonatomic, copy) dispatch_block_t acceptFriendBlock;
@property (nonatomic, copy) dispatch_block_t addFriendBlock;

@property (nonatomic, assign) BOOL isHideSendMsgBtn;//隐藏发送消息按钮

// isask  表示是否别人请求加我为好友  
- (instancetype)initWithStyle:(UITableViewStyle)style andUsermode:(IBaseUserM *)usermode isAsk:(BOOL)isask;

- (void)addSucceed;

@end
