//
//  MeInfoController.m
//  Welian
//
//  Created by dong on 14-9-14.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "MeInfoController.h"
#import "NameController.h"
#import "WorksListController.h"
#import "UserCardController.h"
#import "LocationprovinceController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "IconTableViewCell.h"
#import "MobileInfoCell.h"
#import "PhoneChangeVC.h"
#import "IPhotoUp.h"

@interface MeInfoController () <LocationProDelegate>
{
    NSArray *_data;
    IconTableViewCell *_iconCell;
}
@end

static NSString *iconCellid = @"IconTableViewCellid";
static NSString *mobileCellid = @"MobileInfoCellid";
@implementation MeInfoController

- (NSString *)title
{
    return @"个人资料";
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    // 1.封装图片数据
//    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    // 替换为中等尺寸图片
    NSString *url = [LogInUser getCurrentLoginUser].avatar;
    MJPhoto *photo = [[MJPhoto alloc] init];
    url = [url stringByReplacingOccurrencesOfString:@"_x.jpg" withString:@".jpg"];
    url = [url stringByReplacingOccurrencesOfString:@"_x.png" withString:@".png"];
    photo.url = [NSURL URLWithString:url]; // 图片路径
    photo.srcImageView = _iconCell.iconImage; // 来源于哪个UIImageView
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = @[photo]; // 设置所有的图片
    [browser show];
    [browser.toolbar setHidden:YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self loadPlist];
        // 2.设置tableView分割线
        [self.tableView registerNib:[UINib nibWithNibName:@"IconTableViewCell" bundle:nil] forCellReuseIdentifier:iconCellid];
        [self.tableView registerNib:[UINib nibWithNibName:@"MobileInfoCell" bundle:nil] forCellReuseIdentifier:mobileCellid];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_businesscard"] style:UIBarButtonItemStyleBordered target:self action:@selector(showUserCar)];
        
    }
    return self;
}

#pragma mark 个人名片卡
- (void)showUserCar
{
    UserCardController *carVC = [[UserCardController alloc] init];
    [self.navigationController pushViewController:carVC animated:YES];
}

