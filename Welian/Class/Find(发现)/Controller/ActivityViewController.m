//
//  ActivityViewController.m
//  Welian
//
//  Created by weLian on 14/12/19.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "ActivityViewController.h"
#import "LXActivity.h"
#import "ShareEngine.h"

@interface ActivityViewController () <LXActivityDelegate>
{
    NSDictionary *_shareData;
    LXActivity *lxActivity;
}
@end

@implementation ActivityViewController

//隐藏头部
- (void)hideHeader
{
    //延迟1秒
    [self performSelector:@selector(test) withObject:self afterDelay:.1];
    
    //隐藏旋转
    [WLHUDView hiddenHud];
}

- (void)test {
    self.webView.top = 0;
    self.navigationController.navigationBarHidden = YES;
}

//返回发现
- (void)backToFindVC
{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

//分享
- (void)shareWithInfo:(NSDictionary *)commandDic
{
    _shareData = commandDic;
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
    if (_shareData) {
        NSDictionary *sharDic = nil;
        WeiboType type = 0;
        if ([imageIndex isEqualToString:@"微信好友"]){
            sharDic = _shareData[@"friend"];
            type = weChat;
        }else if ([imageIndex isEqualToString:@"微信朋友圈"]){
            sharDic = _shareData[@"friendCircle"];
            type = weChatFriend;
        }

        NSString *desc = sharDic[@"desc"];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sharDic[@"img"]]]];
        NSString *link = sharDic[@"link"];
        NSString *title = sharDic[@"title"];

        [[ShareEngine sharedShareEngine] sendWeChatMessage:title andDescription:desc WithUrl:link andImage:image WithScene:type];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //铺到状态栏底下而是从状态栏下面
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    self.extendedLayoutIncludesOpaqueBars = YES;
//    self.modalPresentationCapturesStatusBarAppearance = YES;
    
    self.webView.top = -ViewCtrlTopBarHeight;
    self.webView.height = self.view.height + ViewCtrlTopBarHeight;
    
//    [self.view setDebug:YES];
    //旋转
    self.title = @"活动";
    [WLHUDView showHUDWithStr:nil dim:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    DLog(@"fdsa");
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
