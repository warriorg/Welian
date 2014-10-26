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
#import "CertificationController.h"
#import "MyLocationController.h"
#import "HomeController.h"

@interface MeViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_data;
}

@end

static NSString *meinfocellid = @"MeinfoCell";
@implementation MeViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tableView) {
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
//        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 2.读取plist文件的内容
    [self loadPlist];
    
    // 3.设置tableView属性
    [self buildTableView];
    
}

- (void)buildTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"MeinfoCell" bundle:nil] forCellReuseIdentifier:meinfocellid];
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.section==0) {
        MeinfoCell *cell = [tableView dequeueReusableCellWithIdentifier:meinfocellid];
        
        UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
        [cell.MyNameLabel setText:mode.name];
        [cell.deleLabel setText:[NSString stringWithFormat:@"%@    %@",mode.position,mode.company]];
        [cell.headPicImage sd_setImageWithURL:[NSURL URLWithString:mode.avatar] placeholderImage:[UIImage imageNamed:@"discovery_chuang.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
        return cell;
    }else{
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        // 1.取出这行对应的字典数据
        NSDictionary *dict = _data[indexPath.section][indexPath.row];
        // 2.设置文字
        cell.textLabel.text = dict[@"name"];
        [cell.imageView setImage:[UIImage imageNamed:dict[@"icon"]]];
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
            
            controller = [[MyLocationController alloc] init];
        }else if (indexPath.row ==1){
            controller = [[HomeController alloc] initWithStyle:UITableViewStylePlain anduid:@(0)];
            [controller setTitle:@"我的动态"];
        }

    }else if (indexPath.section==2){
        controller = [[CertificationController alloc] init];
        [controller setTitle:@"认证"];
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
