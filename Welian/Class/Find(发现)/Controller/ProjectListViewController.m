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
#import "NotstringView.h"
#import "MJRefresh.h"

@interface ProjectListViewController ()

@property (strong,nonatomic) NSMutableArray *headDatasource;
@property (strong,nonatomic) NSMutableArray *datasource;
@property (strong,nonatomic) NSMutableArray *allDataSource;

@property (assign,nonatomic) NSInteger pageIndex;
@property (assign,nonatomic) NSInteger pageSize;

@property (strong, nonatomic) NotstringView *notView;

@end

@implementation ProjectListViewController

- (void)dealloc
{
    _datasource = nil;
    _headDatasource = nil;
    _allDataSource = nil;
    _notView = nil;
}

- (NotstringView *)notView
{
    if (!_notView) {
        _notView = [[NotstringView alloc] initWithFrame:self.tableView.frame withTitleStr:@"暂无创业项目"];
    }
    return _notView;
}

//标题设置
- (NSString *)title
{
    return @"创业项目";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allDataSource = [NSMutableArray array];
        self.pageIndex = 1;
        self.pageSize = 20;
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
    
    //加载数据
    [self initData];
    
    //上提加载更多
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreDataArray)];
}

#pragma mark - UITableView Datasource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _headDatasource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datasource[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titile = _headDatasource[section];
    if ([[_headDatasource[section] dateFromShortString] isToday]) {
        titile = @"今天";
    }else if([[_headDatasource[section] dateFromShortString] isYesterday]){
        titile = @"昨天";
    }
    return titile;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //微信联系人
    static NSString *cellIdentifier = @"Project_List_Cell";
    
    ProjectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ProjectViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.projectInfo = _datasource[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    IProjectInfo *projectInfo = _datasource[indexPath.section][indexPath.row];
    if (projectInfo) {
        ProjectDetailsViewController *projectDetailVC = [[ProjectDetailsViewController alloc] initWithProjectInfo:projectInfo];
        [self.navigationController pushViewController:projectDetailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
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

//加载更多数据
- (void)loadMoreDataArray
{
    if (_pageIndex * _pageSize > _allDataSource.count) {
        //隐藏加载更多动画
        [self.tableView footerEndRefreshing];
        [self.tableView setFooterHidden:YES];
    }else{
        _pageIndex++;
        [self initData];
    }
}

//获取数据
- (void)initData{
    //"uid":10086,// -1 取自己，0 取推荐的项目，大于0取id为uid的用户
    NSDictionary *params = @{@"uid":@(0),// -1 取自己，0 取推荐的项目，大于0取id为uid的用户
                            @"page":@(_pageIndex),
                            @"size":@(_pageSize)};
    [WLHttpTool getProjectsParameterDic:params
                                success:^(id JSON) {
                                    //隐藏加载更多动画
                                    [self.tableView footerEndRefreshing];
                                    
                                    if (JSON) {
                                        NSArray *projects = [IProjectInfo objectsWithInfo:JSON];
                                        //添加数据
                                        [_allDataSource addObjectsFromArray:projects];
                                        
                                        NSMutableArray *headerKeys = [NSMutableArray array];
                                        NSMutableArray *arrayForArrays = [NSMutableArray array];
                                        NSMutableArray *tempFroGroup = nil;
                                        BOOL checkValueAtIndex = NO;
                                        for (int i = 0; i < _allDataSource.count; i++) {
                                            IProjectInfo *iProject = projects[i];
                                            //监测数组中是否包含该首字母，没有创建
                                            if (![headerKeys containsObject:iProject.date]) {
                                                [headerKeys addObject:iProject.date];
                                                tempFroGroup = [NSMutableArray array];
                                                checkValueAtIndex = NO;
                                            }
                                            
                                            //有就把数据添加进去
                                            if ([headerKeys containsObject:iProject.date]) {
                                                [tempFroGroup addObject:iProject];
                                                if (checkValueAtIndex == NO) {
                                                    [arrayForArrays addObject:tempFroGroup];
                                                    checkValueAtIndex = YES;
                                                }
                                            }
                                        }
                                        self.headDatasource = headerKeys;
                                        self.datasource = arrayForArrays;
                                        [self.tableView reloadData];
                                    }
                                    
                                    if(_allDataSource.count == 0){
                                        [self.tableView addSubview:self.notView];
                                        [self.tableView sendSubviewToBack:self.notView];
                                    }else{
                                        [_notView removeFromSuperview];
                                    }
                                } fail:^(NSError *error) {
                                    //隐藏加载更多动画
                                    [self.tableView footerEndRefreshing];
                                    [UIAlertView showWithError:error];
                                }];
}

@end
