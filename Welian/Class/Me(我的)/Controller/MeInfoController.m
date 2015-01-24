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

@interface MeInfoController () <LocationProDelegate>
{
    NSArray *_data;
}
@property (nonatomic, strong) UIImageView *iconImage;
@end

@implementation MeInfoController

- (UIImageView*)iconImage
{
    if (nil == _iconImage) {
//        UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
        LogInUser *mode = [LogInUser getCurrentLoginUser];
        _iconImage = [[UIImageView alloc] init];
        
        [_iconImage sd_setImageWithURL:[NSURL URLWithString:mode.avatar] placeholderImage:[UIImage imageNamed:@"user_small.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
        [_iconImage setUserInteractionEnabled:YES];
        [_iconImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
    }
    return _iconImage;
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
    photo.srcImageView = self.iconImage; // 来源于哪个UIImageView
    
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
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_businesscard"] style:UIBarButtonItemStyleBordered target:self action:@selector(showUserCar)];
        
    }
    return self;
}

#pragma mark 个人名片卡
- (void)showUserCar
{
    UserCardController *carVC = [[UserCardController alloc] init];

    UserInfoModel *mode = [UserInfoModel userinfoWithLoginUser:[LogInUser getCurrentLoginUser]];
    [carVC setUserinfoM:mode];
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
    static NSString *reuseIdentifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (nil ==cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    // 1.取出这行对应的字典数据
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    [cell.textLabel setText:dict[@"title"]];
//    UserInfoModel *modeuser = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    LogInUser *mode = [LogInUser getCurrentLoginUser];
    
    if (indexPath.section==0) {
        [self.iconImage setFrame:CGRectMake(self.view.bounds.size.width-70, 10, 40, 40)];
        [cell.contentView addSubview:self.iconImage];
        
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            
            [cell.detailTextLabel setText:mode.name];
        }else if (indexPath.row ==1){
            [cell.detailTextLabel setText:mode.company];
        }else if (indexPath.row ==2){
            [cell.detailTextLabel setText:mode.position];
        }else if (indexPath.row ==3){
            [cell.detailTextLabel setText:mode.email];
        }else if (indexPath.row==4){
            if (mode.provincename||mode.cityname) {
                
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@   %@",mode.provincename,mode.cityname]];
            }
        }else if (indexPath.row ==5){
            [cell.detailTextLabel setText:mode.address];
        }

    }else if (indexPath.section ==2){
        [cell.detailTextLabel setText:nil];
    }
    return cell;
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
    if (indexPath.section==0) {
        [self choosePicture];
        
    }else{
        UIViewController *controller;
        if (indexPath.section==2) {
            if (indexPath.row==0) {
                controller = [[WorksListController alloc] initWithType:WLSchool];
            }else {
                controller = [[WorksListController alloc] initWithType:WLCompany];
            }
        }else {
            LogInUser *mode = [LogInUser getCurrentLoginUser];

            if (indexPath.row==0) {
                controller = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
                    [WLHttpTool saveProfileParameterDic:@{@"name":userInfo} success:^(id JSON) {

                        [LogInUser setUserName:userInfo];
                        
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    } fail:^(NSError *error) {
                        
                    }];
                    
                } withType:IWVerifiedTypeName];
                NameController *inffVC = (NameController*)controller;
                [inffVC setUserInfoStr:mode.name];
            }else if (indexPath.row ==1){
                controller = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
                    
                    [WLHttpTool saveProfileParameterDic:@{@"company":userInfo} success:^(id JSON) {
                        [LogInUser setUsercompany:userInfo];
                        
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    } fail:^(NSError *error) {
                        
                    }];
                    
                } withType:IWVerifiedTypeCompany];
                NameController *inffVC = (NameController*)controller;
                [inffVC setUserInfoStr:mode.company];
            }else if (indexPath.row ==2){
                controller = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
                    [WLHttpTool saveProfileParameterDic:@{@"position":userInfo} success:^(id JSON) {
                        [LogInUser setUserPosition:userInfo];
                        
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 
                    } fail:^(NSError *error) {
                        
                    }];
                    
                } withType:IWVerifiedTypeJob];
                NameController *inffVC = (NameController*)controller;
                [inffVC setUserInfoStr:mode.position];
            }else if (indexPath.row ==3){
                controller = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
                    [WLHttpTool saveProfileParameterDic:@{@"email":userInfo} success:^(id JSON) {
                        [LogInUser setUserEmail:userInfo];
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    } fail:^(NSError *error) {
                        
                    }];
                    
                } withType:IWVerifiedTypeMailbox];
                NameController *inffVC = (NameController*)controller;
                [inffVC setUserInfoStr:mode.email];
            } else if (indexPath.row==4){
               LocationprovinceController *locontroller = [[LocationprovinceController alloc] initWithStyle:UITableViewStyleGrouped];
                controller=locontroller;
                [locontroller setLocationDelegate:self];
                [locontroller setMeinfoVC:self];
            
            } else if (indexPath.row==5){
                controller = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
                    [WLHttpTool saveProfileParameterDic:@{@"address":userInfo} success:^(id JSON) {
                        
                        [LogInUser setUserAddress:userInfo];

                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    } fail:^(NSError *error) {
                        
                    }];
                } withType:IWVerifiedTypeAddress];
                NameController *inffVC = (NameController*)controller;
                [inffVC setUserInfoStr:mode.address];
            }

        }
        [controller setTitle:dict[@"title"]];
        
        [self.navigationController pushViewController:controller animated:YES];

    }
    
}

- (void)locationProvinController:(LocationprovinceController *)locationVC withLocationDic:(NSDictionary *)locationDic
{
    [LogInUser setUserProvincename:locationDic[@"provname"]];
    [LogInUser setUserCityname:locationDic[@"cityname"]];
    [LogInUser setUserCityid:locationDic[@"cityid"]];
    [LogInUser setUserProvinceid:locationDic[@"provid"]];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    
    [WLHttpTool saveProfileParameterDic:@{@"cityid":@([locationDic[@"cityid"] integerValue])} success:^(id JSON) {
        
    } fail:^(NSError *error) {
        
    }];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];   
    //image就是你选取的照片
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    NSString *avatarStr = [UIImageJPEGRepresentation(image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    [WLHttpTool uploadAvatarParameterDic:@{@"avatar":avatarStr,@"title":@"png"} success:^(id JSON) {

        [LogInUser setUserAvatar:[JSON objectForKey:@"url"]];
        [self.iconImage setImage:image];

        [UserDefaults setObject:avatarStr forKey:@"icon"];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        
    }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
}



@end
