//
//  ActivityDetailViewController.m
//  Welian
//
//  Created by weLian on 15/1/6.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityEntryViewController.h"
#import "ActivityOrderViewController.h"
#import "ActivityMapViewController.h"
#import "ActivityUserListViewController.h"
#import "LXActivity.h"
#import "ShareEngine.h"
#import "SEImageCache.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

@interface ActivityDetailViewController ()<LXActivityDelegate>
{
    LXActivity *lxActivity;
}

@property (nonatomic, strong) NSDictionary *shareFriend;//分享到微信好友的dict
@property (nonatomic, strong) NSDictionary *shareFriendCircle;//分享到微信朋友圈

@end

@implementation ActivityDetailViewController

- (void)dealloc
{
    _shareFriend = nil;
    _shareFriendCircle = nil;
}

//- (instancetype)initWithShareDic:(NSDictionary *)dict{
//    self = [super init];
//    if (self) {
//        self.shareFriend = dict[@"friend"];
//        self.shareFriendCircle = dict[@"friendCircle"];
//    }
//    return self;
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [WLHUDView hiddenHud];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//可以调用分享
- (void)canShareWithInfo:(NSDictionary *)dict
{
    self.shareFriend = dict[@"friend"];
    self.shareFriendCircle = dict[@"friendCircle"];
    //添加分享按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(shareActivity)];//[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(shareActivity)];
}

//分享活动
- (void)shareActivity
{
    NSArray *shareButtonTitleArray = @[@"微信好友",@"微信朋友圈"];;
    NSArray *shareButtonImageNameArray = @[@"home_repost_wechat",@"home_repost_friendcirle"];
    if (lxActivity) {
        [lxActivity removeFromSuperview];
        lxActivity = nil;
    }
    lxActivity = [[LXActivity alloc] initWithDelegate:self WithTitle:@"分享到" otherButtonTitles:nil ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    [lxActivity showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - LXActivityDelegate
- (void)didClickOnImageIndex:(NSString *)imageIndex
{
    NSDictionary *sharDic = nil;
    WeiboType type = weChat;
    if ([imageIndex isEqualToString:@"微信好友"]){
        sharDic = _shareFriend;
        type = weChat;
    }else if ([imageIndex isEqualToString:@"微信朋友圈"]){
        sharDic = _shareFriendCircle;
        type = weChatFriend;
    }

    NSString *desc = sharDic[@"desc"];
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sharDic[@"img"]]]];
    NSURL *imgUrl = [NSURL URLWithString:sharDic[@"img"]];
    NSString *link = sharDic[@"link"];
    NSString *title = sharDic[@"title"];
    
    [WLHUDView showHUDWithStr:@"" dim:NO];
    [[SEImageCache sharedInstance] imageForURL:imgUrl completionBlock:^(UIImage *image, NSError *error) {
        [WLHUDView hiddenHud];
        DLog(@"shareFriendImage---->>>%@",image);
        [[ShareEngine sharedShareEngine] sendWeChatMessage:title andDescription:desc WithUrl:link andImage:image WithScene:type];
    }];
    
}

#pragma mark - private
//进入地图页面
- (void)toMapVC:(NSArray *)infos
{
    NSString *address = [NSString stringWithFormat:@"%@%@",infos[0],infos[1]];
    DLog(@"toMapVC ----->%@",address);
    ActivityMapViewController *mapVC = [[ActivityMapViewController alloc] initWithAddress:infos[1] city:infos[0]];
    [self.navigationController pushViewController:mapVC animated:YES];
}

//显示已报名人数
- (void)showEntry:(NSArray *)infos
{
    DLog(@"showEntry -----> 活动编号：%@, 人数：%@",infos[0],infos[1]);
    //活动页面，进行phoneGap页面加载
//    ActivityEntryViewController *activityEntryVC = [[ActivityEntryViewController alloc] init];
//    activityEntryVC.wwwFolderName = @"www";
//    activityEntryVC.startPage = [NSString stringWithFormat:@"activity_entry.html?%@?%@?t=%@",infos[0],infos[1],[NSString getNowTimestamp]];
//    [self.navigationController pushViewController:activityEntryVC animated:YES];
    
    ActivityUserListViewController *userListVC = [[ActivityUserListViewController alloc] initWithStyle:UITableViewStylePlain activeInfo:infos];
    [self.navigationController pushViewController:userListVC animated:YES];
}

//进入订单页面
- (void)toOrderVC:(NSArray *)infos
{
    DLog(@"showEntry -----> %@",infos[0]);
    //活动页面，进行phoneGap页面加载
    ActivityOrderViewController *activityOrderVC = [[ActivityOrderViewController alloc] init];
    activityOrderVC.orderInfo = infos[1];
    activityOrderVC.wwwFolderName = @"www";
    activityOrderVC.startPage = [NSString stringWithFormat:@"activity_order.html?%@?t=%@",infos[0],[NSString getNowTimestamp]];
    [self.navigationController pushViewController:activityOrderVC animated:YES];
}

//微信支付
- (void)wechatPay:(NSArray *)infos
{
    NSDictionary *payInfo = infos[0];
    DLog(@"payInfo -----> %@",payInfo);
    UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:@"在线支付"];
    [sheet bk_addButtonWithTitle:@"支付宝支付" handler:^{
        [self alipayWithInfo:payInfo];
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
//    let partner: String = NSBundle.mainBundle().objectForInfoDictionaryKey("Partner") as String
//    let seller: String = NSBundle.mainBundle().objectForInfoDictionaryKey("Seller") as String
    
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
    order.tradeNO = @""; //订单ID（由商家自行制定）
    order.productName = @""; //商品标题
    order.productDescription = @""; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
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
                
            }
            DLog(@"支付结果 result = %@", resultDic);
        }];
    }
}

@end
