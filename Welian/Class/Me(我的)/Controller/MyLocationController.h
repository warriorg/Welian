//
//  MyLocationController.h
//  Welian
//
//  Created by dong on 14-9-18.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "LocationController.h"
#import "BMKPoiSearch.h"

typedef void(^LocationBlok)(BMKPoiInfo *infoPoi);

@interface MyLocationController : LocationController

- (instancetype)initWithLocationBlock:(LocationBlok)locationBlock;

@end
