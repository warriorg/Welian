//
//  ActivityViewController.m
//  Welian
//
//  Created by weLian on 14/12/19.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "ActivityViewController.h"
//#import "LXActivity.h"
//#import "ShareEngine.h"
#import "ActivityDetailViewController.h"

@interface ActivityViewController () //<LXActivityDelegate>
{
//    NSDictionary *_shareData;
//    LXActivity *lxActivity;
}
@end

@implementation ActivityViewController


//进入活动详情页面
- (void)toActivityDetailVC:(NSArray *)infos
{
    DLog(@"infos--->:\n1:%@\n2:%@ ",infos[0],[infos[1] JSONValue]);
    //活动页面，进行phoneGap页面加载
    ActivityDetailViewController *activityDetailVC = [[ActivityDetailViewController alloc] init];
    activityDetailVC.wwwFolderName = @"www";
    activityDetailVC.startPage = [NSString stringWithFormat:@"activity_detail.html?%@?t=%@",infos[0],[NSString getNowTimestamp]];//@"909"
    [self.navigationController pushViewController:activityDetailVC animated:YES];
}


#pragma mark - LXActivityDelegate
//- (void)didClickOnImageIndex:(NSString *)imageIndex
//{
//    if (_shareData) {
//        NSDictionary *sharDic = nil;
//        WeiboType type = weChat;
//        if ([imageIndex isEqualToString:@"微信好友"]){
//            sharDic = _shareData[@"friend"];
//            type = weChat;
//        }else if ([imageIndex isEqualToString:@"微信朋友圈"]){
//            sharDic = _shareData[@"friendCircle"];
//            type = weChatFriend;
//        }
//
//        NSString *desc = sharDic[@"desc"];
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sharDic[@"img"]]]];
//        NSString *link = sharDic[@"link"];
//        NSString *title = sharDic[@"title"];
//        
//        [[ShareEngine sharedShareEngine] sendWeChatMessage:title andDescription:desc WithUrl:link andImage:image WithScene:type];
//    }
//    
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"活动";
    //铺到状态栏底下而是从状态栏下面
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    self.extendedLayoutIncludesOpaqueBars = YES;
//    self.modalPresentationCapturesStatusBarAppearance = YES;
    
    //预加载高度控制
//    self.webView.top = -ViewCtrlTopBarHeight;
//    self.webView.height = self.view.height + ViewCtrlTopBarHeight;
    
    //预加载
//    [WLHUDView showHUDWithStr:nil dim:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
