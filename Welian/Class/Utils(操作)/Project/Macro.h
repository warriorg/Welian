//
//  Macro.h
//  Welian
//
//  Created by weLian on 15/4/21.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#ifndef Welian_Macro_h
#define Welian_Macro_h

//微链服务电话 now now
#define kTelNumber @"18658883913"

// 服务器地址
//测试环境
#define WLHttpServer  @"http://test.welian.com:8080"

//#define WLHttpServer @"http://sev.welian.com:80"

//本地调试
//#define WLHttpServer  @"http://192.168.1.122:80"
//正式环境
//#define WLHttpServer  @"http://www.welian.com:8080"

//支付宝回调地址
//#define kAlipayNotifyURL @"http://test.welian.com:8080/alipay/notify"
#define kAlipayNotifyURL @"http://www.welian.com:8080/alipay/notify"

















#pragma mark - Sqlite Data
#define KWLDataDBName @"wlDataDBName.db"

// 首页数据
#define KHomeDataTableName [NSString stringWithFormat:@"home%@",[LogInUser getCurrentLoginUser].uid]
// 所有动态数据
#define KWLStutarDataTableName [NSString stringWithFormat:@"stutarData%@",[LogInUser getCurrentLoginUser].uid]
// 所有用户详细信息
#define KWLUserInfoTableName [NSString stringWithFormat:@"UserInfo%@",[LogInUser getCurrentLoginUser].uid]
// 用户共同好友
#define KWLSamefriendsTableName [NSString stringWithFormat:@"Samefriends%@",[LogInUser getCurrentLoginUser].uid]

// 投资领域数据 行业
#define KInvestIndustryTableName @"InvestIndustry"

// 文件路径
#define kFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"userInfo.data"]


#pragma mark - 支付宝配置信息
//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088611088140964"
//收款支付宝账号
#define SellerID  @"wx@welian.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"9ztmliltn7r93e3wz31dee780eme05rj"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALoophIkcpw8SAgNtPCoK7dC3igETE8m227BiFUi7fUQbJMFG+yfnwH/Q0zR+zuKScLjB81EAqwYBjU+d7S+Lr4h+VqixRtUL56jXyL4oK6sg7JO5RdkVjmih+/k5f4NlFTSpPPlv4gqON7NLqnoXUmR5K5M7qfJva8ppNbpzTCZAgMBAAECgYAwWqSga8U1Xdcb+Gt6Y0RPqtfHry4fFSnEQBLoglUq5aQ+IAKb2O5Vd3eEubo3Qflc3NnG8JZ9GxRpuhsf4JKFMRS4OqnRHhZNwLugpTCrt6XnukDS69bsmH2li6zXkJ9SHJLhQzkqpZ7gSTd7nkxFy39bmsMqzjK1nNqPR/FhnQJBAOI8yt6wS3DhBmk5leMKKvMMNm1lzd6LLr2vV6RiwEVzlrtli/9VLeRiHP5YUYHTIqN/qGQIyT0O7prFNJtx1LMCQQDSphblXFp4C9dbrUCtM3zRKHN40jTsy0L3VvpAv1i1a/gQ041ni10xh3IOuWYS5bR2OEg2bLnR8S4TKho+08ODAkBnXk9zICnYEXjUazNI4URueI4FvhYqMH3SvWLWASjIkt+0D9m/eDPXvdxxefkD0GxrN9DApCMOetwaazB2NbRxAkB+urWjn4A+IMGbwgvbJ9K78t4lnjGBFHhhXc6JDZVM8Hv5g4za8plKpvYTra6fR9reFNY9CARzLepOVVIc4kIJAkEAltBchwK3mueIOOWW2SN3CMk5NnB/2jzaLNZtAJd9P9wu63dyPETYTmH1OiUMbtdy93Fe7kSPi90AMz1yyxYqfg=="

//把支付宝公钥和RSA私钥配置到代码里面，RSA私钥如果不是php语言签名的，都要用pkcs8转码后再配置到代码里面，php语言签名的直接用rsa_private的pem文件 RSA公钥上传地址：登录b.alipay.com，点我的商家服务，点查询PID和KEY->合作伙伴密钥管理，RSA密钥->查看密钥或者添加密钥
//支付宝商户生成的公钥
#define AlipayPubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"


#endif
