//
//  LoginViewController.m
//  weLian
//
//  Created by dong on 14/10/28.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "LoginViewController.h"
#import "UIImage+ImageEffects.h"
#import "LoginPhoneVC.h"
#import "SignInPhoneController.h"
#import "LoginPhoneVC.h"

@interface LoginViewController ()

@property (strong, nonatomic)  UIButton *signInButton;

@property (strong, nonatomic)  UIButton *logInButtoon;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"login_bg@2x" ofType:@"png"];
    if (iPhone5) {
        path = [[NSBundle mainBundle] pathForResource:@"login_bg_big568h@2x" ofType:@"png"];
    }
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:self.view.bounds];
    [self.view addSubview:imageView];
    
    CGFloat butX = self.view.bounds.size.width*0.25;
    CGFloat butY = self.view.bounds.size.height-135;
    CGFloat butW = self.view.bounds.size.width*0.5;
    CGFloat butH = 35;
    self.signInButton = [[UIButton alloc] initWithFrame:CGRectMake(butX, butY, butW, butH)];
    [self.signInButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.signInButton setBackgroundImage:[UIImage resizedImage:@"login_register_btn.png"] forState:UIControlStateNormal];
    [self.signInButton setBackgroundImage:[UIImage resizedImage:@"login_register_btn_pre.png"] forState:UIControlStateHighlighted];
    [self.signInButton addTarget:self action:@selector(signInButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.signInButton setTitleColor:KBasesColor forState:UIControlStateNormal];
    [self.view addSubview:self.signInButton];
    
    self.logInButtoon = [[UIButton alloc] initWithFrame:CGRectMake(butX, butY+30+35, butW, butH)];
    [self.logInButtoon setTitle:@"登陆" forState:UIControlStateNormal];
    [self.logInButtoon setBackgroundImage:[UIImage resizedImage:@"login_btn.png"] forState:UIControlStateNormal];
    [self.logInButtoon setBackgroundImage:[UIImage resizedImage:@"login_btn_pre"] forState:UIControlStateHighlighted];
    [self.logInButtoon addTarget:self action:@selector(logInButtoonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.logInButtoon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.logInButtoon];
    
}

- (void)signInButtonClick:(UIButton*)but
{
    SignInPhoneController *signinVC = [[SignInPhoneController alloc] init];
    [self.navigationController pushViewController:signinVC animated:YES];
}

- (void)logInButtoonClick:(UIButton*)but
{
    LoginPhoneVC *loginphone = [[LoginPhoneVC alloc] init];
    [self.navigationController pushViewController:loginphone animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
