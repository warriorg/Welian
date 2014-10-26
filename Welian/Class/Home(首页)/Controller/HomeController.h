//
//  HomeController.h
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeController : UITableViewController

//* 有uid时按uid查 （0）为自己   不传uid 首页所有  *//
- (instancetype)initWithStyle:(UITableViewStyle)style anduid:(NSNumber *)uid;

@end
