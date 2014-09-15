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

@interface MeViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_data;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // 1.搭建UI界面
    [self buildUI];
    
    // 2.读取plist文件的内容
    [self loadPlist];
    
    // 3.设置tableView属性
//    [self buildTableView];
    
}

#pragma mark 搭建UI界面
- (void)buildUI
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    // 2.设置tableView每组头部的高度
    self.tableView.sectionHeaderHeight = 15;
    self.tableView.sectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
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
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    // 1.取出这行对应的字典数据
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    
    // 2.设置文字
    cell.textLabel.text = dict[@"name"];
    [cell.imageView setImage:[UIImage imageNamed:dict[@"icon"]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 60;
    }
    return 47;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
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
