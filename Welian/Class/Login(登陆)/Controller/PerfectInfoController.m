//
//  PerfectInfoController.m
//  Welian
//
//  Created by dong on 15/1/5.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "PerfectInfoController.h"
#import "WLTextField.h"
#import "UIImage+ImageEffects.h"
#import "LoginGuideController.h"
#import "BSearchFriendsController.h"
#import "BindingPhoneController.h"
#import "CompotAndPostController.h"
#import "MainViewController.h"
#import "MJExtension.h"
#import "NSString+val.h"
#import "NavViewController.h"
#import "UITextField+LeftRightView.h"
#import "IPhotoUp.h"

@interface PerfectInfoController () <UITextFieldDelegate>
{
    UIButton *_iconBut;
    UITextField *_nameTF;
    UITextField *_companyTF;
    UITextField *_postTF;
    UITextField *_phoneTF;
    UIButton *_loginBut;
    UIButton *_bindingBut;
//    NSString *_imagebase64Str;
    NSString *_imageURL;
    UIScrollView *_scrollView;
}

@end

@implementation PerfectInfoController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadUIView];
    }
    return self;
}

- (void)loadUIView
{
    [self.view setBackgroundColor:WLRGB(231, 234, 238)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelVC)];
    [self setTitle:@"完善信息"];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setContentSize:CGSizeMake(SuperSize.width, 520)];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [scrollView setBackgroundColor:WLRGB(231, 234, 238)];
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    
    UIImage *iconimage = [UIImage imageNamed:@"login_user"];
    UIButton *iconBut = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x-iconimage.size.width*0.5, 25, iconimage.size.width, iconimage.size.height)];
    [iconBut setImage:iconimage forState:UIControlStateNormal];
    _iconBut = iconBut;
    [scrollView addSubview:iconBut];
    [iconBut addTarget:self action:@selector(choosePicture) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField *nameTF = [UITextField textFieldWitFrame:CGRectMake(25, CGRectGetMaxY(iconBut.frame)+25, SuperSize.width-50, 40) placeholder:@"姓名" leftViewImageName:@"login_name" andRightViewImageName:nil];
    [nameTF setDelegate:self];
    [nameTF setReturnKeyType:UIReturnKeyDone];
    _nameTF = nameTF;
    [scrollView addSubview:nameTF];
    
    UITextField *companyTF = [UITextField textFieldWitFrame:CGRectMake(25, CGRectGetMaxY(nameTF.frame)+15, SuperSize.width-50, 40) placeholder:@"单位" leftViewImageName:@"login_gongsi" andRightViewImageName:@"me_right"];
    [companyTF setDelegate:self];
    _companyTF = companyTF;
    [scrollView addSubview:companyTF];
    
    
    UITextField *postTF = [UITextField textFieldWitFrame:CGRectMake(25, CGRectGetMaxY(companyTF.frame)+15, SuperSize.width-50, 40) placeholder:@"职位" leftViewImageName:@"login_zhiwei" andRightViewImageName:@"me_right"];
    [postTF setDelegate:self];
    _postTF = postTF;
    [scrollView addSubview:postTF];
    

    
    UITextField *phoneTF = [UITextField textFieldWitFrame:CGRectMake(25, CGRectGetMaxY(postTF.frame)+15, SuperSize.width-50, 40) placeholder:@"手机号" leftViewImageName:@"login_phone" andRightViewImageName:nil];
    [phoneTF setDelegate:self];
    [phoneTF setKeyboardType:UIKeyboardTypeNumberPad];
    [phoneTF setReturnKeyType:UIReturnKeyDone];
    _phoneTF = phoneTF;
    [scrollView addSubview:phoneTF];
    
    UIButton *loginBut = [[UIButton alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(phoneTF.frame)+25, SuperSize.width-50, 44)];
    [loginBut setBackgroundImage:[UIImage resizedImage:@"login_my_button"] forState:UIControlStateNormal];
    [loginBut setBackgroundImage:[UIImage resizedImage:@"login_my_button_pre"] forState:UIControlStateHighlighted];
    [loginBut setTitle:@"进入微链" forState:UIControlStateNormal];
    [loginBut addTarget:self action:@selector(weixinRegister) forControlEvents:UIControlEventTouchUpInside];
    [loginBut.titleLabel setFont:WLFONTBLOD(18)];
    _loginBut = loginBut;
    [scrollView addSubview:loginBut];
    
    UIButton *bindingBut = [[UIButton alloc] initWithFrame:CGRectMake(SuperSize.width-200-25, CGRectGetMaxY(loginBut.frame)+30, 200, 40)];
    [bindingBut.titleLabel setFont:WLFONT(14)];
    [bindingBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [bindingBut setTitle:@"已有手机注册账号，立即绑定>>" forState:UIControlStateNormal];
    [bindingBut addTarget:self action:@selector(bindingPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
    _bindingBut = bindingBut;
    [scrollView addSubview:bindingBut];
    
    // 键盘管理
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:scrollView];
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [[self.view findFirstResponder] resignFirstResponder];
    }];
    [self.view addGestureRecognizer:tap];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setUserInfoDic:(NSDictionary *)userInfoDic
{
    _userInfoDic = userInfoDic;
    NSDictionary *weixingDic = [userInfoDic objectForKey:@"weixingdata"];
    if (weixingDic) {
        [_phoneTF setText:[weixingDic objectForKey:@"mobile"]];
        [_nameTF setText:[weixingDic objectForKey:@"name"]];
        [_companyTF setText:[weixingDic objectForKey:@"company"]];
        [_postTF setText:[weixingDic objectForKey:@"position"]];
    }
    if ([userInfoDic objectForKey:@"headimgurl"]) {
        UIImage *iconimage = [UIImage imageNamed:@"login_user.png"];
        [_iconBut.layer setCornerRadius:iconimage.size.width*0.5];
        [_iconBut.layer setMasksToBounds:YES];
        [_iconBut.imageView sd_setImageWithURL:[NSURL URLWithString:[userInfoDic objectForKey:@"headimgurl"]] placeholderImage:iconimage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            NSData *imagedata = UIImageJPEGRepresentation(image, 0.5);
            [[WeLianClient sharedClient] uploadImageWithImageData:@[imagedata] Type:@"avatar" FeedID:nil Success:^(id resultInfo) {
                IPhotoUp *photoUp = [[IPhotoUp objectsWithInfo:resultInfo] firstObject];
                _imageURL = photoUp.photo;
            } Failed:^(NSError *error) {
            }];
//            _imagebase64Str = [UIImageJPEGRepresentation(image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [_iconBut setImage:image forState:UIControlStateNormal];
        }];
    }
}



