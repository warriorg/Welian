//
//  ForgetPWDController.m
//  weLian
//
//  Created by dong on 14/10/30.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "ForgetPWDController.h"
#import "NSString+val.h"
#import "LoginPhoneVC.h"
#import "UITextField+LeftRightView.h"
#import "UIImage+ImageEffects.h"

@interface ForgetPWDController () <UITextFieldDelegate>
@property (strong, nonatomic) UITextField *pwdTextField;
@end

@implementation ForgetPWDController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUIView];
    [self.pwdTextField becomeFirstResponder];
}

- (void)loadUIView
{
    [self setTitle:@"验证手机3/3"];
    [self.view setBackgroundColor:WLLineColor];
    
    self.pwdTextField = [UITextField textFieldWitFrame:Rect(25, ViewCtrlTopBarHeight + kFirstMarginTop, SuperSize.width-50, TextFieldHeight) placeholder:@"请输入新的密码" leftViewImageName:@"login_password" andRightViewImageName:nil];
    [self.pwdTextField setDelegate:self];
    [self.pwdTextField setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.pwdTextField];
    
    UIButton *nextBut = [[UIButton alloc] initWithFrame:CGRectMake(25, self.pwdTextField.bottom+25, SuperSize.width-50, TextFieldHeight)];
    [nextBut setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBut setBackgroundImage:[UIImage resizedImage:@"login_my_button"] forState:UIControlStateNormal];
    [nextBut setBackgroundImage:[UIImage resizedImage:@"login_my_button_pre"] forState:UIControlStateHighlighted];
    [nextBut.titleLabel setFont:WLFONTBLOD(18)];
    [nextBut addTarget:self action:@selector(savePWDClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBut];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location>=18) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self savePWDClick:nil];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)savePWDClick:(id)sender {
    [self.pwdTextField resignFirstResponder];
    
    if (![NSString passwordValidate:self.pwdTextField.text]) {
        [WLHUDView showErrorHUD:@"密码为6-18位字符，区分大小写"];
        return;
    }
    
    [WLHttpTool forgetPasswordParameterDic:@{@"newpassword":self.pwdTextField.text} success:^(id JSON) {
        if ([[JSON objectForKey:@"flag"] integerValue]==0) {
            [WLHUDView showSuccessHUD:@"密码修改成功！"];
            LoginPhoneVC *loginPhoneVC = self.navigationController.viewControllers[0];
            [loginPhoneVC setPhoneString:self.phoneString];
            
            [self.navigationController popToViewController:loginPhoneVC animated:YES];

        }else{
            [WLHUDView showErrorHUD:@"密码修改失败！请重试"];
        }
    } fail:^(NSError *error) {
        
    }];
}
@end
