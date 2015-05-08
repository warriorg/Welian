//
//  ProjectUserListViewController.m
//  Welian
//
//  Created by weLian on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectUserListViewController.h"
#import "UserInfoViewController.h"

#import "ActivityUserViewCell.h"
#import "MJRefresh.h"

@interface ProjectUserListViewController ()

@property (strong,nonatomic) NSMutableArray *datasource;
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
//            return @"朋友列表";
            break;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageIndex = 1;
        self.pageSize = KCellConut;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.pageIndex = 1;
        self.pageSize = KCellConut;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //隐藏tableiView分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.datasource = [NSMutableArray array];
    
    //上提加载更多
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataArray)];
    
//    [self.tableView addFooterWithTarget:self action:@selector(loadMoreDataArray)];
    
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
    cell.indexPath = indexPath;
    cell.baseUser = _datasource[indexPath.row];
    WEAKSELF
    [cell setAddFriendBlock:^(NSIndexPath *indexPath){
        [weakSelf addFriendWithIndex:indexPath];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击点赞的人，进入
    IBaseUserM *user = _datasource[indexPath.row];
    //friendship /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
    //    NSString *friendship = info[@"friendship"];
    if(user.uid != nil){
        //系统联系人
//        UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:user isAsk:NO];
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithBaseUserM:user OperateType:nil HidRightBtn:NO];
        [self.navigationController pushViewController:userInfoVC animated:YES];
        //添加好友成功
        [userInfoVC setAddFriendBlock:^(){
            
            IBaseUserM *newUser = _datasource[indexPath.row];
            newUser.friendship = @(4);
            
            //改变数组，刷新列表
            [self.datasource replaceObjectAtIndex:indexPath.row withObject:newUser];
            //刷新列表
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
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
        [self.tableView.footer endRefreshing];
        self.tableView.footer.hidden = YES;
    }else{
        _pageIndex++;
        self.tableView.footer.hidden = NO;
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
    [WeLianClient getProjectZanListWithPid:_projectDetailInfo.pid
                                      Page:@(_pageIndex)
                                      Size:@(_pageSize)
                                   Success:^(id resultInfo) {
                                       //隐藏加载更多动画
                                       [self.tableView.footer endRefreshing];
                                       
                                       if ([resultInfo count] > 0) {
                                           [self.datasource addObjectsFromArray:resultInfo];
                                       }
                                       
                                       //设置是否可以下拉刷新
                                       if ([resultInfo count] != KCellConut) {
                                           self.tableView.footer.hidden = YES;
                                       }else{
                                           self.tableView.footer.hidden = NO;
                                       }
                                       
                                       [self.tableView reloadData];
                                   } Failed:^(NSError *error) {
                                       //隐藏加载更多动画
                                       [self.tableView.footer endRefreshing];
                                       DLog(@"getProjectZanList error:%@",error.description);
                                   }];
    
//    [WLHttpTool getProjectZanUsersParameterDic:@{@"pid":_projectDetailInfo.pid,@"page":@(_pageIndex),@"size":@(_pageSize)}
//                                       success:^(id JSON) {
//                                           //隐藏加载更多动画
//                                           [self.tableView.footer endRefreshing];
//                                           
//                                           if([JSON count] > 0){
//                                               NSArray *users = [NSMutableArray arrayWithArray:[IBaseUserM objectsWithInfo:JSON]];
//                                               [self.datasource addObjectsFromArray:users];
//                                           }
//                                           
//                                           //设置是否可以下拉刷新
//                                           if ([JSON count] != KCellConut) {
//                                               self.tableView.footer.hidden = YES;
//                                           }else{
//                                               self.tableView.footer.hidden = NO;
//                                           }
//                                           
//                                           [self.tableView reloadData];
//                                       } fail:^(NSError *error) {
////                                           [UIAlertView showWithError:error];
//                                       }];
}

//取团队成员的用户列表
- (void)initGroupUserData
{
    [WeLianClient getProjectMembersWithPid:_projectDetailInfo.pid
                                   Success:^(id resultInfo) {
                                       //隐藏加载更多动画
                                       [self.tableView.footer endRefreshing];
                                       
                                       if ([resultInfo count] > 0) {
                                           [self.datasource addObjectsFromArray:resultInfo];
                                       }
                                       
                                       //设置是否可以下拉刷新
//                                       if ([resultInfo count] != KCellConut) {
                                           self.tableView.footer.hidden = YES;
//                                       }else{
//                                           self.tableView.footer.hidden = NO;
//                                       }
                                       
                                       [self.tableView reloadData];
                                   } Failed:^(NSError *error) {
                                       //隐藏加载更多动画
                                       [self.tableView.footer endRefreshing];
                                       DLog(@"getProjectMembers error:%@",error.description);
                                   }];
    
//    [WLHttpTool getProjectMembersParameterDic:@{@"pid":_projectDetailInfo.pid,@"page":@(_pageIndex),@"size":@(_pageSize)}
//                                      success:^(id JSON) {
//                                          //隐藏加载更多动画
//                                          [self.tableView.footer endRefreshing];
//                                          
//                                          if([JSON count] > 0){
//                                              NSArray *users = [NSMutableArray arrayWithArray:[IBaseUserM objectsWithInfo:JSON]];
//                                              [self.datasource addObjectsFromArray:users];
//                                          }
//                                          
//                                          //设置是否可以下拉刷新
//                                          if ([JSON count] != KCellConut) {
//                                              self.tableView.footer.hidden = YES;
//                                          }else{
//                                              self.tableView.footer.hidden = NO;
//                                          }
//                                          
//                                          [self.tableView reloadData];
//                                      } fail:^(NSError *error) {
////                                          [UIAlertView showWithError:error];
//                                      }];
}

- (void)addFriendWithIndex:(NSIndexPath *)indexPath
{
    //friendship /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
    IBaseUserM *userInfo = _datasource[indexPath.row];
    if(userInfo.uid != nil && userInfo.friendship.integerValue != 1){
        //添加
        DLog(@"添加好友");
        //添加好友，发送添加成功，状态变成待验证
        LogInUser *loginUser = [LogInUser getCurrentLoginUser];
        UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"好友验证" message:[NSString stringWithFormat:@"发送至好友：%@",userInfo.name]];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"我是%@的%@",loginUser.company,loginUser.position]];
        [alert bk_addButtonWithTitle:@"取消" handler:nil];
        [alert bk_addButtonWithTitle:@"发送" handler:^{
            //发送好友请求
            [WLHUDView showHUDWithStr:@"发送中..." dim:NO];
            [WeLianClient requestAddFriendWithID:userInfo.uid
                                         Message:[alert textFieldAtIndex:0].text
                                         Success:^(id resultInfo) {
                                             IBaseUserM *newUser = _datasource[indexPath.row];
                                             newUser.friendship = @(4);
                                             
                                             //改变数组，刷新列表
                                             [self.datasource replaceObjectAtIndex:indexPath.row withObject:newUser];
                                             //刷新列表
                                             [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                             [WLHUDView showSuccessHUD:@"好友请求已发送"];
                                         } Failed:^(NSError *error) {
                                             if (error) {
                                                 [WLHUDView showErrorHUD:error.localizedDescription];
                                             }else{
                                                 [WLHUDView showErrorHUD:@"发送失败，请重试"];
                                             }
                                         }];
            
//            [WLHttpTool requestFriendParameterDic:@{@"fid":userInfo.uid,@"message":[alert textFieldAtIndex:0].text} success:^(id JSON) {
//                [WLHUDView showSuccessHUD:@"好友验证发送成功！"];
//                IBaseUserM *newUser = _datasource[indexPath.row];
//                newUser.friendship = @(4);
//                
//                //改变数组，刷新列表
//                [self.datasource replaceObjectAtIndex:indexPath.row withObject:newUser];
//                //刷新列表
//                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            } fail:^(NSError *error) {
//                
//            }];
        }];
        [alert show];
    }
}

@end
