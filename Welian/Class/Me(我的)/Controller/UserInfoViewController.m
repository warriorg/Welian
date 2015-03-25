//
//  UserInfoViewController.m
//  Welian
//
//  Created by weLian on 15/3/25.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "UserInfoViewController.h"

#import "WLCustomSegmentedControl.h"
#import "UserInfoView.h"

#define kTableViewHeaderViewHeight 198.f

#define kTableViewCellHeight 60.f
#define kTableViewHeaderHeight 45.f

@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (assign,nonatomic) UITableView *tableView;
@property (strong,nonatomic) WLCustomSegmentedControl *wlSegmentedControl;
@property (strong,nonatomic) NSArray *datasource;
@property (assign,nonatomic) NSInteger selectType;//选择的类型
@property (strong,nonatomic) IBaseUserM *baseUserModel;

@end

@implementation UserInfoViewController

- (void)dealloc
{
    _wlSegmentedControl = nil;
    _datasource = nil;
    _baseUserModel = nil;
}

- (NSString *)title
{
    return @"详细信息";
}

- (WLCustomSegmentedControl *)wlSegmentedControl
{
    if (!_wlSegmentedControl) {
        _wlSegmentedControl = [[WLCustomSegmentedControl alloc] initWithSectionTitles:@[@"个人信息", @"动态", @"共同好友"]];
        _wlSegmentedControl.frame = CGRectMake(0, kTableViewHeaderViewHeight - 38.f, self.view.width, 38.f);
        _wlSegmentedControl.selectedTextColor = kTitleNormalTextColor;
        _wlSegmentedControl.textColor = kTitleNormalTextColor;
        _wlSegmentedControl.detailTextColor = KBlueTextColor;
        _wlSegmentedControl.selectionIndicatorHeight = 2;//设置底部滑块的高度
        _wlSegmentedControl.selectionIndicatorColor = KBlueTextColor;
        _wlSegmentedControl.showBottomLine = YES;
        _wlSegmentedControl.showLine = YES;//显示分割线
//        _wlSegmentedControl.isShowVertical = YES;//纵向显示
        _wlSegmentedControl.isAllowTouchEveryTime = YES;//允许重复点击
        _wlSegmentedControl.detailLabelFont = [UIFont boldSystemFontOfSize:14.f];
        _wlSegmentedControl.font = [UIFont systemFontOfSize:14.f];
        //设置边线
        _wlSegmentedControl.layer.borderColorFromUIColor = WLLineColor;
        _wlSegmentedControl.layer.borderWidths = @"{0,0,0.8,0}";
        _wlSegmentedControl.layer.masksToBounds = YES;
    }
    return _wlSegmentedControl;
}

- (instancetype)initWithBaseUserM:(IBaseUserM *)iBaseUserModel
{
    self = [super init];
    if (self) {
        self.selectType = 0;
        self.baseUserModel = iBaseUserModel;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scrollViewDidScroll:_tableView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar reset];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    UIColor *color = kNavBgColor;
    if (offsetY > kTableViewHeaderViewHeight/3) {
        CGFloat alpha = 1 - ((kTableViewHeaderViewHeight/3 + 64 - offsetY) / 64);
        
        [self.navigationController.navigationBar useBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar useBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //tableview头部距离问题
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //更多操作
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_more"] style:UIBarButtonItemStyleBordered target:self action:@selector(moreBtnClicked)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0.f,0.f,self.view.width,self.view.height) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    //隐藏表格分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    //设置头部
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, kTableViewHeaderViewHeight)];
    UserInfoView *userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, kTableViewHeaderViewHeight - 38.f)];
    userInfoView.baseUserModel = _baseUserModel;
    [headerView addSubview:userInfoView];
    
    //切换按钮
    [headerView addSubview:self.wlSegmentedControl];
    _wlSegmentedControl.sectionDetailTitles = @[@"",@"2",@"106"];
    
    [_tableView setTableHeaderView:headerView];
    
    WEAKSELF
    [_wlSegmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf selectIndexChanged:index];
    }];
    
    //设置默认选择
    [self selectIndexChanged:_selectType];
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
    titleLabel.text = @"投资";
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
    static NSString *cellIdentifier = @"UserInfo_View_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KTableHeaderHeight;
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
//选择的按钮
- (void)selectIndexChanged:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
}

