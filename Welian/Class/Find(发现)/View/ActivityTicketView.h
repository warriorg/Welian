//
//  ActivityTicketView.h
//  Welian
//
//  Created by weLian on 15/2/12.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActivityBuyTicketBlock)(NSArray *ticekets);

@interface ActivityTicketView : UIView

@property (assign,nonatomic) BOOL isBuyTicket;//yes:购票   no:查看购买的票
@property (strong,nonatomic) NSArray *tickets;
@property (strong,nonatomic) ActivityBuyTicketBlock buyTicketBlock;

- (void)showInView;
- (void)dismiss;

@end
