//
//  UserInfoView.h
//  Welian
//
//  Created by weLian on 15/3/25.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^lookUserDetailInfoBlock)(void);
typedef void(^operateBtnClickedBlcok)(void);

@interface UserInfoView : UIView

@property (strong,nonatomic) LogInUser *loginUser;
@property (strong,nonatomic) IBaseUserM *baseUserModel;
@property (strong,nonatomic) NSNumber *operateType;////操作类型0：添加 1：接受  2:已添加 3：待验证   10:隐藏操作按钮

@property (strong,nonatomic) lookUserDetailInfoBlock lookUserDetailBlock;
@property (strong,nonatomic) operateBtnClickedBlcok operateClickedBlock;

@end