#pragma mark 读取plist文件的内容
- (void)loadPlist
{
    // 1.获得路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"meinfoPlist" withExtension:@"plist"];
    
    // 2.读取数据
    _data = [NSArray arrayWithContentsOfURL:url];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_data[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取出这行对应的字典数据
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    LogInUser *mode = [LogInUser getCurrentLoginUser];
    
    if (indexPath.section==0) {
       IconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iconCellid];
        _iconCell = cell;
        cell.titleLabel.text = dict[@"title"];
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:mode.avatar] placeholderImage:[UIImage imageNamed:@"user_small.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
        [cell.iconImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        return cell;
    }else if(indexPath.section ==2&&indexPath.row==0){
        MobileInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:mobileCellid];
        if (mode.checked.boolValue) {
            
            cell.authImageV.image = [UIImage imageNamed:@"me_renzheng_certification_bg.png"];
        }else{
            cell.authImageV.image = [UIImage imageNamed:@"me_renzheng_phone_failed_bg"];
        }
        [cell.detailLabel setText:mode.mobile];
        return cell;
    }else{
        static NSString *reuseIdentifier = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (nil ==cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
            [cell.detailTextLabel setFont:WLFONT(15)];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        [cell.textLabel setText:dict[@"title"]];
        
        if (indexPath.section==1){
            if (indexPath.row==0) {
                
                [cell.detailTextLabel setText:mode.name];
            }else if (indexPath.row ==1){
                [cell.detailTextLabel setText:mode.company];
            }else if (indexPath.row ==2){
                [cell.detailTextLabel setText:mode.position];
            }
        }else if (indexPath.section ==2){
            if (indexPath.row ==1){
                [cell.detailTextLabel setText:mode.email];
            }else if (indexPath.row==2){
                if (mode.provincename||mode.cityname) {
                    
                    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@   %@",mode.provincename,mode.cityname]];
                }
            }else if (indexPath.row ==3){
                [cell.detailTextLabel setText:mode.address];
            }
            
        }else if (indexPath.section ==3){
            [cell.detailTextLabel setText:nil];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 60;
    }
    return KTableRowH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 1.取出这行对应的字典数据
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    UIViewController *controller;
    LogInUser *mode = [LogInUser getCurrentLoginUser];
    if (indexPath.section==0) {
        [self choosePicture];
    }else if(indexPath.section==2&&indexPath.row==0){
        UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:nil];
        if (mode.checked.boolValue) {
            [sheet bk_addButtonWithTitle:@"修改手机号" handler:^{
                PhoneChangeVC *phoneVC = [[PhoneChangeVC alloc] initWithPhoneType:2];
                phoneVC.phoneChangeBlcok = ^{
                    [WLHUDView showSuccessHUD:@"修改成功"];
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
                [self.navigationController pushViewController:phoneVC animated:YES];
            }];
        }else{
            [sheet bk_addButtonWithTitle:@"认证手机号" handler:^{
                PhoneChangeVC *phoneVC = [[PhoneChangeVC alloc] initWithPhoneType:1];
                phoneVC.phoneChangeBlcok = ^{
                    [WLHUDView showSuccessHUD:@"认证成功"];
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
                [self.navigationController pushViewController:phoneVC animated:YES];
            }];
        }
        
        [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
        [sheet showInView:self.view];
    }else if (indexPath.section==3){
        controller = [[WorksListController alloc] init];
    }else{
        WEAKSELF
        if(indexPath.section ==1){
            if (indexPath.row==0) {
                controller = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
                    [WeLianClient saveUserInfoWithParameterDic:@{@"name":userInfo} Success:^(id resultInfo) {
                        [LogInUser setUserName:userInfo];
                        [weakSelf saveUserInfoAtIndexPath:indexPath];
                    } Failed:^(NSError *error) {
                        
                    }];
                    
                } withType:IWVerifiedTypeName];
                NameController *inffVC = (NameController*)controller;
                [inffVC setUserInfoStr:mode.name];
            }else if (indexPath.row ==1){
                controller = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
                    
                    [WeLianClient saveUserInfoWithParameterDic:@{@"company":userInfo} Success:^(id resultInfo) {
                        [LogInUser setUsercompany:userInfo];
                        [weakSelf saveUserInfoAtIndexPath:indexPath];
                    } Failed:^(NSError *error) {
                        
                    }];
                    
                } withType:IWVerifiedTypeCompany];
                NameController *inffVC = (NameController*)controller;
                [inffVC setUserInfoStr:mode.company];
            }else if (indexPath.row ==2){
                controller = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
                    [WeLianClient saveUserInfoWithParameterDic:@{@"company":userInfo} Success:^(id resultInfo) {
                        [LogInUser setUserPosition:userInfo];
                        [weakSelf saveUserInfoAtIndexPath:indexPath];
                    } Failed:^(NSError *error) {
                        
                    }];
                    
                } withType:IWVerifiedTypeJob];
                NameController *inffVC = (NameController*)controller;
                [inffVC setUserInfoStr:mode.position];
            }
            
        }else if (indexPath.section ==2){
            if (indexPath.row ==1){
                controller = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
                    [WeLianClient saveUserInfoWithParameterDic:@{@"email":userInfo} Success:^(id resultInfo) {
                        [LogInUser setUserEmail:userInfo];
                        [weakSelf saveUserInfoAtIndexPath:indexPath];
                    } Failed:^(NSError *error) {
                        
                    }];
                } withType:IWVerifiedTypeMailbox];
                NameController *inffVC = (NameController*)controller;
                [inffVC setUserInfoStr:mode.email];
            } else if (indexPath.row==2){
                LocationprovinceController *locontroller = [[LocationprovinceController alloc] initWithStyle:UITableViewStyleGrouped];
                controller=locontroller;
                [locontroller setLocationDelegate:self];
                [locontroller setMeinfoVC:self];
                
            } else if (indexPath.row==3){
                controller = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
                    [WeLianClient saveUserInfoWithParameterDic:@{@"address":userInfo} Success:^(id resultInfo) {
                        [LogInUser setUserAddress:userInfo];
                        [weakSelf saveUserInfoAtIndexPath:indexPath];
                    } Failed:^(NSError *error) {
                        
                    }];
                } withType:IWVerifiedTypeAddress];
                NameController *inffVC = (NameController*)controller;
                [inffVC setUserInfoStr:mode.address];
            }
        }
    }
    if (controller) {
        [controller setTitle:dict[@"title"]];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

// 修改基本信息
- (void)saveUserInfoAtIndexPath:(NSIndexPath *)indexPath
{
    [WLHUDView showSuccessHUD:@"修改成功"];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

// 修改城市
- (void)locationProvinController:(LocationprovinceController *)locationVC withLocationDic:(NSDictionary *)locationDic
{
    WEAKSELF
    [WeLianClient saveUserInfoWithParameterDic:@{@"cityid":@([locationDic[@"cityid"] integerValue])} Success:^(id resultInfo) {
        [LogInUser setUserProvincename:locationDic[@"provname"]];
        [LogInUser setUserCityname:locationDic[@"cityname"]];
        [LogInUser setUserCityid:locationDic[@"cityid"]];
        [LogInUser setUserProvinceid:locationDic[@"provid"]];
        [weakSelf saveUserInfoAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
    } Failed:^(NSError *error) {
        
    }];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];   
    //image就是你选取的照片
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *avatarStr = [UIImageJPEGRepresentation(image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [[WeLianClient sharedClient] uploadImageWithImageData:@[imageData] Type:@"avatar" FeedID:nil Success:^(id resultInfo) {
        IPhotoUp *photoUp = [[IPhotoUp objectsWithInfo:resultInfo] firstObject];
        if (photoUp.photo.length&&[photoUp.type isEqualToString:@"avatar"]) {
            //修改头像
            [WeLianClient changeUserAvatarWithAvatar:photoUp.photo
                                             Success:^(id resultInfo) {
                                                 [LogInUser setUserAvatar:[resultInfo objectForKey:@"avatar"]];
                                                 [_iconCell.iconImage setImage:image];
                                                 
                                                 [UserDefaults setObject:avatarStr forKey:@"icon"];
                                                 [self.tableView reloadData];
                                             } Failed:^(NSError *error) {
                                                 
                                             }];
        }
    } Failed:^(NSError *error) {
        
    }];
    
//    [WLHttpTool uploadAvatarParameterDic:@{@"avatar":avatarStr,@"title":@"png"} success:^(id JSON) {
//
//        [LogInUser setUserAvatar:[JSON objectForKey:@"url"]];
//        [_iconCell.iconImage setImage:image];
//
//        [UserDefaults setObject:avatarStr forKey:@"icon"];
//        [self.tableView reloadData];
//    } fail:^(NSError *error) {
//        
//    }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
}



@end
