//
//  ProjectListViewController.m
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectListViewController.h"
#import "ProjectDetailsViewController.h"
#import "ProjectViewCell.h"

@interface ProjectListViewController ()

@property (strong,nonatomic) NSArray *datasource;

@end

@implementation ProjectListViewController

//标题设置
- (NSString *)title
{
    return @"创业项目";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.datasource = @[@{@"zhan":@"100",@"name":@"快推",@"info":@"全球领先移动招聘平台",@"status":@"正在融资"},
                            @{@"zhan":@"10000",@"name":@"快推",@"info":@"全球领先移动招聘平台啊撒旦发射点发说法发生地方",@"status":@"正在融资"},
                            @{@"zhan":@"100",@"name":@"快推",@"info":@"全球领先移动招聘平台",@"status":@"正在融资"},
                            @{@"zhan":@"100",@"name":@"快推",@"info":@"全球领先移动招聘平台",@"status":@"正在融资"},
                            @{@"zhan":@"100",@"name":@"快推",@"info":@"全球领先移动招聘平台",@"status":@"正在融资"}];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //隐藏表格分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加分享按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建项目" style:UIBarButtonItemStyleBordered target:self action:@selector(createProject)];
}

#pragma mark - UITableView Datasource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //微信联系人
    static NSString *cellIdentifier = @"Project_List_Cell";
    
    ProjectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ProjectViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.projectInfo = _datasource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ProjectDetailsViewController *projectDetailVC = [[ProjectDetailsViewController alloc] init];
    [self.navigationController pushViewController:projectDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Private
/**
 *  创建项目
 */
- (void)createProject
{
    
}

@end
