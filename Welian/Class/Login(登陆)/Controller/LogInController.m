//
//  LogInController.m
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "LogInController.h"
#import "UIImage+ImageEffects.h"
#import "loginView.h"
#import "UserInfoController.h"
#import "NavViewController.h"

#define KTimes 3;

@interface LogInController () <UITextFieldDelegate>
{
    __block int timeout;
    dispatch_source_t _timer;
}
@property (strong, nonatomic)  UITextField *phoneTextF;
@property (nonatomic, strong) loginView *trendView;
@property (nonatomic, strong) UIImageView *bgblurImage;
@property (nonatomic, strong) loginView *verificationView;
@property (nonatomic, strong)  UIButton *backBut;

@end

@implementation LogInController


- (loginView*)verificationView
{
    if (_verificationView == nil) {
        _verificationView = [[[NSBundle mainBundle] loadNibNamed:@"loginView" owner:self options:nil] lastObject];
        CGPoint cente = CGPointMake(self.view.center.x, -90);
        [_verificationView setCenter:cente];
        [self.view addSubview:_verificationView];
        [_verificationView setHidden:YES];
        [_verificationView.nextButton setEnabled:YES];
        [_verificationView.nextButton addTarget:self action:@selector(setVerificationNmb) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verificationView;
}

- (loginView *)trendView
{
    if (nil== _trendView) {
        
        _trendView = [[[NSBundle mainBundle]loadNibNamed:@"loginView" owner:self options:nil] lastObject];
        CGPoint cente = CGPointMake(self.view.center.x, -90);
        [_trendView setCenter:cente];
        [self.view addSubview:_trendView];
        [_trendView setHidden:YES];
        [_trendView.nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
        self.phoneTextF = [[UITextField alloc] initWithFrame:CGRectMake(10, 80, 270, 40)];
        [self.phoneTextF setDelegate:self];
        //        [self.phoneTextF setBounds:CGRectMake(0, 0, 270, 50)];
        [self.phoneTextF.layer setCornerRadius:8];
        [self.phoneTextF setKeyboardType:UIKeyboardTypePhonePad];
        [self.phoneTextF.layer setMasksToBounds:YES];
        [self.phoneTextF setFont:[UIFont systemFontOfSize:20]];
        [self.phoneTextF setBackgroundColor:[UIColor lightGrayColor]];
        [self.phoneTextF setPlaceholder:@"手机号码"];
        [self.phoneTextF setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_trendView addSubview:self.phoneTextF];
        
    }
    return _trendView;
}



- (UIImageView *)bgblurImage
{
    if (nil == _bgblurImage) {
        UIImage *background = [UIImage blurredSnapshot:self.view];
        _bgblurImage = [[UIImageView alloc] initWithImage:background];
        [_bgblurImage setUserInteractionEnabled:YES];
    
        // 添加单击的手势
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        tapGestureRecognizer.numberOfTapsRequired = 1; // 设置单击几次才触发方法
        [tapGestureRecognizer addTarget:self action:@selector(tapGestureAction:)]; // 添加点击手势的方法
        [_bgblurImage addGestureRecognizer:tapGestureRecognizer];
        [self.view addSubview:_bgblurImage];
    }
    return _bgblurImage;
}

- (UIButton*)backBut
{
    if (_backBut == nil) {
        _backBut = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 50, 30)];
        [_backBut setTitle:@"返回" forState:UIControlStateNormal];
//        [_backBut setBackgroundColor:[UIColor redColor]];
        [_backBut addTarget:self action:@selector(hideVerificationViewShowTrendView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBut];
        [_backBut setHidden:YES];
    }
    return _backBut;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置按钮图片
    [self setbuttonimage];
    timeout = KTimes;
    
}

/**
 *  发送验证码
 */
- (void)setVerificationNmb
{
    timeout = KTimes;
    [self startTime];
    UserInfoController *userInfoVC = [[UserInfoController alloc] init];
    [self.view.window setRootViewController:[[NavViewController alloc] initWithRootViewController:userInfoVC]];
//    [self presentViewController:[[NavViewController alloc] initWithRootViewController:userInfoVC] animated:YES completion:^{
    
//    }];
    
}

/**
 *  隐藏验证码view，显示电话号码view
 */
- (void)hideVerificationViewShowTrendView
{
    [self.backBut setHidden:YES];
    CGPoint cente = self.verificationView.center;
    cente.y += 500;
//    [self.verificationView.phoneTextF resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        [self.verificationView setCenter:cente];

    } completion:^(BOOL finished) {
        [self.verificationView setHidden:YES];
        [self.verificationView setCenter:CGPointMake(self.view.center.x, -90)];
        [self trendViewShow];
        
    }];
}


/**
 *  隐藏验证码view
 */
- (void)verificationViewHide
{
    [self.backBut setHidden:YES];
    CGPoint cente = self.verificationView.center;
    cente.y += 500;
//    [self.verificationView.phoneTextF resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        [self.verificationView setCenter:cente];
        [self.bgblurImage setHidden:YES];
    } completion:^(BOOL finished) {
        [self.verificationView setHidden:YES];
        [self.verificationView setCenter:CGPointMake(self.view.center.x, -90)];
    }];
}

