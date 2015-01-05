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
    CGFloat imageY = 50;
    if (Iphone5){
        imageY += 50;
    }else if (Iphone6){
        imageY += 100;
    }else if (Iphone6plus){
        imageY += 120;
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
    UIPageControl *page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SuperSize.height-120, SuperSize.width, 20)];

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
    
    UIButton *authBut = [[UIButton alloc] initWithFrame:CGRectMake(25, SuperSize.height-35-44, SuperSize.width-50, 44)];
    [authBut setBackgroundColor:[UIColor redColor]];
    [authBut addTarget:self action:@selector(authButClickWexing) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:authBut];
}

- (void)authButClickWexing
{
    
    if ([ShareSDK hasAuthorizedWithType:ShareTypeWeixiSession]) {
        //取消授权
        [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
    }else{
        //用户用户信息
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:YES
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];


        [ShareSDK getUserInfoWithType:ShareTypeWeixiSession
                          authOptions:authOptions
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {

                                   if (result)
                                   {
                                       NSLog(@"uid = %@",[userInfo uid]);
                                       NSLog(@"name = %@",[userInfo nickname]);
                                       NSLog(@"icon = %@",[userInfo profileImage]);
                                       NSLog(@"性别 = %@",[userInfo gender] == 0 ? @"男" : @"女");
                                       NSLog(@"sourceData = %@",[userInfo sourceData]);
                                       NSLog(@"verifyReason = %@",[userInfo verifyReason]);
                                       NSLog(@"birthday = %@",[userInfo birthday]);
                                       NSLog(@"aboutMe = %@",[userInfo aboutMe]);
                                      

                                   }
                                   NSLog(@"%ld:%@",(long)[error errorCode], [error errorDescription]);
                               }];

    }
    PerfectInfoController *perfcetInfoVC = [[PerfectInfoController alloc] init];
    NavViewController *nav = [[NavViewController alloc] initWithRootViewController:perfcetInfoVC];
    [self presentViewController:nav animated:YES completion:^{
        
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
