//
//  NameController.h
//  Welian
//
//  Created by dong on 14-9-11.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UserInfoBlock)(NSString *userInfo);

@interface NameController : UIViewController
@property (nonatomic, strong) NSString *userInfoStr;
@property (nonatomic, strong) UITextField *infoTextF;
@property (nonatomic, strong) NSArray *dataArray;

- (id)initWithBlock:(UserInfoBlock)block;
@end
