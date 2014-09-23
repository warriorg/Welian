//
//  MyLocationController.m
//  Welian
//
//  Created by dong on 14-9-18.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "MyLocationController.h"
#import "WLHUDView.h"
#import "UIScrollView+SVInfiniteScrolling.h"
//#import "XHRefreshControl.h"
//#import <CoreLocation/CoreLocation.h>


@interface MyLocationController ()<BMKPoiSearchDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

{
    NSMutableArray *_dataArray;
    LocationBlok _locationBlock;
}
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BMKPoiSearch *searcher;
//@property (nonatomic, strong) UIRefreshControl *refreshCont;
@property (nonatomic, strong) BMKNearbySearchOption *option;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayVC;
@property (nonatomic, strong) NSArray *searArray;

@end

@implementation MyLocationController

//- (UITableView*)tableView
//{
//    if (_tableView==nil) {
//        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//        [_tableView setDelegate:self];
//        [_tableView setDataSource:self];
//        [self.view addSubview:_tableView];
//        self.refreshCont = [[UIRefreshControl alloc] init];
//        [self.refreshCont addTarget:self action:@selector(beginPullDownRefreshing) forControlEvents:UIControlEventValueChanged];
//    }
//    return _tableView;
//}

- (BMKPoiSearch*)searcher
{
    if (_searcher == nil) {
        _searcher =[[BMKPoiSearch alloc]init];
    }
    return _searcher;
}

- (BMKNearbySearchOption*)option
{
    if (_option == nil) {
        _option = [[BMKNearbySearchOption alloc]init];
    }
    return _option;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _dataArray = [NSMutableArray array];
    [self statLocationMy];
}

- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    [self stopLocationMy];
    //初始化检索对象
    self.searcher.delegate = self;
    //发起检索
    self.option.pageIndex = 0;
    self.option.pageCapacity = 20;
    
    self.option.location =  userLocation.location.coordinate;
    
    self.option.keyword = @"酒店";
    [self beginLoadMoreRefreshing];
    
}

- (instancetype)initWithLocationBlock:(LocationBlok)locationBlock
{
    self = [super init];
    if (self) {
        _locationBlock = locationBlock;
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(beginPullDownRefreshing) forControlEvents:UIControlEventValueChanged];
        [self.refreshControl beginRefreshing];
        [self addUIViewsear];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)addUIViewsear
{
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar setPlaceholder:@"搜索附件"];
    [self.searchBar setDelegate:self];
    
    [self.tableView setTableHeaderView:self.searchBar];
    [self.searchBar sizeToFit];
    
    self.searchDisplayVC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    [self.searchDisplayVC setSearchResultsDataSource:self];
    [self.searchDisplayVC setSearchResultsDelegate:self];
    [self.searchDisplayVC setDelegate:self];
}


- (void)beginPullDownRefreshing
{
    self.option.pageIndex = 0;
    [self statLocationMy];
}


- (void)beginLoadMoreRefreshing
{
    BOOL flag = [self.searcher poiSearchNearBy:self.option];
    //    [WLHUDView showHUDWithStr:@"" dim:NO];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        [WLHUDView showErrorHUD:@"周边检索发送失败"];
    }
    
}

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        [self.refreshControl endRefreshing];
        [self.tableView.infiniteScrollingView stopAnimating];
        [WLHUDView hiddenHud];
        if (self.option.pageIndex==0) {
            [_dataArray removeAllObjects];
        }
        //在此处理正常结果d
        for (BMKPoiInfo *info in poiResultList.poiInfoList) {
            [_dataArray addObject:info];
        }
        if (_dataArray.count) {
            __weak MyLocationController *weakSelf = self;
            [self.tableView addInfiniteScrollingWithActionHandler:^{
                [weakSelf beginLoadMoreRefreshing];
            }];
        }
        _option.pageIndex++;
        [self.tableView reloadData];
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        [WLHUDView showErrorHUD:@"起始点有歧义"];
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
    } else {
        [WLHUDView showErrorHUD:@"抱歉，未找到结果"];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellind = @"cellindse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellind];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellind];
    }
    
    BMKPoiInfo *info = _dataArray[indexPath.row];
    [cell.textLabel setText:info.name];
    [cell.detailTextLabel setText:info.address];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *selecell = [tableView cellForRowAtIndexPath:indexPath];
    [selecell setAccessoryType:UITableViewCellAccessoryCheckmark];
    BMKPoiInfo *info = _dataArray[indexPath.row];
    _locationBlock(info);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [WLHUDView hiddenHud];
    [self stopLocationMy];
    
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
