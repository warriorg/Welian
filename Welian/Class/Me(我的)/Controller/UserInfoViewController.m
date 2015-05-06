//
//  UserInfoViewController.m
//  Welian
//
//  Created by weLian on 15/3/25.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "UserInfoViewController.h"
#import "CommentInfoController.h"
#import "ProjectDetailsViewController.h"
#import "MessagesViewController.h"
#import "ChatViewController.h"

#import "WLCustomSegmentedControl.h"
#import "UserInfoView.h"
#import "FriendCell.h"
#import "WLStatusCell.h"
#import "UserInfoViewCell.h"
#import "WLNoteInfoView.h"

#define kTableViewHeaderViewHeight 115.f
#define kHeaderBgImageHeight 83.f

#define kTableViewCellHeight 60.f
#define kTableViewHeaderHeight 60.f

@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    CExpandHeader *_header;//用于设置头部背景
}

@property (assign,nonatomic) UITableView *tableView;
@property (strong,nonatomic) WLCustomSegmentedControl *wlSegmentedControl;
@property (strong,nonatomic) NSMutableArray *datasource1;
@property (strong,nonatomic) NSMutableArray *datasource2;
@property (strong,nonatomic) NSMutableArray *datasource3;
@property (assign,nonatomic) NSInteger selectType;//选择的类型
@property (strong,nonatomic) IBaseUserM *baseUserModel;
@property (assign,nonatomic) UserInfoView *userInfoView;
@property (strong,nonatomic) WLNoteInfoView *wlNoteInfoView;//状态提醒
@property (strong,nonatomic) NSNumber *operateType;//操作类型0：添加 1：接受  2:已添加 3：待验证    10:隐藏
@property (assign,nonatomic) NSInteger pageIndex;//默认选择动态页数
@property (assign,nonatomic) BOOL canLoadMore;
@property (assign,nonatomic) BOOL hidRightBtn;//右上角按钮

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
    _operateType = nil;
    _wlNoteInfoView = nil;
    [KNSNotification removeObserver:self];
}

- (NSString *)title
{
    return @"详细信息";
}

- (WLNoteInfoView *)wlNoteInfoView
{
    if (!_wlNoteInfoView) {
        _wlNoteInfoView = [[WLNoteInfoView alloc] initWithFrame:CGRectMake(0.f, kTableViewHeaderViewHeight, self.view.width, self.view.height - kTableViewHeaderViewHeight)];
    }
    WEAKSELF
    [_wlNoteInfoView setReloadBlock:^(){
        [weakSelf selectIndexChanged:weakSelf.selectType];
    }];
    return _wlNoteInfoView;
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
        _wlSegmentedControl.detailLabelFont = kNormalBlod14Font;
        _wlSegmentedControl.font = kNormal14Font;
        //设置边线
        _wlSegmentedControl.layer.borderColorFromUIColor = WLLineColor;
        _wlSegmentedControl.layer.borderWidths = @"{0,0,0.8,0}";
        _wlSegmentedControl.layer.masksToBounds = YES;
    }
    return _wlSegmentedControl;
}

- (instancetype)initWithBaseUserM:(IBaseUserM *)iBaseUserModel OperateType:(NSNumber *)operateType HidRightBtn:(BOOL)hidRightBtn
{
    self = [super init];
    if (self) {
        self.showCustomNavHeader = YES;
        self.selectType = 0;
        self.pageIndex = 1;//默认第一页
        self.baseUserModel = iBaseUserModel;
        self.operateType = operateType;
        self.canLoadMore = YES;
        self.hidRightBtn = hidRightBtn;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self scrollViewDidScroll:_tableView];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
////    self.navigationController.navigationBar.alpha = 1;  //调整navigation bar的透明度
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar reset];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    
//    [self.navigationController.navigationBar setShadowImage:nil];
//    
//
//    self.navigationController.navigationBar.translucent = YES;
//
//    [[UINavigationBar appearance] setBarTintColor:KBasesColor];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTranslucent:YES];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.view.backgroundColor = [UIColor clearColor];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
//    self.navigationController.navigationBar.translucent = NO; //将navigation bar设置为半透明
//    
//    self.navigationController.navigationBar.alpha = 0.6;  //调整navigation bar的透明度
//    
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = nil;//[UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
    //代理置空，否则会闪退 设置手势滑动返回
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
}
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    //开启滑动手势
//    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }else{
//        navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //隐藏导航条
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //设置push到当前VC
    self.isJoindThisVC = YES;
    
    [self scrollViewDidScroll:_tableView];
    
    //取sqlite数据库用户信息
    [self updateLocalSqlUserInfo];
    
    //开启iOS7的滑动返回效果
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        //只有在二级页面生效
//        if ([self.navigationController.viewControllers count] > 1) {
//            self.navigationController.interactivePopGestureRecognizer.delegate = self;
//        }
//    }
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    //tableview头部距离问题
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //添加同意好友请求成功监听
    [KNSNotification addObserver:self selector:@selector(addSucceed) name:[NSString stringWithFormat:kAccepteFriend,_baseUserModel.uid]  object:nil];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0.f,0.f,self.view.width,self.view.height) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(-100,0, 0,0);
    tableView.backgroundColor = [UIColor whiteColor];
    //隐藏表格分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    [self.view sendSubviewToBack:tableView];
    self.tableView = tableView;
    
    
    //设置自定义图片头部背景
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kHeaderBgImageHeight)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kHeaderBgImageHeight)];
    [imageView setImage:[UIImage imageNamed:@"header_gackground_top"]];
    
    //关键步骤 设置可变化背景view属性
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [customView addSubview:imageView];
    _header = [CExpandHeader expandWithScrollView:_tableView expandView:customView];
    
    //设置头部
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.f, _tableView.width, kTableViewHeaderViewHeight)];
    UserInfoView *userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, kTableViewHeaderViewHeight - 38.f)];
    userInfoView.baseUserModel = _baseUserModel;
    if (_operateType) {
        userInfoView.operateType = _operateType;
    }
    self.userInfoView = userInfoView;
    [headerView addSubview:userInfoView];
    
    //切换按钮
    [headerView addSubview:self.wlSegmentedControl];
    //    _wlSegmentedControl.sectionDetailTitles = @[@"",@"2",@"106"];
    
    [_tableView setTableHeaderView:headerView];
    
    WEAKSELF
    [_wlSegmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf selectIndexChanged:index];
    }];
    
    //点击操作
    [userInfoView setOperateClickedBlock:^(void){
        [weakSelf operateBtnClicked];
    }];
    
    [_tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:fridcellid];
    //上提加载更多
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 隐藏当前的上拉刷新控件
    _tableView.footer.hidden = YES;
    
    //设置默认选择
    [self selectIndexChanged:_selectType];
}

