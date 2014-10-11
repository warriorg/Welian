//
//  LocationprovinceController.h
//  weLian
//
//  Created by dong on 14-10-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "LocationController.h"
@class LocationprovinceController;
#import "MeInfoController.h"

@protocol LocationProDelegate <NSObject>

- (void)locationProvinController:(UIViewController*)locationVC withLocationDic:(NSDictionary *)locationDic;

@end

@interface LocationprovinceController : LocationController

@property (weak, nonatomic) id<LocationProDelegate> delegate;

@property (weak, nonatomic) MeInfoController *meinfoVC;

@end
