//
//  IActivityOrderResultModel.h
//  Welian
//
//  Created by weLian on 15/4/29.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@class IAlipayInfoModel;
@interface IActivityOrderResultModel : IFBase

@property (nonatomic, strong) NSNumber *activeid;  //活动id
@property (nonatomic, strong) NSString *orderid;   //订单id
@property (nonatomic, strong) NSNumber *amount;    //总金额
@property (nonatomic, strong) IAlipayInfoModel *alipay;    //用户头像

@end

/*
 {
 
 "state":1000,
 
 "data": {
 
 "orderid":"sdfsadf",
 
 "activeid":1,
 
 "amount":128,
 
 "alipay":{
 
 PartnerID,SellerID,PrivKey PubKey callbackurl
 
 }
 
 },
 
 }
 */