/**
 *  显示验证码输入
 */
- (void)verificationViewshow
{
    [self.bgblurImage setHidden:NO];
    [self.verificationView setHidden:NO];
    [self.verificationView.tsLabel setText:@"我们已将验证码发至：13173698687 请输入您收到的验证码"];
//    [self.verificationView.phoneTextF becomeFirstResponder];
    CGPoint cente = CGPointMake(self.view.center.x, -90);
    cente.y += 250;
    [self.view bringSubviewToFront:self.verificationView];
    [UIView animateWithDuration:0.4 animations:^{
        [self.verificationView setCenter:cente];
        
    } completion:^(BOOL finished) {
        //        [self.bgblurImage setUserInteractionEnabled:NO];
        [self.backBut setHidden:NO];
        [self.view bringSubviewToFront:self.backBut];
    }];
    
    [self startTime];
    
}

/**
 *  隐藏手机号输入，显示验证码输入
 */
- (void)nextClick
{
    if (self.phoneTextF.text) {
        [[NSUserDefaults standardUserDefaults] setObject:self.phoneTextF.text forKey:@"phone"];
        //        [_trendView.tsLabel setText:@"手机号码输入有误，请重新输入"];
        CGPoint cente = self.trendView.center;
        cente.y += 500;
        [self.phoneTextF resignFirstResponder];
        [UIView animateWithDuration:0.4 animations:^{
            [self.trendView setCenter:cente];
        } completion:^(BOOL finished) {
            [self.trendView setHidden:YES];
            CGPoint cente = CGPointMake(self.view.center.x, -90);
            [self.trendView setCenter:cente];
            timeout = KTimes;
            [self verificationViewshow];
        }];
    }
}




/**
 *  手势隐藏手机号输入view
 *
 *  @param tapges
 */
- (void)tapGestureAction:(UITapGestureRecognizer *)tapges
{
    if (!self.trendView.hidden) {
        [self trendViewHide];
    }
    if (!self.verificationView.hidden) {
        [self verificationViewHide];
        
    }
}

/**
 *  显示手机号输入
 */
- (void)trendViewShow
{
    [self.phoneTextF becomeFirstResponder];
    [self.bgblurImage setHidden:NO];
//    [self.bgblurImage setUserInteractionEnabled:YES];
    [self.trendView setHidden:NO];
    CGPoint cente = CGPointMake(self.view.center.x, -90);
    cente.y += 250;
    [self.view bringSubviewToFront:self.trendView];
    [UIView animateWithDuration:0.4 animations:^{
        [self.trendView setCenter:cente];
        
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  隐藏手机号输入
 */
- (void)trendViewHide
{
    CGPoint cente = self.trendView.center;
    cente.y += 500;
    [self.phoneTextF resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        [self.trendView setCenter:cente];
        [self.bgblurImage setHidden:YES];
    } completion:^(BOOL finished) {
        [self.trendView setHidden:YES];
        CGPoint cente = CGPointMake(self.view.center.x, -90);
        [self.trendView setCenter:cente];
        
    }];
}


- (void)setbuttonimage
{
    [self.signInButton setBackgroundImage:[UIImage resizedImage:@"login_btn.png"] forState:UIControlStateNormal];
    [self.signInButton setBackgroundImage:[UIImage resizedImage:@"login_btn_pre"] forState:UIControlStateHighlighted];
    [self.LogInButtoon setBackgroundImage:[UIImage resizedImage:@"login_btn.png"] forState:UIControlStateNormal];
    [self.LogInButtoon setBackgroundImage:[UIImage resizedImage:@"login_btn_pre"] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  注册
 *
 *  @param sender
 */
- (IBAction)signInClick:(UIButton *)sender {
    [self trendViewShow];

}


/**
 *  登陆
 *
 *  @param sender
 */
- (IBAction)logInClick:(UIButton *)sender {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]) {
        [self verificationViewshow];
    }else{
    
        [self trendViewShow];
    }
    
}

-(void)startTime{
    if (timeout< 3)  {
        return;
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.verificationView.nextButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                    self.verificationView.nextButton.userInteractionEnabled = YES;
                    [self.verificationView.nextButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                });
            }else{
                //            int minutes = timeout / 60;
                //            int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    NSLog(@"____%@",strTime);
                    [self.verificationView.nextButton setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                    self.verificationView.nextButton.userInteractionEnabled = NO;
                    [self.verificationView.nextButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
//    timeout=60; //倒计时时间
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    [self aaa:textField];
    if (range.location==0&&string.length) {
        [self.trendView.nextButton setEnabled:YES];
    }
    if (range.location==0&&string.length==0) {
        [self.trendView.nextButton setEnabled:NO];
    }
    if (range.location==11) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.trendView.nextButton setEnabled:NO];
    return YES;
}



@end
