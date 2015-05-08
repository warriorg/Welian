//
//  MeViewController.m
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "MeViewController.h"
#import "MeinfoCell.h"
#import "MeSttingCell.h"
#import "MeInfoController.h"
#import "SettingController.h"
#import "HomeController.h"
#import "InvestCerVC.h"
#import "BadgeBaseCell.h"
#import "MainViewController.h"
#import "MyProjectViewController.h"
#import "MyActivityViewController.h"
#import "MyFriendsController.h"
#import "AddFriendTypeListViewController.h"
#import "FriendsFriendController.h"
#import "WorksListController.h"

#import "UserInfoView.h"
#import "WLCustomSegmentedControl.h"

#define kTableViewHeaderViewHeight 145.f
#define kHeaderBgImageHeight 105.f

@interface MeViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_data;
    CExpandHeader *_header;//用于设置头部背景
}

@property (assign,nonatomic) UITableView *tableView;
@property (strong,nonatomic) WLCustomSegmentedControl *wlSegmentedControl;
@property (strong,nonatomic) NSDictionary *infoDict;
@property (assign,nonatomic) UserInfoView *userInfoView;

@end

//static NSString *meinfocellid = @"MeinfoCell";
static NSString *BadgeBaseCellid = @"BadgeBaseCellid";
@implementation MeViewController

- (void)dealloc
{
    _wlSegmentedControl = nil;
    _infoDict = nil;
}

- (NSString *)title
{
    return @"个人中心";
}

- (WLCustomSegmentedControl *)wlSegmentedControl
{
    if (!_wlSegmentedControl) {
        _wlSegmentedControl = [[WLCustomSegmentedControl alloc] initWithSectionTitles:@[@"好友", @"好友的好友"]];
        _wlSegmentedControl.frame = CGRectMake(0, kTableViewHeaderViewHeight-60.f, self.view.width, 60.f);
        _wlSegmentedControl.selectedTextColor = kTitleNormalTextColor;
        _wlSegmentedControl.textColor = kTitleNormalTextColor;
        _wlSegmentedControl.detailTextColor = KBlueTextColor;
        _wlSegmentedControl.selectionIndicatorHeight = 0;//设置底部滑块的高度
//        _wlSegmentedControl.backgroundColor = kNavBgColor;
//        _wlSegmentedControl.showBottomLine = NO;
        _wlSegmentedControl.showLine = YES;//显示分割线
        _wlSegmentedControl.isShowVertical = YES;//纵向显示
        _wlSegmentedControl.isAllowTouchEveryTime = YES;//允许重复点击
        _wlSegmentedControl.detailLabelFont = kNormalBlod16Font;
        _wlSegmentedControl.font = kNormal14Font;
        //设置边线
        _wlSegmentedControl.layer.borderColorFromUIColor = WLLineColor;
        _wlSegmentedControl.layer.borderWidths = @"{0.8,0,0.8,0}";
        _wlSegmentedControl.layer.masksToBounds = YES;
    }
    return _wlSegmentedControl;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showCustomNavHeader = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //隐藏导航条
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    _wlSegmentedControl.sectionDetailTitles = @[loginUser.friendcount ? loginUser.friendcount.stringValue : @"0",loginUser.friend2count ? loginUser.friend2count.stringValue : @"0"];
    //设置用户信息
    _userInfoView.loginUser = loginUser;
    
    //获取用户信息
    [self initUserInfo];
    
//    //设置导航条是否半透明, 设置背景色,半透明失效
//    self.navigationController.navigationBar.translucent = YES;
//    //设置导航条样式
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //重新刷新也没
//    if (self.tableView) {
//        NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
//        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
//        [self reloadInvestorstate];
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self scrollViewDidScroll:_tableView];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
////    [self.navigationController.navigationBar reset];
//    
////    [[UINavigationBar appearance] setBarTintColor:KBasesColor];
////    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    
////    //设置导航条是否半透明, 设置背景色,半透明失效
////    self.navigationController.navigationBar.translucent = YES;
////    //设置导航条样式
////    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y + kHeaderBgImageHeight;
    UIColor *color = kNavBgColor;
    DLog(@"scroll off Y---%f",offsetY);
    if (offsetY > kHeaderBgImageHeight/2) {
        CGFloat alpha = 1 - ((kHeaderBgImageHeight/2 + 64 - offsetY) / 64);
        self.navHeaderView.backgroundColor = [color colorWithAlphaComponent:alpha];
    } else {
        self.navHeaderView.backgroundColor = [color colorWithAlphaComponent:0];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [KNSNotification addObserver:self selector:@selector(reloadInvestorstate) name:KInvestorstateNotif object:nil];
    
    //tableview头部距离问题
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //设置左侧按钮
    [self.navHeaderView setLeftBtnTitle:nil LeftBtnImage:[UIImage imageNamed:@"me_add_friend"]];
    //设置右侧按钮
    [self.navHeaderView setRightBtnTitle:nil RightBtnImage:[UIImage imageNamed:@"navbar_set"]];
    
    // 2.读取plist文件的内容
    [self loadPlist];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0.f,0.f,self.view.width,self.view.height - TabBarHeight) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
