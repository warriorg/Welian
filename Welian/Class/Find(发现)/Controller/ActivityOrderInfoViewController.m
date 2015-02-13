//
//  ActivityOrderInfoViewController.m
//  Welian
//
//  Created by weLian on 15/2/13.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityOrderInfoViewController.h"
#import "UIImage+ImageEffects.h"

#define kInfoViewHeight 180.f

#define kMarginLeft 15.f


@interface ActivityOrderInfoViewController ()

@end

@implementation ActivityOrderInfoViewController

- (NSString *)title
{
    return @"订单详情";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(237.f, 238.f, 242.f);
    
    UIImageView *contentImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"discovery_activity_pay_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:1]];
    contentImageView.frame = CGRectMake(0, ViewCtrlTopBarHeight, self.view.width, kInfoViewHeight);
    [self.view addSubview:contentImageView];
    
}

#pragma mark - Private


@end
