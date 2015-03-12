//
//  ActivityDetailInfoViewController.m
//  Welian
//
//  Created by weLian on 15/2/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityDetailInfoViewController.h"
#import "ActivityOrderInfoViewController.h"
#import "ActivityMapViewController.h"
#import "ActivityUserListViewController.h"
#import "TOWebViewController.h"
#import "ShareFriendsController.h"
#import "NavViewController.h"
#import "PublishStatusController.h"

#import "MessageKeyboardView.h"
#import "ActivityCustomViewCell.h"
#import "ActivityInfoViewCell.h"
#import "ActivityUserViewCell.h"
#import "ActivityTicketView.h"
#import "WLActivityView.h"

#import "ShareEngine.h"
#import "SEImageCache.h"
#import "UINavigationBar+BackgroundColor.h"
#import "CardStatuModel.h"

#define kHeaderImageHeight 238.f
#define kTableViewHeaderHeight 45.f
#define kOperateButtonHeight 35.f
#define kmarginLeft 10.f

@interface ActivityDetailInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (assign,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *datasource;

@property (assign,nonatomic) UIButton *favorteBtn;
@property (assign,nonatomic) UIButton *joinBtn;
@property (assign,nonatomic) ActivityTicketView *activityTicketView;
@property (strong,nonatomic) ActivityInfo *activityInfo;
@property (strong,nonatomic) NSNumber *activityId;

@end

@implementation ActivityDetailInfoViewController

- (void)dealloc
{
    _datasource = nil;
    _activityInfo = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)title
{
    return @"活动详情";
}

- (instancetype)initWithActivityInfo:(ActivityInfo *)activityInfo
{
    self = [super init];
    if (self) {
        self.activityInfo = activityInfo;
        self.activityId = _activityInfo.activeid;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePayJoined) name:@"NeedReloadActivityUI" object:nil];
    }
    return self;
}

