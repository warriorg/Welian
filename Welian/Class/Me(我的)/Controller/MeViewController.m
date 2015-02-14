//
//  MeViewController.m
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "MeViewController.h"
#import "MeinfoCell.h"
#import "MeSttingCell.h"
#import "MeInfoController.h"
#import "SettingController.h"
#import "HomeController.h"
#import "InvestCerVC.h"
#import "BadgeBaseCell.h"
#import "MainViewController.h"
#import "MyProjectViewController.h"

@interface MeViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_data;
}

@end

static NSString *meinfocellid = @"MeinfoCell";
static NSString *BadgeBaseCellid = @"BadgeBaseCellid";
@implementation MeViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tableView) {
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
        [self reloadInvestorstate];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [KNSNotification addObserver:self selector:@selector(reloadInvestorstate) name:KInvestorstateNotif object:nil];
    // 2.读取plist文件的内容
    [self loadPlist];
    
    // 3.设置tableView属性
    [self buildTableView];
}

// 刷新我是投资人角标
- (void)reloadInvestorstate
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)buildTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"MeinfoCell" bundle:nil] forCellReuseIdentifier:meinfocellid];
    [self.tableView registerNib:[UINib nibWithNibName:@"BadgeBaseCell" bundle:nil] forCellReuseIdentifier:BadgeBaseCellid];
}


#pragma mark 读取plist文件的内容
- (void)loadPlist
{
    // 1.获得路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"meplist" withExtension:@"plist"];
    
    // 2.读取数据
    _data = [NSArray arrayWithContentsOfURL:url];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_data[section] count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        LogInUser *mode = [LogInUser getCurrentLoginUser];
    if (indexPath.section==0) {
        MeinfoCell *cell = [tableView dequeueReusableCellWithIdentifier:meinfocellid];
        [cell.MyNameLabel setText:mode.name];
        [cell.deleLabel setText:[NSString stringWithFormat:@"%@    %@",mode.position,mode.company]];
        [cell.headPicImage sd_setImageWithURL:[NSURL URLWithString:mode.avatar] placeholderImage:[UIImage imageNamed:@"user_small.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
        return cell;
    }else{
        BadgeBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:BadgeBaseCellid];
        // 1.取出这行对应的字典数据
        NSDictionary *dict = _data[indexPath.section][indexPath.row];
        // 2.设置文字
        cell.titLabel.text = dict[@"name"];
        [cell.iconImage setImage:[UIImage imageNamed:dict[@"icon"]]];
        if (indexPath.section==2) {
            [cell.deputLabel setHidden:NO];
            [cell.badgeImage setHidden:YES];
            if (indexPath.row==0) {
                [cell.badgeImage setHidden:!mode.isinvestorbadge.boolValue];
                //            0 默认状态  1  认证成功  -2 正在审核  -1 认证失败
                LogInUser *meinfo = [LogInUser getCurrentLoginUser];
                if (meinfo.investorauth.integerValue==1) {
                    [cell.deputLabel setText:@"认证成功"];
                }else if (meinfo.investorauth.integerValue ==-2){
                    [cell.deputLabel setText:@"正在审核"];
                }else if (meinfo.investorauth.integerValue ==-1){
                    [cell.deputLabel setText:@"认证失败"];
                }else{
                    [cell.deputLabel setHidden:YES];
                }
            }else if (indexPath.row==1){
                [cell.deputLabel setHidden:YES];
            }
            

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
    UIViewController *controller;
    // 1.取出这行对应的字典数据
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    // 2.设置文字
    [controller setTitle:dict[@"name"]];
    if (indexPath.section==0) {
        controller = [[MeInfoController alloc] initWithStyle:UITableViewStyleGrouped];
        [controller setTitle:@"个人信息"];
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            controller = [[HomeController alloc] initWithUid:@(0)];
            [controller setTitle:@"我的动态"];
        }else if (indexPath.row==1){
            controller = [[MyProjectViewController alloc] init];
            [controller setTitle:@"我的项目"];
            
        }
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            
            controller = [[InvestCerVC alloc] initWithStyle:UITableViewStyleGrouped];
            [controller setTitle:@"我是投资人"];
            // 取消我是投资人角标
            [LogInUser setUserIsinvestorbadge:NO];
            [[MainViewController sharedMainViewController] loadNewStustupdata];
            [self reloadInvestorstate];
        }
    }else if (indexPath.section == 3){
        controller = [[SettingController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    
     [self.navigationController pushViewController:controller animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
