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
    LogInUser *mode = [LogInUser getNowLogInUser];
    if ([UserDefaults objectForKey:KFirstFID]&&mode.sessionid&&mode.mobile) {
        NSInteger fid = [[UserDefaults objectForKey:KFirstFID] integerValue];
        
        [WLHttpTool loadNewFeedCountParameterDic:@{@"fid":@(fid)} success:^(id JSON) {
            NSNumber *count = [JSON objectForKey:@"count"];
            [UserDefaults setInteger:[count integerValue] forKey:KNewStaustbadge];
            [self updataItembadge];
        } fail:^(NSError *error) {
            
        }];
    }
}


// 根据更新信息设置 提示角标
- (void)updataItembadge
{
    // 首页
    if ([UserDefaults integerForKey:KNewStaustbadge]&&![UserDefaults objectForKey:KMessagebadge]) {
        [self.navTitleView showPrompt];
        [homeItem setImage:[[UIImage imageNamed:@"tabbar_home_prompt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [homeItem setSelectedImage:[[UIImage imageNamed:@"tabbar_home_selected_prompt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }else{
        [self.navTitleView hidePrompt];
        [homeItem setImage:[UIImage imageNamed:@"tabbar_home"]];
        [homeItem setSelectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
        if ([UserDefaults objectForKey:KMessagebadge]) {
            NSString *badgeStr = [UserDefaults objectForKey:KMessagebadge];
            [homeItem setBadgeValue:badgeStr];
        }
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//更新消息数量改变
- (void)updateChatMessageBadge:(NSNotification *)notification
{
    int unRead = [[LogInUser getNowLogInUser] allUnReadChatMessageNum];
    chatMessageItem.badgeValue = unRead <= 0 ? nil : [NSString stringWithFormat:@"%d",unRead];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newFriendPuthMessga) name:KNewFriendNotif object:nil];
    
    // 有新动态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewStustupdata) name:KNEWStustUpdate object:nil];
    
    // 首页动态消息通知
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataItembadge) name:KMessageHomeNotif object:nil];
    
    //添加聊天用户改变监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChatMessageBadge:) name:@"ChatMsgNumChanged" object:nil];
    
    //如果是从好友列表进入聊天，首页变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTapToChatList:) name:@"ChangeTapToChatList" object:nil];
    
//    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(nil, nil);
//    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
//    //这个只会在第一次访问时调用
//    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool greanted, CFErrorRef error){
//        dispatch_semaphore_signal(sema);
//        if (greanted) {
//            [UserDefaults setObject:@"1" forKey:KAddressBook];
//
//        }else {
//            [UserDefaults setObject:@"0" forKey:KAddressBook];
//            
//        }
//    });
    
    [[UITextField appearance] setTintColor:KBasesColor];
    [[UITextView appearance] setTintColor:KBasesColor];

//    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    LogInUser *mode = [LogInUser getNowLogInUser];
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
    homeVC = [[HomeController alloc] initWithStyle:UITableViewStylePlain anduid:nil];
    [homeVC.navigationItem setTitleView:self.navTitleView];
    NavViewController *homeNav = [[NavViewController alloc] initWithRootViewController:homeVC];
    
    [homeNav setDelegate:self];
    [homeNav setTabBarItem:homeItem];
    [self updataItembadge];
    
    
    // 好友
    circleItem = [self itemWithTitle:@"好友" imageStr:@"tabbar_friend" selectedImageStr:@"tabbar_friend_selected"];
    [circleItem setBadgeValue:[UserDefaults objectForKey:KFriendbadge]];
    
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
    
    [self setViewControllers:@[homeNav,friendsNav, chatMeeageNav,findNav,meNav]];
    [self.tabBar setSelectedImageTintColor:KBasesColor];

    selectItem = homeItem;
}

//- (void)messageMainnotif
//{
//    NSString *badgeStr = [NSString stringWithFormat:@"%@",[UserDefaults objectForKey:KMessagebadge]];
//    [homeItem setBadgeValue:badgeStr];
//}

- (void)newFriendPuthMessga
{
    NSString *badgeStr = [NSString stringWithFormat:@"%@",[UserDefaults objectForKey:KFriendbadge]];
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
