//
//  ProjectDetailsViewController.m
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectDetailsViewController.h"
#import "ProjectInfoView.h"
#import "ProjectDetailView.h"
#import "WLSegmentedControl.h"
#import "CommentCell.h"
#import "NoCommentCell.h"
#import "ProjectFavorteViewCell.h"
#import "ShareEngine.h"
#import "LXActivity.h"
#import "ProjectDetailInfoView.h"
#import "UserInfoBasicVC.h"
#import "ProjectUserListViewController.h"
#import "TOWebViewController.h"

#define kHeaderHeight 133.f
#define kHeaderHeight2 93.f
#define kSegementedControlHeight 40.f
#define kTableViewHeaderHeight 30.f

static NSString *noCommentCell = @"NoCommentCell";

@interface ProjectDetailsViewController ()<WLSegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource,LXActivityDelegate>

@property (assign,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *datasource;
@property (strong,nonatomic) IProjectInfo *projectInfo;
@property (assign,nonatomic) ProjectDetailInfoView *projectDetailInfoView;

@property (strong,nonatomic) IProjectDetailInfo *detailInfo;

@property (assign,nonatomic) UIButton *favorteBtn;
@property (assign,nonatomic) UIButton *zanBtn;

@end

@implementation ProjectDetailsViewController

- (void)dealloc
{
    _datasource = nil;
    _projectInfo = nil;
    _detailInfo = nil;
}

- (NSString *)title
{
    return @"详情";
}

- (instancetype)initWithProjectInfo:(IProjectInfo *)projectInfo
{
    self = [super init];
    if (self) {
//        self.datasource = @[@"",@"",@"",@"",@""];
//        CommentMode *commentM = [CommentMode objectWithKeyValues:dic];
//        CommentCellFrame *commentFrame = [[CommentCellFrame alloc] init];
//        [commentFrame setCommentM:commentM];
        self.projectInfo = projectInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加分享按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_more"] style:UIBarButtonItemStyleBordered target:self action:@selector(shareBtnClicked)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0.f,0.f,self.view.width,self.view.height - 44.f)];
    tableView.dataSource = self;
    tableView.delegate = self;
    //隐藏表格分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"NoCommentCell" bundle:nil] forCellReuseIdentifier:noCommentCell];
    
    
    
    //设置底部操作栏
    UIToolbar *operateToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.f, tableView.bottom, self.view.width, 44.0f)];
    //点赞
    self.zanBtn = [self getBtnWithTitle:@"点赞" image:[UIImage imageNamed:@"me_mywriten_good"]];
    [_zanBtn addTarget:self action:@selector(zanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *zanBarItem = [[UIBarButtonItem alloc] initWithCustomView:_zanBtn];
    
    //空白 评论 me_mywriten_comment@2x
    UIBarButtonItem *zhongBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:self action:nil];
    //收藏
    self.favorteBtn = [self getBtnWithTitle:@"收藏" image:[UIImage imageNamed:@"me_mywriten_shoucang"]];
    [_favorteBtn addTarget:self action:@selector(favorteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *favorteBarItem = [[UIBarButtonItem alloc] initWithCustomView:_favorteBtn];
    
    operateToolBar.items = @[zanBarItem,zhongBarItem,favorteBarItem];
    [self.view addSubview:operateToolBar];
    
    //项目详细信息
    ProjectDetailInfoView *projectDetailInfoView = [[ProjectDetailInfoView alloc] initWithFrame:self.navigationController.view.frame];
    projectDetailInfoView.hidden = YES;
    [self.navigationController.view addSubview:projectDetailInfoView];
    self.projectDetailInfoView = projectDetailInfoView;
    WEAKSELF;
    [projectDetailInfoView setCloseBlock:^(){
        [weakSelf closeProjectDetailInfoView];
    }];
    
    [self initData];
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
    favoriteBtn.frame = CGRectMake(0.f, 0.f, self.view.width / 3.f, 44.f);
    return favoriteBtn;
}

#pragma mark - UITableView Datasource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        if (_datasource.count == 0) {
            return 1;
        }else{
            return _datasource.count;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"赞过的人";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:Rect(.0f, .0f, self.view.width, kTableViewHeaderHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.text = section == 0 ? @"赞过的人" : [NSString stringWithFormat:@"评论 (%d)",32];
    [titleLabel sizeToFit];
    titleLabel.left = 15.f;
    titleLabel.centerY = headerView.height / 2.f;
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //赞过的人
        static NSString *cellIdentifier = @"Project_Favorte_View_Cell";
        ProjectFavorteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[ProjectFavorteViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.projectInfo = _detailInfo;
        WEAKSELF;
        [cell setBlock:^(NSIndexPath *indexPath){
            [weakSelf selectZanUserWithIndex:indexPath];
        }];
        return cell;
    }else{
        //评论列表
        if (_datasource.count > 0) {
            CommentCell *cell = [CommentCell cellWithTableView:tableView];
            
//            CommentMode *commentM = [CommentMode objectWithKeyValues:dic];
//            CommentCellFrame *commentFrame = [[CommentCellFrame alloc] init];
//            [commentFrame setCommentM:commentM];
            
            // 传递的模型：文字数据 + 子控件frame数据
            cell.commentCellFrame = _datasource[indexPath.row];
            cell.commentVC = self;
            return cell;
        }else{
            NoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:noCommentCell];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableViewHeaderHeight;
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
    if (indexPath.section == 0) {
        return 40.f;
    }
    return 60;
}

#pragma mark - WLSegmentedControlDelegate
- (void)wlSegmentedControlSelectAtIndex:(NSInteger)index
{
    DLog(@"选择的栏目：%d",(int)index);
    switch (index) {
        case 0:
        {
            //项目网站
            TOWebViewController *webVC = [[TOWebViewController alloc] initWithURLString:@"http://m.huxiu.com/"];
            webVC.navigationButtonsHidden = YES;//隐藏底部操作栏目
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 1:
        {
            ProjectUserListViewController *projectUserListVC = [[ProjectUserListViewController alloc] init];
            projectUserListVC.infoType = UserInfoTypeProjectGroup;
            [self.navigationController pushViewController:projectUserListVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didClickOnImageIndex:(NSString *)imageIndex
{
    DLog(@"选择的项目：%@",imageIndex);
    if ([imageIndex isEqualToString:@"微信好友"]) {
        
    }
    if ([imageIndex isEqualToString:@"微信朋友圈"]) {
        
    }
    if ([imageIndex isEqualToString:@"设置融资信息"]) {
        
    }
    if ([imageIndex isEqualToString:@"设置团队成员"]) {
        
    }
    if ([imageIndex isEqualToString:@"编辑项目信息"]) {
        
    }
}

#pragma mark - Private
/**
 *  分享
 */
- (void)shareBtnClicked
{
    NSArray *buttons = @[@"编辑项目信息",@"设置团队成员",@"设置融资信息"];
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
    if (!_detailInfo.iszan.boolValue) {
        //赞
        [WLHttpTool zanProjectParameterDic:@{@"pid":_detailInfo.pid}
                                   success:^(id JSON) {
                                       _detailInfo.iszan = @(1);
                                       [self checkZanStatus];
                                   } fail:^(NSError *error) {
                                       [UIAlertView showWithError:error];
                                   }];
    }else{
        //取消赞
        [WLHttpTool deleteProjectZanParameterDic:@{@"pid":_detailInfo.pid}
                                         success:^(id JSON) {
                                             _detailInfo.iszan = @(0);
                                             [self checkZanStatus];
                                         } fail:^(NSError *error) {
                                             [UIAlertView showWithError:error];
                                         }];
    }
    
}

- (void)checkZanStatus
{
    if (_detailInfo.iszan.boolValue) {
        [_zanBtn setTitle:@"取消赞" forState:UIControlStateNormal];
        [_zanBtn setImage:[UIImage imageNamed:@"good_small"] forState:UIControlStateNormal];
    }else{
        [_zanBtn setTitle:@"点赞" forState:UIControlStateNormal];
        [_zanBtn setImage:[UIImage imageNamed:@"me_mywriten_good"] forState:UIControlStateNormal];
    }
}

/**
 *  收藏
 *
 *  @param sender 触发的按钮
 */
- (void)favorteBtnClicked:(UIButton *)sender
{
    [_favorteBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
    [_favorteBtn setImage:[UIImage imageNamed:@"me_mywriten_shoucang_pre"] forState:UIControlStateNormal];
}

/**
 *  现实项目信息
 */
- (void)showProjectInfo
{
    [UIAlertView bk_showAlertViewWithTitle:nil
                                   message:@"您还不是认证投资人，无法查看融资信息"
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@[@"去认证"]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                       if (buttonIndex == 0) {
                                           return ;
                                       }else{
                                           [self openProjectDetailInfoView];
                                       }
                                   }];
}

//关闭项目详情
- (void)closeProjectDetailInfoView
{
    _projectDetailInfoView.hidden = YES;
}

- (void)openProjectDetailInfoView
{
    _projectDetailInfoView.hidden = NO;
}

- (void)initData{
    [WLHttpTool getProjectDetailParameterDic:@{@"pid":_projectInfo.pid}
                                     success:^(id JSON) {
                                         IProjectDetailInfo *detailInfo = [IProjectDetailInfo objectWithDict:JSON];
                                         self.detailInfo = detailInfo;
                                         [self updateUI];
                                         [_tableView reloadData];
                                     } fail:^(NSError *error) {
                                         [UIAlertView showWithError:error];
                                     }];
}

- (void)updateUI{
    //设置头部内容
    CGFloat detailHeight = [ProjectDetailView configureWithInfo:_detailInfo.des Images:_detailInfo.photos];
    CGFloat projectInfoViewHeight = _projectInfo.status.boolValue ? kHeaderHeight : kHeaderHeight2;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, self.view.width,projectInfoViewHeight + detailHeight + kSegementedControlHeight)];
    ProjectInfoView *projectInfoView = [[ProjectInfoView alloc] initWithFrame:Rect(0, 0, self.view.width,projectInfoViewHeight)];
    projectInfoView.projectInfo = _detailInfo;
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
    
    ProjectDetailView *projectDetailView = [[ProjectDetailView alloc] initWithFrame:Rect(0, projectInfoView.bottom, self.view.width, detailHeight)];
    projectDetailView.projectInfo = _detailInfo;
    
    //操作栏
    WLSegmentedControl *segementedControl = [[WLSegmentedControl alloc] initWithFrame:Rect(0,projectDetailView.bottom,self.view.width,kSegementedControlHeight) Titles:@[@"项目网址",[NSString stringWithFormat:@"团队成员(%d)",[_detailInfo.memebercount intValue]]] Images:@[[UIImage imageNamed:@"discovery_xiangmu_detail_link"],[UIImage imageNamed:@"discovery_xiangmu_detail_member"]] Bridges:nil isHorizontal:YES];
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
}

//显示项目创建人的信息
- (void)showProjectUserInfo
{
    //系统联系人
    UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:_detailInfo.user isAsk:NO];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

//选择点赞的列表
- (void)selectZanUserWithIndex:(NSIndexPath *)indexPath
{
    if (indexPath.row == _detailInfo.zanusers.count) {
        //进入赞列表
        ProjectUserListViewController *projectUserListVC = [[ProjectUserListViewController alloc] init];
        projectUserListVC.infoType = UserInfoTypeProjectZan;
        [self.navigationController pushViewController:projectUserListVC animated:YES];
    }else{
        //点击点赞的人，进入
        IBaseUserM *user = _detailInfo.zanusers[indexPath.row];
        //系统联系人
        UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:user isAsk:NO];
        //添加好友成功
//        [userInfoVC setAddFriendBlock:^(){
//            NSMutableDictionary *infoDic =  [NSMutableDictionary dictionaryWithDictionary:_datasource[indexPath.row]];
//            //重置好友关系
//            [infoDic setValue:@"4" forKey:@"friendship"];
//            //改变数组，刷新列表
//            [self.datasource replaceObjectAtIndex:indexPath.row withObject:infoDic];
//            //刷新列表
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        }];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }
}

@end
