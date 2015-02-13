//
//  ProjectDetailsViewController.m
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectDetailsViewController.h"
#import "ProjectUserListViewController.h"
#import "CreateProjectController.h"
#import "MemberProjectController.h"
#import "TOWebViewController.h"
#import "FinancingProjectController.h"

#import "ProjectInfoView.h"
#import "ProjectDetailView.h"
#import "WLSegmentedControl.h"
#import "CommentCell.h"
#import "NoCommentCell.h"
#import "ProjectFavorteViewCell.h"
#import "ProjectDetailInfoView.h"
#import "UserInfoBasicVC.h"
#import "MessageKeyboardView.h"
#import "MJRefresh.h"
//分享
#import "ShareEngine.h"
#import "LXActivity.h"
#import "SEImageCache.h"
//图片展示
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

// 投资人
#import "InvestCerVC.h"

#define kHeaderHeight 133.f
#define kHeaderHeight2 93.f
#define kSegementedControlHeight 50.f
#define kTableViewHeaderHeight 40.f

static NSString *noCommentCell = @"NoCommentCell";

@interface ProjectDetailsViewController ()<WLSegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource,LXActivityDelegate>
{
    BOOL _isFinish;
}
@property (assign,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *datasource;//用于存储评论数组
@property (strong,nonatomic) NSNumber *projectPid;
@property (strong,nonatomic) IProjectInfo *iProjectInfo;
@property (strong,nonatomic) ProjectInfo *projectInfo;
@property (assign,nonatomic) ProjectDetailInfoView *projectDetailInfoView;

@property (strong,nonatomic) IProjectDetailInfo *iProjectDetailInfo;
@property (strong,nonatomic) ProjectDetailInfo *projectDetailInfo;
@property (strong,nonatomic) CommentCellFrame *selecCommFrame;

@property (assign,nonatomic) UIButton *favorteBtn;
@property (assign,nonatomic) UIButton *zanBtn;
@property (strong,nonatomic) NSIndexPath *selectIndex;
@property (strong,nonatomic) UITapGestureRecognizer *tapGesture;

@property (strong,nonatomic) MessageKeyboardView *messageView;//下方的键盘输入栏目
@property (assign,nonatomic) UIToolbar *operateToolBar;//下方的操作栏

@property (assign,nonatomic) NSInteger pageIndex;
@property (assign,nonatomic) NSInteger pageSize;

@end

@implementation ProjectDetailsViewController

- (void)dealloc
{
    _projectPid = nil;
    _datasource = nil;
    _projectInfo = nil;
    _iProjectInfo = nil;
    _iProjectDetailInfo = nil;
    _projectDetailInfo = nil;
    _selecCommFrame = nil;
    _messageView = nil;
    _selectIndex = nil;
    _tapGesture = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
}

- (NSString *)title
{
    return @"项目详情";
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        //添加屏幕点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            //隐藏键盘
            [self hideKeyBoard];
        }];
        self.tapGesture = tap;
    }
    return _tapGesture;
}

//通过I模型展示
- (instancetype)initWithIProjectInfo:(IProjectInfo *)iProjectInfo
{
    self = [super init];
    if (self) {
        self.iProjectInfo = iProjectInfo;
        self.pageIndex = 1;
        self.pageSize = 10;
        self.projectPid = _iProjectInfo.pid;
        
        //初始化页面数据
        [self initUI];
    }
    return self;
}

- (instancetype)initWithProjectInfo:(ProjectInfo *)projectInfo
{
    self = [super init];
    if (self) {
        self.projectInfo = projectInfo;
        self.pageIndex = 1;
        self.pageSize = 10;
        self.projectPid = _projectInfo.pid;
        
        //初始化页面数据
        [self initUI];
    }
    return self;
}

- (instancetype)initWithProjectPid:(NSNumber *)projectPid
{
    self = [super init];
    if (self) {
        self.projectPid = projectPid;
        self.pageIndex = 1;
        self.pageSize = 10;
    }
    return self;
}

