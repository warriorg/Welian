//
//  ActivityTicketViewCell.h
//  Welian
//
//  Created by weLian on 15/2/12.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ActivityTicketViewCell : BaseTableViewCell

@property (strong,nonatomic) IActivityTicket *iActivityTicket;

//返回cell的高度
+ (CGFloat)configureWithName:(NSString *)name DetailInfo:(NSString *)detailInfo;

@end
