//
//  LoginGuideController.m
//  Welian
//
//  Created by dong on 15/1/5.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "LoginGuideController.h"
#import "PerfectInfoController.h"
#import "NavViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "UIImage+ImageEffects.h"
#import "MainViewController.h"
#import "MJExtension.h"
#import "LoginPhoneVC.h"
#import "SignInPhoneController.h"
#import "WXApi.h"

@interface LoginGuideController () <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_page;
}
@end

@implementation LoginGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:WLRGB(245, 244, 242)];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setPagingEnabled:YES];
    [scrollView setBounces:YES];
    [scrollView setDelegate:self];
    [scrollView setAlwaysBounceHorizontal:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    CGFloat imageY = 40;
    CGFloat butY = 45;
    CGFloat PageY = 10;
    if (Iphone5){
        imageY += 50;
        butY += 10;
        PageY += 20;
    }else if (Iphone6){
        imageY += 100;
        butY += 30;
        PageY += 30;
    }else if (Iphone6plus){
        imageY += 120;
        butY += 30;
        PageY += 40;
    }
    for (NSInteger i = 1; i <= 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"login_guide%d.png",i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        // 如果不指定UIImaView的大小，会默认使用image的大小
        imageView.frame = CGRectMake((SuperSize.width * (i-1) + ((SuperSize.width-image.size.width)*0.5)), imageY, image.size.width, image.size.height);
        
        [scrollView addSubview:imageView];
        
    }

    [scrollView setContentSize:CGSizeMake(SuperSize.width * 4, 0)];
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    // 创建分页控件
    UIPageControl *page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SuperSize.height-110-PageY, SuperSize.width, 20)];

    // 设置分页的圆点标
    [page setNumberOfPages:4]; // 个数
    
    // 被选中标的颜色
    [page setCurrentPageIndicatorTintColor:WLRGB(130, 165, 206)];
    
    // 其他标的颜色
    [page setPageIndicatorTintColor:WLRGB(225, 225, 225)];
    _page = page;
    [self.view addSubview:page];
    
    // 设置分页控件监听方法
    [page addTarget:self action:@selector(updatepagechangen:) forControlEvents:UIControlEventValueChanged]; // 页码的变化
    

    CGRect phoneF = CGRectMake(25, SuperSize.height-butY-44, SuperSize.width-50, 44);
    // 微信登陆
    if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]) {
        UIButton *authBut = [[UIButton alloc] initWithFrame:CGRectMake(25, SuperSize.height-butY-44, (SuperSize.width-50-20)*0.5, 44)];
        [authBut setBackgroundImage:[UIImage resizedImage:@"login_my_bg"] forState:UIControlStateNormal];
        [authBut setBackgroundImage:[UIImage resizedImage:@"login_my_bg_pre"] forState:UIControlStateHighlighted];
        [authBut setImage:[UIImage imageNamed:@"login_wechat_logo"] forState:UIControlStateNormal];
        [authBut setTitle:@"微信登录" forState:UIControlStateNormal];
        [authBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [authBut setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [authBut addTarget:self action:@selector(authButClickWexing) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:authBut];
        phoneF = CGRectMake(CGRectGetMaxX(authBut.frame)+20, SuperSize.height-butY-44, (SuperSize.width-50-20)*0.5, 44);
    }
    // 手机登陆
    UIButton *phongBut = [[UIButton alloc] initWithFrame:phoneF];
    [phongBut setBackgroundImage:[UIImage resizedImage:@"login_my_bg"] forState:UIControlStateNormal];
    [phongBut setBackgroundImage:[UIImage resizedImage:@"login_my_bg_pre"] forState:UIControlStateHighlighted];
    [phongBut setImage:[UIImage imageNamed:@"login_phone_logo"] forState:UIControlStateNormal];
    [phongBut setTitle:@"手机登陆" forState:UIControlStateNormal];
    [phongBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [phongBut setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [phongBut addTarget:self action:@selector(phoneLoginButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phongBut];
    
    // 注册新用户
    UIButton *registBut = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x-45, SuperSize.height-40, 90, 30)];
    [registBut.titleLabel setFont:WLFONT(14)];
    [registBut setTitle:@"新用户注册" forState:UIControlStateNormal];
    [registBut setTitleColor:WLRGB(173, 173, 173) forState:UIControlStateNormal];
    [registBut addTarget:self action:@selector(registerNewButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBut];
}

// 注册新用户
- (void)registerNewButClick
{
    SignInPhoneController *signInVC = [[SignInPhoneController alloc] init];
    NavViewController *nav = [[NavViewController alloc] initWithRootViewController:signInVC];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

// 手机登陆
- (void)phoneLoginButClick
{
    LoginPhoneVC *loginPhong = [[LoginPhoneVC alloc] init];
    NavViewController *nav = [[NavViewController alloc] initWithRootViewController:loginPhong];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

// 微信登陆
- (void)authButClickWexing
{
    //取消授权
    [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
    
    //用户用户信息
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    [WLHUDView showHUDWithStr:@"授权中..." dim:YES];

    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               if (result)
                               {
                                   NSLog(@"sourceData = %@",[userInfo sourceData]);
                                   NSDictionary *sourceDic = [userInfo sourceData];
                                   if (!sourceDic) return;
                                   NSMutableDictionary *reqstDic = [NSMutableDictionary dictionary];
                                   [reqstDic setObject:[sourceDic objectForKey:@"openid"] forKey:@"openid"];
                                   [reqstDic setObject:[sourceDic objectForKey:@"unionid"] forKey:@"unionid"];
                                   [reqstDic setObject:KPlatformType forKey:@"platform"];
                                   if ([UserDefaults objectForKey:BPushRequestChannelIdKey]) {
                                       [reqstDic setObject:[UserDefaults objectForKey:BPushRequestChannelIdKey] forKey:@"clientid"];
                                   }
                                   
                                   [WLHttpTool loginParameterDic:reqstDic success:^(id JSON) {
                                       NSDictionary *dataDic = JSON;
                                       if (dataDic) {
                                           UserInfoModel *mode = [UserInfoModel objectWithKeyValues:dataDic];
                                           //记录最后一次登陆的手机号
                                           SaveLoginMobile(mode.mobile);
                                           [UserDefaults setObject:mode.sessionid forKey:@"sessionid"];
                                           [LogInUser createLogInUserModel:mode];
                                           [LogInUser setUseropenid:[sourceDic objectForKey:@"openid"]];
                                           [LogInUser setUserunionid:[sourceDic objectForKey:@"unionid"]];
                                          // 进入主页面
                                           MainViewController *mainVC = [[MainViewController alloc] init];
                                           [[UIApplication sharedApplication].keyWindow setRootViewController:mainVC];
                                       }

                                      [WLHUDView hiddenHud];
                                   } fail:^(NSError *error) {
                                       if (error.code==-2) { // -2微信没有登录过
                                           PerfectInfoController *perfcetInfoVC = [[PerfectInfoController alloc] init];

                                           NSMutableDictionary *userinfodic = [NSMutableDictionary dictionaryWithDictionary:[userInfo sourceData]];
                                          NSDictionary *dataDic = error.userInfo;
                                           if (dataDic) {
                                               [userinfodic setObject:dataDic forKey:@"weixingdata"];
                                           }
                                           
                                           [perfcetInfoVC setUserInfoDic:userinfodic];
                                           NavViewController *nav = [[NavViewController alloc] initWithRootViewController:perfcetInfoVC];
                                           [self presentViewController:nav animated:YES completion:^{
                                               
                                           }];
                                       }else if (error.code==-1){ //-1系统错误
                                       
                                       
                                       }
                                       [WLHUDView hiddenHud];
                                   } isHUD:YES];
                                   
                               }else{
                                    [WLHUDView hiddenHud];
                                   [[[UIAlertView alloc] initWithTitle:[error errorDescription] message:@"" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];

                               }

                               DLog(@"%ld:%@",(long)[error errorCode], [error errorDescription]);
                           }];
    
}

- (void)updatepagechangen:(UIPageControl *)page
{
    
    [_scrollView setContentOffset:CGPointMake(page.currentPage * _scrollView.bounds.size.width, 0) animated:YES];
    
}

// 页面滑动时 分页控件 圆点的变化
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_page setCurrentPage:_scrollView.contentOffset.x/_scrollView.bounds.size.width];
    
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
