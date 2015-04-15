//
//  PhoneChangeVC.m
//  Welian
//
//  Created by dong on 15/3/26.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "PhoneChangeVC.h"
#import "UIImage+ImageEffects.h"
#import "NSString+val.h"

@interface PhoneChangeVC () <UITextFieldDelegate>
{
    __block int timeout;
    dispatch_source_t _timer;
    
    NSInteger _type;
}
@property (strong,nonatomic) NSString *checkCode;
@end

#define KTimes 60;

@implementation PhoneChangeVC

- (void)dealloc
{
    _checkCode = nil;
}

- (instancetype)initWithPhoneType:(NSInteger)type
{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机校验";
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.scrollView addGestureRecognizer:singleTap];
    [self.authBut setBackgroundImage:[UIImage resizedImage:@"bluebuttton_pressed"] forState:UIControlStateNormal];
    [self.authBut setBackgroundImage:[UIImage resizedImage:@"bluebutton"] forState:UIControlStateHighlighted];
    [self.sureBut setBackgroundImage:[UIImage resizedImage:@"discovery_activity_detail_button_blue_bg"] forState:UIControlStateNormal];
    [self.sureBut setBackgroundImage:[UIImage resizedImage:@"discovery_activity_detail_button_blue_bg_pre"] forState:UIControlStateHighlighted];
    [self.phoneTF setIsToBounds:YES];
    [self.phoneTF setDelegate:self];
    [self.authCodeTF setIsToBounds:YES];
    [self.authCodeTF setDelegate:self];
    
    if (_type==1) {
        [self.phoneTF setText:[LogInUser getCurrentLoginUser].mobile];
        [self.titleLabel setText:@"验证手机就可以成为认证用户了哦"];
        [self.sureBut setTitle:@"立即认证" forState:UIControlStateNormal];
    }else if (_type==2){
        [self.phoneTF setText:[LogInUser getCurrentLoginUser].mobile];
        [self.titleLabel setText:@"修改手机号码"];
        [self.sureBut setTitle:@"确认修改" forState:UIControlStateNormal];
    }
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textf
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneTF) {
        if (range.location >= 11)
            return NO; // return NO to not change text
        return YES;
    }else if (textField == self.authCodeTF){
        if (range.location >= 6)
            return NO; // return NO to not change text
        return YES;
    }
    return YES;
}


#pragma mark - 确认
- (IBAction)sureButClick:(id)sender {
    if (self.phoneTF.text.length == 0) {
        [WLHUDView showErrorHUD:@"请输入手机号！"];
        return;
    }
    if (self.phoneTF.text.length > 0 && ![self.phoneTF.text isMobileNumber]) {
        [WLHUDView showErrorHUD:@"请填写正确的手机号！"];
        return;
    }
//    if (![NSString phoneValidate:self.phoneTF.text]) {
//        [WLHUDView showErrorHUD:@"请输入正确的手机号！"];
//        return;
//    }
    
    if (self.authCodeTF.text.length != 4 || ![_checkCode isEqualToString:self.authCodeTF.text]) {
        [WLHUDView showErrorHUD:@"请输入正确的验证码！"];
        return;
    }
    WEAKSELF
    [WLHttpTool checkMobileCodeParameterDic:@{@"code":self.authCodeTF.text} success:^(id JSON) {
        if ([JSON objectForKey:@"flag"]) {
            [WLHUDView showSuccessHUD:[JSON objectForKey:@"msg"]];
            if ([[JSON objectForKey:@"flag"] integerValue]==0) {
                [LogInUser setUserMobile:self.phoneTF.text];
                [LogInUser setUserChecked:@(1)];
                if (weakSelf.phoneChangeBlcok) {
                    weakSelf.phoneChangeBlcok();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                
            }
        }
    } fail:^(NSError *error) {
        
    }];
    
}


#pragma mark - 发送验证码
- (IBAction)authButClick:(id)sender {
    if (self.phoneTF.text.length == 0) {
        [WLHUDView showErrorHUD:@"请输入手机号！"];
        return;
    }
    if (self.phoneTF.text.length > 0 && ![self.phoneTF.text isMobileNumber]) {
        [WLHUDView showErrorHUD:@"请填写正确的手机号！"];
        return;
    }
//    if (!self.phoneTF.text.length) {
//        [WLHUDView showErrorHUD:@"请输入手机号"];
//        return;
//    }
//    if (![NSString phoneValidate:self.phoneTF.text]) {
//        [WLHUDView showErrorHUD:@""];
//        return;
//    }
    [self startTime];
    [self chongxingfasongforgetcode];
}


//*  重新发送验证码*//
// 注册重新发送验证码
- (void)chongxingfasongforgetcode
{
    [WLHttpTool getMobileCheckCodeParameterDic:@{@"mobile":self.phoneTF.text} success:^(id JSON) {
        if ([JSON objectForKey:@"checkcode"]) {
//            [WLHUDView showSuccessHUD:@"发送成功"];
            self.checkCode = [JSON objectForKey:@"checkcode"];
        }
    } fail:^(NSError *error) {
        
    }];
}


-(void)startTime{
    timeout = KTimes;
    if (timeout< 60)  {
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
                    [self.authBut setTitle:@"重新发送" forState:UIControlStateNormal];
                    [self.authBut setEnabled:YES];
                    
                });
            }else{
                NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.authBut setTitle:[NSString stringWithFormat:@"发送(%@s)",strTime] forState:UIControlStateDisabled];
                    
                    [self.authBut setEnabled:NO];
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
}

@end
