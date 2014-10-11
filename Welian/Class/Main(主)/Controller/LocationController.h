//
//  LocationController.h
//  Welian
//
//  Created by dong on 14-9-23.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKLocationService.h"
#import "BMKGeometry.h"
#import "BMKGeocodeSearchOption.h"
#import "BMKGeocodeSearch.h"

@interface LocationController : UITableViewController

@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKReverseGeoCodeOption *reverseGeoCodeSearchOption;
@property (nonatomic, strong) BMKGeoCodeSearch *geoSearch;

// 开始定位
- (void)statLocationMy;

// 停止定位
- (void)stopLocationMy;

//处理位置坐标更新
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation;

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error;

@end