// 微信验证
- (void)weixinRegister
{
    
    if (![self.userInfoDic objectForKey:@"openid"]) {
        return;
    }
    if (![self.userInfoDic objectForKey:@"unionid"]) {
        return;
    }
    
    if (!_nameTF.text.length) {
        [WLHUDView showErrorHUD:@"请填写你的姓名"];
        return;
    }
    if (_nameTF.text.length<2||_nameTF.text.length>20) {
        [WLHUDView showErrorHUD:@"姓名长度为2-20个字"];
        return;
    }
    
    if (!_phoneTF.text.length) {
        [WLHUDView showErrorHUD:@"请填写手机号码"];
        return;
    }
    if (_phoneTF.text.length != 11) {
        [WLHUDView showErrorHUD:@"手机号码有误！"];
        return;
    }
    
    if (!_companyTF.text.length) {
        [WLHUDView showErrorHUD:@"请填写你所在的公司"];
        return;
    }
    if (_companyTF.text.length<2||_companyTF.text.length>30) {
        [WLHUDView showErrorHUD:@"公司长度为2-30个字"];
        return;
    }
    
    if (!_postTF.text.length) {
        [WLHUDView showErrorHUD:@"请填写你的职位"];
        return;
    }
    if (_postTF.text.length<2 ||_postTF.text.length>30) {
        [WLHUDView showErrorHUD:@"职位长度为2-30个字"];
        return;
    }
    
    if (!_imageURL.length) {
        [WLHUDView showErrorHUD:@"头像上传失败，请重新上传"];
        return;
    }
    
    NSMutableDictionary *requstDic = [NSMutableDictionary dictionary];
    [requstDic setObject:[self.userInfoDic objectForKey:@"unionid"] forKey:@"unionid"];
    [requstDic setObject:[self.userInfoDic objectForKey:@"openid"] forKey:@"openid"];
    [requstDic setObject:_nameTF.text  forKey:@"name"];
    [requstDic setObject:_phoneTF.text forKey:@"mobile"];
    [requstDic setObject:_companyTF.text forKey:@"company"];
    [requstDic setObject:_postTF.text forKey:@"position"];
    [requstDic setObject:_imageURL forKey:@"avatar"];

    [WLHUDView showHUDWithStr:@"正在加载..." dim:YES];
    [WeLianClient wxRegisterWithParameterDic:requstDic Success:^(id resultInfo) {
        DLog(@"%@",resultInfo);
        [WLHUDView hiddenHud];
        if ([resultInfo isKindOfClass:[NSDictionary class]]) {
            [UIAlertView bk_showAlertViewWithTitle:@"手机号码已经注册，可直接绑定" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"绑定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex==1) {
                    [self bindingPhoneClick:nil];
                }
            }];

        }else{
            ILoginUserModel *loginUserM = resultInfo;
            [LogInUser createLogInUserModel:loginUserM];
            // 进入主页面
            MainViewController *mainVC = [[MainViewController alloc] init];
            [[UIApplication sharedApplication].keyWindow setRootViewController:mainVC];
        }
    } Failed:^(NSError *error) {
        [WLHUDView hiddenHud];
    }];
