//
//  NewFriendViewCell.h
//  Welian
//
//  Created by weLian on 15/1/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NewFriendUser.h"

typedef enum : NSUInteger {
    FriendOperateTypeAdd = 0,//添加
    FriendOperateTypeAccept,//接受
    FriendOperateTypeAdded,//已添加
    FriendOperateTypeWait,//待验证
} FriendOperateType;

typedef void(^newFriendOperateBlock)(FriendOperateType type,NewFriendUser *newFriendUser);

@interface NewFriendViewCell : BaseTableViewCell

@property (assign, nonatomic) UIImageView *logoImageView;
@property (assign, nonatomic) UILabel *nameLabel;
@property (assign, nonatomic) UILabel *messageLabel;
@property (assign, nonatomic) UIButton *operateBtn;

@property (strong, nonatomic) newFriendOperateBlock newFriendBlock;

//通用的类型
@property (strong, nonatomic) NSDictionary *dicData;
//新的好友
@property (strong, nonatomic) NewFriendUser *nFriendUser;

//返回cell的高度
+ (CGFloat)configureWithName:(NSString *)name message:(NSString *)msg;

@end
