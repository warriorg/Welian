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

#define kHeaderHeight 43.f
#define kTableViewCellHeight 98.f
#define kTableViewHeaderHeight 25.f

@interface ActivityListViewController ()<UITableViewDataSource,UITableViewDelegate,WLSegmentedControlDelegate>

@property (assign,nonatomic) WLSegmentedControl *segmentedControl;
@property (assign,nonatomic) UITableView *tableView;
@property (strong,nonatomic) ActivityTypeInfoView *timeActivityTypeInfo;
@property (strong,nonatomic) ActivityTypeInfoView *cityActivityTypeInfo;

@property (strong,nonatomic) NSArray *datasource;

@property (strong,nonatomic) NSString *selectTimeType;
@property (strong,nonatomic) NSString *selectAddressType;

@end

@implementation ActivityListViewController

- (void)dealloc
{
    _datasource = nil;
    _cityActivityTypeInfo = nil;
    _timeActivityTypeInfo = nil;
    _selectTimeType = nil;
    _selectAddressType = nil;
}

- (NSString *)title
{
    return @"活动";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.datasource = @[@"",@"",@"",@""];
        self.selectTimeType = @"全部";
        self.selectAddressType = @"全国";
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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f,ViewCtrlTopBarHeight + kHeaderHeight,self.view.width,self.view.height - ViewCtrlTopBarHeight - kHeaderHeight)];
    tableView.dataSource = self;
    tableView.delegate = self;
    //隐藏表格分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    ActivityTypeInfoView *timeActivityTypeInfo = [[ActivityTypeInfoView alloc] initWithFrame:CGRectMake(0.f, tableView.top, self.view.width, tableView.height)];
    timeActivityTypeInfo.hidden = YES;
    timeActivityTypeInfo.datasource = @[@"全部",@"今天",@"明天",@"最近一周",@"周末"];
    WEAKSELF
    [timeActivityTypeInfo setBlock:^(NSString *info){
//        [weakSelf dismissTimeTypeInfo];
        weakSelf.selectTimeType = info;
        weakSelf.segmentedControl.titles = @[_selectTimeType,_selectAddressType];
    }];
    [self.view addSubview:timeActivityTypeInfo];
    self.timeActivityTypeInfo = timeActivityTypeInfo;
    
    ActivityTypeInfoView *cityActivityTypeInfo = [[ActivityTypeInfoView alloc] initWithFrame:CGRectMake(0.f, tableView.top, self.view.width, tableView.height)];
    cityActivityTypeInfo.hidden = YES;
    cityActivityTypeInfo.showLocation = YES;//显示当前定位的城市
    cityActivityTypeInfo.datasource = @[@"定位中...",@"全国",@"杭州",@"上海",@"北京",@"广州",@"深圳",@"武汉"];
    [cityActivityTypeInfo setBlock:^(NSString *info){
//        [weakSelf dismissCityTypeInfo];
        weakSelf.selectAddressType = info;
        weakSelf.segmentedControl.titles = @[_selectTimeType,_selectAddressType];
    }];
    [self.view addSubview:cityActivityTypeInfo];
    self.cityActivityTypeInfo = cityActivityTypeInfo;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(.0f,ViewCtrlTopBarHeight, self.view.height, kHeaderHeight)];
    headView.layer.borderColorFromUIColor = RGB(231.f, 231.f, 231.f);
    headView.layer.borderWidths = @"{0,0,0.6,0}";
    [self.view addSubview:headView];
    
    //操作栏
    WLSegmentedControl *segmentedControl = [[WLSegmentedControl alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, headView.height - 0.5) Titles:@[_selectTimeType,_selectAddressType] Images:nil Bridges:nil isHorizontal:YES];
    segmentedControl.showSmallImage = YES;
    segmentedControl.lineHeightAll = YES;
    segmentedControl.delegate = self;
    [headView addSubview:segmentedControl];
    self.segmentedControl = segmentedControl;
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
//- (void)showTimeTypeInfo
//{
//    _timeActivityTypeInfo.bottom = _tableView.top;
//    _timeActivityTypeInfo.backgroundColor = [UIColor clearColor];
//    [UIView animateWithDuration:.3f
//                          delay:.0f
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         _timeActivityTypeInfo.top = _tableView.top;
//                         _timeActivityTypeInfo.hidden = NO;
//                         _timeActivityTypeInfo.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//                     } completion:^(BOOL finished) {
//                         _timeActivityTypeInfo.hidden = NO;
//                         _timeActivityTypeInfo.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//                         _timeActivityTypeInfo.top = _tableView.top;
//                     }];
//}

//- (void)dismissTimeTypeInfo
//{
//    [UIView animateWithDuration:.2f
//                          delay:.0f
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         _timeActivityTypeInfo.bottom = _tableView.top;
//                         _timeActivityTypeInfo.backgroundColor = [UIColor clearColor];
//                     } completion:^(BOOL finished) {
//                         _timeActivityTypeInfo.hidden = YES;
//                         _timeActivityTypeInfo.bottom = _tableView.top;
//                         _timeActivityTypeInfo.backgroundColor = [UIColor clearColor];
//                     }];
//}

//- (void)showCityTypeInfo
//{
//    _cityActivityTypeInfo.bottom = _tableView.top;
//    _cityActivityTypeInfo.backgroundColor = [UIColor clearColor];
//    [UIView animateWithDuration:.3f
//                          delay:.0f
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         _cityActivityTypeInfo.top = _tableView.top;
//                         _cityActivityTypeInfo.hidden = NO;
//                         _cityActivityTypeInfo.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//                     } completion:^(BOOL finished) {
//                         _cityActivityTypeInfo.hidden = NO;
//                         _cityActivityTypeInfo.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//                         _cityActivityTypeInfo.top = _tableView.top;
//                     }];
//}
//
//- (void)dismissCityTypeInfo
//{
//    [UIView animateWithDuration:.2f
//                          delay:.0f
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         _cityActivityTypeInfo.bottom = _tableView.top;
//                         _cityActivityTypeInfo.backgroundColor = [UIColor clearColor];
//                     } completion:^(BOOL finished) {
//                         _cityActivityTypeInfo.hidden = YES;
//                         _cityActivityTypeInfo.bottom = _tableView.top;
//                         _cityActivityTypeInfo.backgroundColor = [UIColor clearColor];
//                     }];
//}


@end
