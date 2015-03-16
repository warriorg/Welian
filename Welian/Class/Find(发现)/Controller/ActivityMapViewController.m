//
//  ActivityMapViewController.m
//  Welian
//
//  Created by weLian on 15/1/6.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityMapViewController.h"
#import "BMapKit.h"

@interface ActivityMapViewController ()<BMKGeoCodeSearchDelegate>

@property (strong,nonatomic) NSString *city;
@property (strong,nonatomic) NSString *address;
@property (assign,nonatomic) BMKMapView *mapView;
@property (strong,nonatomic) BMKGeoCodeSearch *searcher;
//@property (strong,nonatomic) BMKLocationService *locService;//定位功能

@end

@implementation ActivityMapViewController

- (void)dealloc
{
    _address = nil;
    _city = nil;
    _searcher = nil;
//    _locService = nil;
}

- (instancetype)initWithAddress:(NSString *)address city:(NSString *)city
{
    self = [super init];
    if (self) {
        self.city = city;
        self.address = address;
        self.needlessCancel = YES;
    }
    return self;
}

//初始化页面
- (void)loadView
{
    [super loadView];
    
    BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:Rect(0, 0, self.view.width, self.view.height)];
    mapView.showsUserLocation = YES;
//    mapView.userTrackingMode = BMKUserTrackingModeNone;
    [self.view addSubview:mapView];
    self.mapView = mapView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar reset];
}

-(void)viewWillDisappear:(BOOL)animated
{
    _searcher.delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = _address;
    
//    //初始化BMKLocationService
//    BMKLocationService *locService = [[BMKLocationService alloc] init];
//    locService.delegate = self;
//    //启动LocationService
//    [locService startUserLocationService];
//    self.locService = locService;
    
    [_mapView setZoomLevel:5];
    
    //初始化检索对象
    BMKGeoCodeSearch *searcher =[[BMKGeoCodeSearch alloc]init];
    searcher.delegate = self;
    self.searcher = searcher;
    
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city = [_city isKindOfClass:[NSNull class]] ? @"" : _city;
    geoCodeSearchOption.address = _address;
    BOOL flag = [_searcher geoCode:geoCodeSearchOption];
    [WLHUDView showHUDWithStr:@"获取位置中..." dim:NO];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
//{
//    //NSLog(@"heading is %@",userLocation.heading);
//}
////处理位置坐标更新
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
//{
//    _mapView.showsUserLocation = YES;//显示定位图层
//    [_mapView updateLocationData:userLocation];
//    //启动LocationService
//    [_locService stopUserLocationService];
//    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//}

//实现Deleage处理回调结果
//接收正向编码结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    [WLHUDView hiddenHud];
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = result.location;
        annotation.title = _address;
        [_mapView addAnnotation:annotation];
        
        
        //设定地图中心点坐标
        [_mapView setCenterCoordinate:result.location animated:YES];
        
        //设定当前地图的显示范围
        [_mapView setRegion:BMKCoordinateRegionMake(result.location,BMKCoordinateSpanMake(0.02,0.02))];
        //设置地图缩放级别
        [_mapView setZoomLevel:19];
        //设置选中标记
        [_mapView selectAnnotation:annotation animated:YES];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (BMKAnnotationView *)_mapView:(BMKMapView *)_mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

@end
