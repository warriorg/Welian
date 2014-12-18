//
//  LoginPhoneVC.m
//  weLian
//
//  Created by dong on 14/10/29.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "LoginPhoneVC.h"
#import "NSString+val.h"
#import "MainViewController.h"
#import "MJExtension.h"
#import "WLTextField.h"
#import "ForgetPhoneController.h"

@interface LoginPhoneVC ()<UITextFieldDelegate>

@property (strong, nonatomic)  WLTextField *phoneTextField;

@property (strong, nonatomic)  WLTextField *pwdTextField;

@end

@implementation LoginPhoneVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneTextField) {
        if (range.location>=11) return NO;
    }else if (textField == self.pwdTextField){
        if (range.location>=18) return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.phoneTextField) {
        [self.pwdTextField becomeFirstResponder];
    }else if (textField == self.pwdTextField){
        [self loginPhonePWD:nil];
    }
    
    return YES;
}

- (void)setPhoneString:(NSString *)phoneString
{
    _phoneString = phoneString;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUIView];
    if ([NSString phoneValidate:self.phoneString]) {
        [self.phoneTextField setText:self.phoneString];
        [self.pwdTextField becomeFirstResponder];
    }else{
    
        [self.phoneTextField becomeFirstResponder];
    }
}

- (void)loadUIView
{
    [self setTitle:@"登录"];
    [self.view setBackgroundColor:WLLineColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(loginPhonePWD:)];
    
    CGSize size = self.view.bounds.size;
    
    self.phoneTextField = [[WLTextField alloc] initWithFrame:CGRectMake(0, 20+64, size.width, 44)];
    [self.phoneTextField setPlaceholder:@"手机号码"];
    [self.phoneTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.phoneTextField setDelegate:self];
    [self.phoneTextField setBackgroundColor:[UIColor whiteColor]];
    [self.phoneTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.phoneTextField setReturnKeyType:UIReturnKeyNext];
    [self.view addSubview:self.phoneTextField];
    
    self.pwdTextField = [[WLTextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.phoneTextField.frame)+1, size.width, 44)];
    [self.pwdTextField setPlaceholder:@"密码"];
    [self.pwdTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.pwdTextField setBackgroundColor:[UIColor whiteColor]];
    [self.pwdTextField setSecureTextEntry:YES];
    [self.pwdTextField setDelegate:self];
    [self.pwdTextField setKeyboardType:UIKeyboardTypeDefault];
    [self.pwdTextField setReturnKeyType:UIReturnKeyGo];
    [self.view addSubview:self.pwdTextField];
    
    CGFloat butW = 75;
    UIButton *forgetBut = [[UIButton alloc] initWithFrame:CGRectMake(size.width-butW-20, CGRectGetMaxY(self.pwdTextField.frame)+15, butW, 30)];
    [forgetBut.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [forgetBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [forgetBut setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBut addTarget:self action:@selector(forgetPwd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBut];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)forgetPwd:(UIButton *)sender {
    ForgetPhoneController *forgetVC = [[ForgetPhoneController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (void)loginPhonePWD:(UIBarButtonItem *)sender {
    [self.phoneTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    
    if (![NSString phoneValidate:self.phoneTextField.text]) {
        [WLHUDView showErrorHUD:@"手机号码有误！"];
        return;
    }
    if (![NSString passwordValidate:self.pwdTextField.text]) {
        [WLHUDView showErrorHUD:@"密码有误！"];
        return;
    }
    NSMutableDictionary *reqstDic = [NSMutableDictionary dictionary];
    [reqstDic setObject:self.phoneTextField.text forKey:@"mobile"];
    [reqstDic setObject:self.pwdTextField.text forKey:@"password"];
    [reqstDic setObject:@"ios" forKey:@"platform"];
    if ([UserDefaults objectForKey:BPushRequestChannelIdKey]) {
        
        [reqstDic setObject:[UserDefaults objectForKey:BPushRequestChannelIdKey] forKey:@"clientid"];
    }
    
    [WLHttpTool loginParameterDic:reqstDic success:^(id JSON) {
        NSDictionary *dataDic = JSON;
        if (dataDic) {
            UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
            [mode setKeyValues:dataDic];
            [mode setCheckcode:self.pwdTextField.text];
            
            [[UserInfoTool sharedUserInfoTool] saveUserInfo:mode];
            MainViewController *mainVC = [[MainViewController alloc] init];
            [[UIApplication sharedApplication].keyWindow setRootViewController:mainVC];
            
            if (![UserDefaults objectForKey:BPushRequestChannelIdKey]) {
                

            }else{
                
            }
        }

    } fail:^(NSError *error) {
        
    } isHUD:YES];
}

@end