//
- (instancetype)initWithProjectDetailInfo:(IProjectDetailInfo *)detailInfo
{
    self = [super init];
    if (self) {
        self.iProjectDetailInfo = detailInfo;
        self.projectPid = _iProjectDetailInfo.pid;
        _isFinish = YES;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //删除键盘监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
//    //代理置空，否则会闪退 设置手势滑动返回
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    //开启iOS7的滑动返回效果
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        //只有在二级页面生效
//        if ([self.navigationController.viewControllers count] > 1) {
//            self.navigationController.interactivePopGestureRecognizer.delegate = self;
//        }
//    }
//}
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    //开启滑动手势
//    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//}

// 返回
- (void)backItem
{
    if (_isFinish) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //返回按钮
    UIButton *backBut = [[UIButton alloc] init];
    [backBut setTitle:@"返回" forState:UIControlStateNormal];
    [backBut setImage:[UIImage imageNamed:@"backItem"] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(backItem) forControlEvents:UIControlEventTouchUpInside];
    [backBut setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBut];
    [backBut sizeToFit];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0.f,0.f,self.view.width,self.view.height - toolBarHeight)];
    tableView.dataSource = self;
    tableView.delegate = self;
    //隐藏表格分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"NoCommentCell" bundle:nil] forCellReuseIdentifier:noCommentCell];
    
    //回复输入栏
    self.messageView = [[MessageKeyboardView alloc] initWithFrame:CGRectMake(0, tableView.bottom, self.view.width, toolBarHeight) andSuperView:self.view withMessageBlock:^(NSString *comment) {
        
        //评论,
        NSDictionary *params = [NSDictionary dictionary];
        //回复某个人的评论
        CommentMode *commentM = [[CommentMode alloc] init];
        commentM.comment = comment;
        commentM.created = [[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        if (_selecCommFrame) {
            params = @{@"pid":_projectPid,@"touid":_selecCommFrame.commentM.user.uid,@"comment":comment};
            
            WLBasicTrends *touser = [[WLBasicTrends alloc] init];
            touser.avatar = _selecCommFrame.commentM.user.avatar;
            touser.company = _selecCommFrame.commentM.user.company;
            touser.investorauth = _selecCommFrame.commentM.user.investorauth;
            touser.name = _selecCommFrame.commentM.user.name;
            touser.position = _selecCommFrame.commentM.user.position;
            touser.uid = _selecCommFrame.commentM.user.uid;
            commentM.touser = touser;
        }else{
            params = @{@"pid":_projectPid,@"comment":comment};
        }
        
        LogInUser *loginUser = [LogInUser getCurrentLoginUser];
        WLBasicTrends *user = [[WLBasicTrends alloc] init];
        user.avatar = loginUser.avatar;
        user.company = loginUser.company;
        user.investorauth = loginUser.investorauth.intValue;
        user.name = loginUser.name;
        user.position = loginUser.position;
        user.uid = loginUser.uid;
        commentM.user = user;
        
        [WLHttpTool commentProjectParameterDic:params
                                       success:^(id JSON) {
                                           commentM.fcid = JSON[@"pcid"];
                                           
                                           CommentCellFrame *commentFrame = [[CommentCellFrame alloc] init];
                                           [commentFrame setCommentM:commentM];
                                           [_datasource insertObject:commentFrame atIndex:0];
                                           
                                           //刷新列表
                                           _iProjectDetailInfo.commentcount = @(_iProjectDetailInfo.commentcount.integerValue + 1);
                                           [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                                       } fail:^(NSError *error) {
                                           [UIAlertView showWithTitle:@"系统提示" message:@"评论失败，请重试！"];
                                       }];
        
    }];
    [self.view addSubview:self.messageView];
    
    //设置底部操作栏
    UIToolbar *operateToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.f, tableView.bottom, self.view.width, toolBarHeight)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //点赞
    UIButton *zanBtn = [self getBtnWithTitle:@"点赞" image:[UIImage imageNamed:@"me_mywriten_good"]];
    [zanBtn addTarget:self action:@selector(zanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *zanBarItem = [[UIBarButtonItem alloc] initWithCustomView:zanBtn];
    self.zanBtn = zanBtn;
    
    //空白 评论 me_mywriten_comment@2x
    UIButton *commentBtn = [self getBtnWithTitle:@"评论" image:[UIImage imageNamed:@"me_mywriten_comment"]];
    [commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commentBarItem = [[UIBarButtonItem alloc] initWithCustomView:commentBtn];
//    UIBarButtonItem *zhongBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                                                                                  target:self action:nil];
    //收藏
    UIButton *favorteBtn = [self getBtnWithTitle:@"收藏" image:[UIImage imageNamed:@"me_mywriten_shoucang"]];
    [favorteBtn addTarget:self action:@selector(favorteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *favorteBarItem = [[UIBarButtonItem alloc] initWithCustomView:favorteBtn];
    self.favorteBtn = favorteBtn;
    
    operateToolBar.items = @[zanBarItem,spacer,commentBarItem,spacer,favorteBarItem];
    [self.view addSubview:operateToolBar];
    self.operateToolBar = operateToolBar;
    
    //项目详细信息
    ProjectDetailInfoView *projectDetailInfoView = [[ProjectDetailInfoView alloc] initWithFrame:self.view.bounds];
    projectDetailInfoView.hidden = YES;
    [[[UIApplication sharedApplication] keyWindow] addSubview:projectDetailInfoView];
    self.projectDetailInfoView = projectDetailInfoView;
    WEAKSELF;
    [projectDetailInfoView setCloseBlock:^(){
        [weakSelf closeProjectDetailInfoView];
    }];
    
    if (_projectDetailInfo) {
        [self.tableView reloadData];
        [self updateUI];
    }else{
        //获取数据
        [self initData];
    }
    
    //上提加载更多
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreCommentData)];
}

//获取按钮对象
- (UIButton *)getBtnWithTitle:(NSString *)title image:(UIImage *)image{
    UIButton *favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteBtn.backgroundColor = [UIColor clearColor];
    favoriteBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [favoriteBtn setTitle:title forState:UIControlStateNormal];
    [favoriteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [favoriteBtn setImage:image forState:UIControlStateNormal];
    favoriteBtn.imageEdgeInsets = UIEdgeInsetsMake(0.f, -10.f, 0.f, 0.f);
//    favoriteBtn.frame = CGRectMake(0.f, 0.f, self.view.width / 3.f, toolBarHeight);
    favoriteBtn.frame = CGRectMake(0.f, 0.f, (self.view.width - 20 * 2) / 3.f, toolBarHeight);
    return favoriteBtn;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //隐藏键盘
    [self hideKeyBoard];
}

#pragma mark - UITableView Datasource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _iProjectDetailInfo.zancount.integerValue < 1 ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_iProjectDetailInfo.zancount.integerValue < 1) {
        //没有点赞的好友
        return _datasource.count ? : 1;
    }else{
        if (section == 0) {
            return 1;
        }else{
            if (_datasource.count == 0) {
                return 1;
            }else{
                return _datasource.count ? : 1;
            }
        }

    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:Rect(.0f, .0f, self.view.width, kTableViewHeaderHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.text = section == 0 && _iProjectDetailInfo.zancount.integerValue > 0 ? @"赞过的人" : [NSString stringWithFormat:@"评论（%d）",_iProjectDetailInfo.commentcount.intValue];
    [titleLabel sizeToFit];
    titleLabel.left = 15.f;
    titleLabel.centerY = headerView.height / 2.f;
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_iProjectDetailInfo.zancount.intValue > 0) {
        if(indexPath.section == 0){
            //赞过的人
            static NSString *cellIdentifier = @"Project_Favorte_View_Cell";
            ProjectFavorteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[ProjectFavorteViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.projectInfo = _iProjectDetailInfo;
            WEAKSELF;
            [cell setBlock:^(NSIndexPath *indexPath){
                [weakSelf selectZanUserWithIndex:indexPath];
            }];
            return cell;
        }else{
            //评论列表
            if (_datasource.count > 0) {
                CommentCell *cell = [CommentCell cellWithTableView:tableView];
                cell.showBottomLine = YES;
                // 传递的模型：文字数据 + 子控件frame数据
                cell.commentCellFrame = _datasource[indexPath.row];
                cell.commentVC = self;
                return cell;
            }else{
                NoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:noCommentCell];
                [cell.msgLabel setFont:WLFONT(14)];
                cell.msgLabel.text = @"还没有评论哦,赶快抢占沙发吧~";
                cell.layer.borderColorFromUIColor = [UIColor clearColor];
                return cell;
            }
        }
    }else{
        //评论列表
        if (_datasource.count > 0) {
            CommentCell *cell = [CommentCell cellWithTableView:tableView];
            cell.showBottomLine = YES;
            // 传递的模型：文字数据 + 子控件frame数据
            cell.commentCellFrame = _datasource[indexPath.row];
            cell.commentVC = self;
            return cell;
        }else{
            NoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:noCommentCell];
            [cell.msgLabel setFont:WLFONT(14)];
            cell.msgLabel.text = @"还没有评论哦,赶快抢占沙发吧~";
            cell.layer.borderColorFromUIColor = [UIColor clearColor];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectIndex = indexPath;
    
    CommentCellFrame *selecCommFrame = _datasource[indexPath.row];
    
    UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    if (selecCommFrame.commentM.user.uid.integerValue == [LogInUser getCurrentLoginUser].uid.integerValue) {
        [sheet bk_setDestructiveButtonWithTitle:@"删除" handler:^{
            [WLHttpTool deleteProjectCommentParameterDic:@{@"pcid":selecCommFrame.commentM.fcid}
                                                 success:^(id JSON) {
                                                     //删除当前对象
                                                     [_datasource removeObject:selecCommFrame];
                                                     
                                                     //刷新列表
                                                     _iProjectDetailInfo.commentcount = @(_iProjectDetailInfo.commentcount.integerValue - 1);
                                                     
                                                     //刷新
                                                     [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                                                 } fail:^(NSError *error) {
                                                     [UIAlertView showWithTitle:@"系统提示" message:@"删除失败，请重试！"];
                                                 }];
        }];
    }else{
        [sheet bk_addButtonWithTitle:@"回复" handler:^{
            self.selecCommFrame = selecCommFrame;
            [self.messageView startCompile:_selecCommFrame.commentM.user];
        }];
    }
    [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [sheet showInView:self.view];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_iProjectDetailInfo.zancount.intValue > 0) {
        return kTableViewHeaderHeight;
    }else{
        if (_iProjectDetailInfo.commentcount.integerValue > 0) {
            return kTableViewHeaderHeight;
        }else{
            return 0;
        }
    }
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
    if (_iProjectDetailInfo.zancount.intValue > 0) {
        if (indexPath.section == 0) {
            return 40.f;
        }
        if (_datasource.count > 0) {
            return [_datasource[indexPath.row] cellHeight];
        }else{
            return 60.f;
        }
    }else{
        if (_datasource.count > 0) {
            return [_datasource[indexPath.row] cellHeight];
        }else{
            return 60.f;
        }
    }
}

#pragma mark - WLSegmentedControlDelegate
- (void)wlSegmentedControlSelectAtIndex:(NSInteger)index
{
    DLog(@"选择的栏目：%d",(int)index);
    switch (index) {
        case 0:
        {
            //项目网站
            if (_projectDetailInfo.website.length > 0) {
                TOWebViewController *webVC = [[TOWebViewController alloc] initWithURLString:_projectDetailInfo.website];
                webVC.navigationButtonsHidden = YES;//隐藏底部操作栏目
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
            break;
        case 1:
        {
            //项目成员
            if (_projectDetailInfo.membercount.integerValue > 0) {
                ProjectUserListViewController *projectUserListVC = [[ProjectUserListViewController alloc] init];
                projectUserListVC.infoType = UserInfoTypeProjectGroup;
                projectUserListVC.projectDetailInfo = _iProjectDetailInfo;
                [self.navigationController pushViewController:projectUserListVC animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - LXActivityDelegate
- (void)didClickOnImageIndex:(NSString *)imageIndex
{
    DLog(@"选择的项目：%@",imageIndex);
    
    if ([imageIndex isEqualToString:@"微信好友"]) {
        [self shareInfoWithType:1];
    }
    if ([imageIndex isEqualToString:@"微信朋友圈"]) {
        [self shareInfoWithType:2];
    }
    WEAKSELF
    if ([imageIndex isEqualToString:@"设置融资信息"]) {
        FinancingProjectController *financingProjectVC = [[FinancingProjectController alloc] initIsEdit:YES withData:_iProjectDetailInfo];
        financingProjectVC.projectDataBlock = ^(ProjectDetailInfo *projectModel){
            weakSelf.projectDetailInfo = projectModel;
            [weakSelf updateUI];
        };
        [self.navigationController pushViewController:financingProjectVC animated:YES];
    }
    if ([imageIndex isEqualToString:@"设置团队成员"]) {
        MemberProjectController *memberProjectVC = [[MemberProjectController alloc] initIsEdit:YES withData:_iProjectDetailInfo];
        memberProjectVC.projectDataBlock = ^(ProjectDetailInfo *projectModel){
            weakSelf.projectDetailInfo = projectModel;
            [weakSelf updateUI];
        };
        [self.navigationController pushViewController:memberProjectVC animated:YES];
    }
    if ([imageIndex isEqualToString:@"编辑项目信息"]) {
        CreateProjectController *createProjcetVC = [[CreateProjectController alloc] initIsEdit:YES withData:_iProjectDetailInfo];
        createProjcetVC.projectDataBlock = ^(ProjectDetailInfo *projectModel){
            weakSelf.projectDetailInfo = projectModel;
            [weakSelf updateUI];
        };
        [self.navigationController pushViewController:createProjcetVC animated:YES];
    }
}

//分享
- (void)shareInfoWithType:(NSInteger)type
{
    NSString *desc = [NSString stringWithFormat:@"%@\n%@",_projectDetailInfo.name,_projectDetailInfo.intro];
    UIImage *shareImage = [UIImage imageNamed:@"discovery_xiangmu"];
    NSString *link = _projectDetailInfo.shareurl.length == 0 ? @"http://www.welian.com/" : _projectDetailInfo.shareurl;
    NSString *title = @"";
    WeiboType wxType = weChat;
    switch (type) {
        case 1:
            title = @"推荐一个好项目";
            wxType = weChat;
            break;
        case 2:
            title = [NSString stringWithFormat:@"%@ | %@",_projectDetailInfo.name,_projectDetailInfo.intro];
            wxType = weChatFriend;
            break;
        default:
            break;
    }
    
    [[ShareEngine sharedShareEngine] sendWeChatMessage:title andDescription:desc WithUrl:link andImage:shareImage WithScene:wxType];
//    [WLHUDView showHUDWithStr:@"" dim:NO];
//    [[SEImageCache sharedInstance] imageForURL:imgUrl completionBlock:^(UIImage *image, NSError *error) {
//        [WLHUDView hiddenHud];
//        DLog(@"shareFriendImage---->>>%@",image);
//        
//    }];
}

#pragma mark - Private
/**
 *  分享
 */
- (void)shareBtnClicked
{
    NSArray *buttons = [NSArray array];
    if ([LogInUser getCurrentLoginUser].uid.integerValue == _iProjectDetailInfo.user.uid.integerValue) {
        buttons = @[@"编辑项目信息",@"设置团队成员",@"设置融资信息"];
    }
    LXActivity *lxActivity = [[LXActivity alloc] initWithDelegate:self WithTitle:@"分享到" otherButtonTitles:buttons ShareButtonTitles:@[@"微信好友",@"微信朋友圈"] withShareButtonImagesName:@[@"home_repost_wechat",@"home_repost_friendcirle"]];
    [lxActivity showInView:[UIApplication sharedApplication].keyWindow];
}

/**
 *  点赞
 *
 *  @param sender 触发的按钮
 */
- (void)zanBtnClicked:(UIButton *)sender
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    NSMutableArray *zanUsers = [NSMutableArray arrayWithArray:_iProjectDetailInfo.zanusers];
    if (!_iProjectDetailInfo.iszan.boolValue) {
        //赞
        [WLHttpTool zanProjectParameterDic:@{@"pid":_projectPid}
                                   success:^(id JSON) {
                                       _iProjectDetailInfo.iszan = @(1);
                                       _iProjectDetailInfo.zancount = @(_iProjectDetailInfo.zancount.integerValue + 1);
                                       [_projectDetailInfo updateZancount:_iProjectDetailInfo.zancount];
                                       
                                       IBaseUserM *zanUser = [[IBaseUserM alloc] init];
                                       zanUser.avatar = loginUser.avatar;
                                       zanUser.name = loginUser.name;
                                       zanUser.uid = loginUser.uid;
                                       zanUser.position = loginUser.position;
                                       zanUser.company = loginUser.company;
                                       zanUser.investorauth = loginUser.investorauth;
                                       //插入
                                       [zanUsers insertObject:zanUser atIndex:0];
                                       _iProjectDetailInfo.zanusers = [NSArray arrayWithArray:zanUsers];
                                       
                                       //刷新
                                       if (_iProjectDetailInfo.zancount.integerValue <= 1) {
                                           //如果之前没有刷新整个table
                                           [_tableView reloadData];
                                       }else{
                                           [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                                       }
                                       
                                       [self checkZanStatus];
                                       
                                       [self updateUI];
                                   } fail:^(NSError *error) {
                                       [UIAlertView showWithTitle:@"系统提示" message:@"点赞失败，请重试！"];
                                   }];
    }else{
        //取消赞
        [WLHttpTool deleteProjectZanParameterDic:@{@"pid":_projectPid}
                                         success:^(id JSON) {
                                             _iProjectDetailInfo.iszan = @(0);
                                             _iProjectDetailInfo.zancount = @(_iProjectDetailInfo.zancount.integerValue - 1);
                                             [_projectDetailInfo updateZancount:_iProjectDetailInfo.zancount];
                                             
                                             IBaseUserM *zanUser = [zanUsers bk_match:^BOOL(id obj) {
                                                 return [obj uid].integerValue == loginUser.uid.integerValue;
                                             }];
                                             if (zanUser) {
                                                 [zanUsers removeObject:zanUser];
                                                 
                                                 _iProjectDetailInfo.zanusers = [NSArray arrayWithArray:zanUsers];
                                                 
                                                 //刷新
                                                 if (_iProjectDetailInfo.zancount.integerValue <= 1) {
                                                     //如果之前没有刷新整个table
                                                     [_tableView reloadData];
                                                 }else{
                                                     [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                                                 }
                                             }
                                             
                                             [self checkZanStatus];
                                             
                                             [self updateUI];
                                         } fail:^(NSError *error) {
                                             [UIAlertView showWithTitle:@"系统提示" message:@"取消赞失败，请重试！"];
                                         }];
    }
    
}

/**
 *  评论项目
 *
 *  @param sender 触发的按钮
 */
- (void)commentBtnClicked:(UIButton *)sender
{
    _selecCommFrame = nil;
    _selectIndex = nil;
    [self.messageView.commentTextView becomeFirstResponder];
}

/**
 *  收藏
 *
 *  @param sender 触发的按钮
 */
- (void)favorteBtnClicked:(UIButton *)sender
{
    if (_iProjectDetailInfo.isfavorite.boolValue) {
        //取消收藏
        [WLHttpTool deleteFavoriteProjectParameterDic:@{@"pid":_projectPid}
                                              success:^(id JSON) {
                                                  _iProjectDetailInfo.isfavorite = @(0);
                                                  [self checkFavorteStatus];
                                                  if (self.favoriteBlock) {
                                                      self.favoriteBlock();
                                                  }
                                              } fail:^(NSError *error) {
                                                  [UIAlertView showWithTitle:@"系统提示" message:@"取消收藏失败，请重试！"];
                                              }]; 
    }else{
        //收藏项目
        [WLHttpTool favoriteProjectParameterDic:@{@"pid":_projectPid}
                                        success:^(id JSON) {
                                            _iProjectDetailInfo.isfavorite = @(1);
                                            [self checkFavorteStatus];
                                        } fail:^(NSError *error) {
                                            [UIAlertView showWithTitle:@"系统提示" message:@"收藏项目失败，请重试！"];
                                        }];
    }
    
}

//检测是否点赞
- (void)checkZanStatus
{
    if (_iProjectDetailInfo.iszan.boolValue) {
        [_zanBtn setTitle:@"已赞" forState:UIControlStateNormal];
        [_zanBtn setImage:[UIImage imageNamed:@"me_mywriten_good_pre"] forState:UIControlStateNormal];
    }else{
        [_zanBtn setTitle:@"点赞" forState:UIControlStateNormal];
        [_zanBtn setImage:[UIImage imageNamed:@"me_mywriten_good"] forState:UIControlStateNormal];
    }
}

//检测是否收藏当前项目
- (void)checkFavorteStatus
{
    if (_iProjectDetailInfo.isfavorite.boolValue) {
        [_favorteBtn setTitle:@"已收藏" forState:UIControlStateNormal];
        [_favorteBtn setImage:[UIImage imageNamed:@"me_mywriten_shoucang_pre"] forState:UIControlStateNormal];
    }else{
        [_favorteBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_favorteBtn setImage:[UIImage imageNamed:@"me_mywriten_shoucang"] forState:UIControlStateNormal];
    }
}

/**
 *  现实项目信息
 */
- (void)showProjectInfo
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    //认证投资人或者自己创建的项目可以查看融资信息
    if (loginUser.investorauth.boolValue || loginUser.uid.integerValue == _projectDetailInfo.rsProjectUser.uid.integerValue) {
        [self openProjectDetailInfoView];
    }else{
        [UIAlertView bk_showAlertViewWithTitle:nil
                                       message:@"您不是认证投资人，无法查看融资信息"
                             cancelButtonTitle:@"取消"
                             otherButtonTitles:@[@"去认证"]
                                       handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                           if (buttonIndex == 0) {
                                               return ;
                                           }else{
                                               InvestCerVC *investVC = [[InvestCerVC alloc] initWithStyle:UITableViewStyleGrouped];
                                               [investVC setTitle:@"我是投资人"];
                                               [self.navigationController pushViewController:investVC animated:YES];
                                           }
                                       }];
    }
}

//关闭项目详情
- (void)closeProjectDetailInfoView
{
    _projectDetailInfoView.hidden = YES;
}

- (void)openProjectDetailInfoView
{
    _projectDetailInfoView.projectDetailInfo = _iProjectDetailInfo;
    _projectDetailInfoView.hidden = NO;
}

//获取详情信息
- (void)initData{
    [WLHttpTool getProjectDetailParameterDic:@{@"pid":_projectPid}
                                     success:^(id JSON) {
                                         IProjectDetailInfo *detailInfo = [IProjectDetailInfo objectWithDict:JSON];
                                         self.iProjectDetailInfo = detailInfo;
                                         self.projectDetailInfo = [ProjectDetailInfo createWithIProjectDetailInfo:detailInfo];
                                         
                                         //添加分享按钮
                                         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_more"] style:UIBarButtonItemStyleBordered target:self action:@selector(shareBtnClicked)];
                                         
                                         NSMutableArray *dataAM = [NSMutableArray arrayWithCapacity:detailInfo.comments.count];
                                         for (ICommentInfo *commentInfo in detailInfo.comments) {
                                             
                                             CommentMode *commentM = [[CommentMode alloc] init];
                                             commentM.fcid = commentInfo.pcid;
                                             commentM.comment = commentInfo.comment;
                                             commentM.created = commentInfo.created;
                                             if (commentInfo.user.uid) {
                                                 WLBasicTrends *user = [[WLBasicTrends alloc] init];
                                                 user.avatar = commentInfo.user.avatar;
                                                 user.company = commentInfo.user.company;
                                                 user.investorauth = commentInfo.user.investorauth.intValue;
                                                 user.name = commentInfo.user.name;
                                                 user.position = commentInfo.user.position;
                                                 user.uid = commentInfo.user.uid;
                                                 commentM.user = user;
                                             }
                                             if (commentInfo.touser.uid) {
                                                 WLBasicTrends *touser = [[WLBasicTrends alloc] init];
                                                 touser.avatar = commentInfo.touser.avatar;
                                                 touser.company = commentInfo.touser.company;
                                                 touser.investorauth = commentInfo.touser.investorauth.intValue;
                                                 touser.name = commentInfo.touser.name;
                                                 touser.position = commentInfo.touser.position;
                                                 touser.uid = commentInfo.touser.uid;
                                                 commentM.touser = touser;
                                             }
                                             
                                             CommentCellFrame *commentFrame = [[CommentCellFrame alloc] init];
                                             [commentFrame setCommentM:commentM];
                                             
                                             [dataAM addObject:commentFrame];
                                         }
                                         self.datasource = dataAM;
                                         [_tableView reloadData];
                                         
                                         [self updateUI];
                                     } fail:^(NSError *error) {
                                         [UIAlertView showWithTitle:@"系统提示" message:@"获取详情失败，请重试！"];
                                     }];
}

//初始化页面展示
- (void)initUI
{
    //设置头部内容
    CGFloat detailHeight = _projectInfo ? [ProjectDetailView configureWithInfo:_projectInfo.des Images:nil] : [ProjectDetailView configureWithInfo:_iProjectInfo.des Images:nil];
    CGFloat projectInfoViewHeight =  _projectInfo ? [ProjectInfoView configureWithProjectInfo:_projectInfo] : [ProjectInfoView configureWithIProjectInfo:_iProjectInfo];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, self.view.width,projectInfoViewHeight + detailHeight)];
    ProjectInfoView *projectInfoView = [[ProjectInfoView alloc] initWithFrame:Rect(0, 0, self.view.width,projectInfoViewHeight)];
    if (_projectInfo) {
        projectInfoView.projectInfo = _projectInfo;
    }
    if (_iProjectInfo) {
        projectInfoView.iProjectInfo = _iProjectInfo;
    }
    //设置底部边框线
    projectInfoView.layer.borderColorFromUIColor = RGB(229.f, 229.f, 229.f);//RGB(173.f, 173.f, 173.f);
    projectInfoView.layer.borderWidths = @"{0,0,0.5,0}";
    
    //项目详情
    ProjectDetailView *projectDetailView = [[ProjectDetailView alloc] initWithFrame:Rect(0, projectInfoViewHeight, self.view.width, detailHeight)];
    if (_projectInfo) {
        projectDetailView.projectInfo = _projectInfo;
    }
    if (_iProjectInfo) {
        projectDetailView.iProjectInfo = _iProjectInfo;
    }
    
    [headView addSubview:projectInfoView];
    [headView addSubview:projectDetailView];
    [_tableView setTableHeaderView:headView];
}
//更新也没展示
- (void)updateUI{
    //设置头部内容
    CGFloat detailHeight = [ProjectDetailView configureWithInfo:_projectDetailInfo.des Images:_projectDetailInfo.rsPhotoInfos.allObjects];
    CGFloat projectInfoViewHeight = [ProjectInfoView configureWithInfo:_projectDetailInfo];//_projectInfo.status.boolValue ? kHeaderHeight : kHeaderHeight2;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, self.view.width,projectInfoViewHeight + detailHeight + kSegementedControlHeight)];
    ProjectInfoView *projectInfoView = [[ProjectInfoView alloc] initWithFrame:Rect(0, 0, self.view.width,projectInfoViewHeight)];
    projectInfoView.projectDetailInfo = _projectDetailInfo;
    //设置底部边框线
    projectInfoView.layer.borderColorFromUIColor = RGB(229.f, 229.f, 229.f);//RGB(173.f, 173.f, 173.f);
    projectInfoView.layer.borderWidths = @"{0,0,0.5,0}";
    WEAKSELF;
    [projectInfoView setInfoBlock:^(void){
        [weakSelf showProjectInfo];
    }];
    [projectInfoView setUserShowBlock:^(void){
        [weakSelf showProjectUserInfo];
    }];
    
    //项目详情
    ProjectDetailView *projectDetailView = [[ProjectDetailView alloc] initWithFrame:Rect(0, projectInfoView.bottom, self.view.width, detailHeight)];
    projectDetailView.projectDetailInfo = _projectDetailInfo;
    [projectDetailView setImageClickedBlock:^(NSIndexPath *indexPath,NSArray *photos){
        [weakSelf showDetailImagesWithIndex:indexPath Photos:photos];
    }];
    
    //操作栏
    NSString *linkImage = _projectDetailInfo.website.length > 0 ? @"discovery_xiangmu_detail_link" : @"discovery_xiangmu_detail_nolink";
    NSString *memeberImage = _projectDetailInfo.membercount.integerValue > 0 ? @"discovery_xiangmu_detail_member" : @"discovery_xiangmu_detail_nomember";
    WLSegmentedControl *segementedControl = [[WLSegmentedControl alloc] initWithFrame:Rect(0,projectDetailView.bottom,self.view.width,kSegementedControlHeight) Titles:@[@"项目网址",[NSString stringWithFormat:@"团队成员(%d)",[_projectDetailInfo.membercount intValue]]] Images:@[[UIImage imageNamed:linkImage],[UIImage imageNamed:memeberImage]] Bridges:nil isHorizontal:YES];
    segementedControl.delegate = self;
    //设置底部边框线
    segementedControl.layer.borderColorFromUIColor = RGB(229.f, 229.f, 229.f);
    segementedControl.layer.borderWidths = @"{0.5,0,0.5,0}";
    
    [headView addSubview:projectInfoView];
    [headView addSubview:projectDetailView];
    [headView addSubview:segementedControl];
    [_tableView setTableHeaderView:headView];
    
    //判断赞按钮状态
    [self checkZanStatus];
    //判断收藏状态
    [self checkFavorteStatus];
}

//显示项目创建人的信息
- (void)showProjectUserInfo
{
    //系统联系人
    UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:_iProjectDetailInfo.user isAsk:NO];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

//展示项目图片
- (void)showDetailImagesWithIndex:(NSIndexPath *)indexPath Photos:(NSArray *)photos{
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

//选择点赞的列表
- (void)selectZanUserWithIndex:(NSIndexPath *)indexPath
{
    if (indexPath.row == _iProjectDetailInfo.zanusers.count) {
        if (_projectDetailInfo.zancount.integerValue > 0) {
            //进入赞列表
            ProjectUserListViewController *projectUserListVC = [[ProjectUserListViewController alloc] init];
            projectUserListVC.infoType = UserInfoTypeProjectZan;
            projectUserListVC.projectDetailInfo = _iProjectDetailInfo;
            [self.navigationController pushViewController:projectUserListVC animated:YES];
        }
    }else{
        //点击点赞的人，进入
        IBaseUserM *user = _iProjectDetailInfo.zanusers[indexPath.row];
        //系统联系人
        UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:user isAsk:NO];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }
}

//加载更多评论
- (void)loadMoreCommentData
{
    if (_datasource.count >= _iProjectDetailInfo.commentcount.integerValue) {
        //隐藏加载更多动画
        [self.tableView footerEndRefreshing];
        [self.tableView setFooterHidden:YES];
        return;
    }
    if (_datasource.count < _iProjectDetailInfo.commentcount.integerValue) {
        _pageIndex++;
        [WLHttpTool getProjectCommentsParameterDic:@{@"pid":_projectPid,@"page":@(_pageIndex),@"size":@(_pageSize)}
                                           success:^(id JSON) {
                                               //隐藏加载更多动画
                                               [self.tableView footerEndRefreshing];
                                               
                                               if (JSON) {
                                                   NSArray *comments = [ICommentInfo objectsWithInfo:JSON];
                                                   
                                                   for (ICommentInfo *commentInfo in comments) {
                                                       CommentMode *commentM = [[CommentMode alloc] init];
                                                       commentM.fcid = commentInfo.pcid;
                                                       commentM.comment = commentInfo.comment;
                                                       commentM.created = commentInfo.created;
                                                       if (commentInfo.user.uid) {
                                                           WLBasicTrends *user = [[WLBasicTrends alloc] init];
                                                           user.avatar = commentInfo.user.avatar;
                                                           user.company = commentInfo.user.company;
                                                           user.investorauth = commentInfo.user.investorauth.intValue;
                                                           user.name = commentInfo.user.name;
                                                           user.position = commentInfo.user.position;
                                                           user.uid = commentInfo.user.uid;
                                                           commentM.user = user;
                                                       }
                                                       if (commentInfo.touser.uid) {
                                                           WLBasicTrends *touser = [[WLBasicTrends alloc] init];
                                                           touser.avatar = commentInfo.touser.avatar;
                                                           touser.company = commentInfo.touser.company;
                                                           touser.investorauth = commentInfo.touser.investorauth.intValue;
                                                           touser.name = commentInfo.touser.name;
                                                           touser.position = commentInfo.touser.position;
                                                           touser.uid = commentInfo.touser.uid;
                                                           commentM.touser = touser;
                                                       }
                                                       
                                                       CommentCellFrame *commentFrame = [[CommentCellFrame alloc] init];
                                                       [commentFrame setCommentM:commentM];
                                                       
                                                       [_datasource addObject:commentFrame];
                                                   }
                                                   //刷新列表
                                                   [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                                               }
                                           } fail:^(NSError *error) {
                                               
                                           }];
    }
}

//隐藏键盘
- (void)hideKeyBoard
{
    //处理
    _selectIndex = nil;
    
    //取消手势
    [_tableView removeGestureRecognizer:self.tapGesture];
    
    //显示下方的操作栏
    _operateToolBar.hidden = NO;
    
    [self.messageView dismissKeyBoard];
    [self.messageView startCompile:nil];
}

//键盘监听 改变
- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y - toolBarHeight;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    _tableView.frame = newTextViewFrame;
//    [_tableView setDebug:YES];
    [UIView commitAnimations];
    
    //设置
    if (_selectIndex) {
        [_tableView scrollToRowAtIndexPath:_selectIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }else{
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    //添加手势
    [_tableView addGestureRecognizer:self.tapGesture];
    //隐藏下方的操作栏
    _operateToolBar.hidden = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    //    textView.frame = self.view.bounds;
    _tableView.frame = Rect(0.f,0.f,self.view.width,self.view.height - toolBarHeight);
    [UIView commitAnimations];
}

@end
