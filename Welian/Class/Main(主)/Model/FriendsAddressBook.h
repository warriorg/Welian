//
//  FriendsAddressBook.h
//  weLian
//
//  Created by dong on 14/10/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "IBaseUserM.h"

@interface FriendsAddressBook : IBaseUserM

// 0通讯录好友，1微信好友
@property (nonatomic, strong) NSNumber *type;

@end
