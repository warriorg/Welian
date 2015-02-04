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
#import "ProjectViewCell.h"
#import "ProjectDetailsViewController.h"

@interface MyProjectViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _pageIndex;
}
@property (nonatomic, strong) NSMutableArray *collectDataArray;
@property (nonatomic, strong) NSMutableArray *createDataArray;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

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
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(refreshdata) forControlEvents:UIControlEventValueChanged];
        [_tableView addSubview:_refreshControl];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectDataArray = [NSMutableArray array];
    _pageIndex = 1;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建项目" style:UIBarButtonItemStyleBordered target:self action:@selector(createNewProject)];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.tableView];
    __weak MyProjectViewController *weakVC = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        if (index == 0) {
            if (!weakVC.collectDataArray) {
                [weakVC refreshdata];
            }else{
                [weakVC.tableView reloadData];
            }
        }else if (index == 1){
            weakVC.createDataArray = [NSMutableArray array];
            if (!weakVC.createDataArray) {
                [weakVC refreshdata];
            }else{
                [weakVC.tableView reloadData];
            }
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshdata];
}

#pragma mark - 刷新数据
- (void)refreshdata
{
    [self.refreshControl beginRefreshing];
    NSInteger uid = 0;
    if (self.segmentedControl.selectedSegmentIndex==0) {
        uid = 0;
    }else if (self.segmentedControl.selectedSegmentIndex ==1){
        uid = -1;
    }
    _pageIndex = 1;
    [WLHttpTool getProjectsParameterDic:@{@"uid":@(uid),// -1 取自己，0 取推荐的项目，大于0取id为uid的用户
                                          @"page":@(_pageIndex),
                                          @"size":@(20)} success:^(id JSON) {
        if (JSON) {
            [self.refreshControl endRefreshing];
            NSArray *projects = [IProjectInfo objectsWithInfo:JSON];
            if (self.segmentedControl.selectedSegmentIndex==0) {
                [self.collectDataArray removeAllObjects];
                self.collectDataArray = nil;
                self.collectDataArray = [NSMutableArray arrayWithArray:projects];
            }else if (self.segmentedControl.selectedSegmentIndex==1){
                [self.createDataArray removeAllObjects];
                self.createDataArray = nil;
                self.createDataArray = [NSMutableArray arrayWithArray:projects];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segmentedControl.selectedSegmentIndex ==0) {
        
        return self.collectDataArray.count;
    }else if (self.segmentedControl.selectedSegmentIndex==1){
        return self.createDataArray.count;
    }
    return 0;
}

- (ProjectViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Project_List_Cell";
    ProjectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ProjectViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.segmentedControl.selectedSegmentIndex==0) {
        cell.projectInfo = self.collectDataArray[indexPath.row];
    }else if (self.segmentedControl.selectedSegmentIndex==1){
        cell.projectInfo = self.createDataArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    IProjectInfo *projectInfo = nil;
    if (self.segmentedControl.selectedSegmentIndex==0) {
       projectInfo = self.collectDataArray[indexPath.row];
    }else if (self.segmentedControl.selectedSegmentIndex==1){
        projectInfo = self.createDataArray[indexPath.row];
    }
    if (projectInfo) {
        ProjectDetailsViewController *projectDetailVC = [[ProjectDetailsViewController alloc] initWithProjectInfo:projectInfo];
        [self.navigationController pushViewController:projectDetailVC animated:YES];
    }
}

#pragma mark - 创建新项目
- (void)createNewProject
{
    CreateProjectController *createProjectVC = [[CreateProjectController alloc] initIsEdit:YES];
    [self.navigationController pushViewController:createProjectVC animated:YES];
}

@end
