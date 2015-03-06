//
//  ListItem.h
//  POHorizontalList
//
//  Created by Polat Olu on 15/02/2013.
//  Copyright (c) 2013 Polat Olu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShareType) {
    ///** 微链好友 **//
    ShareTypeWLFriend = 1,
    ///** 创业圈 **//
    ShareTypeWLCircle,
    ///** 微信好友 **//
    ShareTypeWeixinFriend,
    ///** 微信朋友圈 **//
    ShareTypeWeixinCircle,
    ///** 删除 **//
    ShareTypeDelete,
    ///** 举报 **//
    ShareTypeReport,
    ///** 编辑项目信息 **//
    ShareTypeProjectInfo ,
    ///** 设置团队成员 **//
    ShareTypeProjectMember,
    ///** 设置融资信息 **//
    ShareTypeProjectFinancing
};

typedef void (^WLActivityBlock)(ShareType duration);

@interface ListItem : UIView {
    CGRect textRect;
    CGRect imageRect;
}

@property (nonatomic, copy)   WLActivityBlock activityBlock;
@property (nonatomic, assign) ShareType seleStyle;

- (id)initWithImageName:(NSString *)imageName text:(NSString *)imageTitle selectionStyle:(ShareType)style;

@end
