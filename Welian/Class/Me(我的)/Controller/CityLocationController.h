//
//  CityLocationController.h
//  weLian
//
//  Created by dong on 14-10-11.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "BasicTableViewController.h"
#import "MeInfoController.h"

@interface CityLocationController : BasicTableViewController

@property (nonatomic, strong) NSDictionary *provinDic;

@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, weak)  MeInfoController *meInfoVC;

@end
