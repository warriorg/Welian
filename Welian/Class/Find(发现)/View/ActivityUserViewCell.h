//
//  ActivityUserViewCell.h
//  Welian
//
//  Created by weLian on 15/1/20.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void(^addFriendOperateBlock)(NSIndexPath *indexPath);

@interface ActivityUserViewCell : BaseTableViewCell

@property (strong, nonatomic) addFriendOperateBlock addFriendBlock;

@property (strong,nonatomic) NSIndexPath *indexPath;
//报名列表的字典用户
@property (strong, nonatomic) NSDictionary *activityUserData;

@property (strong, nonatomic) IBaseUserM *baseUser;

@end
