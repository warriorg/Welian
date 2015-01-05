//
//  PerfectInfoController.m
//  Welian
//
//  Created by dong on 15/1/5.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "PerfectInfoController.h"
#import "WLTextField.h"

@interface PerfectInfoController ()

@end

@implementation PerfectInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:WLRGB(231, 234, 238)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelVC)];
    [self setTitle:@"完善信息"];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setContentSize:CGSizeMake(SuperSize.width, 520)];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    
    UIImage *iconimage = [UIImage imageNamed:@"login_user"];
    
    UIButton *iconBut = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x-iconimage.size.width*0.5, 25, iconimage.size.width, iconimage.size.height)];
    [iconBut setImage:iconimage forState:UIControlStateNormal];
    [scrollView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [scrollView addSubview:iconBut];
    
    UITextField *nameTF = [self addPerfectInfoTextfWithFrameY:CGRectGetMaxY(iconBut.frame)+25 Placeholder:@"姓名" leftImageName:@"login_name"];
    [scrollView addSubview:nameTF];
    
    
    UITextField *postTF = [self addPerfectInfoTextfWithFrameY:CGRectGetMaxY(nameTF.frame)+15 Placeholder:@"职位" leftImageName:@"login_zhiwei"];
    UIButton *postRightV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 16)];
    [postRightV setUserInteractionEnabled:NO];
    [postRightV setImage:[UIImage imageNamed:@"me_right"] forState:UIControlStateNormal];
    [postTF setRightView:postRightV];
    [scrollView addSubview:postTF];
    
    UITextField *companyTF = [self addPerfectInfoTextfWithFrameY:CGRectGetMaxY(postTF.frame)+15 Placeholder:@"公司" leftImageName:@"login_gongsi"];
    UIButton *companyRightV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 16)];
    [companyRightV setUserInteractionEnabled:NO];
    [companyRightV setImage:[UIImage imageNamed:@"me_right"] forState:UIControlStateNormal];
    [companyTF setRightView:companyRightV];
    [scrollView addSubview:companyTF];
    
    UITextField *phoneTF = [self addPerfectInfoTextfWithFrameY:CGRectGetMaxY(companyTF.frame)+15 Placeholder:@"手机号" leftImageName:@"login_phone"];
    [scrollView addSubview:phoneTF];
    
    
    UIButton *loginBut = [[UIButton alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(phoneTF.frame)+25, SuperSize.width-50, 44)];
    [loginBut setBackgroundColor:[UIColor redColor]];
    [scrollView addSubview:loginBut];
    // Do any additional setup after loading the view.
    
    UIButton *bindingBut = [[UIButton alloc] initWithFrame:CGRectMake(SuperSize.width-200-25, CGRectGetMaxY(loginBut.frame)+30, 200, 40)];
    [bindingBut.titleLabel setFont:WLFONT(14)];
    [bindingBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [bindingBut setTitle:@"已有手机注册账号，立即绑定>>" forState:UIControlStateNormal];
    [scrollView addSubview:bindingBut];
}


- (UITextField *)addPerfectInfoTextfWithFrameY:(CGFloat)Y Placeholder:(NSString *)placeholder leftImageName:(NSString *)imagename
{
    UITextField *textf = [[UITextField alloc] initWithFrame:CGRectMake(25, Y, SuperSize.width-50, 40)];
    [textf setPlaceholder:placeholder];
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

- (void)cancelVC
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
