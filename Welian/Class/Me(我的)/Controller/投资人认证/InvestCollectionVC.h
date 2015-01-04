//
//  InvestCollectionVC.h
//  Welian
//
//  Created by dong on 14/12/27.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "BasicViewController.h"


typedef void (^InvestBlock)(void);


@interface InvestCollectionVC : BasicViewController

@property (nonatomic, copy) InvestBlock investBlock;

- (instancetype)initWithType:(NSInteger)type;

@end
