//
//  ActivityUserListViewController.m
//  Welian
//
//  Created by weLian on 15/1/20.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityUserListViewController.h"
#import "UserInfoViewController.h"

#import "MJRefresh.h"
#import "ActivityUserViewCell.h"
#import "NotstringView.h"

@interface ActivityUserListViewController ()

@property (strong,nonatomic) NSString *activeId;
@property (strong,nonatomic) NSMutableArray *datasource;

@property (assign,nonatomic) NSInteger pageIndex;
@property (assign,nonatomic) NSInteger pageSize;
@property (assign,nonatomic) NSInteger allPages;
@property (assign,nonatomic) NSInteger totalNum;

@property (strong,nonatomic) NotstringView *noDataNotView;//提醒

@end

@implementation ActivityUserListViewController

- (void)dealloc
{
    _activeId = nil;
    _datasource = nil;
    _noDataNotView = nil;
}

- (NotstringView *)noDataNotView
{
    if (!_noDataNotView) {
        _noDataNotView = [[NotstringView alloc] initWithFrame:self.tableView.frame withTitleStr:@"该活动暂无报名人员！"];
    }
    return _noDataNotView;
}

- (instancetype)initWithStyle:(UITableViewStyle)style activeInfo:(NSArray *)activeInfo
{
    self = [super initWithStyle:style];
    if (self) {
        self.pageIndex = 1;
        self.pageSize = KCellConut;
        self.activeId = activeInfo[0];
        self.totalNum = [activeInfo[1] integerValue];
        self.allPages = ceil((float)_totalNum/(float)_pageSize);
        self.datasource = [NSMutableArray array];
        self.title = [NSString stringWithFormat:@"报名列表(%@人)",activeInfo[1]];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style ActiveInfo:(ActivityInfo *)activeInfo
{
    self = [super initWithStyle:style];
    if (self) {
        self.pageIndex = 1;
        self.pageSize = KCellConut;
        self.activeId = activeInfo.activeid.stringValue;
        self.totalNum = activeInfo.joined.integerValue;
        self.allPages = ceil((float)_totalNum/(float)_pageSize);
        self.datasource = [NSMutableArray array];
        self.title = [NSString stringWithFormat:@"报名列表(%@人)",activeInfo.joined];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //隐藏tableiView分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (_totalNum == 0) {
        [self.tableView addSubview:self.noDataNotView];
        [self.tableView sendSubviewToBack:self.noDataNotView];
    }
    
    //上提加载更多
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataArray)];
    // 隐藏当前的上拉刷新控件
    self.tableView.footer.hidden = YES;
    
    //加载数据
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
    static NSString *cellIdentifier = @"ActivityUserList_Cell";
    
    ActivityUserViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ActivityUserViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.indexPath = indexPath;
//    cell.activityUserData = _datasource[indexPath.row];
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
    
    IBaseUserM *baseUser = _datasource[indexPath.row];
//    NSDictionary *info = _datasource[indexPath.row];
//    NSString *uid = info[@"uid"];
    //friendship /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
//    NSString *friendship = info[@"friendship"];
    if(baseUser.uid != nil){
//        IBaseUserM *baseUser = [[IBaseUserM alloc] init];
//        baseUser.name = info[@"name"];
//        baseUser.uid = info[@"uid"];
//        baseUser.friendship = @([info[@"friendship"] integerValue]);
        //系统联系人
//        UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:baseUser isAsk:NO];
        
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithBaseUserM:baseUser OperateType:nil HidRightBtn:NO];
        [self.navigationController pushViewController:userInfoVC animated:YES];
        
        //添加好友成功
        [userInfoVC setAddFriendBlock:^(){
            NSMutableDictionary *infoDic =  [NSMutableDictionary dictionaryWithDictionary:_datasource[indexPath.row]];
            //重置好友关系
            [infoDic setValue:@"4" forKey:@"friendship"];
            //改变数组，刷新列表
            [self.datasource replaceObjectAtIndex:indexPath.row withObject:infoDic];
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
//获取数据
- (void)initData
{
    [WeLianClient getActiveRecordersWithID:@(_activeId.integerValue)
                                      Page:@(_pageIndex)
                                      Size:@(_pageSize)
                                   Success:^(id resultInfo) {
                                       //隐藏加载更多动画
                                       [self.tableView.footer endRefreshing];
                                       
                                       NSArray *records = resultInfo;
                                       
                                       if (records.count > 0) {
                                           [self.datasource addObjectsFromArray:records];
                                       }
                                       
                                       //设置是否可以下拉刷新
                                       if ([records count] != KCellConut) {
                                           self.tableView.footer.hidden = YES;
                                       }else{
                                           self.tableView.footer.hidden = NO;
                                       }
                                       
                                       if (_datasource.count > 0) {
                                           [_noDataNotView removeFromSuperview];
                                       }else{
                                           [self.tableView addSubview:self.noDataNotView];
                                           [self.tableView sendSubviewToBack:self.noDataNotView];
                                       }
                                       
                                       [self.tableView reloadData];
                                   } Failed:^(NSError *error) {
                                       //隐藏加载更多动画
                                       [self.tableView.footer endRefreshing];
                                   }];
    
//    [WLHttpTool loadActiveRecordsParameterDic:@{@"activeid":_activeId,@"page":@(_pageIndex),@"size":@(_pageSize)}
//                                      success:^(id JSON) {
//                                          //隐藏加载更多动画
//                                          [self.tableView.footer endRefreshing];
////                                          NSInteger count = [JSON[@"count"] integerValue];
//                                          NSArray *records = JSON[@"records"];
//                                          
//                                          if (records.count > 0) {
//                                              [self.datasource addObjectsFromArray:records];
//                                          }
//                                          
//                                          //设置是否可以下拉刷新
//                                          if ([records count] != KCellConut) {
//                                              self.tableView.footer.hidden = YES;
//                                          }else{
//                                              self.tableView.footer.hidden = NO;
//                                          }
//                                          
//                                          if (_datasource.count > 0) {
//                                              [_noDataNotView removeFromSuperview];
//                                          }else{
//                                              [self.tableView addSubview:self.noDataNotView];
//                                              [self.tableView sendSubviewToBack:self.noDataNotView];
//                                          }
//                                          
//                                          [self.tableView reloadData];
//                                      } fail:^(NSError *error) {
//                                          //隐藏加载更多动画
//                                          [self.tableView.footer endRefreshing];
////                                          [UIAlertView showWithError:error];
//                                      }];
}

//加载更多数据
- (void)loadMoreDataArray
{
    if (_pageIndex < _allPages) {
        _pageIndex ++;
        self.tableView.footer.hidden = NO;
        [self initData];
    }else{
        //隐藏加载更多动画
        [self.tableView.footer endRefreshing];
        self.tableView.footer.hidden = YES;
    }
}

- (void)addFriendWithIndex:(NSIndexPath *)indexPath
{
    //friendship /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
    IBaseUserM *baseUser = _datasource[indexPath.row];
//    NSDictionary *info = _datasource[indexPath.row];
//    NSString *uid = info[@"uid"];
//    NSString *friendship = info[@"friendship"];
//    NSString *name = info[@"name"];
//    NSString *wlname = [info[@"wlname"] length] == 0 ? name : info[@"wlname"];
    
    if(baseUser.uid != nil && baseUser.friendship.integerValue != 1){
        //添加
        DLog(@"添加好友");
        NSString *wlname = baseUser.wlname.length == 0 ? baseUser.name : baseUser.wlname;
        
        //添加好友，发送添加成功，状态变成待验证
        LogInUser *loginUser = [LogInUser getCurrentLoginUser];
        UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"好友验证" message:[NSString stringWithFormat:@"发送至好友：%@",wlname]];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"我是%@的%@",loginUser.company,loginUser.position]];
        [alert bk_addButtonWithTitle:@"取消" handler:nil];
        [alert bk_addButtonWithTitle:@"发送" handler:^{
            //发送好友请求
            [WLHUDView showHUDWithStr:@"发送中..." dim:NO];
            [WeLianClient requestAddFriendWithID:baseUser.uid
                                         Message:[alert textFieldAtIndex:0].text
                                         Success:^(id resultInfo) {
                                             NSMutableDictionary *infoDic =  [NSMutableDictionary dictionaryWithDictionary:_datasource[indexPath.row]];
                                             //重置好友关系
                                             [infoDic setValue:@"4" forKey:@"friendship"];
                                             //                //发送邀请成功，修改状态，刷新列表
                                             //                NeedAddUser *addUser = [needAddUser updateFriendShip:4];
                                             //改变数组，刷新列表
                                             [self.datasource replaceObjectAtIndex:indexPath.row withObject:infoDic];
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
            
//            [WLHttpTool requestFriendParameterDic:@{@"fid":uid,@"message":[alert textFieldAtIndex:0].text} success:^(id JSON) {
//                [WLHUDView showSuccessHUD:@"好友验证发送成功！"];
//                NSMutableDictionary *infoDic =  [NSMutableDictionary dictionaryWithDictionary:_datasource[indexPath.row]];
//                //重置好友关系
//                [infoDic setValue:@"4" forKey:@"friendship"];
////                //发送邀请成功，修改状态，刷新列表
////                NeedAddUser *addUser = [needAddUser updateFriendShip:4];
//                //改变数组，刷新列表
//                [self.datasource replaceObjectAtIndex:indexPath.row withObject:infoDic];
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
