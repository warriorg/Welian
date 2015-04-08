//
//  ProjectListViewController.m
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectListViewController.h"
#import "ProjectDetailsViewController.h"
#import "CreateProjectController.h"
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
        self.pageSize = KCellConut;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //隐藏表格分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadReflshData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    //添加分享按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建项目" style:UIBarButtonItemStyleBordered target:self action:@selector(createProject)];
    
    NSArray *sortedInfo = [ProjectInfo allNormalProjectInfos];
    self.headDatasource = sortedInfo[0];
    self.datasource = sortedInfo[1];
    
    //加载数据
    [self loadReflshData];
    
    //上提加载更多
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataArray)];
    // 隐藏当前的上拉刷新控件
    self.tableView.footer.hidden = YES;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30.f)];
    headerView.backgroundColor = RGB(236.f, 238.f, 241.f);
    
    NSString *titile = _headDatasource[section];
    if ([[_headDatasource[section] dateFromShortString] isToday]) {
        titile = @"今天";
    }else if([[_headDatasource[section] dateFromShortString] isYesterday]){
        titile = @"昨天";
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = RGB(125.f, 125.f, 125.f);
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.text = titile;
    [titleLabel sizeToFit];
    titleLabel.left = 15.f;
    titleLabel.centerY = headerView.height / 2.f;
    [headerView addSubview:titleLabel];
    
    return headerView;
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
    ProjectInfo *projectInfo = _datasource[indexPath.section][indexPath.row];
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
    CreateProjectController *createProjectVC = [[CreateProjectController alloc] initIsEdit:NO withData:nil];
    [self.navigationController pushViewController:createProjectVC animated:YES];
}

//下拉刷新数据
- (void)loadReflshData
{
    //开始刷新动画
    [self.refreshControl beginRefreshing];
    
    self.pageIndex = 1;
    self.allDataSource = [NSMutableArray array];
    [self initData];
}

//加载更多数据
- (void)loadMoreDataArray
{
    if (_pageIndex * _pageSize > _allDataSource.count) {
        //隐藏加载更多动画
        [self.tableView.footer endRefreshing];
        self.tableView.footer.hidden = YES;
    }else{
        _pageIndex++;
        self.tableView.footer.hidden = NO;
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
                                    [self.refreshControl endRefreshing];
//                                    [self.tableView headerEndRefreshing];
                                    [self.tableView.footer endRefreshing];
                                    
                                    if (JSON) {
                                        if (_pageIndex == 1) {
                                            //第一页
                                            [ProjectInfo deleteAllProjectInfoWithType:@(0)];
                                        }
                                        NSArray *projects = [IProjectInfo objectsWithInfo:JSON];
                                        for (IProjectInfo *iProjectInfo in projects) {
                                            [ProjectInfo createProjectInfoWith:iProjectInfo withType:@(0)];
                                        }
                                        
                                        NSArray *sortedInfo = [ProjectInfo allNormalProjectInfos];
                                        self.headDatasource = sortedInfo[0];
                                        self.datasource = sortedInfo[1];
                                        
                                        //添加数据
                                        [_allDataSource addObjectsFromArray:projects];
                                        [self.tableView reloadData];
//
//                                        NSMutableArray *headerKeys = [NSMutableArray array];
//                                        NSMutableArray *arrayForArrays = [NSMutableArray array];
//                                        NSMutableArray *tempFroGroup = nil;
//                                        BOOL checkValueAtIndex = NO;
//                                        for (int i = 0; i < _allDataSource.count; i++) {
//                                            IProjectInfo *iProject = projects[i];
//                                            //监测数组中是否包含当前日期，没有创建
//                                            if (![headerKeys containsObject:iProject.date]) {
//                                                [headerKeys addObject:iProject.date];
//                                                tempFroGroup = [NSMutableArray array];
//                                                checkValueAtIndex = NO;
//                                            }
//                                            
//                                            //有就把数据添加进去
//                                            if ([headerKeys containsObject:iProject.date]) {
//                                                [tempFroGroup addObject:iProject];
//                                                if (checkValueAtIndex == NO) {
//                                                    [arrayForArrays addObject:tempFroGroup];
//                                                    checkValueAtIndex = YES;
//                                                }
//                                            }
//                                        }
//                                        self.headDatasource = headerKeys;
//                                        self.datasource = arrayForArrays;
//                                        [self.tableView reloadData];
                                    }
                                    
                                    if(_allDataSource.count == 0){
                                        [self.tableView addSubview:self.notView];
                                        [self.tableView sendSubviewToBack:self.notView];
                                    }else{
                                        [_notView removeFromSuperview];
                                    }
                                } fail:^(NSError *error) {
                                    [self.refreshControl endRefreshing];
                                    //隐藏加载更多动画
                                    [self.tableView.footer endRefreshing];
//                                    [UIAlertView showWithError:error];
                                }];
}

@end