- (instancetype)initWIthActivityId:(NSNumber *)activityId
{
    self = [super init];
    if (self) {
        self.activityId = activityId;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePayJoined) name:@"NeedReloadActivityUI" object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self scrollViewDidScroll:_tableView];
    
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1]];
//    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:21], NSFontAttributeName, nil]];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
    UIColor *color = RGB(74.f, 117.f, 183.f);
    if (offsetY > kHeaderImageHeight/3.f) {
        CGFloat alpha = 1 - ((kHeaderImageHeight/3.f + 64 - offsetY) / 64);
        
        [self.navigationController.navigationBar useBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar useBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //tableview头部距离问题
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //设置头部背景透明
    [self.navigationController.navigationBar useBackgroundColor:[UIColor clearColor]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0.f,0.f,self.view.width,self.view.height - toolBarHeight)];
    tableView.dataSource = self;
    tableView.delegate = self;
    //隐藏表格分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
//    [tableView registerNib:[UINib nibWithNibName:@"NoCommentCell" bundle:nil] forCellReuseIdentifier:noCommentCell];
    
    //设置底部操作栏
    UIView *operateToolView = [[UIView alloc] initWithFrame:CGRectMake(0.f, tableView.bottom, self.view.width, toolBarHeight)];
    operateToolView.backgroundColor = RGB(247.f, 247.f, 247.f);
    operateToolView.layer.borderColorFromUIColor = RGB(231.f, 231.f, 231.f);
    operateToolView.layer.borderWidths = @"{0.6,0,0,0}";
    [self.view addSubview:operateToolView];
    
    //收藏
    UIButton *favorteBtn = [UIView getBtnWithTitle:@"收藏" image:[UIImage imageNamed:@"me_mywriten_shoucang"]];
    favorteBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    favorteBtn.layer.borderWidth = .7f;
    favorteBtn.size = CGSizeMake(108.f, kOperateButtonHeight);
    favorteBtn.left = kmarginLeft;
    favorteBtn.centerY = operateToolView.height / 2.f;
    [favorteBtn addTarget:self action:@selector(favorteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [operateToolView addSubview:favorteBtn];
    self.favorteBtn = favorteBtn;
    
    //我要报名
    UIButton *joinBtn = [UIView getBtnWithTitle:@"我要购票" image:nil];
    joinBtn.size = CGSizeMake(self.view.width - favorteBtn.right - kmarginLeft * 2.f, kOperateButtonHeight);
    joinBtn.right = operateToolView.width - kmarginLeft;
    joinBtn.centerY = operateToolView.height / 2.f;
    joinBtn.backgroundColor = RGB(52.f, 115.f, 185.f);
    [joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [joinBtn addTarget:self action:@selector(joinBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [operateToolView addSubview:joinBtn];
    self.joinBtn = joinBtn;
    
    //购票页面
    ActivityTicketView *activityTicketView = [[ActivityTicketView alloc] initWithFrame:self.view.bounds];
    activityTicketView.hidden = YES;
    [[[UIApplication sharedApplication] keyWindow] addSubview:activityTicketView];
    self.activityTicketView = activityTicketView;
    
    if (_activityInfo) {
        [self initActivityUIInfo];
        
        //检测分享按钮是否显示
        [self checkShareBtn];
        
        [self checkFavorteStatus];
        [self checkOperateBtnStatus];
    }
    
    //获取详情信息
    [self initData];
}

#pragma mark - UITableView Datasource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_activityInfo) {
            return 4.f;
        }else{
            return 0;
        }
    }else{
        return _datasource.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, self.view.width, kTableViewHeaderHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.layer.borderColorFromUIColor = RGB(231.f, 231.f, 231.f);
    headerView.layer.borderWidths = @"{0,0,0.6,0}";
    
    UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, headerView.width, 15.f)];
    topBgView.backgroundColor = RGB(236.f, 238.f, 241.f);
    [headerView addSubview:topBgView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = RGB(125.f, 125.f, 125.f);
    titleLabel.text = @"嘉宾";
    [titleLabel sizeToFit];
    titleLabel.left = 15.f;
    titleLabel.centerY = (headerView.height - topBgView.height) / 2.f + topBgView.height;
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0){
        //微信联系人
        if (indexPath.row < 3) {
            static NSString *cellIdentifier = @"Activity_Custom_View_Cell";
            ActivityCustomViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[ActivityCustomViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            }
            switch (indexPath.row) {
                case 0:
                {
                    cell.showCustomInfo = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.imageView.image = [UIImage imageNamed:@"discovery_activity_detail_time"];
                    cell.textLabel.text = [_activityInfo displayStartTimeInfo];
                }
                    break;
                case 1:
                {
                    cell.showCustomInfo = NO;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.imageView.image = [UIImage imageNamed:@"discovery_activity_detail_place"];
                    cell.textLabel.text = _activityInfo.address.length == 0 ? _activityInfo.city : _activityInfo.address;
                }
                    break;
                case 2:
                {
                    cell.showCustomInfo = YES;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.imageView.image = [UIImage imageNamed:@"discovery_activity_detail_people"];
                    
                    NSString *info = [NSString stringWithFormat:@"已报名%@人",_activityInfo.joined];
                    cell.textLabel.text = info;
                    [cell.textLabel setAttributedText:[NSObject getAttributedInfoString:info searchStr:_activityInfo.joined.stringValue color:KBlueTextColor font:[UIFont systemFontOfSize:14.f]]];
                    
                    NSString *detailInfo = [NSString stringWithFormat:@"/限额%@人",_activityInfo.limited];
                    cell.detailTextLabel.text = detailInfo;
                    //设置特殊颜色
                    [cell.detailTextLabel setAttributedText:[NSObject getAttributedInfoString:detailInfo searchStr:_activityInfo.limited.stringValue color:KBlueTextColor font:[UIFont systemFontOfSize:14.f]]];
                    //收费和免费中未现在人数
                    if (_activityInfo.type.integerValue == 1 || (_activityInfo.type.integerValue == 0 && _activityInfo.limited.integerValue == 0)) {
                        cell.detailTextLabel.hidden = YES;
                    }else{
                        cell.detailTextLabel.hidden = NO;
                    }
                }
                    break;
                default:
                    break;
            }
            return cell;
        }else if (indexPath.row == 3){
            static NSString *cellIdentifier = @"Activity_Detail_Info_View_Cell";
            ActivityInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[ActivityInfoViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            }
            cell.layer.borderColorFromUIColor = RGB(231.f, 231.f, 231.f);
            cell.layer.borderWidths = @"{0.6,0,0,0}";
            
            cell.textLabel.text = _activityInfo.sponsor.length > 0 ? [NSString stringWithFormat:@"主办方：%@",_activityInfo.sponsor] : @"";
//            cell.detailTextLabel.text = _activityInfo.intro;
//            cell.detailTextView.text = [_activityInfo displayActivityInfo];
            cell.detailTextLabel.text = [_activityInfo displayActivityInfo];
            WEAKSELF
            [cell setBlock:^(void){
                [weakSelf showActivityDetailInfo];
            }];
             return cell;
        }else{
            return nil;
        }
    }else{
        static NSString *cellIdentifier = @"Activity_User_View_Cell";
        ActivityUserViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[ActivityUserViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.indexPath = indexPath;
        cell.hidOperateBtn = YES;
        cell.baseUser = _datasource[indexPath.row];
        cell.hidBottomLine = YES;//隐藏分割线
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 1:
            {
                //地图
                NSString *cityAddress = [NSString stringWithFormat:@"%@-%@",_activityInfo.city,_activityInfo.address];
                DLog(@"toMapVC ----->%@",cityAddress);
                ActivityMapViewController *mapVC = [[ActivityMapViewController alloc] initWithAddress:_activityInfo.address city:_activityInfo.city];
                [self.navigationController pushViewController:mapVC animated:YES];
            }
                break;
            case 2:
            {
                //报名列表
                ActivityUserListViewController *userListVC = [[ActivityUserListViewController alloc] initWithStyle:UITableViewStylePlain ActiveInfo:_activityInfo];
                [self.navigationController pushViewController:userListVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.f;
    }else{
        if (_datasource.count > 0) {
            return kTableViewHeaderHeight;
        }else{
            return 0.f;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return [ActivityCustomViewCell configureWithMsg:[_activityInfo displayStartTimeInfo]];
                break;
            case 1:
                return [ActivityCustomViewCell configureWithMsg:_activityInfo.address.length == 0 ? _activityInfo.city : _activityInfo.address];
                break;
            case 2:
                return [ActivityCustomViewCell configureWithMsg:[NSString stringWithFormat:@"已报名%@人/限额%@人",_activityInfo.joined,_activityInfo.limited]];
                break;
            case 3:
                return [ActivityInfoViewCell configureWithTitle:_activityInfo.sponsor.length > 0 ? [NSString stringWithFormat:@"主办方：%@",_activityInfo.sponsor] : @"" Msg:[_activityInfo displayActivityInfo]];//_activityInfo.intro];
            default:
                return 60.f;
                break;
        }
    }else if (indexPath.section == 1) {
        return 60.f;
    }else{
        return 100.f;
    }
}

#pragma mark - Private
//检测分享按钮是否显示
- (void)checkShareBtn
{
    //添加分享按钮 navbar_share
    if(_activityInfo.shareurl.length > 0){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_more"] style:UIBarButtonItemStyleBordered target:self action:@selector(shareBtnClicked)];
    }
}

//分享
- (void)shareBtnClicked
{
    WLActivityView  *shareView = [[WLActivityView alloc] initWithOneSectionArray:@[@(ShareTypeWLFriend),@(ShareTypeWLCircle),@(ShareTypeWeixinFriend),@(ShareTypeWeixinCircle)] andTwoArray:nil];
    [shareView show];
    CardStatuModel *newCardM = [[CardStatuModel alloc] init];
    newCardM.cid = _activityId;
    newCardM.type = @(3);
    newCardM.url = _activityInfo.shareurl;
    newCardM.title = _activityInfo.name;
    newCardM.intro = _activityInfo.intro;
    //分享回调
    WEAKSELF
    [shareView setWlShareBlock:^(ShareType duration){
        switch (duration) {
            case ShareTypeWLFriend://微链好友
            {
                ShareFriendsController *shareFVC = [[ShareFriendsController alloc] init];
                shareFVC.cardM = newCardM;
                NavViewController *navShareFVC = [[NavViewController alloc] initWithRootViewController:shareFVC];
                [self presentViewController:navShareFVC animated:YES completion:^{
                    
                }];
            }
                break;
            case ShareTypeWLCircle://微链创业圈
            {
                PublishStatusController *publishShareVC = [[PublishStatusController alloc] initWithType:PublishTypeForward];
                publishShareVC.statusCard = newCardM;
                
                NavViewController *navShareFVC = [[NavViewController alloc] initWithRootViewController:publishShareVC];
                [self presentViewController:navShareFVC animated:YES completion:^{
                    
                }];
            }
                break;
            case ShareTypeWeixinFriend://微信好友
                [weakSelf shareToWX:weChat];
                break;
            case ShareTypeWeixinCircle://微信朋友圈
                [weakSelf shareToWX:weChatFriend];
                break;
            default:
                break;
        }
    }];
}

//分享到微信和微信朋友圈
- (void)shareToWX:(WeiboType)type
{
    NSString *desc = _activityInfo.intro;
    NSURL *imgUrl = [NSURL URLWithString:_activityInfo.logo];
    NSString *link = _activityInfo.shareurl;
    NSString *title = _activityInfo.name;
    
    [WLHUDView showHUDWithStr:@"" dim:NO];
    [[SDWebImageManager sharedManager] downloadImageWithURL:imgUrl options:SDWebImageRetryFailed|SDWebImageLowPriority
                                                   progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                       DLog(@"shareFriendImage---->>>%.2f",(float)receivedSize);
                                                   } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                       [WLHUDView hiddenHud];
                                                       DLog(@"shareFriendImage---->>>%@",image);
                                                       [[ShareEngine sharedShareEngine] sendWeChatMessage:title andDescription:desc WithUrl:link andImage:image WithScene:type];
                                                   }];
}

//收藏
- (void)favorteBtnClicked:(UIButton *)sender
{
    if (_activityInfo.isfavorite.boolValue) {
        //取消收藏
        [WLHttpTool deleteFavoriteActiveParameterDic:@{@"activeid":_activityInfo.activeid}
                                             success:^(id JSON) {
//                                                 _iProjectDetailInfo.isfavorite = @(0);
                                                 self.activityInfo = [_activityInfo updateFavorite:@(0)];
                                                 [self checkFavorteStatus];
                                                 //通知刷新我的活动中的数据
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"MyActivityInfoChanged" object:nil];
                                             } fail:^(NSError *error) {
                                                 [UIAlertView showWithTitle:nil message:@"取消收藏失败，请重试！"];
                                             }];
        
    }else{
        //收藏项目
        [WLHttpTool favoriteActiveParameterDic:@{@"activeid":_activityInfo.activeid}
                                       success:^(id JSON) {
//                                           _iProjectDetailInfo.isfavorite = @(1);
                                           self.activityInfo = [_activityInfo updateFavorite:@(1)];
                                           [self checkFavorteStatus];
                                           //通知刷新我的活动中的数据
                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"MyActivityInfoChanged" object:nil];
                                        } fail:^(NSError *error) {
                                            [UIAlertView showWithTitle:nil message:@"收藏活动失败，请重试！"];
                                        }];
    }
}

