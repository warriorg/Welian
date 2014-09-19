//
//  MainViewController.m
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "MainViewController.h"
#import "HomeController.h"
#import "FriendsController.h"
#import "FindViewController.h"
#import "MeViewController.h"
#import "NavViewController.h"
#import "BMKLocationService.h"
#import "BMKGeometry.h"
#import "BMKGeocodeSearchOption.h"
#import "BMKGeocodeSearch.h"
//#import "BMKReverseGeoCodeOption.h"

@interface MainViewController () <UINavigationControllerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService *_locService;

    BMKReverseGeoCodeOption *_reverseGeoCodeSearchOption;
    BMKGeoCodeSearch *_geoSearch;
}
@end

@implementation MainViewController

- (void)loadLocationVC
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    //初始化检索对象
    _geoSearch =[[BMKGeoCodeSearch alloc]init];
    [_geoSearch setDelegate:self];
    
    //发起反向地理编码检索
    _reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([CLLocationManager locationServicesEnabled]) {
        // 打开定位
        [self loadLocationVC];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务已关闭" message:@"前往“设置”>“隐私”>“定位服务”打开" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    // 首页
    UITabBarItem *homeItem = [self itemWithTitle:@"动态" imageStr:@"tabbar_home" selectedImageStr:@"tabbar_home_selected"];
    
    HomeController *homeVC = [[HomeController alloc] init];
    [homeVC.navigationItem setTitle:@"动态"];
    NavViewController *homeNav = [[NavViewController alloc] initWithRootViewController:homeVC];
    [homeNav setDelegate:self];
    [homeNav setTabBarItem:homeItem];
    
    
    // 圈子
    UITabBarItem *circleItem = [self itemWithTitle:@"好友" imageStr:@"tabbar_friend" selectedImageStr:@"tabbar_friend_selected"];
    FriendsController *friendsVC = [[FriendsController alloc] init];
    NavViewController *friendsNav = [[NavViewController alloc] initWithRootViewController:friendsVC];
    [friendsNav setDelegate:self];
    [friendsVC.navigationItem setTitle:@"好友"];
    [friendsNav setTabBarItem:circleItem];
    
    
    // 发现
    UITabBarItem *findItem = [self itemWithTitle:@"发现" imageStr:@"tabbar_discovery" selectedImageStr:@"tabbar_discovery_selected"];
    FindViewController *findVC = [[FindViewController alloc] init];
    NavViewController *findNav = [[NavViewController alloc] initWithRootViewController:findVC];
    [findNav setDelegate:self];
    [findVC.navigationItem setTitle:@"发现"];
    [findNav setTabBarItem:findItem];
    
    // 我
    UITabBarItem *meItem = [self itemWithTitle:@"我" imageStr:@"tabbar_me" selectedImageStr:@"tabbar_me_selected"];
    MeViewController *meVC = [[MeViewController alloc] init];
    NavViewController *meNav = [[NavViewController alloc] initWithRootViewController:meVC];
    [meNav setDelegate:self];
    [meVC.navigationItem setTitle:@"我"];
    [meNav setTabBarItem:meItem];
    
    [self setViewControllers:@[homeNav,friendsNav,findNav,meNav]];
    [homeItem setBadgeValue:@"3"];
    [self.tabBar setSelectedImageTintColor:KBasesColor];
}


//处理位置坐标更新
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
//    NSDictionary* testdic = BMKConvertBaiduCoorFrom(userLocation.location.coordinate,BMK_COORDTYPE_COMMON);
//    //转换GPS坐标至百度坐标
//    testdic = BMKConvertBaiduCoorFrom(userLocation.location.coordinate,BMK_COORDTYPE_GPS);
    CGFloat la = userLocation.location.coordinate.latitude;
    
    [UserDefaults setObject:[NSString stringWithFormat:@"%f",la] forKey:@"lat"];
    [UserDefaults setObject:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude] forKey:@"lon"];
    
    
    
    _reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_geoSearch reverseGeoCode:_reverseGeoCodeSearchOption];
    if(flag)
    {
//        [_geoSearch setDelegate:nil];
        DLog(@"反geo检索发送成功");
    }
    else
    {
        DLog(@"反geo检索发送失败");
    }
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      // 在此处理正常结果
      [_locService setDelegate:nil];
      [_geoSearch setDelegate:nil];
      DLog(@"%@",result.address);
  }
  else {
      DLog(@"抱歉，未找到结果");
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITabBarItem*)itemWithTitle:(NSString *)title imageStr:(NSString *)imageStr selectedImageStr:(NSString *)selectedImageStr
{
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imageStr] selectedImage:[UIImage imageNamed:selectedImageStr]];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName :KBasesColor,NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateSelected];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
    return item;
}

@end
