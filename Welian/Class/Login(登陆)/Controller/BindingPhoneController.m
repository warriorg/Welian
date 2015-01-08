//
//  BindingPhoneController.m
//  Welian
//
//  Created by dong on 15/1/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BindingPhoneController.h"
#import "UIImage+ImageEffects.h"

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
    _phoneTF = phoneTF;
    [self.view addSubview:phoneTF];
    
    UITextField *pwdTF = [self addPerfectInfoTextfWithFrameY:CGRectGetMaxY(phoneTF.frame)+15 Placeholder:@"密码" leftImageName:@"login_password"];
    [pwdTF setReturnKeyType:UIReturnKeyDone];
    _pwdTF = pwdTF;
    [self.view addSubview:pwdTF];
    
    UIButton *bindingBut = [[UIButton alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(pwdTF.frame)+30, SuperSize.width-50, 44)];
    [bindingBut setBackgroundImage:[UIImage resizedImage:@"login_my_button"] forState:UIControlStateNormal];
    [bindingBut setBackgroundImage:[UIImage resizedImage:@"login_my_button_pre"] forState:UIControlStateHighlighted];
    [bindingBut.titleLabel setFont:WLFONTBLOD(18)];
    [bindingBut setTitle:@"绑定" forState:UIControlStateNormal];
    [self.view addSubview:bindingBut];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneTF resignFirstResponder];
    [_pwdTF resignFirstResponder];
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
