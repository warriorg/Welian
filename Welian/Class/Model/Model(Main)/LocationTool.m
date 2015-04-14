//
//  LocationTool.m
//  Welian
//
//  Created by dong on 15/1/24.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//
#import "LocationTool.h"

@interface LocationTool () <BMKLocationServiceDelegate>

@end

@implementation LocationTool
single_implementation(LocationTool)

- (BMKLocationService*)locService
{
    if (_locService == nil) {
        _locService = [[BMKLocationService alloc] init];
    }
    return _locService;
}

- (BMKReverseGeoCodeOption *)reverseGeoCodeSearchOption
{
    if (_reverseGeoCodeSearchOption ==nil) {
        _reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    }
    return _reverseGeoCodeSearchOption;
}

- (BMKGeoCodeSearch*)geoSearch
{
    if (_geoSearch == nil) {
        _geoSearch = [[BMKGeoCodeSearch alloc] init];
    }
    return _geoSearch;
}

- (void)statLocationMy
{
    if ([CLLocationManager locationServicesEnabled]) {
        // 打开定位
        [self loadLocationVC];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务已关闭" message:@"前往“设置”>“隐私”>“定位服务”打开" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)stopLocationMy
{
    [self.locService stopUserLocationService];
    [self.locService setDelegate:nil];
}

- (void)loadLocationVC
{
    //初始化BMKLocationService
    self.locService.delegate = self;
    //启动LocationService
    [self.locService startUserLocationService];
}

//处理位置坐标更新
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    [self stopLocationMy];
    if (self.userLocationBlock) {
        self.userLocationBlock(userLocation);
    }
    //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
    //         = BMKConvertBaiduCoorFrom(userLocation.location.coordinate,BMK_COORDTYPE_COMMON);
    //    //转换GPS坐标至百度坐标
//    NSDictionary* testdic = BMKConvertBaiduCoorFrom(userLocation.location.coordinate,BMK_COORDTYPE_GPS);
//    
//    //转换GPS坐标至百度坐标
//    NSLog(@"x=%@,y=%@",[testdic objectForKey:@"x"],[testdic objectForKey:@"y"]);
//    
//    CLLocationCoordinate2D test = CLLocationCoordinate2DMake([[testdic objectForKey:@"x"] floatValue], [[testdic objectForKey:@"y"] floatValue]);
    
//    DLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//    
//    
//    //发起反向地理编码检索
//    self.reverseGeoCodeSearchOption.reverseGeoPoint = test;
//    BOOL flag = [self.geoSearch reverseGeoCode:self.reverseGeoCodeSearchOption];
//    if(flag)
//    {
//        DLog(@"反geo检索发送成功");
//    }
//    else
//    {
//        DLog(@"反geo检索发送失败");
//    }
}

////接收反向地理编码结果
//-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result
//                        errorCode:(BMKSearchErrorCode)error{
//    
//    if (error == BMK_SEARCH_NO_ERROR) {
//        // 在此处理正常结果
//        
//        DLog(@"%@",result.address);
//    }
//    else {
//        DLog(@"抱歉，未找到结果");
//    }
//}



@end

