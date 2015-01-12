//
//  MyFriendsOperateViewCell.m
//  Welian
//
//  Created by weLian on 15/1/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "MyFriendsOperateViewCell.h"

@interface MyFriendsOperateViewCell ()

@end

@implementation MyFriendsOperateViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //操作按钮
        NSArray *btnImages = @[[UIImage imageNamed:@"me_myfriend_new_logo"],
                               [UIImage imageNamed:@"me_myfriend_phone_logo"],
                               [UIImage imageNamed:@"me_myfriend_wechat_logo"],
                               [UIImage imageNamed:@"me_myfriend_friendsfriend_logo"]];
        
        //新的消息数量
        NSString *badgeStr = [NSString stringWithFormat:@"%@",[LogInUser getNowLogInUser].newfriendbadge];
        
        WLSegmentedControl *segementedControl = [[WLSegmentedControl alloc] initWithFrame:self.bounds Titles:@[@"新的好友",@"手机联系人",@"微信好友",@"好友的好友"] Images:btnImages Bridges:@[badgeStr == nil ? @"0": badgeStr,@"0",@"0",@"0"]];
//        segementedControl.delegate = self;
        [self addSubview:segementedControl];
        self.segementedControl = segementedControl;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _segementedControl.frame = self.bounds;
}

@end
