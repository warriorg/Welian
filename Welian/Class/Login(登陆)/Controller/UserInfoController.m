//
//  UserInfoController.m
//  Welian
//
//  Created by dong on 14-9-11.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "UserInfoController.h"
#import "NameController.h"
#import "MainViewController.h"
#import "WLHUDView.h"
#import "MJExtension.h"
#import "BSearchFriendsController.h"
#import "NavViewController.h"

#import "UITextField+LeftRightView.h"
#import "UIImage+ImageEffects.h"
#import "CompotAndPostController.h"
#import "IPhotoUp.h"

@interface UserInfoController () <UITextFieldDelegate>
{
    UIButton *_iconBut;
    UITextField *_nameTF;
    UITextField *_companyTF;
    UITextField *_postTF;
    UIButton *_loginBut;
    UIScrollView *_scrollView;
    NSString *_imageURL;

    
}
@end

@implementation UserInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"加入微链"];
    [self loadUIView];
}

- (void)loadUIView
{
    [self.view setBackgroundColor:WLRGB(231, 234, 238)];
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
    
    
    UIButton *loginBut = [[UIButton alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(postTF.frame)+25, SuperSize.width-50, 44)];
    [loginBut setBackgroundImage:[UIImage resizedImage:@"login_my_button"] forState:UIControlStateNormal];
    [loginBut setBackgroundImage:[UIImage resizedImage:@"login_my_button_pre"] forState:UIControlStateHighlighted];
    [loginBut setTitle:@"进入微链" forState:UIControlStateNormal];
    [loginBut addTarget:self action:@selector(saveAndLogin) forControlEvents:UIControlEventTouchUpInside];
    [loginBut.titleLabel setFont:WLFONTBLOD(18)];
    _loginBut = loginBut;
    [scrollView addSubview:loginBut];
    
    // 键盘管理
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:scrollView];
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [[self.view findFirstResponder] resignFirstResponder];
    }];
    [self.view addGestureRecognizer:tap];
    
}



#pragma mark - 保存并登陆
- (void)saveAndLogin
{
    if (!_nameTF.text.length) {
        [WLHUDView showErrorHUD:@"请填写你的姓名"];
        return;
    }
    if (_nameTF.text.length<2||_nameTF.text.length>20) {
        [WLHUDView showErrorHUD:@"姓名长度为2-20个字"];
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
        [WLHUDView showErrorHUD:@"请选择头像"];
        return;
    }
    [WLHUDView showHUDWithStr:@"登录中..." dim:YES];
    [WeLianClient registerWithName:_nameTF.text Mobile:self.phoneString Company:_companyTF.text Position:_postTF.text Password:[self.pwdString MD5String] Avatar:_imageURL Success:^(id resultInfo) {
        DLog(@"%@",resultInfo);
        [WLHUDView hiddenHud];
        ILoginUserModel *loginUserM = resultInfo;
        [LogInUser createLogInUserModel:loginUserM];
        //进入主页面
        MainViewController *mainVC = [[MainViewController alloc] init];
        [[UIApplication sharedApplication].keyWindow setRootViewController:mainVC];
        
    } Failed:^(NSError *error) {
        [WLHUDView showErrorHUD:error.localizedDescription];
    }];
    
//    [WLHttpTool registerParameterDic:@{@"name":_nameTF.text,@"company":_companyTF.text,@"position":_postTF.text,@"avatar":_imagebase64Str,@"avatarname":@"jpg",@"password":[mima MD5String]} success:^(id JSON) {
//        NSDictionary *datadic = [NSDictionary dictionaryWithDictionary:JSON];
//        if ([datadic objectForKey:@"url"]) {
//            
//            NSMutableDictionary *reqstDic = [NSMutableDictionary dictionary];
//            [reqstDic setObject:self.phoneString forKey:@"mobile"];
//            [reqstDic setObject:self.pwdString forKey:@"password"];
//            [reqstDic setObject:KPlatformType forKey:@"platform"];
//            if ([UserDefaults objectForKey:kBPushRequestChannelIdKey]) {
//                
//                [reqstDic setObject:[UserDefaults objectForKey:kBPushRequestChannelIdKey] forKey:@"clientid"];
//            }
//
//            [WLHttpTool loginParameterDic:reqstDic success:^(id JSON) {
//                NSDictionary *dataDic = JSON;
//                if (dataDic) {
//                    UserInfoModel *mode = [UserInfoModel objectWithKeyValues:dataDic];
//                    [mode setCheckcode:self.pwdString];
//                    [UserDefaults setObject:mode.sessionid forKey:kSessionId];
//                    [LogInUser createLogInUserModel:mode];
//                    BSearchFriendsController *bsearchVC = [[BSearchFriendsController alloc] init];
//                    [bsearchVC setIsStart:YES];
//                    NavViewController *nav = [[NavViewController alloc] initWithRootViewController:bsearchVC];
//                    [self presentViewController:nav animated:YES completion:^{
//                        
//                    }];
//                }
//                
//            } fail:^(NSError *error) {
//                
//            } isHUD:YES];
//
//        }
//    } fail:^(NSError *error) {
//        
//    }];

}




#pragma mark - 选取头像照片
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
    if (textField == _nameTF){
        if (range.location>=20) return NO;
    }
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==_nameTF) {
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
