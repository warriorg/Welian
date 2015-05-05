//
//  MainViewController.m
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "MainViewController.h"
#import "HomeController.h"
#import "FindViewController.h"
#import "MeViewController.h"
#import "NavViewController.h"
#import "MyFriendsController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ChatMessageController.h"
#import "MessagesViewController.h"
#import "LogInUser.h"
#import "LocationTool.h"
#import "WLLocationHelper.h"

#import "MyFriendUser.h"
#import "NewFriendUser.h"
#import "MJExtension.h"

@interface NavTitleView : UIView
{
    UIView *prompt;
    UILabel *titLabel;
}
- (void)hidePrompt;
- (void)showPrompt;
- (void)settitStr:(NSString *)titStr;

@end

@implementation NavTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        titLabel = [[UILabel alloc] initWithFrame:frame];
//        [titLabel setCenter:self.center];
        [titLabel setFont:WLFONTBLOD(17)];
        [titLabel setTextColor:[UIColor whiteColor]];
        [titLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:titLabel];
        prompt = [[UIView alloc] init];
        [prompt setBackgroundColor:[UIColor redColor]];
        [prompt.layer setCornerRadius:5];
        [prompt.layer setMasksToBounds:YES];
        [prompt setHidden:YES];
        [self addSubview:prompt];
    }
    return self;
}

- (void)settitStr:(NSString *)titStr
{
    [titLabel setText:titStr];
    [titLabel sizeToFit];
    [titLabel setCenter:self.center];
    
    [prompt setFrame:CGRectMake(CGRectGetMaxX(titLabel.frame)-2, 0, 10, 10)];
    
}

- (void)showPrompt
{
    [prompt setHidden:NO];
}
- (void)hidePrompt
{
    [prompt setHidden:YES];
}


@end

@interface MainViewController () <UINavigationControllerDelegate>
{
    UITabBarItem *homeItem;
    UITabBarItem *selectItem;
//    UITabBarItem *circleItem;
    UITabBarItem *chatMessageItem;
    UITabBarItem *findItem;
    UITabBarItem *meItem;
    HomeController *homeVC;
}

@property (strong,nonatomic) CLGeocoder* geocoder;
@property (nonatomic, strong) NavTitleView *navTitleView;

@end

@implementation MainViewController

single_implementation(MainViewController)

