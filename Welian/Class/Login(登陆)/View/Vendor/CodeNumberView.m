//
//  CodeNumberView.m
//  DXAlertView
//
//  Created by dong on 14/10/22.
//  Copyright (c) 2014年 xiekw. All rights reserved.
//

#import "CodeNumberView.h"
#import <QuartzCore/QuartzCore.h>
#import "AuthCodeTextField.h"

#define kAlertWidth 280.0f
#define kAlertHeight 160.0f

#define KTimes 60;

@interface CodeNumberView() <UITextFieldDelegate>
{
    __block int timeout;
    dispatch_source_t _timer;
}
@property (nonatomic, strong) AuthCodeTextField *codeTextF;
@property (nonatomic, strong) UIView *backImageView;


@end

@implementation CodeNumberView

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

- (id)initWithPhoneNumber:(NSString *)phoneStr
{
    if (self = [super init]) {
        self.layer.cornerRadius = 8.0;
        self.backgroundColor = [UIColor whiteColor];
        
        UIImage *aaim = [UIImage imageNamed:@"login_information"];
        UIImageView *image = [[UIImageView alloc] initWithImage:aaim];
        [image setFrame:CGRectMake(10, 20, aaim.size.width, aaim.size.height)];
        [self addSubview:image];
        
        CGFloat labeX =CGRectGetMaxX(image.frame)+5;
        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(labeX, 10, kAlertWidth-labeX-20, 44)];
        [titLabel setText:[NSString stringWithFormat:@"我们已将验证码发送至：%@ 请输入您的验证码",phoneStr]];
        [titLabel setNumberOfLines:0];
        [titLabel setFont:[UIFont systemFontOfSize:15.0]];
        [self addSubview:titLabel];
        
        
#define kSingleButtonWidth 160.0f
#define kCoupleButtonWidth 107.0f
#define kButtonHeight 44.0f
#define kButtonBottomOffset 10.0f
        // 手机号
        self.codeTextF = [[AuthCodeTextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titLabel.frame)+10, 260, 40)];
        [self.codeTextF setDelegate:self];
        [self addSubview:self.codeTextF];
        
        
        
        CGRect rightBtnFrame = CGRectMake(0, kAlertHeight - kButtonHeight, kAlertWidth, kButtonHeight);
        self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nextBtn.frame = rightBtnFrame;
        [self.nextBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.nextBtn setTitleColor:KBasesColor forState:UIControlStateNormal];
        [self.nextBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:21]];
        [self.nextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [self.nextBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nextBtn];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (range.location>3) {
        return NO;
    }
    if (range.location==0) {
        [self.codeTextF.oneLabel setText:string];
    }else if (range.location==1){
        [self.codeTextF.twoLabel setText:string];
    }else if (range.location == 2){
        [self.codeTextF.thirdLabel setText:string];
    }else if (range.location ==3){
        [self.codeTextF.fourLabel setText:string];
    }
    
    if (self.codeTextF.fourLabel.text.length) {
        [self.nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    }else {
        [self.nextBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    }
    
    return YES;
}


- (void)rightBtnClicked:(id)sender
{
    if (self.rightBlock) {
        self.rightBlock(self.codeTextF.text);
    }
    if ([self.nextBtn.titleLabel.text isEqualToString:@"提交"]) {
        [self dismissAlert];
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
        [self.codeTextF resignFirstResponder];
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
    timeout = KTimes;
    [self startTime];
}

-(void)startTime{
    
    if (timeout< 60)  {
        return;
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        
        dispatch_source_set_event_handler(_timer, ^{
            if (self.codeTextF.oneLabel.text.length) {
                timeout = 0;
            }
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.nextBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                    [self.nextBtn setEnabled:YES];
                    
                });
            }else{
                NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.nextBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateDisabled];
                    
                    [self.nextBtn setEnabled:NO];
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
}


@end
