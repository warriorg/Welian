//
//  PublishStatusController.h
//  Welian
//
//  Created by dong on 14-9-12.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardStatuModel.h"

#define Time  0.25
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define  keyboardHeight 216
#define  toolBarHeight 50
#define  buttonWh 34

typedef enum {
    PublishTypeNomel = 0,  // 正常发布
    PublishTypeForward = 2 // 转发
    
} PublishType;

// 发送成功
typedef void(^WLPublishStatusBlock)(void);

// 需要重新发送
typedef void (^WLPublishStatusDataBlock)(NSDictionary *statusDic);

@interface PublishStatusController : UIViewController

@property (nonatomic, strong) CardStatuModel *statusCard;

@property (nonatomic, copy) WLPublishStatusBlock publishBlock;

@property (nonatomic, copy) WLPublishStatusDataBlock publishDicBlock;

- (instancetype)initWithType:(PublishType)publishType;


@end
