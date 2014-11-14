//
//  SettingController.m
//  Welian
//
//  Created by dong on 14-9-14.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "SettingController.h"
#import "UIImage+ImageEffects.h"
#import "NameController.h"
#import "WLTool.h"
#import "NavViewController.h"
#import "AboutViewController.h"
#import "BPush.h"

@interface SettingController () <UIActionSheetDelegate>
{
    NSArray *_data;
    NSString *_upURL;
}

@property (nonatomic, strong) UISwitch *remindSwitch;
@end

@implementation SettingController

- (UISwitch *)remindSwitch
{
    if (nil == _remindSwitch) {
        _remindSwitch = [[UISwitch alloc] init];
        [_remindSwitch setOnTintColor:KBasesColor];
    }
    return _remindSwitch;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self loadPlist];
        
        // 2.设置tableView
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        // 3.要在tableView底部添加一个按钮
        UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];

        [logout setBackgroundImage:[UIImage resizedImage:@"background_white"] forState:UIControlStateNormal];
        [logout setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [logout setBackgroundImage:[UIImage resizedImage:@"background_grey"] forState:UIControlStateHighlighted];
        
        // tableFooterView的宽度是不需要设置。默认就是整个tableView的宽度
        logout.bounds = CGRectMake(0, 0, 0, 44);
        
        // 4.设置按钮文字
        [logout setTitle:@"退出登录" forState:UIControlStateNormal];
        
        //    logout.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        [logout addTarget:self action:@selector(exitLoging:) forControlEvents:UIControlEventTouchUpInside];
        
        self.tableView.tableFooterView = logout;
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _data.count - 1) {
        return 15;
    }
    return 0;
}

#pragma mark - 退出登陆
- (void)exitLoging:(UIButton*)but
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确定要退出登录？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"LogInStoryboard" bundle:nil];
        
        NavViewController  *detailViewController = [storyBoard instantiateViewControllerWithIdentifier:@"LogInStoryboardNav"];
        UserInfoModel *mode = [[UserInfoModel alloc] init];
        [[UserInfoTool sharedUserInfoTool] saveUserInfo:mode];
        [BPush unbindChannel];
//        [UserDefaults removeObjectForKey:BPushRequestUserIdKey];
//        [UserDefaults removeObjectForKey:BPushRequestChannelIdKey];
        [UserDefaults removeObjectForKey:KFirstFID];
        [self.view.window setRootViewController:detailViewController];
    }
}

#pragma mark 读取plist文件的内容
- (void)loadPlist
{
    // 1.获得路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"settingPlist" withExtension:@"plist"];
    
    // 2.读取数据
    _data = [NSArray arrayWithContentsOfURL:url];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"设置"];
    
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
    
    if (indexPath.section==0&&indexPath.row==0) {
        [cell setAccessoryView:self.remindSwitch];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else if (indexPath.section==0&&indexPath.row==1){
        UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
        [cell.detailTextLabel setText:mode.mobile];
    }else if (indexPath.section==1&&indexPath.row==1){
        NSString *localVersion =[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
        [cell.detailTextLabel setText:localVersion];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0&&indexPath.row==1) {
        UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
        NameController *phoneVC = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
            [mode setMobile:userInfo];
            [[UserInfoTool sharedUserInfoTool] saveUserInfo:mode];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }withType:IWVerifiedTypeAddress];
        [phoneVC setUserInfoStr:mode.mobile];
        
        [self.navigationController pushViewController:phoneVC animated:YES];
    }else if (indexPath.section==1&&indexPath.row==0){
        AboutViewController *aboutVC = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
        
    }else if (indexPath.section==1&&indexPath.row==1){
        [WLTool updateVersions:^(NSDictionary *versionDic) {
            
            if ([[versionDic objectForKey:@"flag"] integerValue]==1) {
                NSString *msg = [versionDic objectForKey:@"msg"];
                _upURL = [versionDic objectForKey:@"url"];
                
                [[[UIAlertView alloc] initWithTitle:@"更新提示" message:msg  delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"立即更新", nil] show];
            }else{
                [WLHUDView showSuccessHUD:@"已是最新版本！"];
            }

        }];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_upURL]];
    }
}



@end
