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

#import "NotstringView.h"
#import "MJRefresh.h"

#define kTableViewCellHeight 98.f
#define kTableViewHeaderHeight 25.f

@interface MyActivityViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (assign,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@property (strong,nonatomic) NotstringView *notView;
@property (strong,nonatomic) NSArray *datasource;

@property (assign,nonatomic) NSInteger selectType;
@property (assign,nonatomic) NSInteger pageIndex;
@property (assign,nonatomic) NSInteger pageSize;


@end

@implementation MyActivityViewController

- (void)dealloc
{
    _segmentedControl = nil;
    _refreshControl = nil;
    _datasource = nil;
    _notView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NotstringView *)notView
{
    if (!_notView) {
        _notView = [[NotstringView alloc] initWithFrame:self.tableView.frame withTitleStr:@"暂无活动"];
    }
    return _notView;
}

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
//        self.datasource = @[@"",@"",@"",@""];
        self.pageIndex = 1;
        self.pageSize = KCellConut;
        self.selectType = 0;
        
        //监听页面数据改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadReflshData) name:@"MyActivityInfoChanged" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    WEAKSELF
    //添加头部操作
    [self.view addSubview:self.segmentedControl];
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        //切换调用
        weakSelf.selectType = index;
        [weakSelf loadReflshData];
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.segmentedControl.bottom, self.view.width, self.view.height - self.segmentedControl.bottom)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    //    [tableView setDebug:YES];
    
    //添加下来刷新
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadReflshData) forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:self.refreshControl];
    
//    _refreshControl = [[UIRefreshControl alloc] init];
//    [_refreshControl addTarget:self action:@selector(refreshdata) forControlEvents:UIControlEventValueChanged];
//    [tableView addSubview:_refreshControl];
    
    //上提加载更多
    [_tableView addFooterWithTarget:self action:@selector(loadMoreDataArray)];
    [_tableView setFooterHidden:YES];
    
    [self loadReflshData];
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
    if (_datasource.count > 0) {
        cell.activityInfo = _datasource[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_datasource.count > 0) {
        ActivityDetailInfoViewController *activityInfoVC = [[ActivityDetailInfoViewController alloc] initWithActivityInfo:_datasource[indexPath.row]];
        [self.navigationController pushViewController:activityInfoVC animated:YES];
    }
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

#pragma mark - Private
//获取详情信息
- (void)initData
{
    //1 收藏，2参加的
    NSDictionary *params = @{@"type":@(_selectType + 1),
                             @"page":@(_pageIndex),
                             @"size":@(_pageSize)};
    [WLHttpTool getMyActivesParameterDic:params
                                 success:^(id JSON) {
                                     //隐藏加载更多动画
                                     [self.refreshControl endRefreshing];
                                     [_tableView footerEndRefreshing];
                                     
                                     DLog(@"---json:%@",JSON);
                                     if (JSON) {
                                         if (_pageIndex == 1) {
                                             //第一页
                                             [ActivityInfo deleteAllActivityInfoWithType:@(_selectType + 1)];
                                         }
                                         //0：普通   1：收藏  2：我参加的
                                         NSArray *activitys = [IActivityInfo objectsWithInfo:JSON];
                                         for (IActivityInfo *iActivityInfo in activitys) {
                                             [ActivityInfo createActivityInfoWith:iActivityInfo withType:@(_selectType + 1)];
                                         }
                                     }
                                     
                                     //获取数据
                                     self.datasource = [ActivityInfo allMyActivityInfoWithType:@(_selectType + 1)];
                                     [self.tableView reloadData];
                                     
                                     //设置是否可以下拉刷新
                                     if ([JSON count] != KCellConut) {
                                         [self.tableView setFooterHidden:YES];
                                     }else{
                                         [self.tableView setFooterHidden:NO];
                                         _pageIndex++;
                                     }
                                     
                                     if(_datasource.count == 0){
                                         [_tableView addSubview:self.notView];
                                         [_tableView sendSubviewToBack:self.notView];
                                     }else{
                                         [_notView removeFromSuperview];
                                     }
                                 } fail:^(NSError *error) {
                                     [self.refreshControl endRefreshing];
                                     //隐藏加载更多动画
                                     [self.tableView footerEndRefreshing];
                                     DLog(@"getMyActivesParameterDic error:%@",error.description);
                                 }];
}

//下拉刷新数据
- (void)loadReflshData
{
    //开始刷新动画
    [self.refreshControl beginRefreshing];
    
    self.pageIndex = 1;
    [self initData];
}

//加载更多数据
- (void)loadMoreDataArray
{
    [self initData];
}

@end