//我要报名
- (void)joinBtnClicked:(UIButton *)sender
{    
    //我要购票
//    [self loadActivityTickets];
    
    //0 还没开始，1进行中。2结束
    switch (_activityInfo.status.integerValue) {
        case 1:
            //活动进行中
            if (_activityInfo.isjoined.boolValue && _activityInfo.type.integerValue == 1) {
                //查看我的门票
                [self lookMyTicketsInfo];
            }
            break;
        case 2:
            //活动已结束
            if (_activityInfo.isjoined.boolValue && _activityInfo.type.integerValue == 1) {
                //查看我的门票
                [self lookMyTicketsInfo];
            }
            break;
        default:
        {
            //还没开始
            //1.已报名
            if(_activityInfo.isjoined.boolValue){
                //1收费，0免费
                if (_activityInfo.type.integerValue == 0) {
                    //取消报名
                    [UIAlertView bk_showAlertViewWithTitle:nil
                                                   message:@"取消参加当前活动？"
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@[@"确定"]
                                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                                       if (buttonIndex == 0) {
                                                           return;
                                                       }else{
                                                           [self cancelActivityJoined];
                                                       }
                                                   }];
                }else{
                    //查看我的门票
                    [self lookMyTicketsInfo];
                }
            }else{
                //名额未满 //1收费，0免费
                if(_activityInfo.type.integerValue == 0){
                    //免费活动
                    if(_activityInfo.limited.integerValue == 0){
                        //不限人数，可以报名
                        [self noPayToJoin];
                    }else{
                        if(_activityInfo.limited.integerValue > _activityInfo.joined.integerValue){
                            //不限人数，可以报名
                            [self noPayToJoin];
                        }else{
                            
                        }
                    }
                }else{
                    //收费活动
                    if(_activityInfo.limited.integerValue > 0){
                        //我要购票
                        [self loadActivityTickets];
                    }else{
                        
                    }
                }
                
                
//                //名额未满
//                if (_activityInfo.limited.integerValue == 0 && _activityInfo.type.integerValue == 0) {
//                    //不限人数，可以报名
//                    [self noPayToJoin];
//                }else{
//                    //名额未满
//                    if(_activityInfo.limited.integerValue > _activityInfo.joined.integerValue){
//                        //1收费，0免费
//                        if (_activityInfo.type.integerValue == 0) {
//                            //我要报名
//                            [self noPayToJoin];
//                        }else{
//                            //我要购票
//                            [self loadActivityTickets];
//                        }
//                    }else{
//                        //名额已满
//                        
//                    }
//                }
            }
        }
            break;
    }
}

