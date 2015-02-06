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
#import "MJRefresh.h"
#import "NotstringView.h"

@interface MyProjectViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _pageIndex;
    NSMutableDictionary *_getProjectDic;
}
@property (nonatomic, strong) NSMutableArray *collectDataArray;
@property (nonatomic, strong) NSMutableArray *createDataArray;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NotstringView *notstrView;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation MyProjectViewController

- (NotstringView *)notstrView
{
    if (!_notstrView) {
        _notstrView = [[NotstringView alloc] initWithFrame:self.tableView.frame withTitleStr:@"暂无项目"];
        [self.tableView addSubview:_notstrView];
        [_notstrView setHidden:YES];
    }
    return _notstrView;
}


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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50+64, SuperSize.width, SuperSize.height-50-64)];
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
    _getProjectDic = [NSMutableDictionary dictionary];
    _selectIndex = 0;
    _pageIndex = 1;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建项目" style:UIBarButtonItemStyleBordered target:self action:@selector(createNewProject)];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.tableView];
    __weak MyProjectViewController *weakVC = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        weakVC.selectIndex = index;
        if (index == 0) {
            [weakVC.notstrView setHidden:weakVC.collectDataArray.count];
            [weakVC.tableView reloadData];
        }else if (index == 1){
            [weakVC.notstrView setHidden:weakVC.createDataArray.count];
            [weakVC.tableView reloadData];
            if (!weakVC.createDataArray) {
                [weakVC refreshdata];
            }
        }
    }];
    
    // 上拉加载更多
    [self.tableView addFooterWithTarget:self action:@selector(laodMoreData)];
    [self.tableView setFooterHidden:YES];
    [self refreshdata];
}

#pragma mark - 刷新数据
- (void)refreshdata
{
    [self.refreshControl beginRefreshing];
    _pageIndex = 1;
    [_getProjectDic removeAllObjects];
    [_getProjectDic setObject:@(_pageIndex) forKey:@"page"];
    [_getProjectDic setObject:@(KCellConut) forKey:@"size"];
    if (self.segmentedControl.selectedSegmentIndex==0) {
        // -1 取自己，0 取推荐的项目，大于0取id为uid的用户
        [WLHttpTool getFavoriteProjectsParameterDic:_getProjectDic success:^(id JSON) {
            [self.refreshControl endRefreshing];
            [self.tableView footerEndRefreshing];
            if (self.segmentedControl.selectedSegmentIndex==self.selectIndex) {
                if (JSON) {
                    NSArray *projects = [IProjectInfo objectsWithInfo:JSON];
                    [self.notstrView setHidden:projects.count];
                    [self.collectDataArray removeAllObjects];
                    self.collectDataArray = nil;
                    self.collectDataArray = [NSMutableArray arrayWithArray:projects];
                    [self.tableView reloadData];
                    if (projects.count != KCellConut) {
                        [self.tableView setFooterHidden:YES];
                    }else{
                        [self.tableView setFooterHidden:NO];
                        _pageIndex++;
                    }
                }
            }
            
        } fail:^(NSError *error) {
            [self.refreshControl endRefreshing];
            [self.tableView footerEndRefreshing];
        }];
    }else if (self.segmentedControl.selectedSegmentIndex ==1){
       [_getProjectDic setObject:@(-1) forKey:@"uid"];
        // -1 取自己，0 取推荐的项目，大于0取id为uid的用户
        [WLHttpTool getProjectsParameterDic:_getProjectDic success:^(id JSON) {
            [self.refreshControl endRefreshing];
            [self.tableView footerEndRefreshing];
            if (self.segmentedControl.selectedSegmentIndex==self.selectIndex) {
                if (JSON) {
                    NSArray *projects = [IProjectInfo objectsWithInfo:JSON];
                    [self.notstrView setHidden:projects.count];
                    [self.createDataArray removeAllObjects];
                    self.createDataArray = nil;
                    self.createDataArray = [NSMutableArray arrayWithArray:projects];
                    [self.tableView reloadData];
                    if (projects.count != KCellConut) {
                        [self.tableView setFooterHidden:YES];
                    }else{
                        [self.tableView setFooterHidden:NO];
                        _pageIndex++;
                    }
                }
            }
        } fail:^(NSError *error) {
            [self.refreshControl endRefreshing];
            [self.tableView footerEndRefreshing];
        }];
    }
    
    
}

#pragma mark - 上拉加载更多
- (void)laodMoreData
{
    [_getProjectDic removeAllObjects];
    [_getProjectDic setObject:@(_pageIndex) forKey:@"page"];
    [_getProjectDic setObject:@(KCellConut) forKey:@"size"];
    if (self.segmentedControl.selectedSegmentIndex==0) {
        [WLHttpTool getFavoriteProjectsParameterDic:_getProjectDic success:^(id JSON) {
            [self.refreshControl endRefreshing];
            [self.tableView footerEndRefreshing];
            if (self.segmentedControl.selectedSegmentIndex==self.selectIndex) {
                if (JSON) {
                    NSArray *projects = [IProjectInfo objectsWithInfo:JSON];
                    [self.collectDataArray addObjectsFromArray:projects];
                    [self.tableView reloadData];
                    if (projects.count != KCellConut) {
                        [self.tableView setFooterHidden:YES];
                    }else{
                        [self.tableView setFooterHidden:NO];
                        _pageIndex++;
                    }
                }
            }
        } fail:^(NSError *error) {
            [self.refreshControl endRefreshing];
            [self.tableView footerEndRefreshing];
        }];
    }else if (self.segmentedControl.selectedSegmentIndex ==1){
        [_getProjectDic setObject:@(-1) forKey:@"uid"];
        // -1 取自己，0 取推荐的项目，大于0取id为uid的用户
        [WLHttpTool getProjectsParameterDic:_getProjectDic success:^(id JSON) {
            [self.refreshControl endRefreshing];
            [self.tableView footerEndRefreshing];
            if (self.segmentedControl.selectedSegmentIndex==self.selectIndex) {
                if (JSON) {
                    NSArray *projects = [IProjectInfo objectsWithInfo:JSON];
                    [self.createDataArray addObjectsFromArray:projects];
                    [self.tableView reloadData];
                    if (projects.count != KCellConut) {
                        [self.tableView setFooterHidden:YES];
                    }else{
                        [self.tableView setFooterHidden:NO];
                        _pageIndex++;
                    }
                }
            }
        } fail:^(NSError *error) {
            [self.refreshControl endRefreshing];
            [self.tableView footerEndRefreshing];
        }];
    }
    
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
#pragma mark - 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentedControl.selectedSegmentIndex==0) {
        IProjectInfo *projectInfo = self.collectDataArray[indexPath.row];
        [WLHttpTool deleteFavoriteProjectParameterDic:@{@"pid":projectInfo.pid} success:^(id JSON) {
            
        } fail:^(NSError *error) {
            
        }];
    }else if (self.segmentedControl.selectedSegmentIndex==1){
        
    }
}

#pragma mark - 创建新项目
- (void)createNewProject
{
    CreateProjectController *createProjectVC = [[CreateProjectController alloc] initIsEdit:YES];
    [self.navigationController pushViewController:createProjectVC animated:YES];
}

@end
