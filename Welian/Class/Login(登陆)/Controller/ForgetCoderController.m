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

#define KTimes 60;

@interface ForgetCoderController () <UITextFieldDelegate>
{
    __block int timeout;
    dispatch_source_t _timer;
}
@property (strong, nonatomic) WLTextField *forgetCoderTextField;
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

- (void)loadUIView
{
    [self setTitle:@"验证手机2/3"];
    [self.view setBackgroundColor:WLLineColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(coderForgetCoderNext:)];
    
    CGSize size = self.view.bounds.size;
    self.forgetCoderTextField = [[WLTextField alloc] initWithFrame:CGRectMake(0, 20+64, size.width, 44)];
    [self.forgetCoderTextField setPlaceholder:@"验证码"];
    [self.forgetCoderTextField setDelegate:self];
    [self.forgetCoderTextField setBackgroundColor:[UIColor whiteColor]];
    [self.forgetCoderTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:self.forgetCoderTextField];
    
    CGFloat butW = 88;
    self.forgetAgainCoderButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width-88-20, 91, butW, 30)];
    [self.forgetAgainCoderButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [self.forgetAgainCoderButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.forgetAgainCoderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.forgetAgainCoderButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.forgetAgainCoderButton setBackgroundImage:[UIImage resizedImage:@"bluebutton"] forState:UIControlStateNormal];
    [self.forgetAgainCoderButton setBackgroundImage:[UIImage resizedImage:@"bluebuttton_pressed"] forState:UIControlStateHighlighted];
    [self.forgetAgainCoderButton setBackgroundImage:[UIImage resizedImage:@"login_background"] forState:UIControlStateDisabled];
    [self.forgetAgainCoderButton addTarget:self action:@selector(forgetAgainCoderClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetAgainCoderButton];
    
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
    NSMutableDictionary *reqstDic = [NSMutableDictionary dictionary];
    [reqstDic setObject:@"forgetPassword" forKey:@"type"];
    [reqstDic setObject:self.phoneString forKey:@"mobile"];
    [reqstDic setObject:KPlatformType forKey:@"platform"];
    
    if ([UserDefaults objectForKey:BPushRequestChannelIdKey]) {
        [reqstDic setObject:[UserDefaults objectForKey:BPushRequestChannelIdKey] forKey:@"clientid"];
    }
    
    [WLHttpTool getCheckCodeParameterDic:reqstDic success:^(id JSON) {
        if ([[JSON objectForKey:@"flag"] integerValue] == 1) {
            
            self.coderString = [JSON objectForKey:@"checkcode"];
            
        }else if ([[JSON objectForKey:@"flag"] integerValue]==0){
            [WLHUDView showErrorHUD:@"该号码未注册，请先注册！"];
        }
    } fail:^(NSError *error) {
        
    }];
}


- (void)coderForgetCoderNext:(id)sender {
    [self.forgetCoderTextField resignFirstResponder];
    
    if (![self.forgetCoderTextField.text isEqualToString:self.coderString]) {
        
        [WLHUDView showErrorHUD:@"验证码输入有误！"];
        return;
    }
    
    [WLHttpTool checkCodeParameterDic:@{@"code":self.coderString} success:^(id JSON) {
        if ([[JSON objectForKey:@"flag"] integerValue]==0) {
            
            ForgetPWDController *forgetPWDVC = [[ForgetPWDController alloc] init];
            [forgetPWDVC setPhoneString:self.phoneString];
            [forgetPWDVC setCoderString:self.coderString];
            [self.navigationController pushViewController:forgetPWDVC animated:YES];
            
        }else{
            [WLHUDView showErrorHUD:@"验证失败，请重试！"];
        }
    } fail:^(NSError *error) {
        
    }];
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