//免费报名
- (void)noPayToJoin
{
    [UIAlertView bk_showAlertViewWithTitle:nil
                                   message:@"报名参加当前活动？"
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@[@"报名"]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                       if (buttonIndex == 0) {
                                           return ;
                                       }else{
                                           [self createActivityOrderWithType:0 Tickets:nil];
                                       }
                                   }];
}

//创建订单进入购票页面
- (void)buyTicketToOrderInfo:(NSArray *)tickets
{
    [self createActivityOrderWithType:1 Tickets:tickets];
}

//进入活动详情页面
- (void)showActivityDetailInfo
{
    // 观点  虎嗅网
    if (_activityInfo.url.length > 0) {
        TOWebViewController *webVC = [[TOWebViewController alloc] initWithURLString:_activityInfo.url];
        webVC.navigationButtonsHidden = YES;//隐藏底部操作栏目
        [self.navigationController pushViewController:webVC animated:YES];
    }else{
        [UIAlertView showWithMessage:@"暂无活动详情"];
    }
}

//检测是否收藏当前项目
- (void)checkFavorteStatus
{
    if (_activityInfo.isfavorite.boolValue) {
        [_favorteBtn setTitle:@"已收藏" forState:UIControlStateNormal];
        [_favorteBtn setImage:[UIImage imageNamed:@"me_mywriten_shoucang_pre"] forState:UIControlStateNormal];
    }else{
        [_favorteBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_favorteBtn setImage:[UIImage imageNamed:@"me_mywriten_shoucang"] forState:UIControlStateNormal];
    }
}

