//
//  SignInPWDController.m
//  weLian
//
//  Created by dong on 14/10/29.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "SignInPWDController.h"
#import "UserInfoController.h"
#import "NSString+val.h"
#import "UIImage+ImageEffects.h"
#import "UITextField+LeftRightView.h"

#define KTimes 60;

@interface SignInPWDController ()<UITextFieldDelegate>
{
    __block int timeout;
    dispatch_source_t _timer;
}

@property (strong, nonatomic) UITextField *coderTextField;

@property (strong, nonatomic) UITextField *pwdTextField;

@property (strong, nonatomic) UIButton *timeButton;

@end

@implementation SignInPWDController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUIView];
    [self.coderTextField becomeFirstResponder];
    timeout = KTimes;
    [self startTime];
}

- (void)loadUIView
{
    [self setTitle:@"验证手机号2/3"];
    [self.view setBackgroundColor:WLLineColor];
    
    self.coderTextField = [UITextField textFieldWitFrame:Rect(25, ViewCtrlTopBarHeight + kFirstMarginTop, SuperSize.width-50, TextFieldHeight) placeholder:@"验证码" leftViewImageName:@"login_code" andRightViewImageName:nil];
    [self.coderTextField setDelegate:self];
    [self.coderTextField setBackgroundColor:[UIColor whiteColor]];
    [self.coderTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:self.coderTextField];
    
    CGFloat butW = 100;
    self.timeButton = [[UIButton alloc] initWithFrame:CGRectMake(SuperSize.width-25-butW, ViewCtrlTopBarHeight + kFirstMarginTop, butW, TextFieldHeight)];
    [self.timeButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [self.timeButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.timeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.timeButton setBackgroundImage:[UIImage resizedImage:@"button_blue"] forState:UIControlStateNormal];
    [self.timeButton setBackgroundImage:[UIImage resizedImage:@"button_blue_pre"] forState:UIControlStateHighlighted];
    [self.timeButton setBackgroundImage:[UIImage resizedImage:@"button_white"] forState:UIControlStateDisabled];
    [self.timeButton addTarget:self action:@selector(againCoder:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.timeButton];
    
    
    self.pwdTextField = [UITextField textFieldWitFrame:Rect(25, self.coderTextField.bottom+10, SuperSize.width-50, TextFieldHeight) placeholder:@"密码" leftViewImageName:@"login_password" andRightViewImageName:nil];
    [self.pwdTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.pwdTextField setBackgroundColor:[UIColor whiteColor]];
    [self.pwdTextField setDelegate:self];
    [self.pwdTextField setSecureTextEntry:YES];
    [self.view addSubview:self.pwdTextField];
    
    UIButton *nextBut = [[UIButton alloc] initWithFrame:CGRectMake(25, self.pwdTextField.bottom+25, SuperSize.width-50, TextFieldHeight)];
    [nextBut setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBut setBackgroundImage:[UIImage resizedImage:@"login_my_button"] forState:UIControlStateNormal];
    [nextBut setBackgroundImage:[UIImage resizedImage:@"login_my_button_pre"] forState:UIControlStateHighlighted];
    [nextBut.titleLabel setFont:WLFONTBLOD(18)];
    [nextBut addTarget:self action:@selector(nextPush:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBut];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==self.coderTextField) {
        if (range.location >= 4) return NO;
    }else if (textField == self.pwdTextField){
        if (range.location >= 18) return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)againCoder:(UIButton *)sender {
    timeout = KTimes;
    [self.coderTextField setText:nil];
    [self startTime];
    [self chongxingfasong];
}


- (void)nextPush:(UIButton *)sender {
    
    if (![self.coderTextField.text isEqualToString:self.coderString]) {
        [WLHUDView showErrorHUD:@"验证码输入有误！"];
        return;
    }
    
    if (![NSString passwordValidate:self.pwdTextField.text]) {
        [WLHUDView showErrorHUD:@"密码为6-18位！"];
        return;
    }
    [WLHUDView showHUDWithStr:@"加载中..." dim:YES];
    [WeLianClient checkCodeWithMobile:self.phoneString Code:self.coderString Success:^(id resultInfo) {
        DLog(@"%@",resultInfo);
        if ([[resultInfo objectForKey:@"flag"] integerValue]==0) {
            [WLHUDView hiddenHud];
            UserInfoController *userinVC = [[UserInfoController alloc] init];
            [userinVC setPhoneString:self.phoneString];
            [userinVC setPwdString:self.pwdTextField.text];
            [self.navigationController pushViewController:userinVC animated:YES];
        }else if ([[resultInfo objectForKey:@"flag"] integerValue]==1){
            [WLHUDView showErrorHUD:@"验证失败！"];
        }
    } Failed:^(NSError *error) {
        [WLHUDView showErrorHUD:error.localizedDescription];
    }];
//    [WLHttpTool checkCodeParameterDic:@{@"code":self.coderTextField.text} success:^(id JSON) {
//        if ([[JSON objectForKey:@"flag"] integerValue]==0) {
//            
//            UserInfoController *userinVC = [[UserInfoController alloc] init];
//            [userinVC setPhoneString:self.phoneString];
//            [userinVC setPwdString:self.pwdTextField.text];
//            [self.navigationController pushViewController:userinVC animated:YES];
//        
//        }else if ([[JSON objectForKey:@"flag"] integerValue]==1){
//            [WLHUDView showErrorHUD:@"验证失败！"];
//        }
//    } fail:^(NSError *error) {
//        
//    }];
}

//*  重新发送验证码*//
// 注册重新发送验证码
- (void)chongxingfasong
{
//    NSMutableDictionary *reqstDicM = [NSMutableDictionary dictionary];
//    [reqstDicM setObject:@"register" forKey:@"type"];
//    [reqstDicM setObject:self.phoneString forKey:@"mobile"];
//    [reqstDicM setObject:KPlatformType forKey:@"platform"];
//    
//    if ([UserDefaults objectForKey:kBPushRequestChannelIdKey]) {
//        [reqstDicM setObject:[UserDefaults objectForKey:kBPushRequestChannelIdKey] forKey:@"clientid"];
//    }
    [WLHUDView showHUDWithStr:@"加载中..." dim:YES];
    [WeLianClient getCodeWithMobile:self.phoneString Type:@"register" Success:^(id resultInfo) {
        DLog(@"%@",resultInfo);
        [WLHUDView hiddenHud];
        if ([resultInfo objectForKey:@"code"]) {
            NSString *coderStr = [resultInfo objectForKey:@"code"];
            self.coderString = coderStr;
        }
    } Failed:^(NSError *error) {
        [WLHUDView showErrorHUD:error.localizedDescription];
    }];
    
//    [WLHttpTool getCheckCodeParameterDic:reqstDicM success:^(id JSON) {
//        if ([[JSON objectForKey:@"flag"] integerValue] == 0) {
//            NSString *coderStr = [JSON objectForKey:@"checkcode"];
//            self.coderString = coderStr;
//        }else if ([[JSON objectForKey:@"flag"] integerValue]==1){
//            [WLHUDView showErrorHUD:@"该号码已经注册，请直接登录！"];
//        }
//    } fail:^(NSError *error) {
//        
//    }];
}

-(void)startTime{
    
    if (timeout< 60)  {
        return;
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        
        dispatch_source_set_event_handler(_timer, ^{
//            if (self.codeTextF.oneLabel.text.length) {
//                timeout = 0;
//            }
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.timeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                    [self.timeButton setEnabled:YES];
                    
                });
            }else{
                NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.timeButton setTitle:[NSString stringWithFormat:@"重新发送(%@s)",strTime] forState:UIControlStateDisabled];
                    
                    [self.timeButton setEnabled:NO];
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
}


@end