//    tableView.contentInset = UIEdgeInsetsMake(-100,0, 0,0);
    //隐藏表格分割线
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    [self.view sendSubviewToBack:tableView];
    self.tableView = tableView;
//    [tableView setDebug:YES];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"BadgeBaseCell" bundle:nil] forCellReuseIdentifier:BadgeBaseCellid];
    
    //设置自定义图片头部背景 me_background
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kHeaderBgImageHeight)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kHeaderBgImageHeight)];
    [imageView setImage:[UIImage imageNamed:@"header_gackground_top"]];
//    [imageView setImage:[UIImage imageNamed:@"me_background"]];
    
    //关键步骤 设置可变化背景view属性
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [customView addSubview:imageView];
    _header = [CExpandHeader expandWithScrollView:_tableView expandView:customView];
    
    //设置头部
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, kTableViewHeaderViewHeight)];
    
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    UserInfoView *userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, kTableViewHeaderViewHeight - 60.f)];
//    userInfoView.backgroundColor = [UIColor clearColor];
    userInfoView.loginUser = loginUser;
    self.userInfoView = userInfoView;
    [headerView addSubview:userInfoView];
//    [userInfoView setDebug:YES];
    
    //切换按钮
    [headerView addSubview:self.wlSegmentedControl];
    _wlSegmentedControl.sectionDetailTitles = @[loginUser.friendcount ? loginUser.friendcount.stringValue : @"0",loginUser.friend2count ? loginUser.friend2count.stringValue : @"0"];
    
    [_tableView setTableHeaderView:headerView];
//    _tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
//    [headerView setDebug:YES];
    
//    [self.tableView setParallaxHeaderView:headerView
//                                     mode:VGParallaxHeaderModeFill
//                                   height:kTableViewHeaderViewHeight];
    
    WEAKSELF
    [_wlSegmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf selectIndexChanged:index];
    }];
    //设置点击进入用户信息
    [userInfoView setLookUserDetailBlock:^(void){
        [weakSelf lookMeInfo];
    }];
}

#pragma mark - 重新方法
- (void)leftBtnClicked:(UIButton *)sender
{
    [self addFriendBtnClick];
}

- (void)rightBtnClicked:(UIButton *)sender
{
    [self setBtnClick];
}

#pragma mark 读取plist文件的内容
- (void)loadPlist
{
    // 1.获得路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"meplist" withExtension:@"plist"];
    
    // 2.读取数据
    _data = [NSArray arrayWithContentsOfURL:url];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_data[section] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    
    BadgeBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:BadgeBaseCellid];
    // 1.取出这行对应的字典数据
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    // 2.设置文字
    cell.titLabel.text = dict[@"name"];
    cell.deputLabel.hidden = NO;
    [cell.iconImage setImage:[UIImage imageNamed:dict[@"icon"]]];
    if (indexPath.section==1 && indexPath.row==0) {
        //        [cell.deputLabel setHidden:NO];
//        [cell.badgeImage setHidden:YES];
        [cell.badgeImage setHidden:!loginUser.isinvestorbadge.boolValue];
        //            0 默认状态  1  认证成功  -2 正在审核  -1 认证失败
        if (loginUser.investorauth.integerValue==1) {
            [cell.deputLabel setText:@"认证成功"];
        }else if (loginUser.investorauth.integerValue ==-2){
            [cell.deputLabel setText:@"正在审核"];
        }else if (loginUser.investorauth.integerValue ==-1){
            [cell.deputLabel setText:@"认证失败"];
        }else{
            cell.deputLabel.text = @"";
        }
    }
    
    NSString *detailInfo = @"";
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //动态
                    WLStatusM *feedM = [_infoDict objectForKey:@"feed"];
                    detailInfo = feedM.content;
                }
                    break;
                case 1:
                {
                    //活动
                    detailInfo = [_infoDict objectForKey:@"active"];
                }
                    break;
                case 2:
                {
                    //项目
                    detailInfo = [_infoDict objectForKey:@"project"];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //投资案例
                    IIMeInvestAuthModel *investorM = [_infoDict objectForKey:@"investor"];
                    InvestItemM *investItemM = [investorM.items firstObject];
                    detailInfo = investItemM.item;
                }
                    break;
                case 1:
                {
                    //我的履历
                    detailInfo = [loginUser displayMyNewLvliInfo];//@"杭州传送门网络技术有限公司/iOS";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    cell.deputLabel.text = detailInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *controller = nil;
    // 1.取出这行对应的字典数据
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    // 2.设置文字
    [controller setTitle:dict[@"name"]];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    controller = [[HomeController alloc] initWithUid:@(0)];
                    [controller setTitle:@"我的动态"];
                }
                    break;
                case 1:
                {
                    //我的活动
                    controller = [[MyActivityViewController alloc] init];
                }
                    break;
                case 2:
                {
                    controller = [[MyProjectViewController alloc] initWithUid:nil];
                    [controller setTitle:@"我的项目"];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    controller = [[InvestCerVC alloc] initWithStyle:UITableViewStyleGrouped];
                    // 取消我是投资人角标
                    [LogInUser setUserIsinvestorbadge:NO];
                    [[MainViewController sharedMainViewController] loadNewStustupdata];
                    [self reloadInvestorstate];
                }
                    break;
                case 1:
                {
                    //我的履历
                    controller = [[WorksListController alloc] init];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KTableRowH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _data.count - 1) {
        return 30.f;
    }else{
        return 0.01f;
    }
}

