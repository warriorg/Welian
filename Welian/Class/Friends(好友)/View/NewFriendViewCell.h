//
//  NewFriendViewCell.h
//  Welian
//
//  Created by weLian on 15/1/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NewFriendUser.h"
#import "NeedAddUser.h"


typedef enum : NSUInteger {
    FriendOperateTypeAdd = 0,//添加
    FriendOperateTypeAccept,//接受
    FriendOperateTypeAdded,//已添加
    FriendOperateTypeWait,//待验证
} FriendOperateType;

typedef void(^newFriendOperateBlock)(FriendOperateType type,NewFriendUser *newFriendUser,NSIndexPath *indexPath);
typedef void(^addFriendOperateBlock)(NSInteger type,NeedAddUser *needAddUser,NSIndexPath *indexPath);

@interface NewFriendViewCell : BaseTableViewCell

@property (strong, nonatomic) newFriendOperateBlock newFriendBlock;
@property (strong, nonatomic) addFriendOperateBlock needAddBlock;

@property (strong,nonatomic) NSIndexPath *indexPath;
//通用的类型
@property (strong, nonatomic) NSDictionary *dicData;
//新的好友
@property (strong, nonatomic) NewFriendUser *nFriendUser;

//搜索出来的用户
@property (strong, nonatomic) IBaseUserM *userInfoModel;

//需要添加的好友
@property (strong, nonatomic) NeedAddUser *needAddUser;

//返回cell的高度
+ (CGFloat)configureWithName:(NSString *)name message:(NSString *)msg;

@end
