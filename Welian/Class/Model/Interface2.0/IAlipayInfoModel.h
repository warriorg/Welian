//
//  IAlipayInfoModel.h
//  Welian
//
//  Created by weLian on 15/4/29.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface IAlipayInfoModel : IFBase

@property (nonatomic, strong) NSString *partnerid;////合作身份者id，以2088开头的16位纯数字
@property (nonatomic, strong) NSString *sellerid;////收款支付宝账号
@property (nonatomic, strong) NSString *privkey;////商户私钥，自助生成
@property (nonatomic, strong) NSString *pubkey; ////把支付宝公钥和RSA私钥配置到代码里面，RSA私钥如果不是php语言签名的，都要用pkcs8转码后再配置到代码里面，php语言签名的直接用rsa_private的pem文件 RSA公钥上传地址：登录b.alipay.com，点我的商家服务，点查询PID和KEY->合作伙伴密钥管理，RSA密钥->查看密钥或者添加密钥
//支付宝商户生成的公钥
@property (nonatomic, strong) NSString *callbackurl;//支付宝回调地址

@end

/*
 callbackurl = "http://sev.welian.com/alipay/notify";
 partnerid = 2088611088140964;
 privkey = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALoophIkcpw8SAgNtPCoK7dC3igETE8m227BiFUi7fUQbJMFG+yfnwH/Q0zR+zuKScLjB81EAqwYBjU+d7S+Lr4h+VqixRtUL56jXyL4oK6sg7JO5RdkVjmih+/k5f4NlFTSpPPlv4gqON7NLqnoXUmR5K5M7qfJva8ppNbpzTCZAgMBAAECgYAwWqSga8U1Xdcb+Gt6Y0RPqtfHry4fFSnEQBLoglUq5aQ+IAKb2O5Vd3eEubo3Qflc3NnG8JZ9GxRpuhsf4JKFMRS4OqnRHhZNwLugpTCrt6XnukDS69bsmH2li6zXkJ9SHJLhQzkqpZ7gSTd7nkxFy39bmsMqzjK1nNqPR/FhnQJBAOI8yt6wS3DhBmk5leMKKvMMNm1lzd6LLr2vV6RiwEVzlrtli/9VLeRiHP5YUYHTIqN/qGQIyT0O7prFNJtx1LMCQQDSphblXFp4C9dbrUCtM3zRKHN40jTsy0L3VvpAv1i1a/gQ041ni10xh3IOuWYS5bR2OEg2bLnR8S4TKho+08ODAkBnXk9zICnYEXjUazNI4URueI4FvhYqMH3SvWLWASjIkt+0D9m/eDPXvdxxefkD0GxrN9DApCMOetwaazB2NbRxAkB+urWjn4A+IMGbwgvbJ9K78t4lnjGBFHhhXc6JDZVM8Hv5g4za8plKpvYTra6fR9reFNY9CARzLepOVVIc4kIJAkEAltBchwK3mueIOOWW2SN3CMk5NnB/2jzaLNZtAJd9P9wu63dyPETYTmH1OiUMbtdy93Fe7kSPi90AMz1yyxYqfg==";
 pubkey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB";
 sellerid = "";
 */