#pragma mark - Private
// 刷新我是投资人角标
- (void)reloadInvestorstate
{
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
}

//选择的按钮
- (void)selectIndexChanged:(NSInteger)index
{
    switch (index) {
        case 0://一度好友
        {
            MyFriendsController *friendsVC = [[MyFriendsController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:friendsVC animated:YES];
        }
            break;
        case 1://二度好友
        {
            FriendsFriendController *friendVC = [[FriendsFriendController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:friendVC animated:YES];
        }
            break;
        default:
            break;
    }
}

//添加好友
- (void)addFriendBtnClick
{
    AddFriendTypeListViewController *addTypeListVC = [[AddFriendTypeListViewController alloc] initWithStyle:UITableViewStyleGrouped fromMe:YES];
    [self.navigationController pushViewController:addTypeListVC animated:YES];
}

//设置
- (void)setBtnClick
{
    SettingController *setVC = [[SettingController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:setVC animated:YES];
}

//查看个人信息
- (void)lookMeInfo
{
    MeInfoController *meInfoVC = [[MeInfoController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:meInfoVC animated:YES];
}


- (NSDictionary *)getUserInfoWith:(NSDictionary *)dataDic
{
    // 详细信息
    NSDictionary *profile = [dataDic objectForKey:@"profile"];
    ILoginUserModel *profileM = [ILoginUserModel objectWithKeyValues:profile];
    
    // 动态
    NSDictionary *feed = [dataDic objectForKey:@"feed"];
    WLStatusM *feedM = [WLStatusM objectWithKeyValues:feed];
    
    // 投资案例
    NSDictionary *investor = [dataDic objectForKey:@"investor"];
    IIMeInvestAuthModel *investorM = [IIMeInvestAuthModel objectWithDict:investor];
    
    // 我的项目
    NSArray *projects = [dataDic objectForKey:@"projects"];
    NSArray *projectsArrayM = [IProjectInfo objectsWithInfo:projects];
    IProjectInfo *projectM = [projectsArrayM firstObject];
    NSString *projectName = projectM.name;
    
    // 工作经历列表
    NSArray *usercompany = [dataDic objectForKey:@"usercompany"];
    NSMutableArray *companyArrayM = [NSMutableArray arrayWithCapacity:usercompany.count];
    for (NSDictionary *dic in usercompany) {
        ICompanyResult *usercompanyM = [ICompanyResult objectWithKeyValues:dic];
        [companyArrayM addObject:usercompanyM];
        //保存到数据库
        [CompanyModel createCompanyModel:usercompanyM];
    }
    
    // 教育经历列表
    NSArray *userschool = [dataDic objectForKey:@"userschool"];
    NSMutableArray *schoolArrayM = [NSMutableArray arrayWithCapacity:userschool.count];
    for (NSDictionary *dic  in userschool) {
        ISchoolResult *userschoolM = [ISchoolResult objectWithKeyValues:dic];
        [schoolArrayM addObject:userschoolM];
        //保存到数据库
        [SchoolModel createSchoolModel:userschoolM];
    }
    
    //活动
    NSString *active = [[dataDic objectForKey:@"active"] objectForKey:@"name"] ? : @"";
    
    return (@{@"feed":feedM,@"investor":investorM,@"projects":projectsArrayM,@"project":projectName,@"profile":profileM,@"usercompany":companyArrayM,@"userschool":schoolArrayM,@"active":active});
}

- (void)reSetUserInfo:(ILoginUserModel *)loginUserModel
{
    //保存到数据库
    LogInUser *loginUser = [LogInUser createLogInUserModel:loginUserModel];
    //设置用户信息
    _userInfoView.loginUser = loginUser;
    //设置好友数量
    _wlSegmentedControl.sectionDetailTitles = @[loginUser.friendcount ? loginUser.friendcount.stringValue : @"0",loginUser.friend2count ? loginUser.friend2count.stringValue : @"0"];
}

- (void)initUserInfo
{
    //获取用户详细信息
    [WeLianClient getUserDetailInfoWithUid:@(0) Success:^(id resultInfo) {
        DLog(@"getUserDetailInfo -- %@",resultInfo);
        WEAKSELF
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            weakSelf.infoDict = [self getUserInfoWith:resultInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                //重置用户信息
                [weakSelf reSetUserInfo:[weakSelf.infoDict objectForKey:@"profile"]];
                [weakSelf.tableView reloadData];
            });
        });
    } Failed:^(NSError *error) {
        
    }];
}

@end
