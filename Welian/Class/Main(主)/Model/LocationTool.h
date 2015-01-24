//
//  LocationTool.h
//  Welian
//
//  Created by dong on 15/1/24.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMKLocationService.h"
#import "BMKGeometry.h"
#import "BMKGeocodeSearchOption.h"
#import "BMKGeocodeSearch.h"
#import "Singleton.h"

typedef void(^BKLocationBlock)(BMKUserLocation *userLocation);

@interface LocationTool : NSObject
single_interface(LocationTool)

@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKReverseGeoCodeOption *reverseGeoCodeSearchOption;
@property (nonatomic, strong) BMKGeoCodeSearch *geoSearch;

@property (nonatomic, copy) BKLocationBlock userLocationBlock;

// 开始定位
- (void)statLocationMy;

// 停止定位
- (void)stopLocationMy;

//处理位置坐标更新
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation;

//接收反向地理编码结果
//-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error;

@end

