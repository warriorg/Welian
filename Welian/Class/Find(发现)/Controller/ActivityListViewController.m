//
//  ActivityListViewController.m
//  Welian
//
//  Created by weLian on 15/2/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityDetailInfoViewController.h"
#import "ActivityListViewCell.h"
#import "WLSegmentedControl.h"

#define kHeaderHeight 43.f
#define kTableViewCellHeight 98.f
#define kTableViewHeaderHeight 25.f

@interface ActivityListViewController ()<UITableViewDataSource,UITableViewDelegate,WLSegmentedControlDelegate>

@property (assign,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *datasource;

@end

@implementation ActivityListViewController

- (NSString *)title
{
    return @"活动";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.datasource = @[@"",@"",@"",@""];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(.0f,ViewCtrlTopBarHeight, self.view.height, kHeaderHeight)];
    headView.layer.borderColorFromUIColor = RGB(231.f, 231.f, 231.f);
    headView.layer.borderWidths = @"{0,0,0.6,0}";
    [self.view addSubview:headView];
    //操作栏
    WLSegmentedControl *segmentedControl = [[WLSegmentedControl alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, headView.height) Titles:@[@"时间",@"地区"] Images:nil Bridges:nil isHorizontal:YES];
    segmentedControl.showSmallImage = YES;
    segmentedControl.lineHeightAll = YES;
    [headView addSubview:segmentedControl];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f,headView.bottom,self.view.width,self.view.height - headView.bottom)];
    tableView.dataSource = self;
    tableView.delegate = self;
    //隐藏表格分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

#pragma mark - UITableView Datasource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kTableViewHeaderHeight)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = RGB(173.f, 173.f, 173.f);
    titleLabel.text = @"以下为历史活动";
    [titleLabel sizeToFit];
    titleLabel.centerX = headView.width / 2.f;
    titleLabel.centerY = headView.height / 2.f;
    [headView addSubview:titleLabel];
    
    headView.layer.borderColorFromUIColor = RGB(231.f, 231.f, 231.f);
    headView.layer.borderWidths = @"{0,0,0.6,0}";
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Activity_List_View_Cell";
    
    ActivityListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ActivityListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//    cell.projectInfo = _datasource[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ActivityDetailInfoViewController *activityInfoVC = [[ActivityDetailInfoViewController alloc] init];
    [self.navigationController pushViewController:activityInfoVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.f;
    }else{
        return kTableViewHeaderHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellHeight;
}

#pragma mark - WLSegmentedControlDelegate
- (void)wlSegmentedControlSelectAtIndex:(NSInteger)index
{
    
}

#pragma mark - Private


@end
