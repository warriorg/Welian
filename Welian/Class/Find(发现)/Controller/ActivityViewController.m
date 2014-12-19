//
//  ActivityViewController.m
//  Welian
//
//  Created by weLian on 14/12/19.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "ActivityViewController.h"
#import "WeixinActivity.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

//隐藏头部
//- (void)hideHeader
//{
//    self.navigationController.navigationBarHidden = YES;
//    //隐藏旋转
//    [WLHUDView hiddenHud];
//}

//返回发现
- (void)backToFindVC
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

//分享
- (void)shareWithInfo
{
    NSArray *activity = @[[[WeixinSessionActivity alloc] init], [[WeixinTimelineActivity alloc] init]];
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@""]]];
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[@"标题,内容 ,share2",[NSURL URLWithString:@"www.baidu.com"]] applicationActivities:activity];
    //将不会被显示出来的列表
    activityView.excludedActivityTypes = @[UIActivityTypeMail,UIActivityTypeMessage,UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePrint];
    [self presentViewController:activityView animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //铺到状态栏底下而是从状态栏下面
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //旋转
//    self.title = @"活动";
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
