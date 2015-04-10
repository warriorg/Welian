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
#import "ActivityTypeInfoView.h"
#import "NotstringView.h"
#import "MJRefresh.h"

#define kHeaderHeight 43.f
#define kTableViewCellHeight 98.f
#define kTableViewHeaderHeight 25.f

@interface ActivityListViewController ()<UITableViewDataSource,UITableViewDelegate,WLSegmentedControlDelegate>

@property (assign,nonatomic) WLSegmentedControl *segmentedControl;
@property (assign,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@property (strong,nonatomic) ActivityTypeInfoView *timeActivityTypeInfo;
@property (strong,nonatomic) ActivityTypeInfoView *cityActivityTypeInfo;

@property (strong,nonatomic) NSArray *datasource;

@property (strong,nonatomic) NSDictionary *selectTimeType;
@property (strong,nonatomic) NSDictionary *selectAddressType;
@property (assign,nonatomic) NSInteger pageIndex;
@property (assign,nonatomic) NSInteger pageSize;

@property (strong,nonatomic) NotstringView *notView;
@property (strong,nonatomic) NSIndexPath *selectIndex;
@property (strong,nonatomic) NSArray *cityList;
@property (strong,nonatomic) NSArray *timeList;

@end

@implementation ActivityListViewController

- (void)dealloc
{
    _datasource = nil;
    _cityActivityTypeInfo = nil;
    _timeActivityTypeInfo = nil;
    _selectTimeType = nil;
    _selectAddressType = nil;
    _refreshControl = nil;
    _selectIndex = nil;
    _cityList = nil;
    _timeList = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NotstringView *)notView
{
    if (!_notView) {
        _notView = [[NotstringView alloc] initWithFrame:self.tableView.frame withTitleStr:@"暂无活动"];
    }
    return _notView;
}

- (NSString *)title
{
    return @"活动";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.datasource = [ActivityInfo allNormalActivityInfos];
        
        //获取省列表
        NSArray *localCitys = [NSArray arrayWithContentsOfFile:[[ResManager documentPath] stringByAppendingString:@"/ActivityCitys.plist"]];
        NSMutableArray *customCitys = [NSMutableArray array];
        [customCitys addObject:@{@"cityid":@"-1",@"name":@"定位中..."}];
        [customCitys addObject:@{@"cityid":@"0",@"name":@"全国"}];
        [customCitys addObjectsFromArray:localCitys];
        self.cityList = [NSArray arrayWithArray:customCitys];
        
        //活动当前定位的城市
        NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocationCity"];
        NSDictionary *localCity = nil;
        if (city.length > 0) {
            localCity = [localCitys bk_match:^BOOL(id obj) {
//                return [[obj objectForKey:@"name"] isEqualToString:city];
                return [city isContainsString:[obj objectForKey:@"name"]];
            }];
        }
        
        self.timeList = @[@{@"cityid":@"-1",@"name":@"全部"}
                          ,@{@"cityid":@"0",@"name":@"今天"}
                          ,@{@"cityid":@"1",@"name":@"明天"}
                          ,@{@"cityid":@"7",@"name":@"最近一周"}
                          ,@{@"cityid":@"-2",@"name":@"周末"}];
        
        self.selectTimeType = @{@"cityid":@"-1",@"name":@"全部"};
        self.selectAddressType = localCity != nil ? localCity : @{@"cityid":@"0",@"name":@"全国"};
        self.pageIndex = 1;
        self.pageSize = KCellConut;
        
        //监听报名状态改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUiInfo) name:@"UpdateJoinedUI" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //tableview头部距离问题
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //添加创建活动按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建活动" style:UIBarButtonItemStyleDone target:self action:@selector(createActivity)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f,ViewCtrlTopBarHeight + kHeaderHeight,self.view.width,self.view.height - ViewCtrlTopBarHeight - kHeaderHeight)];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    //隐藏表格分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
//    [tableView setDebug:YES];
    
    //添加下来刷新
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadReflshData) forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:self.refreshControl];
    
    ActivityTypeInfoView *timeActivityTypeInfo = [[ActivityTypeInfoView alloc] initWithFrame:CGRectMake(0.f, tableView.top, self.view.width, tableView.height)];
    timeActivityTypeInfo.hidden = YES;
    timeActivityTypeInfo.datasource = _timeList;
    WEAKSELF
    [timeActivityTypeInfo setBlock:^(NSDictionary *info){
//        [weakSelf dismissTimeTypeInfo];
        weakSelf.selectTimeType = info;
        weakSelf.segmentedControl.titles = @[_selectTimeType[@"name"],_selectAddressType[@"name"]];
        [weakSelf loadReflshData];
    }];
    [self.view addSubview:timeActivityTypeInfo];
    self.timeActivityTypeInfo = timeActivityTypeInfo;
    
    ActivityTypeInfoView *cityActivityTypeInfo = [[ActivityTypeInfoView alloc] initWithFrame:CGRectMake(0.f, tableView.top, self.view.width, tableView.height)];
    cityActivityTypeInfo.hidden = YES;
    cityActivityTypeInfo.showLocation = YES;//显示当前定位的城市
    cityActivityTypeInfo.datasource = _cityList;
    [cityActivityTypeInfo setBlock:^(NSDictionary *info){
//        [weakSelf dismissCityTypeInfo];
        weakSelf.selectAddressType = info;
        weakSelf.segmentedControl.titles = @[_selectTimeType[@"name"],_selectAddressType[@"name"]];
        [weakSelf loadReflshData];
    }];
    [self.view addSubview:cityActivityTypeInfo];
    self.cityActivityTypeInfo = cityActivityTypeInfo;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(.0f,ViewCtrlTopBarHeight, self.view.height, kHeaderHeight)];
    headView.layer.borderColorFromUIColor = RGB(231.f, 231.f, 231.f);
    headView.layer.borderWidths = @"{0,0,0.6,0}";
    [self.view addSubview:headView];
    
    //操作栏
    WLSegmentedControl *segmentedControl = [[WLSegmentedControl alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, headView.height - 0.5) Titles:@[_selectTimeType[@"name"],_selectAddressType[@"name"]] Images:nil Bridges:nil isHorizontal:YES];
    segmentedControl.showSmallImage = YES;
    segmentedControl.lineHeightAll = YES;
    segmentedControl.delegate = self;
    [headView addSubview:segmentedControl];
    self.segmentedControl = segmentedControl;
    
    //初始化数据
    [self loadReflshData];
    
    //上提加载更多
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataArray)];
    // 隐藏当前的上拉刷新控件
    _tableView.footer.hidden = YES;
}

