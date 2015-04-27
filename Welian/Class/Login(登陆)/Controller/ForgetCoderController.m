//
//  ForgetCoderController.m
//  weLian
//
//  Created by dong on 14/10/30.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "ForgetCoderController.h"
#import "ForgetPWDController.h"
#import "NSString+val.h"
#import "UIImage+ImageEffects.h"
#import "UITextField+LeftRightView.h"

#define KTimes 60;

@interface ForgetCoderController () <UITextFieldDelegate>
{
    __block int timeout;
    dispatch_source_t _timer;
}
@property (strong, nonatomic) UITextField *forgetCoderTextField;
@property (strong, nonatomic) UIButton *forgetAgainCoderButton;

@end

@implementation ForgetCoderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUIView];
    [self.forgetCoderTextField becomeFirstResponder];
    
    timeout = KTimes;
    [self startTime];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    timeout = 1;
}

- (void)loadUIView
{
    [self setTitle:@"验证手机2/3"];
    [self.view setBackgroundColor:WLLineColor];

    self.forgetCoderTextField = [UITextField textFieldWitFrame:Rect(25, ViewCtrlTopBarHeight + kFirstMarginTop, SuperSize.width-50, TextFieldHeight) placeholder:@"验证码" leftViewImageName:@"login_code" andRightViewImageName:nil];
    [self.forgetCoderTextField setDelegate:self];
    [self.forgetCoderTextField setBackgroundColor:[UIColor whiteColor]];
    [self.forgetCoderTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:self.forgetCoderTextField];
    
    CGFloat butW = 100;
    self.forgetAgainCoderButton = [[UIButton alloc] initWithFrame:CGRectMake(SuperSize.width-25-butW, ViewCtrlTopBarHeight + kFirstMarginTop, butW, TextFieldHeight)];
    [self.forgetAgainCoderButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [self.forgetAgainCoderButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.forgetAgainCoderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.forgetAgainCoderButton setBackgroundImage:[UIImage resizedImage:@"button_blue"] forState:UIControlStateNormal];
    [self.forgetAgainCoderButton setBackgroundImage:[UIImage resizedImage:@"button_blue_pre"] forState:UIControlStateHighlighted];
    [self.forgetAgainCoderButton setBackgroundImage:[UIImage resizedImage:@"button_white"] forState:UIControlStateDisabled];
    [self.forgetAgainCoderButton addTarget:self action:@selector(forgetAgainCoderClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetAgainCoderButton];
    
    UIButton *nextBut = [[UIButton alloc] initWithFrame:CGRectMake(25, self.forgetCoderTextField.bottom+25, SuperSize.width-50, TextFieldHeight)];
    [nextBut setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBut setBackgroundImage:[UIImage resizedImage:@"login_my_button"] forState:UIControlStateNormal];
    [nextBut setBackgroundImage:[UIImage resizedImage:@"login_my_button_pre"] forState:UIControlStateHighlighted];
    [nextBut.titleLabel setFont:WLFONTBLOD(18)];
    [nextBut addTarget:self action:@selector(coderForgetCoderNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBut];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location>=4) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self coderForgetCoderNext:nil];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)forgetAgainCoderClick:(id)sender {
    timeout = KTimes;
    [self startTime];
    [self chongxingfasongforgetcode];

}

//*  重新发送验证码*//
// 注册重新发送验证码
- (void)chongxingfasongforgetcode
{
//    NSMutableDictionary *reqstDic = [NSMutableDictionary dictionary];
//    [reqstDic setObject:@"forgetPassword" forKey:@"type"];
//    [reqstDic setObject:self.phoneString forKey:@"mobile"];
//    [reqstDic setObject:KPlatformType forKey:@"platform"];
//    
//    if ([UserDefaults objectForKey:kBPushRequestChannelIdKey]) {
//        [reqstDic setObject:[UserDefaults objectForKey:kBPushRequestChannelIdKey] forKey:@"clientid"];
//    }
    [WLHUDView showHUDWithStr:@"加载中..." dim:NO];
    [WeLianClient getCodeWithMobile:self.phoneString Type:@"forgetpassword" Success:^(id resultInfo) {
        DLog(@"%@",resultInfo);
        [WLHUDView hiddenHud];
        if ([resultInfo objectForKey:@"code"]) {
            self.coderString = [resultInfo objectForKey:@"code"];
        }
    } Failed:^(NSError *error) {
        [WLHUDView showErrorHUD:error.localizedDescription];
    }];
    
//    [WLHttpTool getCheckCodeParameterDic:reqstDic success:^(id JSON) {
//        if ([[JSON objectForKey:@"flag"] integerValue] == 1) {
//            
//            self.coderString = [JSON objectForKey:@"checkcode"];
//            
//        }else if ([[JSON objectForKey:@"flag"] integerValue]==0){
//            [WLHUDView showErrorHUD:@"该号码未注册，请先注册！"];
//        }
//    } fail:^(NSError *error) {
//        
//    }];
}


- (void)coderForgetCoderNext:(id)sender {
    [self.forgetCoderTextField resignFirstResponder];
    
    if (![self.forgetCoderTextField.text isEqualToString:self.coderString]) {
        
        [WLHUDView showErrorHUD:@"验证码输入有误！"];
        return;
    }
    [WeLianClient checkCodeWithMobile:self.phoneString Code:self.coderString Success:^(id resultInfo) {
        if ([[resultInfo objectForKey:@"flag"] integerValue]==0) {
            ForgetPWDController *forgetPWDVC = [[ForgetPWDController alloc] init];
            [forgetPWDVC setPhoneString:self.phoneString];
            [forgetPWDVC setCoderString:self.coderString];
            [self.navigationController pushViewController:forgetPWDVC animated:YES];
            
        }else if([[resultInfo objectForKey:@"flag"] integerValue]==1){
            [WLHUDView showErrorHUD:@"验证失败，请重试！"];
        }
    } Failed:^(NSError *error) {
        
    }];
    
//    [WLHttpTool checkCodeParameterDic:@{@"code":self.coderString} success:^(id JSON) {
//        if ([[JSON objectForKey:@"flag"] integerValue]==0) {
//            
//            ForgetPWDController *forgetPWDVC = [[ForgetPWDController alloc] init];
//            [forgetPWDVC setPhoneString:self.phoneString];
//            [forgetPWDVC setCoderString:self.coderString];
//            [self.navigationController pushViewController:forgetPWDVC animated:YES];
//            
//        }else{
//            [WLHUDView showErrorHUD:@"验证失败，请重试！"];
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

            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.forgetAgainCoderButton setTitle:@"重新发送" forState:UIControlStateNormal];
                    [self.forgetAgainCoderButton setEnabled:YES];
                    
                });
            }else{
                NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.forgetAgainCoderButton setTitle:[NSString stringWithFormat:@"重新发送(%@s)",strTime] forState:UIControlStateDisabled];
                    
                    [self.forgetAgainCoderButton setEnabled:NO];
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
}

@end