//检测操作按钮状态
- (void)checkOperateBtnStatus
{
    //0 还没开始，1进行中。2结束
    _joinBtn.backgroundColor = [UIColor lightGrayColor];
    switch (_activityInfo.status.integerValue) {
        case 1:
            //进行中
            if (_activityInfo.isjoined.boolValue && _activityInfo.type.integerValue == 1) {
                //如果是收费活动
                [_joinBtn setTitle:@"查看我的门票" forState:UIControlStateNormal];
            }else{
                [_joinBtn setTitle:@"正在进行" forState:UIControlStateNormal];
            }
            break;
        case 2:
            //获取已结束
            if (_activityInfo.isjoined.boolValue && _activityInfo.type.integerValue == 1) {
                //如果是收费活动
                [_joinBtn setTitle:@"查看我的门票" forState:UIControlStateNormal];
            }else{
                [_joinBtn setTitle:@"已结束" forState:UIControlStateNormal];
            }
            break;
        default:
        {
            //还没开始
            //1.已报名
            if(_activityInfo.isjoined.boolValue){
                //1收费，0免费
                if (_activityInfo.type.integerValue == 0) {
                    [_joinBtn setTitle:@"取消报名" forState:UIControlStateNormal];
                }else{
                    [_joinBtn setTitle:@"查看我的门票" forState:UIControlStateNormal];
                }
            }else{
                //名额未满 //1收费，0免费
                if(_activityInfo.type.integerValue == 0){
                    //免费活动
                    if(_activityInfo.limited.integerValue == 0){
                        //不限人数，可以报名
                        _joinBtn.backgroundColor = RGB(52.f, 115.f, 185.f);
                        [_joinBtn setTitle:@"我要报名" forState:UIControlStateNormal];
                    }else{
                        if(_activityInfo.limited.integerValue > _activityInfo.joined.integerValue){
                            _joinBtn.backgroundColor = RGB(52.f, 115.f, 185.f);
                            [_joinBtn setTitle:@"我要报名" forState:UIControlStateNormal];
                        }else{
                            [_joinBtn setTitle:@"名额已满" forState:UIControlStateNormal];
                        }
                    }
                }else{
                    //收费活动
                    if(_activityInfo.limited.integerValue > 0){
                        _joinBtn.backgroundColor = RGB(52.f, 115.f, 185.f);
                        [_joinBtn setTitle:@"我要购票" forState:UIControlStateNormal];
                    }else{
                        [_joinBtn setTitle:@"已售罄" forState:UIControlStateNormal];
                    }
                }
                
//                if (_activityInfo.limited.integerValue == 0 && _activityInfo.type.integerValue == 0) {
//                    //不限人数，可以报名
//                    _joinBtn.backgroundColor = RGB(52.f, 115.f, 185.f);
//                    [_joinBtn setTitle:@"我要报名" forState:UIControlStateNormal];
//                }else{
//                    //收费活动
//                    if(_activityInfo.limited.integerValue > _activityInfo.joined.integerValue){
//                        //1收费，0免费
//                        if (_activityInfo.type.integerValue == 0) {
//                            _joinBtn.backgroundColor = RGB(52.f, 115.f, 185.f);
//                            [_joinBtn setTitle:@"我要报名" forState:UIControlStateNormal];
//                        }else{
//                            
//                        }
//                    }else{
//                        [_joinBtn setTitle:@"名额已满" forState:UIControlStateNormal];
//                    }
//                }
            }
        }
            break;
    }
}

