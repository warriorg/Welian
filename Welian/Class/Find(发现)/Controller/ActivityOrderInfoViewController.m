//
//  ActivityOrderInfoViewController.m
//  Welian
//
//  Created by weLian on 15/2/13.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityOrderInfoViewController.h"
#import "UIImage+ImageEffects.h"
#import "ActivityOrderInfoViewCell.h"

#define kMarginEdge 8.f
#define kMarginLeft 15.f
#define kTotalPriceViewHeight 58.f
#define kTableViewBottomHeight 150.f
#define kTableViewCellHeight 30.f


@interface ActivityOrderInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ActivityOrderInfoViewController

- (NSString *)title
{
    return @"订单详情";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(237.f, 238.f, 242.f);
    
    //tableview头部距离问题
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //订单列表
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ViewCtrlTopBarHeight, self.view.width, self.view.height - ViewCtrlTopBarHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
//    [tableView setDebug:YES];
    
    //头部内容
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, [self configureTableHeaderHeight])];
    headerView.backgroundColor = [UIColor whiteColor];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = kTitleNormalTextColor;
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.text = @"管家类App的创业逻辑";
    titleLabel.numberOfLines = 0.f;
    titleLabel.width = headerView.width - kMarginLeft * 2.f;
    [titleLabel sizeToFit];
    titleLabel.left = kMarginLeft;
    titleLabel.top = kMarginLeft;
    [headerView addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = kNormalTextColor;
    timeLabel.font = [UIFont systemFontOfSize:12.f];
    timeLabel.text = @"12-12(周五)13：00～15：00";
    timeLabel.numberOfLines = 0.f;
    timeLabel.width = headerView.width - kMarginLeft * 2.f;
    [timeLabel sizeToFit];
    timeLabel.left = kMarginLeft;
    timeLabel.top = titleLabel.bottom + kMarginEdge;
    [headerView addSubview:timeLabel];
    
    tableView.tableHeaderView = headerView;
    
    //底部内容
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, kTableViewBottomHeight)];
    
    UIView *totalInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, footerView.width, kTotalPriceViewHeight)];
    totalInfoView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:totalInfoView];
    
    //总金额
    UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    totalPriceLabel.backgroundColor = [UIColor clearColor];
    totalPriceLabel.font = [UIFont systemFontOfSize:14.f];
    totalPriceLabel.textColor = kTitleNormalTextColor;
    totalPriceLabel.text = @"700元";
    [totalPriceLabel setAttributedText:[NSObject getAttributedInfoString:totalPriceLabel.text searchStr:@"700" color:RGB(224.f, 68.f, 0.f) font:[UIFont boldSystemFontOfSize:18.f]]];
    [totalPriceLabel sizeToFit];
    totalPriceLabel.right = totalInfoView.right - kMarginLeft;
    totalPriceLabel.top = 19.f;
    [totalInfoView addSubview:totalPriceLabel];
    
    //总数量
    UILabel *totalNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    totalNumLabel.backgroundColor = [UIColor clearColor];
    totalNumLabel.font = [UIFont systemFontOfSize:14.f];
    totalNumLabel.textColor = kTitleNormalTextColor;
    totalNumLabel.text = @"共4张　　　总计 ";
    [totalNumLabel sizeToFit];
    totalNumLabel.right = totalPriceLabel.left;
    totalNumLabel.centerY = totalPriceLabel.centerY;
    [totalInfoView addSubview:totalNumLabel];
    
    //下方的分割波浪边线
    UIImageView *contentImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"discovery_activity_pay_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:1]];
    contentImageView.frame = CGRectMake(0, totalInfoView.bottom, footerView.width, 10.f);
    [footerView addSubview:contentImageView];
    
    //支付按钮
    UIButton *payBtn = [UIView getBtnWithTitle:@"确认支付" image:nil];
    payBtn.frame = CGRectMake(kMarginLeft, contentImageView.bottom + 50.f, footerView.width - kMarginLeft * 2.f, 45.f);
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.backgroundColor = KBlueTextColor;
    [payBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:payBtn];
    //支付说明
    UIButton *payAboutBtn = [UIView getBtnWithTitle:@"付款说明" image:nil];
    [payAboutBtn setTitleColor:KBlueTextColor forState:UIControlStateNormal];
    payAboutBtn.backgroundColor = [UIColor clearColor];
    [payAboutBtn sizeToFit];
    payAboutBtn.right = payBtn.right;
    payAboutBtn.bottom = payBtn.top - kMarginEdge;
    [payAboutBtn addTarget:self action:@selector(payAboutBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:payAboutBtn];
    
    tableView.tableFooterView = footerView;
}

#pragma mark - UITableView Datasource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Activity_OrderInfo_View_Cell";
    ActivityOrderInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ActivityOrderInfoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
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
    return kTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellHeight;
}

#pragma mark - Private
//支付
- (void)payBtnClicked:(UIButton *)sender
{
    
}

//支付说明
- (void)payAboutBtnClicked:(UIButton *)sender
{
    
}

//获取表格头部内容的高度
- (CGFloat)configureTableHeaderHeight
{
    CGSize titleSize = [@"管家类App的创业逻辑" calculateSize:CGSizeMake(self.view.width - kMarginLeft * 2.f, FLT_MAX) font:[UIFont boldSystemFontOfSize:16.f]];
    CGSize timeSize = [@"12-12(周五)13：00～15：00" calculateSize:CGSizeMake(self.view.width - kMarginLeft * 2.f, FLT_MAX) font:[UIFont systemFontOfSize:12.f]];
    return titleSize.height + timeSize.height + kMarginLeft + kMarginEdge;
}

//获取表格的高度
- (CGFloat)configureTableViewHeight
{
    return [self configureTableHeaderHeight] + 3 * kTableViewCellHeight + kTableViewBottomHeight;
}

@end
