//
//  HomeController.h
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "BasicViewController.h"

@interface HomeController : BasicViewController

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UITableView *tableView;
//* 有uid时按uid查 （0）为自己   不传uid 首页所有  *//
- (instancetype)initWithUid:(NSNumber *)uid;

- (void)beginPullDownRefreshing;

@end
