//
//  BasicPlainTableViewController.m
//  Welian
//
//  Created by dong on 15/1/4.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BasicPlainTableViewController.h"

@interface BasicPlainTableViewController ()

@end

@implementation BasicPlainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (!self.needlessCancel) {
        [WLHUDView hiddenHud];
        [WLHttpTool cancelAllRequestHttpTool];
    }
}



@end
