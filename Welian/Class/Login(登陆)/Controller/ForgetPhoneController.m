//
//  ForgetPhoneController.m
//  weLian
//
//  Created by dong on 14/10/30.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "ForgetPhoneController.h"
#import "NSString+val.h"
#import "ForgetCoderController.h"
#import "UITextField+LeftRightView.h"
#import "UIImage+ImageEffects.h"

@interface ForgetPhoneController ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *phoneTextField;
@end

@implementation ForgetPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUIView];
    [self.phoneTextField becomeFirstResponder];
}

- (void)loadUIView
{
    [self setTitle:@"验证手机1/3"];
    [self.view setBackgroundColor:WLLineColor];

    self.phoneTextField = [UITextField textFieldWitFrame:Rect(25, ViewCtrlTopBarHeight + kFirstMarginTop, SuperSize.width-50, TextFieldHeight) placeholder:@"手机号码" leftViewImageName:@"login_phone" andRightViewImageName:nil];
    [self.phoneTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.phoneTextField setDelegate:self];
    [self.phoneTextField setBackgroundColor:[UIColor whiteColor]];
    [self.phoneTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:self.phoneTextField];
    
    UIButton *nextBut = [[UIButton alloc] initWithFrame:CGRectMake(25, self.phoneTextField.bottom+25, SuperSize.width-50, TextFieldHeight)];
    [nextBut setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBut setBackgroundImage:[UIImage resizedImage:@"login_my_button"] forState:UIControlStateNormal];
    [nextBut setBackgroundImage:[UIImage resizedImage:@"login_my_button_pre"] forState:UIControlStateHighlighted];
    [nextBut.titleLabel setFont:WLFONTBLOD(18)];
    [nextBut addTarget:self action:@selector(forgetPhoneNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBut];
    
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, nextBut.bottom+15, SuperSize.width-40, 40)];
    [textLabel setNumberOfLines:0];
    [textLabel setText:@"该手机号码作为您在微链的登录账号，微链不会在任何地方泄露您的手机号码。"];
    [textLabel setTextColor:[UIColor lightGrayColor]];
    [textLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.view addSubview:textLabel];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location>=11) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self forgetPhoneNext:nil];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)forgetPhoneNext:(id)sender {
    [self.phoneTextField resignFirstResponder];
    
    if (![NSString phoneValidate:self.phoneTextField.text]) {
        [WLHUDView showErrorHUD:@"手机号码输入错误！"];
        return;
    }
    
//    NSMutableDictionary *reqstDic = [NSMutableDictionary dictionary];
//    [reqstDic setObject:@"forgetPassword" forKey:@"type"];
//    [reqstDic setObject:self.phoneTextField.text forKey:@"mobile"];
//    [reqstDic setObject:KPlatformType forKey:@"platform"];
//    
//    if ([UserDefaults objectForKey:kBPushRequestChannelIdKey]) {
//        [reqstDic setObject:[UserDefaults objectForKey:kBPushRequestChannelIdKey] forKey:@"clientid"];
//    }
    [WLHUDView showHUDWithStr:@"加载中..." dim:YES];
    [WeLianClient getCodeWithMobile:self.phoneTextField.text Type:@"forgetpassword" Success:^(id resultInfo) {
        DLog(@"%@",resultInfo);
        [WLHUDView hiddenHud];
        if ([resultInfo objectForKey:@"code"]) {
            ForgetCoderController  *forgetCoderVC = [[ForgetCoderController alloc] init];
            [forgetCoderVC setPhoneString:self.phoneTextField.text];
            [forgetCoderVC setCoderString:[resultInfo objectForKey:@"code"]];
            [self.navigationController pushViewController:forgetCoderVC animated:YES];
        }
    } Failed:^(NSError *error) {
        [WLHUDView showErrorHUD:error.localizedDescription];
    }];
//    [WLHttpTool getCheckCodeParameterDic:reqstDic success:^(id JSON) {
//        if ([[JSON objectForKey:@"flag"] integerValue] == 1) {
//
//            ForgetCoderController  *forgetCoderVC = [[ForgetCoderController alloc] init];
//            [forgetCoderVC setPhoneString:self.phoneTextField.text];
//            [forgetCoderVC setCoderString:[JSON objectForKey:@"checkcode"]];
//            [self.navigationController pushViewController:forgetCoderVC animated:YES];
//
//        }else if ([[JSON objectForKey:@"flag"] integerValue]==0){
//            [WLHUDView showErrorHUD:@"该号码未注册，请先注册！"];
//        }
//    } fail:^(NSError *error) {
//        
//    }];
}
@end
