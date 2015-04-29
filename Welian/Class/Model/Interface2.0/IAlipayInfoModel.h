//
//  IAlipayInfoModel.h
//  Welian
//
//  Created by weLian on 15/4/29.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface IAlipayInfoModel : IFBase

@property (nonatomic, strong) NSString *PartnerID;////合作身份者id，以2088开头的16位纯数字
@property (nonatomic, strong) NSString *SellerID;////收款支付宝账号
@property (nonatomic, strong) NSString *PrivKey;////商户私钥，自助生成
@property (nonatomic, strong) NSString *PubKey; ////把支付宝公钥和RSA私钥配置到代码里面，RSA私钥如果不是php语言签名的，都要用pkcs8转码后再配置到代码里面，php语言签名的直接用rsa_private的pem文件 RSA公钥上传地址：登录b.alipay.com，点我的商家服务，点查询PID和KEY->合作伙伴密钥管理，RSA密钥->查看密钥或者添加密钥
//支付宝商户生成的公钥
@property (nonatomic, strong) NSString *callbackurl;//支付宝回调地址

@end
