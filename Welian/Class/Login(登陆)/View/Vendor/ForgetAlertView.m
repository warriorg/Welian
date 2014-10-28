//
//  ForgetAlertView.m
//  DXAlertView
//
//  Created by dong on 14/10/22.
//  Copyright (c) 2014年 xiekw. All rights reserved.
//

#import "ForgetAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+val.h"

#define kAlertWidth 280.0f
#define kAlertHeight 160.0f

@interface ForgetAlertView() <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UITextField *phoneTextF;
@property (nonatomic, strong) UIView *backImageView;

@end

@implementation ForgetAlertView

+ (CGFloat)alertWidth
{
    return kAlertWidth;
}

+ (CGFloat)alertHeight
{
    return kAlertHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define kTitleYOffset 15.0f
#define kTitleHeight 25.0f

#define kContentOffset 30.0f
#define kBetweenLabelOffset 20.0f

- (id)initWithDeputStr:(NSString *)deputStr andTextFidePlesh:(NSString *)placeholder
{
    if (self = [super init]) {
        self.layer.cornerRadius = 8.0;
        self.backgroundColor = [UIColor whiteColor];
#define kSingleButtonWidth 160.0f
#define kCoupleButtonWidth 107.0f
#define kButtonHeight 44.0f
#define kButtonBottomOffset 10.0f
        
        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kAlertWidth, 25)];
        [titLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [titLabel setTextAlignment:NSTextAlignmentCenter];
        [titLabel setText:@"重设密码"];
        [self addSubview:titLabel];
        
        UILabel *detLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titLabel.frame)+3, kAlertWidth, 20)];
        [detLabel setTextAlignment:NSTextAlignmentCenter];
        [detLabel setFont:[UIFont systemFontOfSize:15]];
        [detLabel setText:deputStr];
        [self addSubview:detLabel];
        
        // 手机号
        self.phoneTextF = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(detLabel.frame)+10, 260, 40)];
        [self.phoneTextF setDelegate:self];
        [self.phoneTextF.layer setCornerRadius:8];
        if ([placeholder isEqualToString:@"手机号码"]) {
            
            [self.phoneTextF setKeyboardType:UIKeyboardTypeNumberPad];
        }
        [self.phoneTextF.layer setMasksToBounds:YES];
        [self.phoneTextF setFont:[UIFont systemFontOfSize:20]];
        [self.phoneTextF setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        [self.phoneTextF setPlaceholder:placeholder];
        [self.phoneTextF setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self.phoneTextF becomeFirstResponder];
        [self addSubview:self.phoneTextF];
        
        
        CGRect rightBtnFrame = CGRectMake(0, kAlertHeight - kButtonHeight, kAlertWidth, kButtonHeight);
        self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nextBtn.frame = rightBtnFrame;
        [self.nextBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.nextBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nextBtn];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (void)rightBtnClicked:(id)sender
{
    if ([self.phoneTextF.placeholder isEqualToString:@"手机号码"]) {
        if (![NSString phoneValidate:self.phoneTextF.text]) {
            [WLHUDView showErrorHUD:@"手机号错误！"];
            return;
        }
    }else{
        if (![NSString passwordValidate:self.phoneTextF.text]) {
            [WLHUDView showErrorHUD:@"长度为6-18位！"];
            return;
        }
    }
    
    [self dismissAlert];
    if (self.rightBlock) {
        self.rightBlock(self.phoneTextF.text);
    }
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, -kAlertHeight, kAlertWidth, kAlertHeight);
    [topVC.view addSubview:self];
}

- (void)dismissAlert
{
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview
{
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, kAlertHeight);
    
    [UIView animateWithDuration:0.25f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.backImageView setAlpha:0.0f];
        self.frame = afterFrame;
        self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
        [self.phoneTextF resignFirstResponder];
    } completion:^(BOOL finished) {
        [self.backImageView removeFromSuperview];
        self.backImageView = nil;
        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.0f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        // 添加单击的手势
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        tapGestureRecognizer.numberOfTapsRequired = 1; // 设置单击几次才触发方法
        [tapGestureRecognizer addTarget:self action:@selector(removeFromSuperview)]; // 添加点击手势的方法
        [self.backImageView addGestureRecognizer:tapGestureRecognizer];
    }
    [topVC.view addSubview:self.backImageView];
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeight) * 0.5-130, kAlertWidth, kAlertHeight);
    [UIView animateWithDuration:0.25f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.backImageView setAlpha:0.5];
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
}

@end
