//
//  SignInPhoneController.m
//  weLian
//
//  Created by dong on 14/10/29.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "SignInPhoneController.h"
#import "NSString+val.h"
#import "SignInPWDController.h"
#import "WLTextField.h"

@interface SignInPhoneController () <UITextFieldDelegate>
@property (strong, nonatomic) WLTextField *phoneTextField;
@end

@implementation SignInPhoneController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 11)
        return NO; // return NO to not change text
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUIView];
    [self.phoneTextField becomeFirstResponder];
}

- (void)loadUIView
{
    [self setTitle:@"注册"];
    [self.view setBackgroundColor:WLLineColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(coderPhoneClick:)];
    
    CGSize size = self.view.bounds.size;
    self.phoneTextField = [[WLTextField alloc] initWithFrame:CGRectMake(0, 20+64, size.width, 44)];
    [self.phoneTextField setPlaceholder:@"手机号码"];
    [self.phoneTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.phoneTextField setDelegate:self];
    [self.phoneTextField setBackgroundColor:[UIColor whiteColor]];
    [self.phoneTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:self.phoneTextField];
    
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.phoneTextField.frame)+15, size.width-40, 40)];
    [textLabel setNumberOfLines:0];
    [textLabel setText:@"该手机号码作为您在微链的登陆账号，微链不会在任何地方泄露您的手机号码。"];
    [textLabel setTextColor:[UIColor lightGrayColor]];
    [textLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.view addSubview:textLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self coderPhoneClick:nil];
    return YES;
}


#pragma mark- 发送手机号，获取验证码
- (void)coderPhoneClick:(UIBarButtonItem *)sender {
    [self.phoneTextField resignFirstResponder];
    
    if ([NSString phoneValidate:self.phoneTextField.text]) {
        NSMutableDictionary *reqstDicM = [NSMutableDictionary dictionary];
        [reqstDicM setObject:@"register" forKey:@"type"];
        [reqstDicM setObject:self.phoneTextField.text forKey:@"mobile"];
        [reqstDicM setObject:@"ios" forKey:@"platform"];
        
        if ([UserDefaults objectForKey:BPushRequestChannelIdKey]) {
            [reqstDicM setObject:[UserDefaults objectForKey:BPushRequestChannelIdKey] forKey:@"clientid"];
        }
        
        [WLHttpTool getCheckCodeParameterDic:reqstDicM success:^(id JSON) {
            if ([[JSON objectForKey:@"flag"] integerValue]==0) {
            // 未注册
              NSString *coderStr = [JSON objectForKey:@"checkcode"];
                
                SignInPWDController  *signInPWDVC = [[SignInPWDController alloc] init];
                [signInPWDVC setPhoneString:self.phoneTextField.text];
                [signInPWDVC setCoderString:coderStr];
                [self.navigationController pushViewController:signInPWDVC animated:YES];
                
            }else if ([[JSON objectForKey:@"flag"] integerValue]==1){
                // 该号码已注册
                [WLHUDView showErrorHUD:@"该号码已存在，请登陆！"];
            }
        } fail:^(NSError *error) {
            
        }];
    }else{
        [WLHUDView showErrorHUD:@"手机号码有误！"];
    }
}
@end