#pragma mark - UITableView Datasource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_selectType == 0) {
        return _datasource1.count;
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
        {
            //个人信息
            NSNumber *type = (NSNumber *)[_datasource1[section] objectForKey:@"type"];
            switch (type.integerValue) {
                case 0:
                {
                    //投资信息
                    return [[[_datasource1[section] objectForKey:@"info"] objectForKey:@"types"] count];
                }
                    break;
                default:
                {
                    //履历
                    //项目
                    return [[_datasource1[section] objectForKey:@"info"] count];
                }
                    break;
            }
        }
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
        //        @"icon":@"me_touzi",@"title":@"投资信息",@"type":@(0),@"info":investorM}
        UIImageView *logoImageView = [[UIImageView alloc] init];
        logoImageView.image = [UIImage imageNamed:[_datasource1[section] objectForKey:@"icon"]];//me_touzi.png   me_lvli.png me_xiangmu.png
        [logoImageView sizeToFit];
        logoImageView.left = 15.f;
        logoImageView.centerY = (kTableViewHeaderHeight - KTableHeaderHeight) / 2.f + KTableHeaderHeight;
        [headView addSubview:logoImageView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = kNormal16Font;
        titleLabel.textColor = kTitleNormalTextColor;
        titleLabel.text = [_datasource1[section] objectForKey:@"title"];
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
            WEAKSELF
            cell.feedzanBlock = ^(WLStatusM *statusM){
                WLStatusFrame *statusF = weakSelf.datasource2[indexPath.row];
                [statusF setStatus:statusM];
                [weakSelf.datasource2 replaceObjectAtIndex:indexPath.row withObject:statusF];
//                [_tableView reloadData];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            cell.feedTuiBlock = ^(WLStatusM *statusM){
                WLStatusFrame *statusF = weakSelf.datasource2[indexPath.row];
                [statusF setStatus:statusM];
                [weakSelf.datasource2 replaceObjectAtIndex:indexPath.row withObject:statusF];
//                [_tableView reloadData];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
            IBaseUserM *modeIM = _datasource3[indexPath.row];
            cell.userMode = modeIM;
            cell.layer.borderColorFromUIColor = RGB(231.f, 231.f, 231.f);
            cell.layer.borderWidths = @"{0,0,0.5,0}";
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
            
            NSNumber *type = (NSNumber *)[_datasource1[indexPath.section] objectForKey:@"type"];
            
            cell.imageView.image = nil;
            cell.hidBottomLine = NO;
            cell.isInTwoLine = NO;
            switch (type.integerValue) {
                case 0:
                {
                    NSString *titleInfo = @"";
                    NSString *detailInfo = @"";
                    
                    NSDictionary *infoData = [_datasource1[indexPath.section] objectForKey:@"info"];
                    NSArray *types = [infoData objectForKey:@"types"];
                    //是否隐藏下划线
                    if (indexPath.row == types.count - 1) {
                        cell.hidBottomLine = YES;
                    }
                    IIMeInvestAuthModel *investModel = [infoData objectForKey:@"info"];
                    NSNumber *investType = [[types objectAtIndex:indexPath.row] objectForKey:@"type"];
                    switch (investType.integerValue) {
                        case 1:
                            titleInfo = @"投资领域：";
                            detailInfo = [investModel displayInvestIndustrys];
                            break;
                        case 2:
                            titleInfo = @"投资案例：";
                            detailInfo = [investModel displayInvestItems];
                            break;
                        default:
                            titleInfo = @"投资阶段：";
                            detailInfo = [investModel displayInvestStages];
                            break;
                    }
                    //投资信息
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.isInTwoLine = YES;
                    cell.textLabel.text = titleInfo;
                    cell.textLabel.font = kNormal14Font;
                    cell.textLabel.textColor = kTitleTextColor;
                    
                    cell.detailTextLabel.text = detailInfo;
                    cell.detailTextLabel.numberOfLines = 0.f;
                    cell.detailTextLabel.font = kNormal14Font;
                    cell.detailTextLabel.textColor = kTitleTextColor;
                }
                    break;
                case 1:
                {
                    //项目
                    NSArray *infos = [_datasource1[indexPath.section] objectForKey:@"info"];
                    //是否隐藏下划线
                    if (indexPath.row == infos.count - 1) {
                        cell.hidBottomLine = YES;
                    }
                    IProjectInfo *projectInfo = [infos objectAtIndex:indexPath.row];
                    cell.textLabel.text = projectInfo.name;
                    cell.textLabel.font = kNormal14Font;
                    cell.textLabel.textColor = kTitleTextColor;
                    
                    cell.detailTextLabel.text = projectInfo.intro;
                    cell.detailTextLabel.numberOfLines = 1.f;
                    cell.detailTextLabel.font = kNormal12Font;
                    cell.detailTextLabel.textColor = kNormalTextColor;
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                case 2:
                {
                    NSArray *infos = [_datasource1[indexPath.section] objectForKey:@"info"];
                    NSObject *info = [infos objectAtIndex:indexPath.row];
                    //是否隐藏下划线
                    if (indexPath.row == infos.count - 1) {
                        cell.hidBottomLine = YES;
                    }
                    //履历
                    NSString *titleInfo = @"";
                    NSString *detailInfo = @"";
                    NSString *endTime = @"";
                    if ([info isKindOfClass:[ICompanyResult class]]) {
                        ICompanyResult *result = (ICompanyResult *)info;
                        endTime = result.endyear.integerValue == -1 ? @"至今" : [NSString stringWithFormat:@"%@/%@",result.endyear,result.endmonth];
                        titleInfo = [NSString stringWithFormat:@"%@/%@—/%@",result.startyear,result.startmonth,endTime];
                        detailInfo = [NSString stringWithFormat:@"%@%@",result.jobname.length > 0 ? [NSString stringWithFormat:@"%@ ",[result.jobname deleteTopAndBottomKonggeAndHuiche]] : @"",[result.companyname deleteTopAndBottomKonggeAndHuiche]];
                    }else{
                        ISchoolResult *result = (ISchoolResult *)info;
                        endTime = result.endyear.integerValue == -1 ? @"至今" : [NSString stringWithFormat:@"%@/%@",result.endyear,result.endmonth];
                        titleInfo = [NSString stringWithFormat:@"%@/%@—/%@",result.startyear,result.startmonth,endTime];
                        detailInfo = [NSString stringWithFormat:@"%@%@",result.specialtyname.length > 0 ? [NSString stringWithFormat:@"%@ ",[result.specialtyname deleteTopAndBottomKonggeAndHuiche]] : @"",[result.schoolname deleteTopAndBottomKonggeAndHuiche]];
                    }
                    
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.hidBottomLine = YES;
                    cell.textLabel.text = titleInfo;
                    cell.textLabel.font = kNormal12Font;
                    cell.textLabel.textColor = kNormalTextColor;
                    
                    cell.detailTextLabel.text = detailInfo;
                    cell.detailTextLabel.font = kNormal14Font;
                    cell.detailTextLabel.numberOfLines = 0.f;
                    cell.detailTextLabel.textColor = kTitleNormalTextColor;
                    cell.imageView.image = [UIImage imageNamed:@"me_lvli_line"];
                }
                    break;
                default:
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
            //个人信息
            NSNumber *type = (NSNumber *)[_datasource1[indexPath.section] objectForKey:@"type"];
            if (type.integerValue == 1) {
                //项目
                IProjectInfo *projectInfo = [[_datasource1[indexPath.section] objectForKey:@"info"] objectAtIndex:indexPath.row];
                ProjectDetailsViewController *projectVC = [[ProjectDetailsViewController alloc] initWithIProjectInfo:projectInfo];
                [self.navigationController pushViewController:projectVC animated:YES];
            }
        }
            break;
        case 1:
        {
            //进入详情
            [self pushCommentInfoVC:indexPath];
        }
            break;
        case 2:
        {
            IBaseUserM *modeIM = _datasource3[indexPath.row];
//            UserInfoBasicVC *userinfVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:modeIM isAsk:NO];
            UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithBaseUserM:modeIM OperateType:nil HidRightBtn:NO];
            [self.navigationController pushViewController:userInfoVC animated:YES];
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
    return [self configureCellHeightWithIndex:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self configureCellHeightWithIndex:indexPath];
}

//获取对应的Cell高度
- (CGFloat)configureCellHeightWithIndex:(NSIndexPath *)indexPath
{
    switch (_selectType) {
        case 0:
        {
            //个人信息
            NSNumber *type = (NSNumber *)[_datasource1[indexPath.section] objectForKey:@"type"];
            switch (type.integerValue) {
                case 0:
                {
                    NSString *titleInfo = @"";
                    NSString *detailInfo = @"";
                    
                    NSDictionary *infoData = [_datasource1[indexPath.section] objectForKey:@"info"];
                    NSArray *types = [infoData objectForKey:@"types"];
                    IIMeInvestAuthModel *investModel = [infoData objectForKey:@"info"];
                    NSNumber *investType = [[types objectAtIndex:indexPath.row] objectForKey:@"type"];
                    switch (investType.integerValue) {
                        case 1:
                            titleInfo = @"投资领域：";
                            detailInfo = [investModel displayInvestIndustrys];
                            break;
                        case 2:
                            titleInfo = @"投资案例：";
                            detailInfo = [investModel displayInvestItems];
                            break;
                        default:
                            titleInfo = @"投资阶段：";
                            detailInfo = [investModel displayInvestStages];
                            break;
                    }
                    return [UserInfoViewCell configureWithMsg:titleInfo detailMsg:detailInfo];
                }
                    break;
                case 1:
                {
                    //项目
                    return 50.f;
                }
                    break;
                case 2:
                {
                    //履历
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
    [self checkNoteInfoLoad:NO];
    _tableView.footer.hidden = YES;
    _wlNoteInfoView.loadFailed = NO;
    switch (index) {
        case 0:
        {
            [self initUserInfo];
        }
            break;
        case 1:
        {
            //隐藏表格分割线
//            [_tableView setFooterHidden:NO];
//            _tableView.footer.hidden = NO;
            if (_datasource2.count <= 0) {
                [self getUserFeedsData];
            }
            if(!_canLoadMore){
                _tableView.footer.hidden = YES;
            }
        }
            break;
        case 2:
        {
            [self getSameFriendData];
        }
            break;
        default:
            break;
    }
}

- (void)checkNoteInfoLoad:(BOOL)isLoad
{
    NSString *noteInfo = @"加载中...";
    UIView *noteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    BOOL loaded = YES;
    switch (_selectType) {
        case 0:
        {
            //加载完成，但数据为空
            if (isLoad && _datasource1.count <= 0) {
                noteInfo = @"这家伙还没设置过自己的资料";
                noteView = self.wlNoteInfoView;
            }else if(!isLoad && _datasource1.count <= 0){
                loaded = NO;
                noteView = self.wlNoteInfoView;
            }
        }
            break;
        case 1:
        {
            //加载完成，但数据为空
            if (isLoad && _datasource2.count <= 0) {
                noteInfo = @"这家伙很懒，什么都没留下";
                noteView = self.wlNoteInfoView;
            }else if(!isLoad && _datasource2.count <= 0){
                loaded = NO;
                noteView = self.wlNoteInfoView;
            }
        }
            break;
        case 2:
        {
            //加载完成，但数据为空
            if (isLoad && _datasource3.count <= 0) {
                noteInfo = @"你们之间还没有共同好友";
                noteView = self.wlNoteInfoView;
            }else if(!isLoad && _datasource3.count <= 0){
                loaded = NO;
                noteView = self.wlNoteInfoView;
            }
        }
            break;
        default:
            break;
    }
    
    self.wlNoteInfoView.isLoaded = isLoad;
    self.wlNoteInfoView.noteInfo = noteInfo;
    _tableView.tableFooterView = noteView;
    
    [_tableView reloadData];
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
    [WLHUDView showHUDWithStr:@"删除中..." dim:YES];
    [WeLianClient deleteFriendWithID:_baseUserModel.uid
                             Success:^(id resultInfo) {
                                 [WLHUDView hiddenHud];
                                 
                                 LogInUser *loginUser = [LogInUser getCurrentLoginUser];
                                 //更新数据库好友的数量
                                 loginUser.friendcount = @(loginUser.friendcount.integerValue - 1);
                                 
                                 MyFriendUser *friendUser = [loginUser getMyfriendUserWithUid:_baseUserModel.uid];
                                 //数据库删除当前好友
                                 //        [loginUser removeRsMyFriendsObject:friendUser];
                                 //更新设置为不是我的好友
                                 [friendUser updateIsNotMyFriend];
                                 //聊天状态发送改变
                                 [friendUser updateIsChatStatus:NO];
                                 //更新未读消息数量
                                 [friendUser updateUnReadMessageNumber:@(0)];
                                 
                                 
                                 //删除新的好友本地数据库
                                 NewFriendUser *newFuser = [loginUser getNewFriendUserWithUid:_baseUserModel.uid];
                                 if (newFuser) {
                                     //删除好友请求数据
                                     //更新好友请求列表数据为 添加
                                     [newFuser updateOperateType:0];
                                 }
                                 //更新本地添加好友数据库
                                 NeedAddUser *needAddUser = [loginUser getNeedAddUserWithUid:_baseUserModel.uid];
                                 if (needAddUser) {
                                     //更新未好友的好友
                                     [needAddUser updateFriendShip:2];
                                 }
                                 
                                 [loginUser.managedObjectContext MR_saveToPersistentStoreAndWait];
                                 
                                 //聊天状态发送改变
                                 [KNSNotification postNotificationName:kChatUserChanged object:nil];
                                 [KNSNotification postNotificationName:KupdataMyAllFriends object:self];
                                 [self.navigationController popViewControllerAnimated:YES];
                                 [WLHUDView showSuccessHUD:@"删除成功！"];
                             } Failed:^(NSError *error) {
                                 [WLHUDView hiddenHud];
                                 [WLHUDView showErrorHUD:@"删除失败，请重试！"];
                             }];
    
//    [WLHttpTool deleteFriendParameterDic:@{@"fid":_baseUserModel.uid} success:^(id JSON) {
//        LogInUser *loginUser = [LogInUser getCurrentLoginUser];
//        //更新数据库好友的数量
//        loginUser.friendcount = @(loginUser.friendcount.integerValue - 1);
//        
//        MyFriendUser *friendUser = [loginUser getMyfriendUserWithUid:_baseUserModel.uid];
//        //数据库删除当前好友
//        //        [loginUser removeRsMyFriendsObject:friendUser];
//        //更新设置为不是我的好友
//        [friendUser updateIsNotMyFriend];
//        //聊天状态发送改变
//        [friendUser updateIsChatStatus:NO];
//        //更新未读消息数量
//        [friendUser updateUnReadMessageNumber:@(0)];
//        
//        
//        //删除新的好友本地数据库
//        NewFriendUser *newFuser = [loginUser getNewFriendUserWithUid:_baseUserModel.uid];
//        if (newFuser) {
//            //删除好友请求数据
//            //更新好友请求列表数据为 添加
//            [newFuser updateOperateType:0];
//        }
//        //更新本地添加好友数据库
//        NeedAddUser *needAddUser = [loginUser getNeedAddUserWithUid:_baseUserModel.uid];
//        if (needAddUser) {
//            //更新未好友的好友
//            [needAddUser updateFriendShip:2];
//        }
//        
//        [loginUser.managedObjectContext MR_saveToPersistentStoreAndWait];
//        
//        //聊天状态发送改变
//        [KNSNotification postNotificationName:kChatUserChanged object:nil];
//        [KNSNotification postNotificationName:KupdataMyAllFriends object:self];
//        [self.navigationController popViewControllerAnimated:YES];
//        [WLHUDView showSuccessHUD:@"删除成功！"];
//    } fail:^(NSError *error) {
//        
//    }];
}

//获取共同好友列表
- (void)getSameFriendData
{
    //本地数据库数据
    YTKKeyValueItem *sameFitem = [[WLDataDBTool sharedService] getYTKKeyValueItemById:_baseUserModel.uid.stringValue fromTable:KWLSamefriendsTableName];
    if (sameFitem) {
        _datasource3 = [NSMutableArray arrayWithArray:[IBaseUserM objectsWithInfo:sameFitem.itemObject]];
        //检查
        [self checkNoteInfoLoad:YES];
    }
    
    [WeLianClient getSameFriendListWithID:_baseUserModel.uid
                                     Page:@(1)
                                     Size:@(1000)
                                  Success:^(id resultInfo) {
                                      //保存到Sqlite数据库
                                      [[WLDataDBTool sharedService] putObject:resultInfo withId:_baseUserModel.uid.stringValue intoTable:KWLSamefriendsTableName];
                                      
                                      _datasource3 = [NSMutableArray arrayWithArray:[IBaseUserM objectsWithInfo:resultInfo]];
                                      //检查
                                      [self checkNoteInfoLoad:YES];
                                  } Failed:^(NSError *error) {
                                      _wlNoteInfoView.loadFailed = YES;
                                  }];
    
//    [WLHttpTool loadSameFriendParameterDic:@{@"uid":loginUser.uid,@"fid":_baseUserModel.uid,@"size":@(1000)} success:^(id JSON) {
//        [[WLDataDBTool sharedService] putObject:JSON withId:_baseUserModel.uid.stringValue intoTable:KWLSamefriendsTableName];
//        _datasource3 = [self getSameFriendsWith:JSON];
//        //检查
//        [self checkNoteInfoLoad:YES];
//    } fail:^(NSError *error) {
//        _wlNoteInfoView.loadFailed = YES;
//    }];
}

//获取共同好友字典
//- (NSMutableArray *)getSameFriendsWith:(NSDictionary *)friendsDic
//{
//    NSArray *sameFA = [friendsDic objectForKey:@"samefriends"];
//    NSMutableArray *sameFrindM = [NSMutableArray arrayWithCapacity:sameFA.count];
//    for (NSDictionary *infoD in sameFA) {
//        FriendsUserModel *fmode = [[FriendsUserModel alloc] init];
//        [fmode setKeyValues:infoD];
//        [sameFrindM addObject:fmode];
//    }
//    return sameFrindM;
//}

//获取用户最新动态
- (void)getUserFeedsData
{
    NSMutableDictionary *darDic = [NSMutableDictionary dictionary];
    [darDic setObject:@(KCellConut) forKey:@"size"];
    
    self.pageIndex = 1;
    
    if (_baseUserModel.uid) {
        //查看他人的动态
        [darDic setObject:@(_pageIndex) forKey:@"page"];
        [darDic setObject:_baseUserModel.uid forKey:@"uid"];
    }else {
        //调用自己的动态
//        [darDic setObject:@(0) forKey:@"start"];
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
//                                  if (!_baseUserModel.uid) {
//                                      [self loadFirstFID];
                                      //            if (!_datasource.count) {
                                      //                [self.homeView setHidden:NO];
                                      //            }else{
                                      //                [self.homeView setHidden:YES];
                                      //            }
//                                  }
                                  //        [LogInUser setUserNewstustcount:@(0)];
                                  //        [[MainViewController sharedMainViewController] updataItembadge];
                                  //检查
                                  [self checkNoteInfoLoad:YES];
                                  
                                  [_tableView.footer endRefreshing];
                                  if (jsonarray.count<KCellConut) {
                                      // 隐藏当前的上拉刷新控件
                                      _tableView.footer.hidden = YES;
                                      _canLoadMore = NO;
                                  }else{
                                      _pageIndex++;
                                      _canLoadMore = YES;
                                      // 隐藏当前的上拉刷新控件
                                      _tableView.footer.hidden = NO;
                                  }
                              } fail:^(NSError *error) {
                                  [_tableView.footer endRefreshing];
                                  _wlNoteInfoView.loadFailed = YES;
                              }];
}

#pragma mark 加载更多数据
- (void)loadMoreData
{
    if (_selectType == 1) {
        // 1.最后1条微博的ID
//        WLStatusFrame *f = [_datasource2 lastObject];
//        int start = f.status.fid;
        
        NSMutableDictionary *darDic = [NSMutableDictionary dictionary];
        [darDic setObject:@(KCellConut) forKey:@"size"];
        if (_baseUserModel.uid) {
            [darDic setObject:_baseUserModel.uid forKey:@"uid"];
            [darDic setObject:@(_pageIndex) forKey:@"page"];
        }else{
//            [darDic setObject:@(start) forKey:@"start"];
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
            
//            [_datasource2 addObjectsFromArray:_datasource2];
            //            [_datasource2 addObjectsFromArray:_datasource2];
            
            //检查
            [self checkNoteInfoLoad:YES];
            
            [_tableView.footer endRefreshing];
            if (jsonarray.count<KCellConut) {
                // 隐藏当前的上拉刷新控件
                _tableView.footer.hidden = YES;
                _canLoadMore = NO;
            }else{
                _pageIndex++;
                _canLoadMore = YES;
                // 隐藏当前的上拉刷新控件
                _tableView.footer.hidden = NO;
            }
        } fail:^(NSError *error) {
            [_tableView.footer endRefreshing];
        }];
    }
}

#pragma mark - 取第一条ID保存
- (void)loadFirstFID
{
    // 1.第一条微博的ID
    WLStatusFrame *startf = [_datasource2 firstObject];
    [LogInUser setUserFirststustid:startf.status.fid];
}

- (WLStatusFrame*)dataFrameWith:(NSDictionary *)statusDic
{
    WLStatusM *statusM = [WLStatusM objectWithKeyValues:statusDic];
    
    NSArray *feedarray = [statusDic objectForKey:@"forwards"];
    NSArray *zanarray = [statusDic objectForKey:@"zans"];
    
    NSMutableArray *forwardsM = [NSMutableArray array];
    if (feedarray.count) {
        for (NSDictionary *feeddic in feedarray) {
            IBaseUserM *mode = [IBaseUserM objectWithKeyValues:feeddic];
            [forwardsM addObject:mode];
        }
    }
    [statusM setForwards:forwardsM];
    
    NSMutableArray *zanArrayM = [NSMutableArray array];
    if (zanarray.count) {
        for (NSDictionary *zandic in zanarray) {
            IBaseUserM *mode = [IBaseUserM objectWithKeyValues:zandic];
            [zanArrayM addObject:mode];
        }
    }
    [statusM setZans:zanArrayM];
    
    NSArray *comments = [statusDic objectForKey:@"comments"];
    NSMutableArray *commentArrayM = [NSMutableArray array];
    if (comments.count) {
        for (NSDictionary *commDic in comments) {
            CommentMode *commMode = [CommentMode objectWithKeyValues:commDic];
            [commentArrayM addObject:commMode];
        }
    }
    [statusM setComments:commentArrayM];
    NSArray *joinedusers = [statusDic objectForKey:@"joinedusers"];
    NSMutableArray *joinArrayM = [NSMutableArray array];
    if (joinedusers.count) {
        IBaseUserM *meInfoM = [[IBaseUserM alloc] init];
        meInfoM.name = statusM.user.name;
        meInfoM.uid = statusM.user.uid;
        meInfoM.avatar = statusM.user.avatar;
        [joinArrayM addObject:meInfoM];
    }
    if (joinedusers.count) {
        for (NSDictionary *joDic in joinedusers) {
            IBaseUserM *joMode = [IBaseUserM objectWithKeyValues:joDic];
            [joinArrayM addObject:joMode];
        }
    }
    [statusM setJoinedusers:joinArrayM];
    
    WLStatusFrame *sf = [[WLStatusFrame alloc] initWithWidth:[UIScreen mainScreen].bounds.size.width-60];
    sf.status = statusM;
    return sf;
}

#pragma mark - 进入详情页
- (void)pushCommentInfoVC:(NSIndexPath*)indexPath
{
    WLStatusFrame *statusF = _datasource2[indexPath.row];
    NSInteger type = statusF.status.type.integerValue;
    if (type==2 ||type==4 || type==5||type==6||type==12) return;
    
    CommentInfoController *commentInfo = [[CommentInfoController alloc] init];
    [commentInfo setStatusM:statusF.status];
    commentInfo.feedzanBlock = ^(WLStatusM *statusM){
        
        WLStatusFrame *statusF = _datasource2[indexPath.row];
        [statusF setStatus:statusM];
        [_datasource2 replaceObjectAtIndex:indexPath.row withObject:statusF];
        //        [self.tableView reloadData];
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    commentInfo.feedTuiBlock = ^(WLStatusM *statusM){
        
        WLStatusFrame *statusF = _datasource2[indexPath.row];
        [statusF setStatus:statusM];
        [_datasource2 replaceObjectAtIndex:indexPath.row withObject:statusF];
        //        [self.tableView reloadData];
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    commentInfo.commentBlock = ^(WLStatusM *statusM){
        WLStatusFrame *statusF = _datasource2[indexPath.row];
        [statusF setStatus:statusM];
        [_datasource2 replaceObjectAtIndex:indexPath.row withObject:statusF];
        //        [self.tableView reloadData];
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    commentInfo.deleteStustBlock = ^(WLStatusM *statusM){
        WLStatusFrame *statusF = _datasource2[indexPath.row];
        [statusF setStatus:statusM];
        [_datasource2 removeObject:statusF];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    //    _seletIndexPath = indexPath;
    [self.navigationController pushViewController:commentInfo animated:YES];
}

#pragma mark- 评论
- (void)commentBtnClick:(UIButton*)but event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if(indexPath)
    {
        [self pushCommentInfoVC:indexPath];
    }
}

#pragma mark - 更多按钮
- (void)moreClick:(UIButton*)but event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    
    UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [sheet bk_addButtonWithTitle:@"删除该条动态" handler:^{
        WLStatusFrame *statuF = _datasource2[indexPath.row];
        [WeLianClient deleteFeedWithID:statuF.status.fid Success:^(id resultInfo) {

            [_datasource2 removeObject:statuF];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } Failed:^(NSError *error) {
            
        }];
//        [WLHttpTool deleteFeedParameterDic:@{@"fid":statuF.status.fid} success:^(id JSON) {
//            
//            
//        } fail:^(NSError *error) {
//            
//        }];
    }];
    [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [sheet showInView:self.view];
}

//操作按钮点击
- (void)operateBtnClicked
{
    /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */ ////操作类型0：添加 1：接受  2:已添加 3：待验证   10:隐藏操作按钮
    if (_baseUserModel.friendship.integerValue == 1 || _operateType.integerValue == 2) {
        //好友
        [self chatBtnClicked:nil];
    }else{
        ///操作类型0：添加 1：接受  2:已添加 3：待验证
        switch (_operateType.integerValue) {
            case 0:
            {
                //加好友
                //添加好友，发送添加成功，状态变成待验证
                LogInUser *loginUser = [LogInUser getCurrentLoginUser];
                UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"好友验证" message:[NSString stringWithFormat:@"发送至好友：%@",_baseUserModel.name]];
                [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"我是%@的%@",loginUser.company,loginUser.position]];
                [alert bk_addButtonWithTitle:@"取消" handler:nil];
                [alert bk_addButtonWithTitle:@"发送" handler:^{
                    //发送好友请求
                    [WLHUDView showHUDWithStr:@"发送中..." dim:NO];
                    [WeLianClient requestAddFriendWithID:_baseUserModel.uid
                                                 Message:[alert textFieldAtIndex:0].text
                                                 Success:^(id resultInfo) {
                                                     //设置成待验证的
                                                     self.operateType = @(3);
                                                     _userInfoView.operateType = _operateType;
                                                     
                                                     [WLHUDView showSuccessHUD:@"好友请求已发送"];
                                                     if (_addFriendBlock) {
                                                         _addFriendBlock();
                                                     }
                                                 } Failed:^(NSError *error) {
                                                     if (error) {
                                                         [WLHUDView showErrorHUD:error.description];
                                                     }else{
                                                         [WLHUDView showErrorHUD:@"发送失败，请重试"];
                                                     }
                                                 }];
                    
//                    [WLHttpTool requestFriendParameterDic:@{@"fid":_baseUserModel.uid,@"message":[alert textFieldAtIndex:0].text} success:^(id JSON) {
//                        //设置成待验证的
//                        self.operateType = @(3);
//                        _userInfoView.operateType = _operateType;
//                        
//                        [WLHUDView showSuccessHUD:@"好友验证发送成功！"];
//                        if (_addFriendBlock) {
//                            _addFriendBlock();
//                        }
//                    } fail:^(NSError *error) {
//                        
//                    }];
                }];
                [alert show];
            }
                break;
            case 1:
            {
                //通过验证
                if (self.acceptFriendBlock) {
                    self.acceptFriendBlock();
                }
            }
                break;
            case 3:
            {
                //待验证
                
            }
                break;
            default:
                break;
        }
    }
}

//添加成功
- (void)addSucceed
{
//    NewFriendUser *friendM = [[LogInUser getCurrentLoginUser] getNewFriendUserWithUid:_baseUserModel.uid];
    self.baseUserModel.friendship = @(1);
    //设置用户信息
    _userInfoView.baseUserModel = _baseUserModel;
}

//进入聊天页面
- (void)chatBtnClicked:(UIButton *)sender
{
    ////操作类型0：添加 1：接受  2:已添加 3：待验证   10:隐藏操作按钮
    //已经是好友，雷达页面  不用进入消息页面  ////操作类型0：添加 1：接受  2:已添加 3：待验证   10:隐藏操作按钮
    if(_baseUserModel.friendship.integerValue == 1 && _hidRightBtn){
        LogInUser *loginUser = [LogInUser getCurrentLoginUser];
        MyFriendUser *user = [loginUser getMyfriendUserWithUid:_baseUserModel.uid];
        ChatViewController *chatVC = [[ChatViewController alloc] initWithUser:user];
        [self.navigationController pushViewController:chatVC animated:YES];
    }else{
        UIViewController *rootVC = [self.navigationController.viewControllers firstObject];
        //当前已经在消息页面
        if ([rootVC isKindOfClass:[MessagesViewController class]]) {
            [KNSNotification postNotificationName:kCurrentChatFromUserInfo object:self userInfo:@{@"uid":_baseUserModel.uid.stringValue}];
            
            LogInUser *loginUser = [LogInUser getCurrentLoginUser];
            MyFriendUser *user = [loginUser getMyfriendUserWithUid:_baseUserModel.uid];
            ChatViewController *chatVC = [[ChatViewController alloc] initWithUser:user];
            [self.navigationController pushViewController:chatVC animated:YES];
            
            //替换中间的内容
            NSMutableArray *contros = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [contros removeObjectsInRange:NSMakeRange(1, contros.count - 1) ];
            [contros addObject:chatVC];
            
            [self.navigationController setViewControllers:contros animated:YES];
        }else{
            //进入聊天页面
            [KNSNotification postNotificationName:kChatFromUserInfo object:self userInfo:@{@"uid":_baseUserModel.uid.stringValue}];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

//重新右侧按钮方法
- (void)rightBtnClicked:(UIButton *)sender
{
    /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
    if (_baseUserModel.friendship.integerValue == 1 && !_hidRightBtn) {
        [self moreBtnClicked];
    }
}

//设置右上角按钮
- (void)setRightNavBtnWithUserInfoModel:(IBaseUserM *)userInfoModel
{
    /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
    if (userInfoModel.friendship.integerValue == 1 && !_hidRightBtn) {
        //设置右侧按钮
        [self.navHeaderView setRightBtnTitle:nil RightBtnImage:[UIImage imageNamed:@"navbar_more"]];
        //更多操作
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_more"] style:UIBarButtonItemStyleBordered target:self action:@selector(moreBtnClicked)];
    }
}

- (void)initUserInfo
{
    //取sqlite数据库用户信息
    [self updateLocalSqlUserInfo];
    if (_baseUserModel.uid) {
        //获取用户详细信息
        [WeLianClient getUserDetailInfoWithUid:_baseUserModel.uid Success:^(id resultInfo) {
            DLog(@"userDetailInfo----%@",resultInfo);
            WEAKSELF
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [weakSelf getUserInfoWith:resultInfo];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //检查
                    [weakSelf checkNoteInfoLoad:YES];
                });
            });
            
        } Failed:^(NSError *error) {
            _wlNoteInfoView.loadFailed = YES;
        }];
        
//        [WLHttpTool loadUserInfoParameterDic:@{@"uid":_baseUserModel.uid} success:^(id JSON) {
//            [self getUserInfoWith:JSON];
//        } fail:^(NSError *error) {
//            _wlNoteInfoView.loadFailed = YES;
//        }];
    }
}

//获取本地数据库用户信息
- (void)updateLocalSqlUserInfo
{
    //取sqlite数据库用户信息
    YTKKeyValueItem *item = [[WLDataDBTool sharedService] getYTKKeyValueItemById:_baseUserModel.uid.stringValue fromTable:KWLUserInfoTableName];
    if (item) {
        [self getUserInfoWith:item.itemObject];
    }
    //检查
    [self checkNoteInfoLoad:YES];
}

- (void)getUserInfoWith:(NSDictionary *)dataDic
{
    //保存到sqlite数据库
    [[WLDataDBTool sharedService] putObject:dataDic withId:_baseUserModel.uid.stringValue intoTable:KWLUserInfoTableName];
    
    // 详细信息
    NSDictionary *profile = [dataDic objectForKey:@"profile"];
    IBaseUserM *profileM = [IBaseUserM objectWithKeyValues:profile];
    
    //设置用户信息
    self.baseUserModel = profileM;
    _userInfoView.baseUserModel = _baseUserModel;
    
    //设置操作按钮
    if (_operateType) {
        _userInfoView.operateType = _operateType;
    }
    
    [self setRightNavBtnWithUserInfoModel:_baseUserModel];
    
    //设置好友数量
    _wlSegmentedControl.sectionDetailTitles = @[@"",_baseUserModel.feedcount.stringValue.length > 0 ? (_baseUserModel.feedcount.integerValue > 1000 ? @"999+" : _baseUserModel.feedcount.stringValue) : @"",_baseUserModel.samefriendscount.stringValue.length > 0 ? (_baseUserModel.samefriendscount.integerValue > 99 ? @"99+" : _baseUserModel.samefriendscount.stringValue) : @""];
    
    // 动态
    //    NSDictionary *feed = [dataDic objectForKey:@"feed"];
    //    WLStatusM *feedM = [WLStatusM objectWithKeyValues:feed];
    
    // 投资案例
    NSDictionary *investor = [dataDic objectForKey:@"investor"];
    IIMeInvestAuthModel *investorM = [IIMeInvestAuthModel objectWithDict:investor];
    
    // 我的项目
    //    NSString *projectName = [[dataDic objectForKey:@"project"] objectForKey:@"name"];
    
    NSArray *projects = [dataDic objectForKey:@"projects"];
    NSArray *projectsArrayM = [IProjectInfo objectsWithInfo:projects];
    
    // 创业者
    //        NSDictionary *startup = [dataDic objectForKey:@"startup"];
    
    // 工作经历列表
    NSMutableArray *lvliArray = [NSMutableArray array];
    NSArray *usercompany = [dataDic objectForKey:@"usercompany"];
    for (NSDictionary *dic in usercompany) {
        ICompanyResult *usercompanyM = [ICompanyResult objectWithKeyValues:dic];
        [lvliArray addObject:usercompanyM];
    }
    
    // 教育经历列表
    NSArray *userschool = [dataDic objectForKey:@"userschool"];
    for (NSDictionary *dic  in userschool) {
        ISchoolResult *userschoolM = [ISchoolResult objectWithKeyValues:dic];
        [lvliArray addObject:userschoolM];
    }
    
    NSSortDescriptor *sortByName= [NSSortDescriptor sortDescriptorWithKey:@"startyear" ascending:NO];
    [lvliArray sortUsingDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSMutableArray *infos = [NSMutableArray array];
    //me_touzi.png   me_lvli.png me_xiangmu.png
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    /**  投资者认证  0 默认状态  1  认证成功  -2 正在审核  -1 认证失败 */
    if (_baseUserModel.investorauth.integerValue == 1 || _baseUserModel.uid.integerValue == loginUser.uid.integerValue) {
        if (investorM.items.count > 0 || investorM.industry.count > 0 || investorM.stages.count > 0) {
            //投资阶段
            NSMutableArray *types = [NSMutableArray array];
            if (investorM.stages.count > 0) {
                [types addObject:@{@"type":@(0)}];
            }
            //投资领域
            if (investorM.industry.count > 0) {
                [types addObject:@{@"type":@(1)}];
            }
            //投资案例
            if (investorM.items.count > 0) {
                [types addObject:@{@"type":@(2)}];
            }
            NSDictionary *infoData = @{@"info":investorM,@"types":types};
            [infos addObject:@{@"icon":@"me_touzi",@"title":@"投资信息",@"type":@(0),@"info":infoData}];
        }
    }
    
    if (projectsArrayM.count > 0) {
        [infos addObject:@{@"icon":@"me_xiangmu",@"title":@"项目",@"type":@(1),@"info":projectsArrayM}];
    }
    
    if (lvliArray.count > 0) {
        [infos addObject:@{@"icon":@"me_lvli",@"title":@"履历",@"type":@(2),@"info":lvliArray}];
    }
    self.datasource1 = infos;
}

@end
