//
//  WLLocationHelper.m
//  Welian
//
//  Created by weLian on 15/1/21.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "WLLocationHelper.h"

@interface WLLocationHelper ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, copy) DidGetGeolocationsCompledBlock didGetGeolocationsCompledBlock;

@end

@implementation WLLocationHelper

- (void)setup {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 5.0;
    
    if(IsiOS8Later){
        [_locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
        [_locationManager requestAlwaysAuthorization];
    }
}

+ (WLLocationHelper *)sharedInstance
{
    static WLLocationHelper *_helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _helper = [[WLLocationHelper alloc] init];
    });
    return _helper;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    self.didGetGeolocationsCompledBlock = nil;
}

- (void)getCurrentGeolocationsCompled:(DidGetGeolocationsCompledBlock)compled {
    self.didGetGeolocationsCompledBlock = compled;
    [self.locationManager startUpdatingLocation];//启动位置管理器
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [_locationManager requestAlwaysAuthorization];
            }
            break;
        default:
            break;
    } 
}

// 代理方法实现
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if(newLocation){
        CLGeocoder* geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray* placemarks, NSError* error) {
             if (self.didGetGeolocationsCompledBlock) {
                 self.didGetGeolocationsCompledBlock(placemarks);
             }
         }];
        [manager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations.count > 0) {
        CLGeocoder* geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:[locations objectAtIndex:0] completionHandler:^(NSArray* placemarks, NSError* error) {
             if (self.didGetGeolocationsCompledBlock) {
                 self.didGetGeolocationsCompledBlock(placemarks);
             }
         }];
        [manager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
}

@end
