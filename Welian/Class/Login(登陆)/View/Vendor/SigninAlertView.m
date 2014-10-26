//
//  LoginAlertView.m
//  DXAlertView
//
//  Created by dong on 14/10/22.
//  Copyright (c) 2014年 xiekw. All rights reserved.
//

#import "SigninAlertView.h"
#import "NSString+val.h"
#import <QuartzCore/QuartzCore.h>

#define kAlertWidth 280.0f
#define kAlertHeight 160.0f

@interface SigninAlertView() <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UITextField *phoneTextF;
@property (nonatomic, strong) UIView *backImageView;

@end

@implementation SigninAlertView

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
        
        UIImage *aaim = [UIImage imageNamed:@"login_information.png"];
        UIImageView *image = [[UIImageView alloc] initWithImage:aaim];
        [image setFrame:CGRectMake(10, 15, aaim.size.width, aaim.size.height)];
        [self addSubview:image];
        
        CGFloat labeX =CGRectGetMaxX(image.frame)+5;
        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(labeX, 10, kAlertWidth-labeX-20, 44)];
        [titLabel setText:[NSString stringWithFormat:@"为了确保加入weLian的不是喵星人，我们设置了手机号码校验"]];
        [titLabel setNumberOfLines:0];
        [titLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self addSubview:titLabel];
        
        // 手机号
        self.phoneTextF = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titLabel.frame)+10, 260, 40)];
        [self.phoneTextF setDelegate:self];
        [self.phoneTextF.layer setCornerRadius:8];
        [self.phoneTextF setKeyboardType:UIKeyboardTypeNumberPad];
        [self.phoneTextF.layer setMasksToBounds:YES];
        [self.phoneTextF setFont:[UIFont systemFontOfSize:20]];
        [self.phoneTextF setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        [self.phoneTextF setPlaceholder:@"手机号码"];
        [self.phoneTextF setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self.phoneTextF becomeFirstResponder];
        [self addSubview:self.phoneTextF];
        
        CGRect rightBtnFrame = CGRectMake(0, kAlertHeight - kButtonHeight, kAlertWidth, kButtonHeight);
        self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nextBtn.frame = rightBtnFrame;
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [self.nextBtn setTitleColor:KBasesColor forState:UIControlStateNormal];
        [self.nextBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:21]];
        [self.nextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [self.nextBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.nextBtn setEnabled:NO];
        [self addSubview:self.nextBtn];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location==0&&string.length) {
        [self.nextBtn setEnabled:YES];
    }
    if (range.location==0&&string.length==0) {
        [self.nextBtn setEnabled:NO];
    }
    if (range.location==11) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.nextBtn setEnabled:NO];
    return YES;
}



- (void)rightBtnClicked:(id)sender
{
    [self.phoneTextF resignFirstResponder];
    if (![NSString phoneValidate:self.phoneTextF.text]) {
        [WLHUDView showErrorHUD:@"手机号错误！"];
        return;
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
