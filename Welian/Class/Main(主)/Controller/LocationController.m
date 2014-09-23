//
//  LocationController.m
//  Welian
//
//  Created by dong on 14-9-23.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "LocationController.h"


@interface LocationController () <BMKLocationServiceDelegate>

@end

@implementation LocationController

- (BMKLocationService*)locService
{
    if (_locService == nil) {
        _locService = [[BMKLocationService alloc] init];
    }
    return _locService;
}

//- (BMKReverseGeoCodeOption*)reverseGeoCodeSearchOption
//{
//    if (_reverseGeoCodeSearchOption == nil) {
//        _reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
//    }
//    return _reverseGeoCodeSearchOption;
//}

//- (BMKGeoCodeSearch*)geoSearch
//{
//    if (_geoSearch ==nil) {
//        _geoSearch = [[BMKGeoCodeSearch alloc] init];
//    }
//    return _geoSearch;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

//- (void)statGeoSearch
//{
//    if (_locService==nil) {
//        [self statLocationMy];
//    }
//    //初始化检索对象
//    [self.geoSearch setDelegate:self];
//}

//处理位置坐标更新
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
    //    NSDictionary* testdic = BMKConvertBaiduCoorFrom(userLocation.location.coordinate,BMK_COORDTYPE_COMMON);
    //    //转换GPS坐标至百度坐标
    //    testdic = BMKConvertBaiduCoorFrom(userLocation.location.coordinate,BMK_COORDTYPE_GPS);
//    CGFloat la = userLocation.location.coordinate.latitude;
    
//    self.reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
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
//    if (error == BMK_SEARCH_NO_ERROR) {
//        // 在此处理正常结果
//
//        DLog(@"%@",result.address);
//    }
//    else {
//        DLog(@"抱歉，未找到结果");
//    }
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
