//
//  FindViewController.m
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "FindViewController.h"
#import "InvestorController.h"
#import "UserCardController.h"

@interface FindViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_data;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FindViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // 加载数据
    [self loadDatalist];
    // 加载页面
    [self loadUIview];
    
}

#pragma mark - 加载数据
- (void)loadDatalist
{
    // 1.获得路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Findplist" withExtension:@"plist"];
    
    // 2.读取数据
    _data = [NSArray arrayWithContentsOfURL:url];
    
}

#pragma mark - 加载页面
- (void)loadUIview
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setSectionFooterHeight:0.0];
    [self.tableView  setSectionHeaderHeight:15.0];
    [self.view addSubview:self.tableView];
}

#pragma mark - tableView 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_data[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserCardController *cardVC = [[UserCardController alloc] init];
    [self.navigationController pushViewController:cardVC animated:YES];
    return;
    InvestorController *investorVC = [[InvestorController alloc] init];
    // 1.取出这行对应的字典数据
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    // 2.设置文字
    [investorVC setTitle:dict[@"name"]];
    [self.navigationController pushViewController:investorVC animated:YES];
    return;
    
    UIViewController *controller;
    if (indexPath.section==0) {

    }else if (indexPath.section == 3){

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
