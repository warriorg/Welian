//
//  LoginAlertView.m
//  DXAlertView
//
//  Created by dong on 14/10/22.
//  Copyright (c) 2014年 xiekw. All rights reserved.
//

#import "LoginAlertView.h"
#import "NSString+val.h"

#import <QuartzCore/QuartzCore.h>


#define kAlertWidth 280.0f
#define kAlertHeight 160.0f

@interface LoginAlertView() <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *forgetBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UITextField *phoneTextF;
@property (nonatomic, strong) UITextField *passwordTextF;
@property (nonatomic, strong) UIView *backImageView;

@end

@implementation LoginAlertView

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

- (id)init
{
    if (self = [super init]) {
        self.layer.cornerRadius = 8.0;
        self.backgroundColor = [UIColor whiteColor];
#define kSingleButtonWidth 160.0f
#define kCoupleButtonWidth 107.0f
#define kButtonHeight 44.0f
#define kButtonBottomOffset 10.0f
        // 手机号
        self.phoneTextF = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 260, 40)];
        [self.phoneTextF setDelegate:self];
        [self.phoneTextF.layer setCornerRadius:8];
        [self.phoneTextF setKeyboardType:UIKeyboardTypeNumberPad];
        [self.phoneTextF.layer setMasksToBounds:YES];
        [self.phoneTextF setFont:[UIFont systemFontOfSize:20]];
        [self.phoneTextF setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        [self.phoneTextF setPlaceholder:@"手机号码"];
        [self.phoneTextF setReturnKeyType:UIReturnKeyNext];
        [self.phoneTextF setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self.phoneTextF becomeFirstResponder];
        [self addSubview:self.phoneTextF];
        
        // 密码
        self.passwordTextF = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, 260, 40)];
        [self.passwordTextF setDelegate:self];
        [self.passwordTextF.layer setCornerRadius:8];
        [self.passwordTextF.layer setMasksToBounds:YES];
        [self.passwordTextF setFont:[UIFont systemFontOfSize:20]];
        [self.passwordTextF setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        [self.passwordTextF setPlaceholder:@"密码"];
        [self.passwordTextF setReturnKeyType:UIReturnKeyJoin];
        [self.passwordTextF setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self addSubview:self.passwordTextF];
        
        
        CGRect leftBtnFrame = CGRectMake(0, kAlertHeight - kButtonHeight, kAlertWidth*0.5, kButtonHeight);
        self.forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.forgetBtn.frame = leftBtnFrame;
        [self.forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [self.forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.forgetBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.forgetBtn];
        
        CGRect rightBtnFrame = CGRectMake(kAlertWidth*0.5, kAlertHeight - kButtonHeight, kAlertWidth*0.5, kButtonHeight);
        self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.loginBtn.frame = rightBtnFrame;
        [self.loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
        [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.loginBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.loginBtn];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneTextF) {
        [self.passwordTextF becomeFirstResponder];
    }else{
        [self rightBtnClicked:nil];
    }
    return YES;
}


- (void)leftBtnClicked:(id)sender
{
    [self dismissAlert];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightBtnClicked:(id)sender
{
    [self.phoneTextF resignFirstResponder];
    [self.passwordTextF resignFirstResponder];
    
    if (![NSString phoneValidate:self.phoneTextF.text]) {
        [WLHUDView showErrorHUD:@"手机号错误！"];
        return;
    }
    if (![NSString passwordValidate:self.passwordTextF.text]) {
        [WLHUDView showErrorHUD:@"密码错误！"];
        return;
    }
    
    [self dismissAlert];
    if (self.rightBlock) {
        self.rightBlock(self.phoneTextF.text,self.passwordTextF.text);
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
        [self.passwordTextF resignFirstResponder];
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