//获取票务信息
- (void)loadActivityTickets
{
    //1038   946  收费活动
    [WLHttpTool getActivityTicketParameterDic:@{@"activeid":_activityInfo.activeid}
                                      success:^(id JSON) {
                                          
                                          if (JSON) {
                                              NSArray *tickets = [IActivityTicket objectsWithInfo:JSON];
                                              if (_activityTicketView.hidden) {
                                                  WEAKSELF
                                                  [_activityTicketView setBuyTicketBlock:^(NSArray *ticekets){
                                                      [weakSelf buyTicketToOrderInfo:ticekets];
                                                  }];
                                                  _activityTicketView.isBuyTicket = YES;
                                                  _activityTicketView.tickets = tickets;
                                                  [_activityTicketView showInView];
                                              }else{
                                                  [_activityTicketView dismiss];
                                              }
                                          }
                                      } fail:^(NSError *error) {
                                          DLog(@"getActivityTicketParameterDic error:%@",error.description);
                                      }];
}

//查看我购买的票务信息
- (void)lookMyTicketsInfo
{
    [WLHttpTool getBuyedActiveTicketsParameterDic:@{@"activeid":_activityInfo.activeid}
                                          success:^(id JSON) {
                                              if (JSON) {
                                                  NSArray *tickets = [IActivityTicket objectsWithInfo:JSON];
                                                  if (_activityTicketView.hidden) {
                                                      _activityTicketView.isBuyTicket = NO;
                                                      _activityTicketView.tickets = tickets;
                                                      [_activityTicketView showInView];
                                                  }else{
                                                      [_activityTicketView dismiss];
                                                  }
                                              }
                                          } fail:^(NSError *error) {
                                              DLog(@"getActivityTicketParameterDic error:%@",error.description);
                                          }];
}

//更新页面信息
- (void)updateUI
{
    [_tableView reloadData];
    [self checkFavorteStatus];
    [self checkOperateBtnStatus];
}

//更新页面展示数据信息
- (void)initActivityUIInfo
{
    CGSize titleSize = [_activityInfo.name calculateSize:CGSizeMake(self.view.width - 30.f, FLT_MAX) font:[UIFont boldSystemFontOfSize:16.f]];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kHeaderImageHeight + titleSize.height + 20.f)];
    headerView.layer.borderColorFromUIColor = RGB(231.f, 231.f, 231.f);
    headerView.layer.borderWidths = @"{0,0,0.6,0}";
    
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kHeaderImageHeight)];
    imageView.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:imageView];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_activityInfo.logo] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageLowPriority];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = kTitleNormalTextColor;
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.text = _activityInfo.name;
    titleLabel.width = headerView.width - 30.f;
    titleLabel.numberOfLines = 0;
    [titleLabel sizeToFit];
    titleLabel.top = imageView.bottom + 10.f;
    titleLabel.left = 15.f;
    [headerView addSubview:titleLabel];
    
    [_tableView setTableHeaderView:headerView];
}

