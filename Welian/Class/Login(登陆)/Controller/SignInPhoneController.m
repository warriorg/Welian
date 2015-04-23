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
#import "UITextField+LeftRightView.h"
#import "UIImage+ImageEffects.h"

@interface SignInPhoneController () <UITextFieldDelegate>
@property (strong, nonatomic) UITextField *phoneTextField;
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
}

- (void)loadUIView
{
    [self setTitle:@"注册"];
    [self.view setBackgroundColor:WLLineColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(cancellVC)];
    
    self.phoneTextField = [UITextField textFieldWitFrame:Rect(25, ViewCtrlTopBarHeight + kFirstMarginTop, SuperSize.width-50, TextFieldHeight) placeholder:@"手机号码" leftViewImageName:@"login_phone" andRightViewImageName:nil];
    [self.phoneTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_phoneTextField setDelegate:self];
    _phoneTextField.returnKeyType = UIReturnKeyDone;
    [_phoneTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:_phoneTextField];
    
    UIButton *nextBut = [[UIButton alloc] initWithFrame:CGRectMake(25, self.phoneTextField.bottom+25, SuperSize.width-50, TextFieldHeight)];
    [nextBut setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBut setBackgroundImage:[UIImage resizedImage:@"login_my_button"] forState:UIControlStateNormal];
    [nextBut setBackgroundImage:[UIImage resizedImage:@"login_my_button_pre"] forState:UIControlStateHighlighted];
    [nextBut.titleLabel setFont:WLFONTBLOD(18)];
    [nextBut addTarget:self action:@selector(coderPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBut];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, nextBut.bottom+15, self.view.width-40, 40)];
    [textLabel setNumberOfLines:0];
    [textLabel setText:@"该手机号码作为您在微链的登录账号，微链不会在任何地方泄露您的手机号码。"];
    [textLabel setTextColor:[UIColor lightGrayColor]];
    [textLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.view addSubview:textLabel];
    
}


- (void)cancellVC
{
    [self.view.findFirstResponder resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
- (void)coderPhoneClick:(UIButton *)sender {
    [self.phoneTextField resignFirstResponder];
    
    if ([self.phoneTextField.text isMobileNumber]) {
        NSMutableDictionary *reqstDicM = [NSMutableDictionary dictionary];
        [reqstDicM setObject:@"register" forKey:@"type"];
        [reqstDicM setObject:self.phoneTextField.text forKey:@"mobile"];
        [reqstDicM setObject:KPlatformType forKey:@"platform"];
        
        if ([UserDefaults objectForKey:kBPushRequestChannelIdKey]) {
            [reqstDicM setObject:[UserDefaults objectForKey:kBPushRequestChannelIdKey] forKey:@"clientid"];
        }
        
        [WLHttpTool getCheckCodeParameterDic:reqstDicM success:^(id JSON) {
            if ([[JSON objectForKey:@"flag"] integerValue]==0) {
            // 未注册
              NSString *coderStr = [JSON objectForKey:@"checkcode"];
                SignInPWDController  *signInPWDVC = [[SignInPWDController alloc] init];
                [signInPWDVC setPhoneString:self.phoneTextField.text];
                [signInPWDVC setCoderString:coderStr];
                [UserDefaults setObject:[JSON objectForKey:@"sessionid"] forKey:kSidkey];
                [self.navigationController pushViewController:signInPWDVC animated:YES];
                
            }else if ([[JSON objectForKey:@"flag"] integerValue]==1){
                // 该号码已注册
                [WLHUDView showErrorHUD:@"该号码已存在，请登录！"];
            }
        } fail:^(NSError *error) {
            
        }];
    }else{
        [WLHUDView showErrorHUD:@"手机号码有误！"];
    }
}
@end
