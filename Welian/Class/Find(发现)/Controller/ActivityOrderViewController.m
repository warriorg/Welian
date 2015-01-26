//
//  ActivityOrderViewController.m
//  Welian
//
//  Created by weLian on 15/1/6.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityOrderViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

@interface ActivityOrderViewController ()

@end

@implementation ActivityOrderViewController

- (void)dealloc
{
    _orderInfo = nil;
    _ticketDetail = nil;
    _ticketTitle = nil;
    _payInfo = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderSucess) name:@"AlipayPaySuccess" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
//微信支付
//- (void)wechatPay
//{
//    DLog(@"调用微信支付");
//}

//微信支付
- (void)wechatPay:(NSArray *)infos
{
//    NSDictionary *payInfo = infos[0];
    DLog(@"payInfo -----> %@",infos);
    UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:@"在线支付"];
    [sheet bk_addButtonWithTitle:@"支付宝支付" handler:^{
        [self alipayWithInfo:nil];
    }];
    [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [sheet showInView:self.view];
}

- (void)alipayWithInfo:(NSDictionary *)info
{
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    //如果partner和seller数据存于其他位置,请改写下面两行代码
    
    NSString *partner = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"PartnerID"];
    NSString *seller = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SellerID"];
    NSString *privateKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"];
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
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
    order.productName = _ticketTitle; //商品标题
    order.productDescription = _ticketDetail; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格 [_payInfo[@"amount"] floatValue]
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
                    [UIAlertView showWithTitle:@"系统提示" message:resultDic[@"memo"]];
                }
            }
            DLog(@"支付结果 result = %@", resultDic);
        }];
    }
}

- (void)updateOrderSucess
{
    [WLHUDView showHUDWithStr:@"更新订单状态中..." dim:YES];
    NSDictionary *param = @{@"orderid":_payInfo[@"orderid"]};
    [WLHttpTool updateTicketOrderStatusParameterDic:param
                                            success:^(id JSON) {
                                                [WLHUDView hiddenHud];
                                                //刷新详情页面
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedReloadWebInfo" object:nil];
                                                [UIAlertView bk_showAlertViewWithTitle:@"系统提示"
                                                                               message:@"恭喜您，活动报名成功！"
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil
                                                                               handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                                                                   [self.navigationController popViewControllerAnimated:YES];
                                                                               }];
                                            } fail:^(NSError *error) {
                                                [UIAlertView showWithTitle:@"系统提示" message:@"订单状态修改失败，请电话联系客服确认订单状态"];
                                            }];
}

@end