//更新报名人数信息
- (void)updateJoinedInfo:(BOOL)isJoin
{
    //通知刷新我的活动中的数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyActivityInfoChanged" object:nil];
    //更新列表的报名状态
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateJoinedUI" object:nil];
    
    //更新报名状态
    self.activityInfo = [_activityInfo updateIsjoined:@(isJoin)];
    //更新报名人数
    self.activityInfo = [_activityInfo updateJoined:@(isJoin ? 1 : -1)];
    //更页面
    [self updateUI];
}

//更新支付报名
- (void)updatePayJoined
{
    [self updateJoinedInfo:YES];
}

//获取详情信息
- (void)initData
{
    [WLHttpTool getActivityDetailParameterDic:@{@"activeid":_activityId}
                                      success:^(id JSON) {
                                          if (JSON) {
                                              IActivityInfo *iActivity = [IActivityInfo objectWithDict:JSON];
                                              BOOL isFromList = _activityInfo != nil ? YES : NO;
                                              if (isFromList) {
                                                  self.activityInfo = [ActivityInfo updateActivityInfoWith:iActivity withType:_activityInfo.activeType];
                                              }else{
                                                  self.activityInfo = [ActivityInfo createActivityInfoWith:iActivity withType:0];
                                                  //更新数据
                                                  [self initActivityUIInfo];
                                              }
                                              self.datasource = iActivity.guests;
                                              
                                              //检测分享按钮
                                              [self checkShareBtn];
                                              //更页面
                                              [self updateUI];
                                          }else{
                                              [WLHUDView showSuccessHUD:@"获取失败，该活动不存在！"];
                                          }
                                      } fail:^(NSError *error) {
                                          DLog(@"getActivityDetailParameterDic error:%@",error.description);
                                      }];
}

//取消报名
- (void)cancelActivityJoined
{
    [WLHttpTool deleteActiveRecorderParameterDic:@{@"activeid":_activityId}
                                         success:^(id JSON) {
                                             //更页面
                                             [self updateJoinedInfo:NO];
                                         } fail:^(NSError *error) {
                                             DLog(@"deleteActiveRecorderParameterDic error:%@",error.description);
                                         }];
}

//创建活动报名   type: 0:免费 1：收费
- (void)createActivityOrderWithType:(NSInteger)type Tickets:(NSArray *)tickets
{
    NSDictionary *param = [NSDictionary dictionary];
    if (type == 0) {
        //免费活动
        param = @{@"activeid":_activityId};
    }else{
        NSMutableArray *ticketsinfo = [NSMutableArray array];
        for (int i = 0; i < tickets.count; i++) {
            IActivityTicket *ticket = tickets[i];
            [ticketsinfo addObject:@{@"ticketid":ticket.ticketid,@"count":ticket.buyCount}];
        }
        //需要支付的活动
        param = @{@"activeid":_activityId,
                  @"ticket":ticketsinfo};
    }
    [WLHttpTool createTicketOrderParameterDic:param
                                      success:^(id JSON) {
                                          if ([JSON isKindOfClass:[NSDictionary class]]) {
                                              if ([JSON[@"state"] integerValue] == -1) {
                                                  [WLHUDView showSuccessHUD:@"报名失败，请重新尝试！"];
                                                  return;
                                              }
                                          }
                                          if (type != 0) {
                                              //进入订单页面
                                              ActivityOrderInfoViewController *activityOrderInfoVC = [[ActivityOrderInfoViewController alloc] initWithActivityInfo:_activityInfo Tickets:tickets payInfo:JSON];
                                              [self.navigationController pushViewController:activityOrderInfoVC animated:YES];
                                          }else{
                                              [WLHUDView showSuccessHUD:@"恭喜您，报名成功！"];
                                              //更页面
                                              [self updateJoinedInfo:YES];
                                          }
                                      } fail:^(NSError *error) {
                                          [WLHUDView showSuccessHUD:@"报名失败，请重新尝试！"];
                                      }];
}

@end
