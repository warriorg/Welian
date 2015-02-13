//
//  ActivityDetailInfoViewController.m
//  Welian
//
//  Created by weLian on 15/2/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityDetailInfoViewController.h"
#import "ActivityOrderInfoViewController.h"
#import "MessageKeyboardView.h"
#import "ActivityCustomViewCell.h"
#import "ActivityInfoViewCell.h"
#import "ActivityUserViewCell.h"
#import "ActivityTicketView.h"

#define kHeaderImageHeight 178.f
#define kTableViewHeaderHeight 45.f
#define kOperateButtonHeight 35.f
#define kmarginLeft 10.f

@interface ActivityDetailInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (assign,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *datasource;

@property (assign,nonatomic) UIButton *favorteBtn;
@property (assign,nonatomic) UIButton *joinBtn;
@property (assign,nonatomic) ActivityTicketView *activityTicketView;

@end

@implementation ActivityDetailInfoViewController

- (void)dealloc
{
    _datasource = nil;
}

- (NSString *)title
{
    return @"活动详情";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.datasource = @[@{@"avatar":@"http://img.welian.com/1423142255161-200-200_x.jpg",@"company":@"微链",@"position":@"iOS开发工程师",@"investorauth":@(1),@"uid":@(1000),@"friendship":@(1)},
                            @{@"avatar":@"http://img.welian.com/1423142255161-200-200_x.jpg",@"company":@"微链",@"position":@"iOS开发工程师",@"investorauth":@(1),@"uid":@(1000),@"friendship":@(1)},
                            @{@"avatar":@"http://img.welian.com/1423142255161-200-200_x.jpg",@"company":@"微链",@"position":@"iOS开发工程师",@"investorauth":@(1),@"uid":@(1000),@"friendship":@(1)},
                            @{@"avatar":@"http://img.welian.com/1423142255161-200-200_x.jpg",@"company":@"微链",@"position":@"iOS开发工程师",@"investorauth":@(1),@"uid":@(1000),@"friendship":@(1)}];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.tintColor = KBasesColor;
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.navigationBar.alpha = 0.5f;
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //tableview头部距离问题
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //添加分享按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_more"] style:UIBarButtonItemStyleBordered target:self action:@selector(shareBtnClicked)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0.f,ViewCtrlTopBarHeight,self.view.width,self.view.height - toolBarHeight - ViewCtrlTopBarHeight)];
    tableView.dataSource = self;
    tableView.delegate = self;
    //隐藏表格分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
//    [tableView registerNib:[UINib nibWithNibName:@"NoCommentCell" bundle:nil] forCellReuseIdentifier:noCommentCell];
    
    CGSize titleSize = [@"德奥经典音乐剧《伊丽莎白》第二轮" calculateSize:CGSizeMake(self.view.width - 30.f, FLT_MAX) font:[UIFont boldSystemFontOfSize:16.f]];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kHeaderImageHeight + titleSize.height + 20.f)];
    headerView.layer.borderColorFromUIColor = RGB(231.f, 231.f, 231.f);
    headerView.layer.borderWidths = @"{0,0,0.6,0}";
    
    //图片
    UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kHeaderImageHeight)];
    imageView.backgroundColor = [UIColor redColor];
    [headerView addSubview:imageView];
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = kTitleNormalTextColor;
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.text = @"德奥经典音乐剧《伊丽莎白》第二轮";
    [titleLabel sizeToFit];
    titleLabel.top = imageView.bottom + 10.f;
    titleLabel.left = 15.f;
    [headerView addSubview:titleLabel];
    
    [_tableView setTableHeaderView:headerView];
    
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
}