- (void)updateUiInfo
{
    //获取数据
    self.datasource = [ActivityInfo allNormalActivityInfos];
    [_tableView reloadData];
}

#pragma mark - UITableView Datasource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _datasource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datasource[section] count];
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
    if ([_datasource[indexPath.section] count] > 0) {
        cell.activityInfo = _datasource[indexPath.section][indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectIndex = indexPath;
    ActivityDetailInfoViewController *activityInfoVC = [[ActivityDetailInfoViewController alloc] initWithActivityInfo:_datasource[indexPath.section][indexPath.row]];
    [self.navigationController pushViewController:activityInfoVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.f;
    }else{
        if ([_datasource[section] count] > 0) {
            return kTableViewHeaderHeight;
        }else{
            return 0.f;
        }
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
    switch (index) {
        case 0:
        {
            if (_cityActivityTypeInfo.hidden == NO) {
                [_cityActivityTypeInfo dismissWithFrame:_tableView.frame];
            }
            if (_timeActivityTypeInfo.hidden) {
                _timeActivityTypeInfo.normalInfo = _selectTimeType;
                [_timeActivityTypeInfo showInViewWithFrame:_tableView.frame];
            }else{
                [_timeActivityTypeInfo dismissWithFrame:_tableView.frame];
            }
            
        }
            break;
        case 1:
            if (_timeActivityTypeInfo.hidden == NO) {
                [_timeActivityTypeInfo dismissWithFrame:_tableView.frame];
            }
            if (_cityActivityTypeInfo.hidden) {
                _cityActivityTypeInfo.normalInfo = _selectAddressType;
                [_cityActivityTypeInfo showInViewWithFrame:_tableView.frame];
            }else{
                [_cityActivityTypeInfo dismissWithFrame:_tableView.frame];
            }
            break;
        default:
            break;
    }
}

#pragma mark - Private
- (void)initData
{
    NSDictionary *params = @{@"date":@([_selectTimeType[@"cityid"] integerValue]),
                             @"cityid":@([_selectAddressType[@"cityid"] integerValue]),
                             @"page":@(_pageIndex),
                             @"size":@(_pageSize)};
    [WLHttpTool getActivitysParameterDic:params
                                 success:^(id JSON) {
                                     //隐藏加载更多动画
                                     [self.refreshControl endRefreshing];
                                     [_tableView.footer endRefreshing];
                                     
                                     DLog(@"---json:%@",JSON);
                                     if (JSON) {
                                         if (_pageIndex == 1) {
                                             //第一页
                                             [ActivityInfo deleteAllActivityInfoWithType:@(0)];
                                         }
                                         NSArray *activitys = [IActivityInfo objectsWithInfo:JSON];
                                         for (IActivityInfo *iActivityInfo in activitys) {
                                             [ActivityInfo createActivityInfoWith:iActivityInfo withType:@(0)];
                                         }
                                     }
                                     //获取数据
                                     self.datasource = [ActivityInfo allNormalActivityInfos];
                                     [_tableView reloadData];
                                     
                                     //设置是否可以下拉刷新
                                     if ([JSON count] != KCellConut) {
                                         _tableView.footer.hidden = YES;
                                     }else{
                                         _tableView.footer.hidden = NO;
                                         _pageIndex++;
                                     }
                                     
                                     if(([_datasource[0] count] + [_datasource[1] count]) == 0){
                                         [_tableView addSubview:self.notView];
                                         [_tableView sendSubviewToBack:self.notView];
                                     }else{
//                                         if ([_datasource[0] count] > 0) {
//                                             [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//                                         }else if ([_datasource[1] count] > 0){
//                                             [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//                                         }
                                         [_notView removeFromSuperview];
                                     }
                                 } fail:^(NSError *error) {
                                     [self.refreshControl endRefreshing];
                                     //隐藏加载更多动画
                                     [self.tableView.footer endRefreshing];
                                     DLog(@"getActivitysParameterDic error:%@",error.description);
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

//创建活动
- (void)createActivity
{
    [UIAlertView bk_showAlertViewWithTitle:@"创建活动"
                                   message:@"创建活动请登录my.welian.com"
                         cancelButtonTitle:@"好的"
                         otherButtonTitles:nil
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                       return ;
                                   }];
}

@end
