//
//  InvestInfoListVC.h
//  Welian
//
//  Created by dong on 15/1/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IIMeInvestAuthModel;

@interface InvestInfoListVC : UITableViewController

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) IIMeInvestAuthModel *iimeInvestM;

@end
