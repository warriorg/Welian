//
//  ActivitySubInfoViewController.m
//  Welian
//
//  Created by weLian on 15/5/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivitySubInfoViewController.h"

@interface ActivitySubInfoViewController ()<UIWebViewDelegate>

@property (strong,nonatomic) NSString *urlStrl;

@end

@implementation ActivitySubInfoViewController

- (NSString *)title
{
    return @"活动详情";
}

- (instancetype)initWithUrl:(NSString *)urlStr
{
    self = [super init];
    if (self) {
        self.urlStrl = urlStr;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 注意：contentsize.height必须要大于bounds.size.height，否则不能滚动，也就无法回到父view
    self.scrollView.contentSize = CGSizeMake(self.view.width, 600);
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStrl]]];
    webView.scrollView.scrollEnabled = NO;
    webView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:webView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.size = webView.scrollView.contentSize;
    self.scrollView.contentSize = CGSizeMake(webView.scrollView.contentSize.width, webView.scrollView.contentSize.height + ViewCtrlTopBarHeight);
}

@end