- (NavTitleView *)navTitleView
{
    if (_navTitleView == nil) {
        _navTitleView = [[NavTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [_navTitleView settitStr:@"创业圈"];
    }
    return _navTitleView;
}

- (void)loadNewStustupdata
{
    LogInUser *mode = [LogInUser getCurrentLoginUser];
    if (mode.firststustid.integerValue && mode.sessionid&&mode.mobile) {
        
        //获取最新动态数量
        [WeLianClient getNewFeedCountsWithID:mode.firststustid
                                     Success:^(id resultInfo) {
                                         NSNumber *count = [resultInfo objectForKey:@"count"];
                                         NSNumber *activecount = [resultInfo objectForKey:@"activecount"];
                                         NSNumber *investorcount = [resultInfo objectForKey:@"investorcount"];
                                         NSNumber *projectcount = [resultInfo objectForKey:@"projectcount"];
                                         [LogInUser setUserNewstustcount:count];
                                         [LogInUser setUserActivecount:activecount];
                                         [LogInUser setUserInvestorcount:investorcount];
                                         [LogInUser setUserProjectcount:projectcount];
                                         [self updataItembadge];
                                     } Failed:^(NSError *error) {
                                         
                                     }];
        
//        [WLHttpTool loadNewFeedCountParameterDic:@{@"fid":mode.firststustid} success:^(id JSON) {
//            NSNumber *count = [JSON objectForKey:@"count"];
//            NSNumber *activecount = [JSON objectForKey:@"activecount"];
//            NSNumber *investorcount = [JSON objectForKey:@"investorcount"];
//            NSNumber *projectcount = [JSON objectForKey:@"projectcount"];
//            [LogInUser setUserNewstustcount:count];
//            [LogInUser setUserActivecount:activecount];
//            [LogInUser setUserInvestorcount:investorcount];
//            [LogInUser setUserProjectcount:projectcount];
//            [self updataItembadge];
//        } fail:^(NSError *error) {
//            
//        }];
    }
}


// 根据更新信息设置 提示角标
- (void)updataItembadge
{
    //更新消息页面角标
    [self updateChatMessageBadge:nil];
    
    // 首页 创业圈角标
//    if (meinfo.newstustcount.integerValue &&!meinfo.homemessagebadge.integerValue) {
    if ([LogInUser getCurrentLoginUser].newstustcount.integerValue) {
        [self.navTitleView showPrompt];
        [homeItem setImage:[[UIImage imageNamed:@"tabbar_home_prompt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [homeItem setSelectedImage:[[UIImage imageNamed:@"tabbar_home_selected_prompt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }else{
        [homeItem setImage:[UIImage imageNamed:@"tabbar_home"]];
        [homeItem setSelectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    }
    
    /// 有新的活动或者新的项目
    if ([LogInUser getCurrentLoginUser].isactivebadge.boolValue || [LogInUser getCurrentLoginUser].isprojectbadge.boolValue) {
        [findItem setImage:[[UIImage imageNamed:@"tabbar_discovery_prompt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [findItem setSelectedImage:[[UIImage imageNamed:@"tabbar_discovery_selected_prompt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }else{
        [findItem setImage:[UIImage imageNamed:@"tabbar_discovery"]];
        [findItem setSelectedImage:[UIImage imageNamed:@"tabbar_discovery_selected"]];
    }
    
    // 我的投资人认证状态改变
    if ([LogInUser getCurrentLoginUser].isinvestorbadge.boolValue) {
        [meItem setImage:[[UIImage imageNamed:@"tabbar_friend_prompt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [meItem setSelectedImage:[[UIImage imageNamed:@"tabbar_friend_selected_prompt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }else{
        [meItem setImage:[UIImage imageNamed:@"tabbar_me"]];
        [meItem setSelectedImage:[UIImage imageNamed:@"tabbar_me_selected"]];
    }
}


- (void)dealloc
{
    [KNSNotification removeObserver:self];
}

//更新消息数量改变
- (void)updateChatMessageBadge:(NSNotification *)notification
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    //聊天
    NSInteger unReadChatMsg = [loginUser allUnReadChatMessageNum];
    //消息
    NSInteger unReadMsg = loginUser.homemessagebadge.integerValue;
    //好友通知
    NSInteger unReadFriend = loginUser.newfriendbadge.integerValue;
    NSInteger totalUnRead = unReadChatMsg + unReadMsg + unReadFriend;
    chatMessageItem.badgeValue = totalUnRead <= 0 ? nil : [NSString stringWithFormat:@"%@",@(totalUnRead)];
}

//设置选择的为消息列表页面
- (void)changeTapToChatList:(NSNotification *)notification
{
    self.selectedIndex = 2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [WeLianClient updateclientID];
    // 有新好友通知
    [KNSNotification addObserver:self selector:@selector(newFriendPuthMessga) name:KNewFriendNotif object:nil];
    
    // 有新动态通知
    [KNSNotification addObserver:self selector:@selector(loadNewStustupdata) name:KNEWStustUpdate object:nil];
    
    // 首页动态消息通知
   [KNSNotification addObserver:self selector:@selector(updataItembadge) name:KMessageHomeNotif object:nil];
    
    //添加聊天用户改变监听
    [KNSNotification addObserver:self selector:@selector(updateChatMessageBadge:) name:kChatMsgNumChanged object:nil];
    [KNSNotification addObserver:self selector:@selector(updateChatMessageBadge:) name:kUpdateMainMessageBadge object:nil];
    
    //如果是从好友列表进入聊天，首页变换
    [KNSNotification addObserver:self selector:@selector(changeTapToChatList:) name:kChangeTapToChatList object:nil];
    
    // 新的活动提示
    [KNSNotification addObserver:self selector:@selector(updataItembadge) name:KNewactivitNotif object:nil];
    
    // 我的认证投资人状态改变
    [KNSNotification addObserver:self selector:@selector(updataItembadge) name:KInvestorstateNotif object:nil];
    
    // 新的项目提示
    [KNSNotification addObserver:self selector:@selector(updataItembadge) name:KProjectstateNotif object:nil];
    
    [[UITextField appearance] setTintColor:KBasesColor];
    [[UITextView appearance] setTintColor:KBasesColor];

    LogInUser *mode = [LogInUser getCurrentLoginUser];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:mode.avatar] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        NSString *avatarStr = [UIImageJPEGRepresentation(image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [UserDefaults setObject:avatarStr forKey:@"icon"];
    }];
    
    // 首页
    homeItem = [self itemWithTitle:@"创业圈" imageStr:@"tabbar_home" selectedImageStr:@"tabbar_home_selected"];
//    [homeItem setBadgeValue:[UserDefaults objectForKey:KMessagebadge]];
    homeVC = [[HomeController alloc] initWithUid:nil];
    NavViewController *homeNav = [[NavViewController alloc] initWithRootViewController:homeVC];
    [homeVC.navigationItem setTitle:@"创业圈"];
    [homeNav setDelegate:self];
    [homeNav setTabBarItem:homeItem];
    
    // 好友
//    circleItem = [self itemWithTitle:@"好友" imageStr:@"tabbar_friend" selectedImageStr:@"tabbar_friend_selected"];
//    if ([LogInUser getCurrentLoginUser].newfriendbadge.integerValue) {
//        
//        [circleItem setBadgeValue:[NSString stringWithFormat:@"%@",[LogInUser getCurrentLoginUser].newfriendbadge]];
//    }
    
//    MyFriendsController *friendsVC = [[MyFriendsController alloc] initWithStyle:UITableViewStylePlain];
//    NavViewController *friendsNav = [[NavViewController alloc] initWithRootViewController:friendsVC];
//    [friendsNav setDelegate:self];
//    [friendsVC.navigationItem setTitle:@"好友"];
//    [friendsNav setTabBarItem:circleItem];
    
    
    // 聊天消息
    chatMessageItem = [self itemWithTitle:@"消息" imageStr:@"tabbar_chat" selectedImageStr:@"tabbar_chat_selected"];
//    ChatMessageController *chatMessageVC = [[ChatMessageController alloc] initWithStyle:UITableViewStylePlain];
    MessagesViewController *chatMessageVC = [[MessagesViewController alloc] init];
    NavViewController *chatMeeageNav = [[NavViewController alloc] initWithRootViewController:chatMessageVC];
//    [chatMessageVC.navigationItem setTitle:@"消息"];
    [chatMeeageNav setDelegate:self];
    [chatMeeageNav setTabBarItem:chatMessageItem];
    
    // 发现
    findItem = [self itemWithTitle:@"发现" imageStr:@"tabbar_discovery" selectedImageStr:@"tabbar_discovery_selected"];
    FindViewController *findVC = [[FindViewController alloc] init];
    NavViewController *findNav = [[NavViewController alloc] initWithRootViewController:findVC];
    [findNav setDelegate:self];
    [findVC.navigationItem setTitle:@"发现"];
    [findNav setTabBarItem:findItem];
    
    // 我
    meItem = [self itemWithTitle:@"我" imageStr:@"tabbar_me" selectedImageStr:@"tabbar_me_selected"];
    MeViewController *meVC = [[MeViewController alloc] init];
    NavViewController *meNav = [[NavViewController alloc] initWithRootViewController:meVC];
    [meNav setDelegate:self];
    [meNav setTabBarItem:meItem];
    //设置底部导航
    [self setViewControllers:@[homeNav,findNav,chatMeeageNav,meNav]];
    [self.tabBar setSelectedImageTintColor:KBasesColor];

    selectItem = homeItem;
    [self updataItembadge];
    [self updateChatMessageBadge:nil];
    
    // 定位
    [[LocationTool sharedLocationTool] statLocationMy];
    WEAKSELF
    [[LocationTool sharedLocationTool] setUserLocationBlock:^(BMKUserLocation *userLocation){
        //城市定位
        [weakSelf getLoactionCityInfoWith:userLocation];
        CLLocationCoordinate2D coord2D = userLocation.location.coordinate;
        NSString *latitude = [NSString stringWithFormat:@"%f",coord2D.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f",coord2D.longitude];
        
        [WeLianClient changeUserLocationWithLatitude:latitude
                                          Longtitude:longitude
                                             Success:^(id resultInfo) {
                                                 
                                             } Failed:^(NSError *error) {
                                                 
                                             }];
//        [WLHttpTool saveProfileParameterDic:@{@"x":x,@"y":y} success:^(id JSON) {
//            
//        } fail:^(NSError *error) {
//            
//        }];
    }];
    
    //获取城市定位
//    [self getCityLocationInfo];
}

- (CLGeocoder*)geocoder
{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

//获取城市定位
- (void)getCityLocationInfo
{
    // 定位
//    [[LocationTool sharedLocationTool] statLocationMy];
//    WEAKSELF
//    [[LocationTool sharedLocationTool] setUserLocationBlock:^(BMKUserLocation *userLocation){
//        [weakSelf getLoactionCityInfoWith:userLocation];
//    }];
    
//    [[WLLocationHelper sharedInstance] getCurrentGeolocationsCompled:^(NSArray *placemarks) {
//        if (placemarks.count > 0) {
//            CLPlacemark *placemark = [placemarks firstObject];
//            if (placemark) {
//                NSDictionary *addressDictionary = placemark.addressDictionary;
//                //            NSArray *formattedAddressLines = [addressDictionary valueForKey:@"FormattedAddressLines"];
//                //            NSString *geoLocations = [formattedAddressLines lastObject];
//                if (placemark.locality.length > 0 || addressDictionary != nil) {
//                    //                        [weakSelf didSendGeolocationsMessageWithGeolocaltions:geoLocations location:placemark.location];
//                    NSString *cityStr = placemark.locality.length > 0 ? placemark.locality : addressDictionary[@"City"];
//                    if (cityStr.length > 0) {
//                        NSString *city = [cityStr hasSuffix:@"市"] ? [cityStr stringByReplacingOccurrencesOfString:@"市" withString:@""] : cityStr;
//                        DLog(@"当前城市：%@ ---- placemark.locality:%@",city,placemark.locality);
//                        //定位的城市
//                        [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"LocationCity"];
//                    }else{
//                        //定位的城市
//                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LocationCity"];
//                    }
//                }
//            }
//        }
//    }];
}

- (void)getLoactionCityInfoWith:(BMKUserLocation *)userLocation
{
//  北京 116.300209,39.920026（北京市市辖区）    上海：121.391313,31.240517  台湾：(台湾省)120.434915,22.983245  121.603144,24.952727  香港：114.178428,22.274236（香港特別行政區）  澳门：113.566718,22.154318(澳门特别性质区)  和田区：79.909829,37.124486（和田地区）
    DLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude,userLocation.location.altitude,userLocation.location.course,userLocation.location.speed);
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray* placemarks, NSError* error) {
        if(!error){
            if (placemarks.count > 0) {
                CLPlacemark *placemark = [placemarks firstObject];
                if (placemark) {
                    NSDictionary *addressDictionary = placemark.addressDictionary;
                    //            NSArray *formattedAddressLines = [addressDictionary valueForKey:@"FormattedAddressLines"];
                    //            NSString *geoLocations = [formattedAddressLines lastObject];
                    if (addressDictionary != nil) {
                        //                        [weakSelf didSendGeolocationsMessageWithGeolocaltions:geoLocations location:placemark.location];
//                        NSString *provinStr =[placemark.addressDictionary objectForKey:@"State"];
                        NSString *cityStr = addressDictionary[@"City"];//市
                        NSString *stateStr =  addressDictionary[@"State"];//省
                        
                        DLog(@"当前城市：%@ --省: %@-- placemark.locality:%@",cityStr,stateStr,placemark.locality);
                        
                        NSString * city = cityStr ? cityStr : stateStr;
                        if(city.length > 0){
//                            if ([cityStr containsString:@"市"]) {
//                                //市
//                                NSRange range = [cityStr rangeOfString:@"市"]; //现获取要截取的字符串位置
//                                city = [cityStr substringToIndex:range.location]; //截取字符串
//                            }else if([cityStr containsString:@"省"]){
//                                //省
//                                NSRange range = [cityStr rangeOfString:@"市"]; //现获取要截取的字符串位置
//                                city = [cityStr substringToIndex:range.location]; //截取字符串
//                            }else if ([cityStr containsString:@"特别行政"]){
//                                //特别行政区
//                                NSRange range = [cityStr rangeOfString:@"特别行政"]; //现获取要截取的字符串位置
//                                city = [cityStr substringToIndex:range.location]; //截取字符串
//                            }else if([cityStr containsString:@""]){
//                            
//                            }
                            //定位的城市
                            [UserDefaults setObject:city forKey:kLocationCity];
                        }else{
                            //定位的城市
                            [UserDefaults setObject:@"" forKey:kLocationCity];
                        }
                    }
                }
            }
        }
    }];
}


- (void)newFriendPuthMessga
{
//    NSString *badgeStr = [NSString stringWithFormat:@"%@",[LogInUser getCurrentLoginUser].newfriendbadge];
//    [circleItem setBadgeValue:badgeStr];
    
    //更新消息页面角标
    [self updateChatMessageBadge:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (selectItem == homeItem && item == homeItem) {
        [homeVC beginRefreshing];
//        [homeVC.refreshControl beginRefreshing];
//        [homeVC.tableView setContentOffset:CGPointMake(0,-homeVC.refreshControl.frame.size.height-64) animated:YES];
//        // 延迟0.5秒执行：
//        double delayInSeconds = 0.5;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            // code to be executed on the main queue after delay
//            [homeVC.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
//        });
    }
    selectItem = item;
}

- (UITabBarItem*)itemWithTitle:(NSString *)title imageStr:(NSString *)imageStr selectedImageStr:(NSString *)selectedImageStr
{
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imageStr] selectedImage:[UIImage imageNamed:selectedImageStr]];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName :KBasesColor,NSFontAttributeName:kNormal12Font} forState:UIControlStateSelected];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName:kNormal12Font} forState:UIControlStateNormal];
    return item;
}

@end
