//
//  AddFriendViewController.m
//  Welian
//
//  Created by weLian on 15/1/8.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()

@property (assign,nonatomic) UISegmentedControl *segmentedControl;

@end

@implementation AddFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加title内容
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"手机联系人",@"微信好友"]];
    [segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    self.segmentedControl = segmentedControl;
}

#pragma mark - Private
- (void)segmentedControlChanged:(UISegmentedControl *)sender
{
    
}

@end
