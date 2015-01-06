//
//  ActivityDetailViewController.m
//  Welian
//
//  Created by weLian on 15/1/6.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityEntryViewController.h"
#import "ActivityOrderViewController.h"
#import "LXActivity.h"
#import "ShareEngine.h"
#import "SEImageCache.h"

@interface ActivityDetailViewController ()<LXActivityDelegate>
{
    LXActivity *lxActivity;
}

@property (nonatomic, strong) NSDictionary *shareFriend;//分享到微信好友的dict
@property (nonatomic, strong) NSDictionary *shareFriendCircle;//分享到微信朋友圈

@end

@implementation ActivityDetailViewController

- (instancetype)initWithShareDic:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.shareFriend = dict[@"friend"];
        self.shareFriendCircle = dict[@"friendCircle"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"活动详情";
    //铺到状态栏底下而是从状态栏下面
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //添加分享按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(shareActivity)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//分享活动
- (void)shareActivity
{
    NSArray *shareButtonTitleArray = @[@"微信好友",@"微信朋友圈"];;
    NSArray *shareButtonImageNameArray = @[@"home_repost_wechat",@"home_repost_friendcirle"];
    if (lxActivity) {
        [lxActivity removeFromSuperview];
        lxActivity = nil;
    }
    lxActivity = [[LXActivity alloc] initWithDelegate:self WithTitle:@"分享到" otherButtonTitles:nil ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    [lxActivity showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - LXActivityDelegate
- (void)didClickOnImageIndex:(NSString *)imageIndex
{
        NSDictionary *sharDic = nil;
        WeiboType type = weChat;
        if ([imageIndex isEqualToString:@"微信好友"]){
            sharDic = _shareFriend;
            type = weChat;
        }else if ([imageIndex isEqualToString:@"微信朋友圈"]){
            sharDic = _shareFriendCircle;
            type = weChatFriend;
        }
    
        NSString *desc = sharDic[@"desc"];
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sharDic[@"img"]]]];
        NSURL *imgUrl = [NSURL URLWithString:sharDic[@"img"]];
        NSString *link = sharDic[@"link"];
        NSString *title = sharDic[@"title"];
        
        [[SEImageCache sharedInstance] imageForURL:imgUrl completionBlock:^(UIImage *image, NSError *error) {
            DLog(@"shareFriendImage---->>>%@",image);
            [[ShareEngine sharedShareEngine] sendWeChatMessage:title andDescription:desc WithUrl:link andImage:image WithScene:type];
        }];
    
}

#pragma mark - private
//进入地图页面
- (void)toMapVC:(NSArray *)infos
{
    NSString *address = [NSString stringWithFormat:@"%@%@",infos[0],infos[1]];
    DLog(@"toMapVC ----->%@",address);
}

//显示已报名人数
- (void)showEntry:(NSArray *)infos
{
    DLog(@"showEntry -----> %@,%@",infos[0],infos[1]);
    //活动页面，进行phoneGap页面加载
    ActivityEntryViewController *activityEntryVC = [[ActivityEntryViewController alloc] init];
    activityEntryVC.wwwFolderName = @"www";
    activityEntryVC.startPage = [NSString stringWithFormat:@"activity_entry.html?%@?%@",infos[0],infos[1]];
    [self.navigationController pushViewController:activityEntryVC animated:YES];
}

//进入订单页面
- (void)toOrderVC:(NSArray *)infos
{
    DLog(@"showEntry -----> %@",infos[0]);
    //活动页面，进行phoneGap页面加载
    ActivityOrderViewController *activityOrderVC = [[ActivityOrderViewController alloc] init];
    activityOrderVC.orderInfo = infos[1];
    activityOrderVC.wwwFolderName = @"www";
    activityOrderVC.startPage = [NSString stringWithFormat:@"activity_order.html?%@",infos[0]];
    [self.navigationController pushViewController:activityOrderVC animated:YES];
}

@end
