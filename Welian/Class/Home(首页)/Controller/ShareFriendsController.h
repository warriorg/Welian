//
//  ShareFriendsController.h
//  Welian
//
//  Created by dong on 15/3/5.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BasicTableViewController.h"
#import "CardStatuModel.h"

typedef void(^shareMessageSuccessBlock)(void);
typedef void(^selectFriendBlock)(MyFriendUser *friendUser);

@interface ShareFriendsController : BasicTableViewController

@property (nonatomic, strong) CardStatuModel *cardM;
@property (nonatomic, strong) shareMessageSuccessBlock shareSuccessBlock;
@property (nonatomic, strong) selectFriendBlock selectFriendBlock;

@end
