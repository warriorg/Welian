//
//  ActivityMapViewController.m
//  Welian
//
//  Created by weLian on 15/1/6.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityMapViewController.h"

@interface ActivityMapViewController ()//<MKMapViewDelegate>

@property (strong,nonatomic) NSString *address;
@property (assign,nonatomic) MKMapView *mapview;
@property (strong,nonatomic) CLGeocoder *geocoder;

@end

@implementation ActivityMapViewController

- (void)dealloc
{
    _address = nil;
    _geocoder = nil;
}

- (instancetype)initWithAddress:(NSString *)address
{
    self = [super init];
    if (self) {
        self.address = address;
        self.needlessCancel = YES;
    }
    return self;
}

//初始化页面
- (void)loadView
{
    [super loadView];
    
    MKMapView *mapview = [[MKMapView alloc] initWithFrame:Rect(0, 0, self.view.width, self.view.height)];
    // 旋转屏幕时自动设置设置大小
    [mapview setAutoresizingMask: UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    // 设置代理
//    [mapview setDelegate:self];
    
    //    [_mapview setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    mapview.showsUserLocation = YES;
    // 添加到视图
    [self.view addSubview:mapview];
    self.mapview = mapview;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = _address;
    
    // 地理编辑器
    self.geocoder = [[CLGeocoder alloc] init];
    
    [self showLocation];
}

//解析并显示坐标
- (void)showLocation
{
    [WLHUDView showHUDWithStr:@"获取位置中..." dim:NO];
    // 根据城市名称 利用地理编辑器取出经纬度，设置大头针的位置
    [_geocoder geocodeAddressString:_address completionHandler:^(NSArray *placemarks, NSError *error) {
        //隐藏
        [WLHUDView hiddenHud];
        // 地理编辑器
        CLPlacemark *placemark = placemarks[0];
        CLLocationCoordinate2D location = placemark.location.coordinate;
        
        // 在此插大头针
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = location;
        annotation.title = _address;
        //        annotation.subtitle = order.address
        
        [_mapview addAnnotation:annotation];
        
        //控制显示区域
        MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
        MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
        [_mapview setRegion:region];
        
        //选中标记
        [_mapview selectAnnotation:annotation animated:YES];
    }];
}

// 实现大头针可重用  代理方法
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MKPointAnnotation *)annotation
//{
//    static NSString *ID = @"ID";
//    MKAnnotationView *view = [_mapview dequeueReusableAnnotationViewWithIdentifier:ID];
//    if (nil == view) {
//        view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
//        // 显示图片
//        view.canShowCallout = YES;
//    }
//    // 设置视图信息
//    view.annotation = annotation;
//    // 设置视图图像
////    view.image = [UIImage imageNamed:annotation.imageName];
//    
//    return view;
//}

@end
