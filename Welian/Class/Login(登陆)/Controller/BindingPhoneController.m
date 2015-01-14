//
//  BindingPhoneController.m
//  Welian
//
//  Created by dong on 15/1/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BindingPhoneController.h"
#import "UIImage+ImageEffects.h"
#import "MJExtension.h"
#import "MainViewController.h"
#import "BSearchFriendsController.h"
#import "NSString+val.h"

@interface BindingPhoneController () <UITextFieldDelegate>
{
    UITextField *_phoneTF;
    UITextField *_pwdTF;
}
@end

@implementation BindingPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:WLRGB(231, 234, 238)];
    [self setTitle:@"绑定"];
    UITextField *phoneTF = [self addPerfectInfoTextfWithFrameY:30+64 Placeholder:@"手机号" leftImageName:@"login_phone"];
    [phoneTF setText:self.phoneStr];
    [phoneTF setReturnKeyType:UIReturnKeyNext];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTF = phoneTF;
    [self.view addSubview:phoneTF];
    
    UITextField *pwdTF = [self addPerfectInfoTextfWithFrameY:CGRectGetMaxY(phoneTF.frame)+15 Placeholder:@"密码" leftImageName:@"login_password"];
    [pwdTF setReturnKeyType:UIReturnKeyDone];
    _pwdTF = pwdTF;
    [pwdTF setSecureTextEntry:YES];
    [self.view addSubview:pwdTF];
    
    UIButton *bindingBut = [[UIButton alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(pwdTF.frame)+30, SuperSize.width-50, 44)];
    [bindingBut setBackgroundImage:[UIImage resizedImage:@"login_my_button"] forState:UIControlStateNormal];
    [bindingBut setBackgroundImage:[UIImage resizedImage:@"login_my_button_pre"] forState:UIControlStateHighlighted];
    [bindingBut addTarget:self action:@selector(bindingButClick) forControlEvents:UIControlEventTouchUpInside];
    [bindingBut.titleLabel setFont:WLFONTBLOD(18)];
    [bindingBut setTitle:@"绑定" forState:UIControlStateNormal];
    [self.view addSubview:bindingBut];
    
}

- (void)bindingButClick
{
    [[self.view findFirstResponder] resignFirstResponder];
    
    if (!_phoneTF.text.length) {
        [WLHUDView showErrorHUD:@"请填写手机号码"];
        return;
    }
    if (_phoneTF.text.length != 11) {
        [WLHUDView showErrorHUD:@"手机号码有误！"];
        return;
    }
    if (![NSString passwordValidate:_pwdTF.text]) {
        [WLHUDView showErrorHUD:@"密码有误！"];
        return;
    }
    if (![self.userInfoDic objectForKey:@"openid"]) {
        return;
    }
    if (![self.userInfoDic objectForKey:@"unionid"]) {
        return;
    }
    NSMutableDictionary *requstDic = [NSMutableDictionary dictionary];
    [requstDic setObject:[self.userInfoDic objectForKey:@"unionid"] forKey:@"unionid"];
    [requstDic setObject:[self.userInfoDic objectForKey:@"openid"] forKey:@"openid"];
    [requstDic setObject:_phoneTF.text forKey:@"mobile"];
    [requstDic setObject:_pwdTF.text forKey:@"password"];
    [requstDic setObject:KPlatformType forKey:@"platform"];
    if ([UserDefaults objectForKey:BPushRequestChannelIdKey]) {
        [requstDic setObject:[UserDefaults objectForKey:BPushRequestChannelIdKey] forKey:@"clientid"];
    }
    
    [WLHttpTool loginParameterDic:requstDic success:^(id JSON) {
        NSDictionary *dataDic = JSON;
        if (dataDic) {
            UserInfoModel *mode = [UserInfoModel objectWithKeyValues:dataDic];
            
            //记录最后一次登陆的手机号
            SaveLoginMobile(_phoneTF.text);
            SaveLoginPassWD(_pwdTF.text);
            
            [LogInUser createLogInUserModel:mode];
            [LogInUser setUseropenid:[self.userInfoDic objectForKey:@"openid"]];
            [LogInUser setUserunionid:[self.userInfoDic objectForKey:@"unionid"]];
            
            BSearchFriendsController *BSearchFVC = [[BSearchFriendsController alloc] init];
            [BSearchFVC setIsStart:YES];
            [self presentViewController:BSearchFVC animated:YES completion:^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            }];
        }
    } fail:^(NSError *error) {
        [WLHUDView showErrorHUD:error.domain];
        if (error.code==1) {
            
        }else if (error.code==-1){
        
        }else if (error.code==-2){
            
        }
    } isHUD:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneTF resignFirstResponder];
    [_pwdTF resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _phoneTF) {
        if (range.location>=11) return NO;
    }else if (textField == _pwdTF){
        if (range.location>=18) return NO;
    }
    return YES;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _phoneTF) {
        [_pwdTF becomeFirstResponder];
    }else if (textField == _pwdTF){
        [_pwdTF resignFirstResponder];
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITextField *)addPerfectInfoTextfWithFrameY:(CGFloat)Y Placeholder:(NSString *)placeholder leftImageName:(NSString *)imagename
{
    UITextField *textf = [[UITextField alloc] initWithFrame:CGRectMake(25, Y, SuperSize.width-50, 40)];
    [textf setPlaceholder:placeholder];
    [textf setDelegate:self];
    [textf setLeftViewMode:UITextFieldViewModeAlways];
    [textf setRightViewMode:UITextFieldViewModeAlways];
    [textf setBackgroundColor:[UIColor whiteColor]];
    [textf setClearButtonMode:UITextFieldViewModeWhileEditing];
    UIButton *nameleftV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 16)];
    [nameleftV setUserInteractionEnabled:NO];
    [nameleftV setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [textf setLeftView:nameleftV];
    [textf.layer setCornerRadius:4];
    [textf.layer setMasksToBounds:YES];
    return textf;
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
