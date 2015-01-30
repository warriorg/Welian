//
//  MyProjectViewController.m
//  Welian
//
//  Created by dong on 15/1/30.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "MyProjectViewController.h"
#import "HMSegmentedControl.h"
#import "CreateProjectController.h"

@interface MyProjectViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyProjectViewController


- (HMSegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 64, SuperSize.width, 50)];
        _segmentedControl.sectionTitles = @[@"我收藏的", @"我创建的"];
        _segmentedControl.selectedTextColor = KBasesColor;
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

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50+64, SuperSize.width, SuperSize.height-40-64)];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.tableView];
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建项目" style:UIBarButtonItemStyleBordered target:self action:@selector(createNewProject)];
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    return cell;
}

#pragma mark - 创建新项目
- (void)createNewProject
{
    CreateProjectController *createProjectVC = [[CreateProjectController alloc] init];
    [self.navigationController pushViewController:createProjectVC animated:YES];
}

@end
