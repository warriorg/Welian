//
//  NameController.h
//  Welian
//
//  Created by dong on 14-9-11.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UserInfoBlock)(NSString *userInfo);

typedef enum {
    IWVerifiedTypeName = 1,  // 姓名
    IWVerifiedTypeCompany = 2,  // 公司
    IWVerifiedTypeSchool = 3, // 学校
    IWVerifiedTypeJob = 4, // 职位
    IWVerifiedTypeMailbox = 5, // 邮箱
    IWVerifiedTypeAddress = 6 //  地址
} IWVerifiedType;

@interface NameController : UIViewController
@property (nonatomic, strong) NSString *userInfoStr;
//@property (nonatomic, strong) UITextField *infoTextF;
@property (nonatomic, strong) NSMutableArray *dataArray;

- (id)initWithBlock:(UserInfoBlock)block withType:(IWVerifiedType)verType;

@end
