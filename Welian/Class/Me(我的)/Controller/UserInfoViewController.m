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
#import "FriendCell.h"
#import "WLStatusCell.h"
#import "UserInfoViewCell.h"

#define kTableViewHeaderViewHeight 318.f

#define kTableViewCellHeight 60.f
#define kTableViewHeaderHeight 60.f

@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (assign,nonatomic) UITableView *tableView;
@property (strong,nonatomic) WLCustomSegmentedControl *wlSegmentedControl;
@property (strong,nonatomic) NSArray *datasource1;
@property (strong,nonatomic) NSMutableArray *datasource2;
@property (strong,nonatomic) NSMutableArray *datasource3;
@property (assign,nonatomic) NSInteger selectType;//选择的类型
@property (strong,nonatomic) IBaseUserM *baseUserModel;

@end

@implementation UserInfoViewController
static NSString *fridcellid = @"fridcellid";

- (void)dealloc
{
    _wlSegmentedControl = nil;
    _datasource1 = nil;
    _datasource2 = nil;
    _datasource3 = nil;
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
    tableView.contentInset = UIEdgeInsetsMake(-120,0, 0,0);
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
    
    [_tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:fridcellid];
}

#pragma mark - UITableView Datasource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_selectType == 0) {
        return 3;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (_selectType) {
        case 1:
            return _datasource2.count;
            break;
        case 2:
            return _datasource3.count;
            break;
        default:
            return 3;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_selectType == 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, kTableViewHeaderHeight)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headView.width, KTableHeaderHeight)];
        topBgView.backgroundColor = WLLineColor;
        [headView addSubview:topBgView];
        
        UIImageView *logoImageView = [[UIImageView alloc] init];
        logoImageView.image = [UIImage imageNamed:@"me_xiangmu"];//me_touzi.png   me_lvli.png me_xiangmu.png
        [logoImageView sizeToFit];
        logoImageView.left = 15.f;
        logoImageView.centerY = (kTableViewHeaderHeight - KTableHeaderHeight) / 2.f + KTableHeaderHeight;
        [headView addSubview:logoImageView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:16.f];
        titleLabel.textColor = kTitleNormalTextColor;
        titleLabel.text = @"投资信息";
        [titleLabel sizeToFit];
        titleLabel.left = logoImageView.right + 5.f;
        titleLabel.centerY = logoImageView.centerY;
        [headView addSubview:titleLabel];
        
        headView.layer.borderColorFromUIColor = RGB(231.f, 231.f, 231.f);
        headView.layer.borderWidths = @"{0,0,0.5,0}";
        
        return headView;
    }else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_selectType) {
        case 1:
        {
            // 1.取出一个cell
            WLStatusCell *cell = [WLStatusCell cellWithTableView:tableView];
            [cell setHomeVC:self];
            
            // 2.给cell传递模型数据
            // 传递的模型：文字数据 + 子控件frame数据
            cell.statusFrame = _datasource2[indexPath.row];
            cell.feedzanBlock = ^(WLStatusM *statusM){
                WLStatusFrame *statusF = _datasource2[indexPath.row];
                [statusF setStatus:statusM];
                [_datasource2 replaceObjectAtIndex:indexPath.row withObject:statusF];
                [_tableView reloadData];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            cell.feedTuiBlock = ^(WLStatusM *statusM){
                WLStatusFrame *statusF = _datasource2[indexPath.row];
                [statusF setStatus:statusM];
                [_datasource2 replaceObjectAtIndex:indexPath.row withObject:statusF];
                [_tableView reloadData];
            };
            //    // 评论
            [cell.contentAndDockView.dock.commentBtn addTarget:self action:@selector(commentBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
            // 更多
            [cell.moreBut addTarget:self action:@selector(moreClick:event:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
            break;
        case 2:
        {
            FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:fridcellid];
            UserInfoModel *modeIM = _datasource3[indexPath.row];
            [cell setUserMode:(FriendsUserModel *)modeIM];
            return cell;
        }
            break;
            
        default:
        {
            static NSString *cellIdentifier = @"UserInfo_View_Cell";
            
            UserInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UserInfoViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            }
            switch (indexPath.section) {
                case 1:
                {
                    cell.textLabel.text = @"微链";
                    cell.textLabel.numberOfLines = 0.f;
                    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
                    cell.textLabel.textColor = kTitleTextColor;
                    
                    cell.detailTextLabel.text = @"专注于互联网创业的社交平台";
                    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
                    cell.detailTextLabel.textColor = kNormalTextColor;
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                case 2:
                {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.hidBottomLine = YES;
                    cell.textLabel.text = @"2014/05-至今";
                    cell.textLabel.numberOfLines = 0.f;
                    cell.textLabel.font = [UIFont systemFontOfSize:12.f];
                    cell.textLabel.textColor = kNormalTextColor;
                    
                    cell.detailTextLabel.text = @"产品经理 杭州传送门网络科技有限公司";
                    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
                    cell.detailTextLabel.textColor = kTitleNormalTextColor;
                    cell.imageView.image = [UIImage imageNamed:@"me_lvli_line"];
                    cell.detailTextLabel.top = cell.textLabel.bottom + 10.f;
                }
                    break;
                default:
                {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.isInTwoLine = YES;
                    cell.textLabel.text = @"投资阶段：";
                    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
                    cell.textLabel.textColor = kTitleTextColor;
                    
                    cell.detailTextLabel.text = @"天使轮 | 种子轮";
                    cell.detailTextLabel.numberOfLines = 0.f;
                    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
                    cell.detailTextLabel.textColor = kTitleTextColor;
                }
                    break;
            }
            return cell;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (_selectType) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_selectType == 0) {
        return kTableViewHeaderHeight;
    }else{
        return 0.f;
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
    switch (_selectType) {
        case 0:
        {
            //个人信息
            switch (indexPath.section) {
                case 0:
                {
                    return [UserInfoViewCell configureWithMsg:@"投资阶段：" detailMsg:@"天使轮 | 种子轮"];
                }
                    break;
                case 1:
                {
                    return 50.f;
                }
                    break;
                case 2:
                {
                    return 53.f;
                }
                    break;
                default:
                    return kTableViewCellHeight;
                    break;
            }
        }
            break;
        case 1:
        {
            //动态
            return [_datasource2[indexPath.row] cellHigh]+5;
        }
            break;
        default:
            //共同好友
            return kTableViewCellHeight;
            break;
    }
}



#pragma mark - Private
//选择的按钮
- (void)selectIndexChanged:(NSInteger)index
{
    self.selectType = index;
    [_tableView reloadData];
    switch (index) {
        case 0:
        {
            //隐藏表格分割线
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
        }
            break;
        case 1:
        {
            //隐藏表格分割线
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self getUserFeedsData];
        }
            break;
        case 2:
        {
            //隐藏表格分割线
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            [self getSameFriendData];
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
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    [WLHttpTool loadSameFriendParameterDic:@{@"uid":loginUser.uid,@"fid":_baseUserModel.uid,@"size":@(1000)} success:^(id JSON) {
        [[WLDataDBTool sharedService] putObject:JSON withId:_baseUserModel.uid.stringValue intoTable:KWLSamefriendsTableName];
        _datasource3 = [self getSameFriendsWith:JSON];
        [_tableView reloadData];
    } fail:^(NSError *error) {
        
    }];
}

//获取共同好友字典
- (NSMutableArray *)getSameFriendsWith:(NSDictionary *)friendsDic
{
    NSArray *sameFA = [friendsDic objectForKey:@"samefriends"];
    NSMutableArray *sameFrindM = [NSMutableArray arrayWithCapacity:sameFA.count];
    for (NSDictionary *infoD in sameFA) {
        FriendsUserModel *fmode = [[FriendsUserModel alloc] init];
        [fmode setKeyValues:infoD];
        [sameFrindM addObject:fmode];
    }
    return sameFrindM;
}

//获取用户最新动态
- (void)getUserFeedsData
{
    NSMutableDictionary *darDic = [NSMutableDictionary dictionary];
    [darDic setObject:@(KCellConut) forKey:@"size"];
    
    if (_baseUserModel.uid) {
        //查看他人的动态
        [darDic setObject:@(0) forKey:@"page"];
        [darDic setObject:_baseUserModel.uid forKey:@"uid"];
    }else {
        //调用自己的动态
        [darDic setObject:@(0) forKey:@"start"];
    }
    
    [WLHttpTool loadFeedsParameterDic:darDic
                          andLoadType:_baseUserModel.uid
                              success:^(id JSON) {
        
        NSArray *jsonarray = [NSArray arrayWithArray:JSON];
        
        // 1.在拿到最新微博数据的同时计算它的frame
        [_datasource2 removeAllObjects];
        NSMutableArray *datas = [NSMutableArray array];
                    
        for (NSDictionary *dic in jsonarray) {
            WLStatusFrame *sf = [self dataFrameWith:dic];
            [datas addObject:sf];
        }
        self.datasource2 = datas;
        if (!_baseUserModel.uid) {
            [self loadFirstFID];
//            if (!_datasource.count) {
//                [self.homeView setHidden:NO];
//            }else{
//                [self.homeView setHidden:YES];
//            }
        }
//        [LogInUser setUserNewstustcount:@(0)];
//        [[MainViewController sharedMainViewController] updataItembadge];
        [_tableView reloadData];
        
//        [self.refreshControl endRefreshing];
//        [self.tableView footerEndRefreshing];
//        if (jsonarray.count<KCellConut) {
//            [_tableView setFooterHidden:YES];
//        }
    } fail:^(NSError *error) {
//        [self.refreshControl endRefreshing];
//        [self.tableView footerEndRefreshing];
    }];
}

#pragma mark 加载更多数据
- (void)loadMoreData
{
    // 1.最后1条微博的ID
    WLStatusFrame *f = [_datasource2 lastObject];
    int start = f.status.fid;
    
    NSMutableDictionary *darDic = [NSMutableDictionary dictionary];
    [darDic setObject:@(KCellConut) forKey:@"size"];
    if (_baseUserModel.uid) {
        [darDic setObject:_baseUserModel.uid forKey:@"uid"];
        [darDic setObject:@(start) forKey:@"page"];
    }else{
        [darDic setObject:@(start) forKey:@"start"];
    }
    
    [WLHttpTool loadFeedsParameterDic:darDic andLoadType:_baseUserModel.uid success:^(id JSON) {
        NSArray *jsonarray = [NSArray arrayWithArray:JSON];
        
        // 1.在拿到最新微博数据的同时计算它的frame
        NSMutableArray *newFrames = [NSMutableArray array];
        
        for (NSDictionary *dic in jsonarray) {
            WLStatusFrame *sf = [self dataFrameWith:dic];
            [newFrames addObject:sf];
        }
        // 2.将newFrames整体插入到旧数据的后面
        [_datasource2 addObjectsFromArray:newFrames];
        
        [_tableView reloadData];
        
//        [self.refreshControl endRefreshing];
//        [self.tableView footerEndRefreshing];
        
//        if (jsonarray.count<KCellConut) {
//            [self.tableView setFooterHidden:YES];
//        }
        
    } fail:^(NSError *error) {
//        [self.refreshControl endRefreshing];
//        [self.tableView footerEndRefreshing];
    }];
    
}

#pragma mark - 取第一条ID保存
- (void)loadFirstFID
{
    // 1.第一条微博的ID
    WLStatusFrame *startf = [_datasource2 firstObject];
    [LogInUser setUserFirststustid:@(startf.status.fid)];
}

- (WLStatusFrame*)dataFrameWith:(NSDictionary *)statusDic
{
    WLStatusM *statusM = [WLStatusM objectWithKeyValues:statusDic];
    
    NSArray *feedarray = [statusDic objectForKey:@"forwards"];
    NSArray *zanarray = [statusDic objectForKey:@"zans"];
    
    NSMutableArray *forwardsM = [NSMutableArray array];
    if (feedarray.count) {
        for (NSDictionary *feeddic in feedarray) {
            UserInfoModel *mode = [UserInfoModel objectWithKeyValues:feeddic];
            [forwardsM addObject:mode];
        }
    }
    [statusM setForwardsArray:forwardsM];
    
    NSMutableArray *zanArrayM = [NSMutableArray array];
    if (zanarray.count) {
        for (NSDictionary *zandic in zanarray) {
            UserInfoModel *mode = [UserInfoModel objectWithKeyValues:zandic];
            [zanArrayM addObject:mode];
        }
    }
    [statusM setZansArray:zanArrayM];
    
    NSArray *comments = [statusDic objectForKey:@"comments"];
    NSMutableArray *commentArrayM = [NSMutableArray array];
    if (comments.count) {
        for (NSDictionary *commDic in comments) {
            CommentMode *commMode = [CommentMode objectWithKeyValues:commDic];
            [commentArrayM addObject:commMode];
        }
    }
    [statusM setCommentsArray:commentArrayM];
    NSArray *joinedusers = [statusDic objectForKey:@"joinedusers"];
    NSMutableArray *joinArrayM = [NSMutableArray array];
    if (joinedusers.count) {
        UserInfoModel *meInfoM = [[UserInfoModel alloc] init];
        meInfoM.name = statusM.user.name;
        meInfoM.uid = statusM.user.uid;
        meInfoM.avatar = statusM.user.avatar;
        [joinArrayM addObject:meInfoM];
    }
    if (joinedusers.count) {
        for (NSDictionary *joDic in joinedusers) {
            UserInfoModel *joMode = [UserInfoModel objectWithKeyValues:joDic];
            [joinArrayM addObject:joMode];
        }
    }
    [statusM setJoineduserArray:joinArrayM];
    
    WLStatusFrame *sf = [[WLStatusFrame alloc] initWithWidth:[UIScreen mainScreen].bounds.size.width-60];
    sf.status = statusM;
    return sf;
}

@end
