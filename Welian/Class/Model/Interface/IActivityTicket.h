//
//  IActivityTicket.h
//  Welian
//
//  Created by weLian on 15/3/5.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface IActivityTicket : IFBase

@property (nonatomic,strong) NSNumber *ticketid;//票id
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *intro;//描述
@property (nonatomic,strong) NSNumber *ticketCount;//票的数量
@property (nonatomic,strong) NSNumber *joined;//已经出售的数量
@property (nonatomic,strong) NSNumber *price;//票价
@property (nonatomic,strong) NSNumber *buyCount;//购买的数量，自己设置买票的数量

@end
