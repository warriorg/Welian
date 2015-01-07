//
//  CompotAndPostController.h
//  Welian
//
//  Created by dong on 15/1/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompotAndPostBlock)(NSString *compotAndPostStr);

@interface CompotAndPostController : UIViewController

// 1 公司  2 职位
- (instancetype)initWithType:(NSInteger)type;

@property (nonatomic, copy) CompotAndPostBlock comPostBlock;

@end