#pragma mark - UITableView Datasource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4.f;
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
                cell = [[ActivityCustomViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            switch (indexPath.row) {
                case 0:
                {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.imageView.image = [UIImage imageNamed:@"discovery_activity_detail_time"];
                    cell.textLabel.text = @"2014/04/12 周六 13:30～17:00";
                }
                    break;
                case 1:
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.imageView.image = [UIImage imageNamed:@"discovery_activity_detail_place"];
                    cell.textLabel.text = @"上海黄浦区上海文化广场(上海市永嘉路28号)";
                }
                    break;
                case 2:
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.imageView.image = [UIImage imageNamed:@"discovery_activity_detail_people"];
                    cell.textLabel.text = @"已报名2人/限额5人";
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
            
            cell.textLabel.text = @"主办方：微链";
            cell.detailTextLabel.text = @"阿狸都是放假啦时间佛玩儿了撒打发打发我额额啊发生地发呆是法师打发打发打发打发地方撒上发发呆撒旦发射点发等发达发生的发发发发发大方的啊地方打发发达地方撒阿狸都是放假啦时间佛玩儿了撒打发打发我额额啊发生地发呆是法师打发打发打发打发地方撒上发发呆撒旦发射点发等发达发生的发发发发发大方的啊地方打发发达地方撒阿狸都是放假啦时间佛玩儿了撒打发打发我额额啊发生地发呆是法师打发打发打发打发地方撒上发发呆撒旦发射点发等发达发生的发发发发发大方的啊地方打发发达地方撒阿狸都是放假啦时间佛玩儿了撒打发打发我额额啊发生地发呆是法师打发打发打发打发地方撒上发发呆撒旦发射点发等发达发生的发发发发发大方的啊地方打发发达地方撒阿狸都是放假啦时间佛玩儿了撒打发打发我额额啊发生地发呆是法师打发打发打发打发地方撒上发发呆撒旦发射点发等发达发生的发发发发发大方的啊地方打发发达地方撒";
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
        cell.activityUserData = _datasource[indexPath.row];
        cell.hidBottomLine = YES;//隐藏分割线
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.f;
    }else{
        return kTableViewHeaderHeight;
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
                return [ActivityCustomViewCell configureWithMsg:@"2014/04/12 周六 13:30～17:00"];
                break;
            case 1:
                return [ActivityCustomViewCell configureWithMsg:@"上海黄浦区上海文化广场(上海市永嘉路28号)"];
                break;
            case 2:
                return [ActivityCustomViewCell configureWithMsg:@"已报名2人/限额5人"];
                break;
            case 3:
                return [ActivityInfoViewCell configureWithTitle:@"主办方：微链" Msg:@"阿狸都是放假啦时间佛玩儿了撒打发打发我额额啊发生地发呆是法师打发打发打发打发地方撒上发发呆撒旦发射点发等发达发生的发发发发发大方的啊地方打发发达地方撒阿狸都是放假啦时间佛玩儿了撒打发打发我额额啊发生地发呆是法师打发打发打发打发地方撒上发发呆撒旦发射点发等发达发生的发发发发发大方的啊地方打发发达地方撒阿狸都是放假啦时间佛玩儿了撒打发打发我额额啊发生地发呆是法师打发打发打发打发地方撒上发发呆撒旦发射点发等发达发生的发发发发发大方的啊地方打发发达地方撒阿狸都是放假啦时间佛玩儿了撒打发打发我额额啊发生地发呆是法师打发打发打发打发地方撒上发发呆撒旦发射点发等发达发生的发发发发发大方的啊地方打发发达地方撒阿狸都是放假啦时间佛玩儿了撒打发打发我额额啊发生地发呆是法师打发打发打发打发地方撒上发发呆撒旦发射点发等发达发生的发发发发发大方的啊地方打发发达地方撒"];
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
//分享
- (void)shareBtnClicked
{
    
}

//收藏
- (void)favorteBtnClicked:(UIButton *)sender
{
    
}

//我要报名
- (void)joinBtnClicked:(UIButton *)sender
{
    if (_activityTicketView.hidden) {
        WEAKSELF
        [_activityTicketView setBuyTicketBlock:^(NSArray *ticekets){
            [weakSelf buyTicketToOrderInfo];
        }];
        _activityTicketView.isBuyTicket = YES;
        [_activityTicketView showInView];
    }else{
        [_activityTicketView dismiss];
    }
}

//支付
- (void)buyTicketToOrderInfo
{
    //进入订单页面
    ActivityOrderInfoViewController *activityOrderInfoVC = [[ActivityOrderInfoViewController alloc] init];
    [self.navigationController pushViewController:activityOrderInfoVC animated:YES];
}

@end