//    [WLHttpTool weixinRegisterParameterDic:requstDic success:^(id JSON) {
//        NSDictionary *dataDic = JSON;
//        if (dataDic) {
//            UserInfoModel *mode = [UserInfoModel objectWithKeyValues:dataDic];
//            [mode setName:_nameTF.text];
//            [mode setMobile:_phoneTF.text];
//            [mode setCompany:_companyTF.text];
//            [mode setPosition:_postTF.text];
//            //记录最后一次登陆的手机号
//            SaveLoginMobile(mode.mobile);
//            
//            [UserDefaults setObject:mode.sessionid forKey:kSessionId];
//            [LogInUser createLogInUserModel:mode];
////            [LogInUser setUseropenid:[self.userInfoDic objectForKey:@"openid"]];
////            [LogInUser setUserunionid:[self.userInfoDic objectForKey:@"unionid"]];
//            BSearchFriendsController *bsearchVC = [[BSearchFriendsController alloc] init];
//            [bsearchVC setIsStart:YES];
//            NavViewController *nav = [[NavViewController alloc] initWithRootViewController:bsearchVC];
//            [self presentViewController:nav animated:YES completion:nil];
//        }
//    } fail:^(NSError *error) {
//        if (error.code==1) {
//            [UIAlertView bk_showAlertViewWithTitle:@"手机号码已经注册，可直接绑定" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"绑定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                if (buttonIndex==1) {
//                    [self bindingPhoneClick:nil];
//                }
//            }];
//
//        }
//    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //image就是你选取的照片
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    [_iconBut setImage:image forState:UIControlStateNormal];
    [_iconBut.layer setCornerRadius:_iconBut.bounds.size.width*0.5];
    [_iconBut.layer setMasksToBounds:YES];
    NSData *imagedata = UIImageJPEGRepresentation(image, 0.5);
    [[WeLianClient sharedClient] uploadImageWithImageData:@[imagedata] Type:@"avatar" FeedID:nil Success:^(id resultInfo) {
        IPhotoUp *photoUp = [[IPhotoUp objectsWithInfo:resultInfo] firstObject];
        _imageURL = photoUp.photo;
    } Failed:^(NSError *error) {
    }];
//    _imagebase64Str = [UIImageJPEGRepresentation(image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _phoneTF) {
        if (range.location>=11) return NO;
    }else if (textField == _nameTF){
        if (range.location>=20) return NO;
    }
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==_nameTF) {
        return YES;
    }else if (textField == _phoneTF){
        
        
        return YES;
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            [_scrollView setAlpha:0.2];
            [self.navigationController.navigationBar setAlpha:0];
        } completion:^(BOOL finished) {
            NSInteger type = 1;
            if (textField == _companyTF) {

            }else if (textField ==_postTF){
                type = 2;
            }
            CompotAndPostController *compAPostVC = [[CompotAndPostController alloc] initWithType:type];
            compAPostVC.comPostBlock = ^(NSString *compotAndPostStr){
                if (type==1) {
                    [_companyTF setText:compotAndPostStr];
                }else if (type==2){
                    [_postTF setText:compotAndPostStr];
                }
            };
            [self presentViewController:compAPostVC animated:NO completion:^{
                [_scrollView setAlpha:1.0];
                [self.navigationController.navigationBar setAlpha:1];
                
            }];
        }];

        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[self.view findFirstResponder] resignFirstResponder];
    return YES;
}


- (void)bindingPhoneClick:(UIButton *)but
{
    BindingPhoneController *bindingPVC = [[BindingPhoneController alloc] init];
    [bindingPVC setPhoneStr:_phoneTF.text];
    [bindingPVC setUserInfoDic:self.userInfoDic];
    [self.navigationController pushViewController:bindingPVC animated:YES];
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

@end
