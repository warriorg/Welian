//
//  HomeView.m
//  weLian
//
//  Created by dong on 14/11/12.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "HomeView.h"
#import "UIImage+ImageEffects.h"
#import "PublishStatusController.h"
#import "NavViewController.h"
#import "AddFriendsController.h"
#import "AddFriendTypeListViewController.h"

@interface HomeView()

@end

@implementation HomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"home_empty_logo"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setCenter:self.center];
        [self addSubview:imageView];
        CGRect imageframe = imageView.frame;
        imageframe.origin.y -= 130;
        [imageView setFrame:imageframe];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(imageView.frame)+20, frame.size.width-80, 40)];
        [label setText:@"还没有动态内容哦，赶快发布一条动态或去寻找好友吧！"];
        [label setNumberOfLines:0];
        [label setFont:kNormal14Font];
        [label setTextColor:WLRGB(162, 182, 190)];
        [self addSubview:label];
        
        UIButton *publeshBut = [[UIButton alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(label.frame)+25, (frame.size.width-100)*0.5, 40)];
        [publeshBut setBackgroundImage:[UIImage resizedImage:@"home_empty_button"] forState:UIControlStateNormal];
        [publeshBut setBackgroundImage:[UIImage resizedImage:@"home_empty_button_highlight"] forState:UIControlStateHighlighted];
        [publeshBut setTitle:@"发布动态" forState:UIControlStateNormal];
        [publeshBut setTitleColor:KBasesColor forState:UIControlStateNormal];
        [publeshBut addTarget:self action:@selector(publeshButClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publeshBut];
        
        UIButton *addFriendBut = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(publeshBut.frame)+20, CGRectGetMaxY(label.frame)+25, (frame.size.width-100)*0.5, 40)];
        [addFriendBut setBackgroundImage:[UIImage resizedImage:@"home_empty_button"] forState:UIControlStateNormal];
        [addFriendBut setBackgroundImage:[UIImage resizedImage:@"home_empty_button_highlight"] forState:UIControlStateHighlighted];
        [addFriendBut setTitle:@"添加好友" forState:UIControlStateNormal];
        [addFriendBut setTitleColor:KBasesColor forState:UIControlStateNormal];
        [addFriendBut addTarget:self action:@selector(addFriendButClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addFriendBut];

        
    }
    return self;
}


// 发布动态
- (void)publeshButClick:(UIButton*)but
{
    PublishStatusController *publishVC = [[PublishStatusController alloc] init];
    
    [self.homeController presentViewController:[[NavViewController alloc] initWithRootViewController:publishVC] animated:YES completion:^{
        
    }];
}


// 添加好友
- (void)addFriendButClick:(UIButton*)but
{
    AddFriendTypeListViewController *addFriendVC = [[AddFriendTypeListViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.homeController.navigationController pushViewController:addFriendVC animated:YES];
}

@end
