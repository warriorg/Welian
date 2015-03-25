//
//  UserInfoView.h
//  Welian
//
//  Created by weLian on 15/3/25.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^lookUserDetailInfoBlock)(void);

@interface UserInfoView : UIView

@property (strong,nonatomic) LogInUser *loginUser;
@property (strong,nonatomic) IBaseUserM *baseUserModel;

@property (strong,nonatomic) lookUserDetailInfoBlock lookUserDetailBlock;

@end
