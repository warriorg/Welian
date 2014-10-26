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


@interface MainViewController () <UINavigationControllerDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    
    // 首页
    UITabBarItem *homeItem = [self itemWithTitle:@"动态" imageStr:@"tabbar_home" selectedImageStr:@"tabbar_home_selected"];
    
    HomeController *homeVC = [[HomeController alloc] initWithStyle:UITableViewStylePlain anduid:nil];
    
    [homeVC.navigationItem setTitle:@"动态"];
    NavViewController *homeNav = [[NavViewController alloc] initWithRootViewController:homeVC];
    [homeNav setDelegate:self];
    [homeNav setTabBarItem:homeItem];
    
    
    // 好友
    UITabBarItem *circleItem = [self itemWithTitle:@"好友" imageStr:@"tabbar_friend" selectedImageStr:@"tabbar_friend_selected"];
    MyFriendsController *friendsVC = [[MyFriendsController alloc] initWithStyle:UITableViewStyleGrouped];
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