//更多按钮操作
- (void)moreBtnClicked
{
    UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [sheet bk_setDestructiveButtonWithTitle:@"删除该好友" handler:^{
        [self deleteFriend];
    }];
    [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [sheet showInView:self.view];
}

// 删除好友
- (void)deleteFriend
{
//    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
//    [WLHttpTool deleteFriendParameterDic:@{@"fid":_userMode.uid} success:^(id JSON) {
//        
//        MyFriendUser *friendUser = [loginUser getMyfriendUserWithUid:_userMode.uid];
//        //数据库删除当前好友
//        //        [loginUser removeRsMyFriendsObject:friendUser];
//        //更新设置为不是我的好友
//        [friendUser updateIsNotMyFriend];
//        //聊天状态发送改变
//        [friendUser updateIsChatStatus:NO];
//        
//        //删除新的好友本地数据库
//        NewFriendUser *newFuser = [loginUser getNewFriendUserWithUid:_userMode.uid];
//        if (newFuser) {
//            //删除好友请求数据
//            //更新好友请求列表数据为 添加
//            [newFuser updateOperateType:0];
//        }
//        //更新本地添加好友数据库
//        NeedAddUser *needAddUser = [loginUser getNeedAddUserWithUid:_userMode.uid];
//        if (needAddUser) {
//            //更新未好友的好友
//            [needAddUser updateFriendShip:2];
//        }
//        
//        [loginUser.managedObjectContext MR_saveToPersistentStoreAndWait];
//        //聊天状态发送改变
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatUserChanged" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:KupdataMyAllFriends object:self];
//        [self.navigationController popViewControllerAnimated:YES];
//        [WLHUDView showSuccessHUD:@"删除成功！"];
//    } fail:^(NSError *error) {
//        
//    }];
}

//获取共同好友列表
- (void)getSameFriendData
{
    LogInUser *mode = [LogInUser getCurrentLoginUser];
//    [WLHttpTool loadSameFriendParameterDic:@{@"uid":mode.uid,@"fid":_userMode.uid,@"size":@(1000)} success:^(id JSON) {
//        [[WLDataDBTool sharedService] putObject:JSON withId:_userMode.uid.stringValue intoTable:KWLSamefriendsTableName];
//        _sameFriendArry = [self getSameFriendsWith:JSON];
//        [self.tableView reloadData];
//    } fail:^(NSError *error) {
//        
//    }];
}

//获取用户最新动态
- (void)getUserFeedsData
{
//    NSMutableDictionary *darDic = [NSMutableDictionary dictionary];
//    [darDic setObject:@(KCellConut) forKey:@"size"];
//    
//    if (_uid) {
//        [darDic setObject:@(0) forKey:@"page"];
//        [darDic setObject:_uid forKey:@"uid"];
//    }else {
//        [darDic setObject:@(0) forKey:@"start"];
//    }
//    
//    [WLHttpTool loadFeedsParameterDic:darDic andLoadType:_uid success:^(id JSON) {
//        
//        NSArray *jsonarray = [NSArray arrayWithArray:JSON];
//        
//        // 1.在拿到最新微博数据的同时计算它的frame
//        [_dataArry removeAllObjects];
//        
//        for (NSDictionary *dic in jsonarray) {
//            WLStatusFrame *sf = [self dataFrameWith:dic];
//            [_dataArry addObject:sf];
//        }
//        if (!_uid) {
//            [self loadFirstFID];
//            if (!_dataArry.count) {
//                [self.homeView setHidden:NO];
//            }else{
//                [self.homeView setHidden:YES];
//            }
//        }
//        [LogInUser setUserNewstustcount:@(0)];
//        [[MainViewController sharedMainViewController] updataItembadge];
//        [self.tableView reloadData];
//        
//        [self.refreshControl endRefreshing];
//        [self.tableView footerEndRefreshing];
//        if (jsonarray.count<KCellConut) {
//            [self.tableView setFooterHidden:YES];
//        }
//    } fail:^(NSError *error) {
//        [self.refreshControl endRefreshing];
//        [self.tableView footerEndRefreshing];
//    }];
}

@end
