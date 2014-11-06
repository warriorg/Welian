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

- (instancetype)initWithStyle:(UITableViewStyle)style andUsermode:(UserInfoModel *)usermode isAsk:(BOOL)isask;

- (void)addSucceed;

@end
