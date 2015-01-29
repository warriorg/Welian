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
#import "LogInUser.h"
#import "LocationTool.h"

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
    UITabBarItem *circleItem;
    UITabBarItem *chatMessageItem;
    UITabBarItem *findItem;
    UITabBarItem *meItem;
    HomeController *homeVC;
}

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
        
        [WLHttpTool loadNewFeedCountParameterDic:@{@"fid":mode.firststustid} success:^(id JSON) {
            NSNumber *count = [JSON objectForKey:@"count"];
            NSNumber *activecount = [JSON objectForKey:@"activecount"];
            NSNumber *investorcount = [JSON objectForKey:@"investorcount"];
            [LogInUser setUserNewstustcount:count];
            [LogInUser setUserActivecount:activecount];
            [LogInUser setUserInvestorcount:investorcount];
            [self updataItembadge];
        } fail:^(NSError *error) {
            
        }];
    }
}


// 根据更新信息设置 提示角标
- (void)updataItembadge
{
//     [homeVC.navigationItem setTitleView:self.navTitleView];
    LogInUser *meinfo = [LogInUser getCurrentLoginUser];
    // 首页
    if (meinfo.newstustcount.integerValue &&!meinfo.homemessagebadge.integerValue) {
        [self.navTitleView showPrompt];
        [homeItem setImage:[[UIImage imageNamed:@"tabbar_home_prompt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [homeItem setSelectedImage:[[UIImage imageNamed:@"tabbar_home_selected_prompt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }else{
        [self.navTitleView hidePrompt];
        [homeItem setImage:[UIImage imageNamed:@"tabbar_home"]];
        [homeItem setSelectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
        if (meinfo.homemessagebadge.integerValue) {
            NSString *badgeStr = [NSString stringWithFormat:@"%@",meinfo.homemessagebadge];
            [homeItem setBadgeValue:badgeStr];
        }
    }
    /// 有新的活动
    if (meinfo.isactivebadge.boolValue) {
        [findItem setImage:[[UIImage imageNamed:@"tabbar_discovery_prompt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [findItem setSelectedImage:[[UIImage imageNamed:@"tabbar_discovery_selected_prompt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }else{
        [findItem setImage:[UIImage imageNamed:@"tabbar_discovery"]];
        [findItem setSelectedImage:[UIImage imageNamed:@"tabbar_discovery_selected"]];
    }
    
    // 我的投资人认证状态改变
    if (meinfo.isinvestorbadge.boolValue) {
        [meItem setImage:[[UIImage imageNamed:@"tabbar_friend_prompt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [meItem setSelectedImage:[[UIImage imageNamed:@"tabbar_friend_selected_prompt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }else{
        [meItem setImage:[UIImage imageNamed:@"tabbar_me"]];
        [meItem setSelectedImage:[UIImage imageNamed:@"tabbar_me_selected"]];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//更新消息数量改变
- (void)updateChatMessageBadge:(NSNotification *)notification
{
    NSInteger unRead = [[LogInUser getCurrentLoginUser] allUnReadChatMessageNum];
    chatMessageItem.badgeValue = unRead <= 0 ? nil : [NSString stringWithFormat:@"%d",(int)unRead];
}

//设置选择的为消息列表页面
- (void)changeTapToChatList:(NSNotification *)notification
{
    self.selectedIndex = 2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 有新好友通知
    [KNSNotification addObserver:self selector:@selector(newFriendPuthMessga) name:KNewFriendNotif object:nil];
    
    // 有新动态通知
    [KNSNotification addObserver:self selector:@selector(loadNewStustupdata) name:KNEWStustUpdate object:nil];
    
    // 首页动态消息通知
   [KNSNotification addObserver:self selector:@selector(updataItembadge) name:KMessageHomeNotif object:nil];
    
    //添加聊天用户改变监听
    [KNSNotification addObserver:self selector:@selector(updateChatMessageBadge:) name:@"ChatMsgNumChanged" object:nil];
    
    //如果是从好友列表进入聊天，首页变换
    [KNSNotification addObserver:self selector:@selector(changeTapToChatList:) name:@"ChangeTapToChatList" object:nil];
    
    // 新的活动提示
    [KNSNotification addObserver:self selector:@selector(updataItembadge) name:KNewactivitNotif object:nil];
    
    // 我的认证投资人状态改变
    [KNSNotification addObserver:self selector:@selector(updataItembadge) name:KInvestorstateNotif object:nil];
    
    [[UITextField appearance] setTintColor:KBasesColor];
    [[UITextView appearance] setTintColor:KBasesColor];

    LogInUser *mode = [LogInUser getCurrentLoginUser];
    UIImageView *a = [[UIImageView alloc] init];
    [a sd_setImageWithURL:[NSURL URLWithString:mode.avatar] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        NSString *avatarStr = [UIImageJPEGRepresentation(image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [UserDefaults setObject:avatarStr forKey:@"icon"];
        
    }];
    [a setHidden:YES];
    [self.view addSubview:a];
    
    // 首页
    homeItem = [self itemWithTitle:@"创业圈" imageStr:@"tabbar_home" selectedImageStr:@"tabbar_home_selected"];
//    [homeItem setBadgeValue:[UserDefaults objectForKey:KMessagebadge]];
    homeVC = [[HomeController alloc] initWithUid:nil];
    NavViewController *homeNav = [[NavViewController alloc] initWithRootViewController:homeVC];
    [homeVC.navigationItem setTitle:@"创业圈"];
    [homeNav setDelegate:self];
    [homeNav setTabBarItem:homeItem];
    
    // 好友
    circleItem = [self itemWithTitle:@"好友" imageStr:@"tabbar_friend" selectedImageStr:@"tabbar_friend_selected"];
    if ([LogInUser getCurrentLoginUser].newfriendbadge.integerValue) {
        
        [circleItem setBadgeValue:[NSString stringWithFormat:@"%@",[LogInUser getCurrentLoginUser].newfriendbadge]];
    }
    
    MyFriendsController *friendsVC = [[MyFriendsController alloc] initWithStyle:UITableViewStylePlain];
    NavViewController *friendsNav = [[NavViewController alloc] initWithRootViewController:friendsVC];
    [friendsNav setDelegate:self];
    [friendsVC.navigationItem setTitle:@"好友"];
    [friendsNav setTabBarItem:circleItem];
    
    
    // 聊天消息
    chatMessageItem = [self itemWithTitle:@"消息" imageStr:@"tabbar_chat" selectedImageStr:@"tabbar_chat_selected"];
    ChatMessageController *chatMessageVC = [[ChatMessageController alloc] initWithStyle:UITableViewStylePlain];
    NavViewController *chatMeeageNav = [[NavViewController alloc] initWithRootViewController:chatMessageVC];
    [chatMessageVC.navigationItem setTitle:@"消息"];
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
    [meVC.navigationItem setTitle:@"我"];
    [meNav setTabBarItem:meItem];
    
    [self setViewControllers:@[homeNav,friendsNav, chatMeeageNav,findNav,meNav]];
    [self.tabBar setSelectedImageTintColor:KBasesColor];

    selectItem = homeItem;
    [self updataItembadge];
    [self updateChatMessageBadge:nil];
    
    // 定位
    [[LocationTool sharedLocationTool] statLocationMy];
    [LocationTool sharedLocationTool].userLocationBlock = ^(BMKUserLocation *userLocation){
        
    };
}


- (void)newFriendPuthMessga
{
    NSString *badgeStr = [NSString stringWithFormat:@"%@",[LogInUser getCurrentLoginUser].newfriendbadge];
    [circleItem setBadgeValue:badgeStr];
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
        // 延迟0.5秒执行：
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
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName :KBasesColor,NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateSelected];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    return item;
}

@end
