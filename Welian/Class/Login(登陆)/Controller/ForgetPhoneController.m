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

@interface ForgetPhoneController ()<UITextFieldDelegate>
@property (strong, nonatomic) WLTextField *phoneTextField;
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(forgetPhoneNext:)];
    
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
    
    NSMutableDictionary *reqstDic = [NSMutableDictionary dictionary];
    [reqstDic setObject:@"forgetPassword" forKey:@"type"];
    [reqstDic setObject:self.phoneTextField.text forKey:@"mobile"];
    [reqstDic setObject:@"ios" forKey:@"platform"];
    
    if ([UserDefaults objectForKey:BPushRequestChannelIdKey]) {
        [reqstDic setObject:[UserDefaults objectForKey:BPushRequestChannelIdKey] forKey:@"clientid"];
    }
    
    [WLHttpTool getCheckCodeParameterDic:reqstDic success:^(id JSON) {
        if ([[JSON objectForKey:@"flag"] integerValue] == 1) {

            ForgetCoderController  *forgetCoderVC = [[ForgetCoderController alloc] init];
            [forgetCoderVC setPhoneString:self.phoneTextField.text];
            [forgetCoderVC setCoderString:[JSON objectForKey:@"checkcode"]];
            [self.navigationController pushViewController:forgetCoderVC animated:YES];
            
        }else if ([[JSON objectForKey:@"flag"] integerValue]==0){
            [WLHUDView showErrorHUD:@"该号码未注册，请先注册！"];
        }
    } fail:^(NSError *error) {
        
    }];

}
@end
