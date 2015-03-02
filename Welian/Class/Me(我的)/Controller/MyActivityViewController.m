//
//  MyActivityViewController.m
//  Welian
//
//  Created by weLian on 15/2/28.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "MyActivityViewController.h"
#import "HMSegmentedControl.h"
#import "ActivityListViewCell.h"
#import "ActivityDetailInfoViewController.h"

#define kTableViewCellHeight 98.f
#define kTableViewHeaderHeight 25.f

@interface MyActivityViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (strong,nonatomic) NSArray *datasource;

@end

@implementation MyActivityViewController

- (HMSegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, ViewCtrlTopBarHeight, self.view.width, 50)];
        _segmentedControl.sectionTitles = @[@"我收藏的", @"我报名的"];
        _segmentedControl.selectedTextColor = KBasesColor;
        [_segmentedControl setTextColor:kTitleNormalTextColor];
        _segmentedControl.selectionIndicatorColor = KBasesColor;
        _segmentedControl.selectionIndicatorHeight = 2;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        UIView *lieView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SuperSize.width, 0.5)];
        [lieView setBackgroundColor:[UIColor lightGrayColor]];
        [_segmentedControl addSubview:lieView];
    }
    return _segmentedControl;
}

- (NSString *)title
{
    return @"我的活动";
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
    
//    WEAKSELF
    //添加头部操作
    [self.view addSubview:self.segmentedControl];
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        //切换调用
        
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.segmentedControl.bottom, self.view.width, self.view.height - self.segmentedControl.bottom)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
//    _refreshControl = [[UIRefreshControl alloc] init];
//    [_refreshControl addTarget:self action:@selector(refreshdata) forControlEvents:UIControlEventValueChanged];
//    [tableView addSubview:_refreshControl];
}

#pragma mark - UITableView Datasource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
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
    return 0.01f;
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

@end
