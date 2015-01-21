//
//  UserInfoController.m
//  Welian
//
//  Created by dong on 14-9-11.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "UserInfoController.h"
#import "InfoHeaderView.h"
#import "NameController.h"
#import "MainViewController.h"
#import "WLHUDView.h"
#import "MJExtension.h"
#import "BSearchFriendsController.h"
#import "NavViewController.h"

@interface UserInfoController () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString *avatar;
    NSArray *_dataArray;
   __block NSString *_nameStr;
   __block NSString *_danweiStr;
   __block NSString *_zhiwuStr;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) InfoHeaderView *infoHeader;
@end

@implementation UserInfoController

- (InfoHeaderView*)infoHeader
{
    if (nil == _infoHeader) {
        
        _infoHeader = [[[NSBundle mainBundle] loadNibNamed:@"InfoHeaderView" owner:self options:nil] lastObject];
        [_infoHeader.pictureBut addTarget:self action:@selector(choosePicture) forControlEvents:UIControlEventTouchUpInside];
    }
    return _infoHeader;
}

- (UITableView *)tableView
{
    if (nil == _tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"加入微链"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveAndLogin)];
    
    // 2.读取数据
    _dataArray = @[@"姓名",@"单位",@"职务"];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - 保存并登陆
- (void)saveAndLogin
{
    NSString *mima = self.pwdString;
    if (!_nameStr.length) {
        [WLHUDView showErrorHUD:@"姓名不能为空"];
        return;
    }
    if (!_danweiStr.length) {
        [WLHUDView showErrorHUD:@"单位不能为空"];
        return;
    }
    if (!_zhiwuStr.length) {
        [WLHUDView showErrorHUD:@"职务不能为空"];
        return;
    }
    if (!avatar) {
        [WLHUDView showErrorHUD:@"头像不能为空"];
        return;
    }
    if (!mima.length) {
        [WLHUDView showErrorHUD:@"密码不能为空"];
    }
    
    [WLHttpTool registerParameterDic:@{@"name":_nameStr,@"company":_danweiStr,@"position":_zhiwuStr,@"avatar":avatar,@"avatarname":@"jpg",@"password":mima} success:^(id JSON) {
        NSDictionary *datadic = [NSDictionary dictionaryWithDictionary:JSON];
        if ([datadic objectForKey:@"url"]) {
            
            NSMutableDictionary *reqstDic = [NSMutableDictionary dictionary];
            [reqstDic setObject:self.phoneString forKey:@"mobile"];
            [reqstDic setObject:self.pwdString forKey:@"password"];
            [reqstDic setObject:KPlatformType forKey:@"platform"];
            if ([UserDefaults objectForKey:BPushRequestChannelIdKey]) {
                
                [reqstDic setObject:[UserDefaults objectForKey:BPushRequestChannelIdKey] forKey:@"clientid"];
            }

            [WLHttpTool loginParameterDic:reqstDic success:^(id JSON) {
                NSDictionary *dataDic = JSON;
                if (dataDic) {
                    UserInfoModel *mode = [UserInfoModel objectWithKeyValues:dataDic];
                    [mode setCheckcode:self.pwdString];
                    [UserDefaults setObject:mode.sessionid forKey:@"sessionid"];
                    [LogInUser createLogInUserModel:mode];
                    
                    BSearchFriendsController *bsearchVC = [[BSearchFriendsController alloc] init];
                    [bsearchVC setIsStart:YES];
                    NavViewController *nav = [[NavViewController alloc] initWithRootViewController:bsearchVC];
                    [self presentViewController:nav animated:YES completion:^{
                        
                    }];
                }
                
            } fail:^(NSError *error) {
                
            } isHUD:YES];

        }
    } fail:^(NSError *error) {
        
    }];

}




#pragma mark - 选取头像照片
- (void)choosePicture
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择",nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [imagePicker setAllowsEditing:YES];
    if (buttonIndex==0) { //拍照
        // 判断相机可以使用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        }else {
            [[[UIAlertView alloc] initWithTitle:nil message:@"摄像头不可用！！！" delegate:self cancelButtonTitle:@"知道了！" otherButtonTitles:nil, nil] show];
            return;
        }
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];

        
    }else if(buttonIndex ==1) {  // 从相册选择
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        }else {
            [[[UIAlertView alloc] initWithTitle:nil message:@"相册不可用！！！" delegate:self cancelButtonTitle:@"知道了！" otherButtonTitles:nil, nil] show];
            return;
        }
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //image就是你选取的照片
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    avatar = [UIImageJPEGRepresentation(image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [self.infoHeader.pictureBut setImage:image forState:UIWindowLevelNormal];
    [self.infoHeader.pictureBut.layer setCornerRadius:self.infoHeader.pictureBut.bounds.size.width*0.5];
    [self.infoHeader.pictureBut.layer setMasksToBounds:YES];
    [self.infoHeader.pictureBut.layer setBorderWidth:2];
    [self.infoHeader.pictureBut.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark ---tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellid"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    [cell.textLabel setText:_dataArray[indexPath.row]];
    NSString *str = @"";
    if (indexPath.row==0) {
        str = _nameStr;
    }else if (indexPath.row ==1){
        str = _danweiStr;
    }else if (indexPath.row ==2){
        str = _zhiwuStr;
    }
    [cell.detailTextLabel setText:str];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 170.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.infoHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tit = _dataArray[indexPath.row];
    
    if ([tit isEqualToString:@"姓名"]) {
        NameController *nameVC = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
            _nameStr = userInfo;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } withType:IWVerifiedTypeName];
        [nameVC setUserInfoStr:_nameStr];
        [nameVC setTitle:tit];
        [self.navigationController pushViewController:nameVC animated:YES];
    }else if ([tit isEqualToString:@"单位"]){
        NameController *nameVC = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
            _danweiStr = userInfo;
[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } withType:IWVerifiedTypeCompany];
        [nameVC setUserInfoStr:_danweiStr];
        [nameVC setTitle:tit];
        [self.navigationController pushViewController:nameVC animated:YES];
    }else if ([tit isEqualToString:@"职务"]){
        NameController *nameVC = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
            _zhiwuStr = userInfo;
[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } withType:IWVerifiedTypeJob];
        [nameVC setUserInfoStr:_zhiwuStr];
        [nameVC setTitle:tit];
        [self.navigationController pushViewController:nameVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
