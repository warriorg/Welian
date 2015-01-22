//
//  ActivityUserListViewController.m
//  Welian
//
//  Created by weLian on 15/1/20.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityUserListViewController.h"
#import "MJRefresh.h"
#import "ActivityUserViewCell.h"
#import "UserInfoBasicVC.h"

@interface ActivityUserListViewController ()

@property (strong,nonatomic) NSString *activeId;
@property (strong,nonatomic) NSMutableArray *datasource;

@property (assign,nonatomic) NSInteger pageIndex;
@property (assign,nonatomic) NSInteger pageSize;
@property (assign,nonatomic) NSInteger allPages;

@end

@implementation ActivityUserListViewController

- (void)dealloc
{
    _activeId = nil;
    _datasource = nil;
}

- (instancetype)initWithStyle:(UITableViewStyle)style activeInfo:(NSArray *)activeInfo
{
    self = [super initWithStyle:style];
    if (self) {
        self.pageIndex = 0;
        self.pageSize = 15;
        self.activeId = activeInfo[0];
        self.allPages = ceilf([activeInfo[1] integerValue] / _pageSize);
        self.datasource = [NSMutableArray array];
        self.title = [NSString stringWithFormat:@"报名列表(%@人)",activeInfo[1]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //隐藏tableiView分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //加载数据
    [self initData];
    
    //上提加载更多
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreDataArray)];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //微信联系人
    static NSString *cellIdentifier = @"ActivityUserList_Cell";
    
    ActivityUserViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ActivityUserViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.indexPath = indexPath;
    cell.activityUserData = _datasource[indexPath.row];
    WEAKSELF
    [cell setAddFriendBlock:^(NSIndexPath *indexPath){
        [weakSelf addFriendWithIndex:indexPath];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *info = _datasource[indexPath.row];
    NSString *uid = info[@"uid"];
    //friendship /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
//    NSString *friendship = info[@"friendship"];
    if(uid != nil){
        IBaseUserM *baseUser = [[IBaseUserM alloc] init];
        baseUser.name = info[@"name"];
        baseUser.uid = info[@"uid"];
        baseUser.friendship = @([info[@"friendship"] integerValue]);
        //系统联系人
        UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:baseUser isAsk:NO];
        //    __weak UserInfoBasicVC *weakUserInfoVC = userInfoVC;
        //    WEAKSELF
        //添加好友成功
        //    userInfoVC.acceptFriendBlock = ^(){
        //
        //    };
        [self.navigationController pushViewController:userInfoVC animated:YES];
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
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Private
//获取数据
- (void)initData
{
    [WLHttpTool loadActiveRecordsParameterDic:@{@"activeid":_activeId,@"page":@(_pageIndex),@"size":@(_pageSize)}
                                      success:^(id JSON) {
                                          //隐藏加载更多动画
                                          [self.tableView footerEndRefreshing];
                                          if ([JSON count] > 0) {
                                              [self.datasource addObjectsFromArray:JSON];
                                          }
                                          [self.tableView reloadData];
                                      } fail:^(NSError *error) {
                                          //隐藏加载更多动画
                                          [self.tableView footerEndRefreshing];
                                          [UIAlertView showWithError:error];
                                      }];
}

//加载更多数据
- (void)loadMoreDataArray
{
    if (_pageIndex < _allPages) {
        _pageIndex ++;
    }
    [self initData];
}

- (void)addFriendWithIndex:(NSIndexPath *)indexPath
{
    //friendship /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
    NSDictionary *info = _datasource[indexPath.row];
    NSString *uid = info[@"uid"];
    NSString *friendship = info[@"friendship"];
    NSString *name = info[@"name"];
    NSString *wlname = [info[@"wlname"] length] == 0 ? name : info[@"wlname"];
    if(uid != nil && friendship.integerValue != 1){
        //添加
        DLog(@"添加好友");
        //添加好友，发送添加成功，状态变成待验证
        LogInUser *loginUser = [LogInUser getCurrentLoginUser];
        UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"好友验证" message:[NSString stringWithFormat:@"发送至好友：%@",wlname]];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"我是%@的%@",loginUser.company,loginUser.position]];
        [alert bk_addButtonWithTitle:@"取消" handler:nil];
        [alert bk_addButtonWithTitle:@"发送" handler:^{
            //发送好友请求
            [WLHttpTool requestFriendParameterDic:@{@"fid":uid,@"message":[alert textFieldAtIndex:0].text} success:^(id JSON) {
                [UIAlertView showWithTitle:@"系统提示" message:@"好友请求已发送！"];
//                //发送邀请成功，修改状态，刷新列表
//                NeedAddUser *addUser = [needAddUser updateFriendShip:4];
//                //改变数组，刷新列表
//                [self.datasource replaceObjectAtIndex:indexPath.row withObject:addUser];
                //刷新列表
//                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            } fail:^(NSError *error) {
                
            }];
        }];
        [alert show];
    }
}

@end
