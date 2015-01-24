//
//  LocationprovinceController.h
//  weLian
//
//  Created by dong on 14-10-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "BasicPlainTableViewController.h"
#import "MeInfoController.h"

@class LocationprovinceController;

@protocol LocationProDelegate <NSObject>

- (void)locationProvinController:(LocationprovinceController*)locationVC withLocationDic:(NSDictionary *)locationDic;

@end

@interface LocationprovinceController : BasicPlainTableViewController

@property (weak, nonatomic) id<LocationProDelegate> locationDelegate;

@property (weak, nonatomic) MeInfoController *meinfoVC;

@end
