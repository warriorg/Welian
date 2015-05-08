//
//  ActivityWebDetailInfoView.m
//  Welian
//
//  Created by weLian on 15/5/8.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityWebDetailInfoView.h"

@interface ActivityWebDetailInfoView ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    BOOL isDragging;
}

@property (strong,nonatomic) UIWebView *webView;
@property (assign,nonatomic) UILabel *infoLabel;
@property (strong,nonatomic) UIActivityIndicatorView *activityView;

@end

@implementation ActivityWebDetailInfoView

- (void)dealloc
{
    _webView = nil;
    _urlStr = nil;
    _backBlock = nil;
    _activityView = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = ScreenRect;
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setUrlStr:(NSString *)urlStr
{
    [super willChangeValueForKey:@"urlStr"];
    _urlStr = urlStr;
    [super didChangeValueForKey:@"urlStr"];
    [self reloadWebInfo];
}

- (void)setIsShow:(BOOL)isShow
{
    _isShow = isShow;
    if (!_isShow) {
        _infoLabel.hidden = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    DLog(@"scroll off Y---%f",offsetY);
    if (offsetY < -20) {
        _infoLabel.hidden = NO;
    }else{
        _infoLabel.hidden = YES;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    isDragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    isDragging = NO;
    
    // 下拉返回
    CGFloat offsetY = scrollView.contentOffset.y;
    DLog(@"scroll off Y---%f",offsetY);
    if (offsetY < -60) {
        if (_backBlock) {
            _backBlock();
        }
    }
}

#pragma mark - Private
- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    webView.scrollView.delegate = self;
    [self addSubview:webView];
    self.webView = webView;
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.width, 30.f)];
    infoLabel.font = kNormal14Font;
    infoLabel.textColor = kNormalTextColor;
    infoLabel.text = @"下拉返回活动详情";
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.hidden = YES;
    [self addSubview:infoLabel];
    self.infoLabel = infoLabel;
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.hidesWhenStopped = YES;
    activityView.centerX = ScreenWidth / 2.f;
    activityView.centerY = ScreenHeight / 2.f - 50;
    [self addSubview:activityView];
    self.activityView = activityView;
}

- (void)reloadWebInfo
{
    if (_urlStr.length > 0) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    }else{
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, ScreenWidth,30.f)];
        infoLabel.font = kNormal14Font;
        infoLabel.textColor = kNormalTextColor;
        infoLabel.text = @"暂无活动详情";
        infoLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:infoLabel];
        self.infoLabel = infoLabel;
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    DLog(@"webViewDidStartLoad --");
    [_activityView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DLog(@"webViewDidFinishLoad --");
    [_activityView stopAnimating];
}

@end
