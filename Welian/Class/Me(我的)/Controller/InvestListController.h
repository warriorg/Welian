//
//  InvestListController.h
//  weLian
//
//  Created by dong on 14-10-9.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "BasicTableViewController.h"
@class InvestAuthModel;
@class InvestListController;

@protocol InvestListDelegate <NSObject>

- (void)investListVC:(InvestListController *)investListVC withItmesList:(NSArray *)itmesA;

@end

@interface InvestListController : BasicTableViewController

@property (nonatomic, strong) InvestAuthModel *investM;

@property (nonatomic, weak) id<InvestListDelegate> delegate;

@end
