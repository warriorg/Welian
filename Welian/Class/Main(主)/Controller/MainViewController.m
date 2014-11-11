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
#import "WLDataDBTool.h"

@interface MainViewController () <UINavigationControllerDelegate>
{
    UITabBarItem *homeItem;
    UITabBarItem *selectItem;
    HomeController *homeVC;
}
@end

@implementation MainViewController

- (void)loadFriendRequest
{
    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    if (!mode.sessionid) return;
    [WLHttpTool loadFriendRequestParameterDic:@{@"page":@(1),@"size":@(1000)} success:^(id JSON) {
        
        NSArray *jsonArray = [NSArray arrayWithArray:JSON];
        for (NSDictionary *dic  in jsonArray) {
            NSString *fid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fid"]];
            YTKKeyValueItem *item = [[WLDataDBTool sharedService] getYTKKeyValueItemById:fid fromTable:KNewFriendsTableName];
            if (![item.itemObject objectForKey:@"isLook"]) {
                NSMutableDictionary *mutablDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [mutablDic setObject:@"friendRequest" forKey:@"type"];
                [mutablDic setObject:fid forKey:@"uid"];
                [[WLDataDBTool sharedService] putObject:mutablDic withId:fid intoTable:KNewFriendsTableName];
                
                [self newFriendPuthMessga];
            }
        }
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)loadNewStustupdata
{
    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    if ([UserDefaults objectForKey:KFirstFID]&&mode.sessionid&&mode.mobile&&mode.checkcode) {
        NSInteger fid = [[UserDefaults objectForKey:KFirstFID] integerValue];
        
        [WLHttpTool loadNewFeedCountParameterDic:@{@"fid":@(fid)} success:^(id JSON) {
            NSNumber *count = [JSON objectForKey:@"count"];
            if (![count integerValue]) return;
            
                [[self.viewControllers[0] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%@",count]];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[count integerValue]];
        } fail:^(NSError *error) {
            
        }];
    }

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newFriendPuthMessga) name:KNewFriendNotif object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewStustupdata) name:KNEWStustUpdate object:nil];
    [self loadFriendRequest];
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(nil, nil);
    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
    //这个只会在第一次访问时调用
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool greanted, CFErrorRef error){
        dispatch_semaphore_signal(sema);
        if (greanted) {
            [UserDefaults setObject:@"1" forKey:KAddressBook];
            DLog(@"ABAddressBookSetAuthorization success.");
        }else {
            [UserDefaults setObject:@"0" forKey:KAddressBook];
            
        }
    });
    
    [[UITextField appearance] setTintColor:KBasesColor];
    [[UITextView appearance] setTintColor:KBasesColor];
    

    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];

    
    UIImageView *a = [[UIImageView alloc] init];
    [a sd_setImageWithURL:[NSURL URLWithString:mode.avatar] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        NSString *avatarStr = [UIImageJPEGRepresentation(image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [UserDefaults setObject:avatarStr forKey:@"icon"];
        
    }];
    [a setHidden:YES];
    [self.view addSubview:a];
    
    // 首页
    homeItem = [self itemWithTitle:@"动态" imageStr:@"tabbar_home" selectedImageStr:@"tabbar_home_selected"];
    
    
    homeVC = [[HomeController alloc] initWithStyle:UITableViewStylePlain anduid:nil];
    
    [homeVC.navigationItem setTitle:@"动态"];
    NavViewController *homeNav = [[NavViewController alloc] initWithRootViewController:homeVC];
    [homeNav setDelegate:self];
    [homeNav setTabBarItem:homeItem];
    
    
    // 好友
    UITabBarItem *circleItem = [self itemWithTitle:@"好友" imageStr:@"tabbar_friend" selectedImageStr:@"tabbar_friend_selected"];
    MyFriendsController *friendsVC = [[MyFriendsController alloc] initWithStyle:UITableViewStylePlain];
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
    [self.tabBar setSelectedImageTintColor:KBasesColor];
    selectItem = homeItem;
}

- (void)newFriendPuthMessga
{
    [[self.viewControllers[1] tabBarItem] setBadgeValue:@"1"];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [WLHUDView hiddenHud];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{

    if (selectItem == homeItem && item == homeItem) {
        [homeVC.refreshControl beginRefreshing];
        [homeVC.tableView setContentOffset:CGPointMake(0,-homeVC.refreshControl.frame.size.height-64) animated:YES];
        // 延迟2秒执行：
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // code to be executed on the main queue after delay
            [homeVC.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
        });

    }

        selectItem = item;
}

- (UITabBarItem*)itemWithTitle:(NSString *)title imageStr:(NSString *)imageStr selectedImageStr:(NSString *)selectedImageStr
{
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imageStr] selectedImage:[UIImage imageNamed:selectedImageStr]];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName :KBasesColor,NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateSelected];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
    return item;
}

@end
