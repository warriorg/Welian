//
//  ProjectUserListViewController.m
//  Welian
//
//  Created by weLian on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectUserListViewController.h"
#import "ActivityUserViewCell.h"
#import "UserInfoBasicVC.h"
#import "MJRefresh.h"

@interface ProjectUserListViewController ()

@property (strong,nonatomic) NSArray *datasource;
@property (assign,nonatomic) NSInteger pageIndex;
@property (assign,nonatomic) NSInteger pageSize;

@end

@implementation ProjectUserListViewController

- (void)dealloc
{
    _datasource = nil;
    _projectDetailInfo = nil;
}

- (NSString *)title
{
    switch (_infoType) {
        case UserInfoTypeProjectGroup:
            return @"团队成员";
            break;
        case UserInfoTypeProjectZan:
            return @"赞过的人";
            break;
        default:
            return @"朋友列表";
            break;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageIndex = 1;
        self.pageSize = 20;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //隐藏tableiView分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //上提加载更多
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreDataArray)];
    
    //获取数据
    [self initData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //微信联系人
    static NSString *cellIdentifier = @"Project_UserList_Cell";
    
    ActivityUserViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ActivityUserViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.baseUser = _datasource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击点赞的人，进入
    IBaseUserM *user = _datasource[indexPath.row];
    //系统联系人
    UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:user isAsk:NO];
    [self.navigationController pushViewController:userInfoVC animated:YES];
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
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Private
//加载更多数据
- (void)loadMoreDataArray
{
    NSInteger total = 0;
    switch (_infoType) {
        case UserInfoTypeProjectGroup:
            total = _projectDetailInfo.membercount.integerValue;
            break;
        case UserInfoTypeProjectZan:
            total = _projectDetailInfo.zancount.integerValue;
            break;
        default:
            break;
    }
    if (_pageIndex * _pageSize >= total) {
        //隐藏加载更多动画
        [self.tableView footerEndRefreshing];
        [self.tableView setFooterHidden:YES];
    }else{
        _pageIndex++;
        [self initData];
    }
}

//获取数据
- (void)initData
{
    switch (_infoType) {
        case UserInfoTypeProjectGroup:
            [self initGroupUserData];
            break;
        case UserInfoTypeProjectZan:
            [self initZanUserData];
            break;
        default:
            break;
    }
}

//取赞的用户列表
- (void)initZanUserData
{
    [WLHttpTool getProjectZanUsersParameterDic:@{@"pid":_projectDetailInfo.pid,@"page":@(_pageIndex),@"size":@(_pageSize)}
                                       success:^(id JSON) {
                                           //隐藏加载更多动画
                                           [self.tableView footerEndRefreshing];
                                           
                                           self.datasource = [IBaseUserM objectsWithInfo:JSON];
                                           [self.tableView reloadData];
                                       } fail:^(NSError *error) {
                                           [UIAlertView showWithError:error];
                                       }];
}

//取团队成员的用户列表
- (void)initGroupUserData
{
    [WLHttpTool getProjectMembersParameterDic:@{@"pid":_projectDetailInfo.pid,@"page":@(_pageIndex),@"size":@(_pageSize)}
                                      success:^(id JSON) {
                                          //隐藏加载更多动画
                                          [self.tableView footerEndRefreshing];
                                          
                                          self.datasource = [IBaseUserM objectsWithInfo:JSON];
                                          [self.tableView reloadData];
                                      } fail:^(NSError *error) {
                                          [UIAlertView showWithError:error];
                                      }];
}

@end
