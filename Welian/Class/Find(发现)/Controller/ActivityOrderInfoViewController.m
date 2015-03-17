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

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

#define kMarginEdge 8.f
#define kMarginLeft 15.f
#define kTotalPriceViewHeight 58.f
#define kTableViewBottomHeight 150.f
#define kTableViewCellHeight 30.f


@interface ActivityOrderInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) ActivityInfo *activityInfo;
@property (strong,nonatomic) NSArray *tickets;
@property (strong,nonatomic) NSDictionary *payInfo;

@end

@implementation ActivityOrderInfoViewController

- (void)dealloc
{
    _activityInfo = nil;
    _tickets = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)title
{
    return @"订单详情";
}

- (instancetype)initWithActivityInfo:(ActivityInfo *)activityInfo Tickets:(NSArray *)tickets payInfo:(NSDictionary *)payInfo
{
    self = [super init];
    if (self) {
        self.activityInfo = activityInfo;
        self.tickets = tickets;
        self.payInfo = payInfo;
        
        //添加支付成功监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderSucess) name:@"AlipayPaySuccess" object:nil];
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
    titleLabel.text = _activityInfo.name;
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
    timeLabel.text = [_activityInfo displayStartTimeInfo];
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
    totalPriceLabel.text = [NSString stringWithFormat:@"%@元",[self displayTotalPrice]];
    [totalPriceLabel setAttributedText:[NSObject getAttributedInfoString:totalPriceLabel.text searchStr:[self displayTotalPrice] color:RGB(224.f, 68.f, 0.f) font:[UIFont boldSystemFontOfSize:18.f]]];
    [totalPriceLabel sizeToFit];
    totalPriceLabel.right = totalInfoView.right - kMarginLeft;
    totalPriceLabel.top = 19.f;
    [totalInfoView addSubview:totalPriceLabel];
    
    //总数量
    UILabel *totalNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    totalNumLabel.backgroundColor = [UIColor clearColor];
    totalNumLabel.font = [UIFont systemFontOfSize:14.f];
    totalNumLabel.textColor = kTitleNormalTextColor;
    totalNumLabel.text = [NSString stringWithFormat:@"共%d张　　　总计 ",[self displayTicketCount]];
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
    payAboutBtn.hidden = YES;
    [payAboutBtn sizeToFit];
    payAboutBtn.right = payBtn.right;
    payAboutBtn.bottom = payBtn.top - kMarginEdge;
    [payAboutBtn addTarget:self action:@selector(payAboutBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:payAboutBtn];
    
    tableView.tableFooterView = footerView;
}

#pragma mark - UITableView Datasource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Activity_OrderInfo_View_Cell";
    ActivityOrderInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ActivityOrderInfoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.iActivityTicket = _tickets[indexPath.row];
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
//获取订单详情
- (NSString *)displayOrderDetail
{
    NSMutableString *detailInfo = [NSMutableString string];
    for (int i = 0; i < _tickets.count; i++) {
        IActivityTicket *ticket = _tickets[i];
        if (i > 0) {
            [detailInfo appendString:@"|"];
        }
        [detailInfo appendString:[NSString stringWithFormat:@"%@共%@张",ticket.name,ticket.buyCount]];
    }
    return detailInfo;
}

//获取总金额
- (NSString *)displayTotalPrice
{
    float totalPrice = 0.f;
    for (int i = 0; i < _tickets.count; i++) {
        IActivityTicket *ticket = _tickets[i];
        totalPrice += ticket.price.floatValue * ticket.buyCount.integerValue;
    }
    NSString *price = [NSString stringWithFormat:@"%.2f",totalPrice];
    return price;
}

//获取总票数
- (int)displayTicketCount
{
    float ticketCount = 0;
    for (int i = 0; i < _tickets.count; i++) {
        IActivityTicket *ticket = _tickets[i];
        ticketCount += ticket.buyCount.integerValue;
    }
    return ticketCount;
}

//支付
- (void)payBtnClicked:(UIButton *)sender
{
    if ([[self displayTotalPrice] floatValue] > 0) {
        UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:@"在线支付"];
        [sheet bk_addButtonWithTitle:@"支付宝支付" handler:^{
            [self payByAlipay];
        }];
        [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
        [sheet showInView:self.view];
    }else{
        //金额为0 直接修改订单状态
        [self updateOrderSucess];
    }
}

//支付宝支付
- (void)payByAlipay
{
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    //如果partner和seller数据存于其他位置,请改写下面两行代码
    
    NSString *partner = PartnerID;//[[NSBundle mainBundle] objectForInfoDictionaryKey:@"PartnerID"];
    NSString *seller = SellerID;//[[NSBundle mainBundle] objectForInfoDictionaryKey:@"SellerID"];
    NSString *privateKey = PartnerPrivKey;//[[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"];
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"缺少partner或者seller。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = _payInfo[@"orderid"]; //订单ID（由商家自行制定）
    order.productName = _activityInfo.name; //商品标题
    order.productDescription = [self displayOrderDetail]; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[_payInfo[@"amount"] floatValue]]; //商品价格
    order.notifyURL = kAlipayNotifyURL; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"AlipayWeLian";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
            if (resultStatus == 9000) {
                //支付成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipayPaySuccess" object:nil];
            }else{
                if ([resultDic[@"memo"] length] > 0) {
                    [UIAlertView showWithTitle:nil message:resultDic[@"memo"]];
                }
            }
            DLog(@"支付结果 result = %@", resultDic);
        }];
    }
}


//支付说明
- (void)payAboutBtnClicked:(UIButton *)sender
{
    
}

- (void)updateOrderSucess
{
    [WLHUDView showHUDWithStr:@"更新订单状态中..." dim:YES];
    NSDictionary *param = @{@"orderid":_payInfo[@"orderid"]};
    [WLHttpTool updateTicketOrderStatusParameterDic:param
                                            success:^(id JSON) {
                                                [WLHUDView hiddenHud];
                                                //刷新详情页面
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedReloadActivityUI" object:nil];
                                                [UIAlertView bk_showAlertViewWithTitle:nil
                                                                               message:@"恭喜您，活动报名成功！"
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil
                                                                               handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                                                                   [self.navigationController popViewControllerAnimated:YES];
                                                                               }];
                                            } fail:^(NSError *error) {
                                                [UIAlertView showWithTitle:nil message:@"订单状态修改失败，请电话联系客服确认订单状态"];
                                            }];
}


//获取表格头部内容的高度
- (CGFloat)configureTableHeaderHeight
{
    CGSize titleSize = [_activityInfo.name calculateSize:CGSizeMake(self.view.width - kMarginLeft * 2.f, FLT_MAX) font:[UIFont boldSystemFontOfSize:16.f]];
    CGSize timeSize = [[_activityInfo displayStartTimeInfo] calculateSize:CGSizeMake(self.view.width - kMarginLeft * 2.f, FLT_MAX) font:[UIFont systemFontOfSize:12.f]];
    return titleSize.height + timeSize.height + kMarginLeft + kMarginEdge;
}

//获取表格的高度
- (CGFloat)configureTableViewHeight
{
    return [self configureTableHeaderHeight] + 3 * kTableViewCellHeight + kTableViewBottomHeight;
}

@end
