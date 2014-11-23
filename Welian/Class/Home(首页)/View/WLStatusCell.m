//
//  WLStatusCell.m
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLStatusCell.h"
#import "TQRichTextView.h"
#import "WLPhotoListView.h"
#import "WLStatusDock.h"
#import "UIImage+ImageEffects.h"
#import "WLStatusFrame.h"
#import "WLStatusM.h"
#import "WLBasicTrends.h"
#import "UIImageView+WebCache.h"
#import "MLEmojiLabel.h"
#import "LXActivity.h"
#import "PublishStatusController.h"
#import "NavViewController.h"
#import "ShareEngine.h"
#import "UserInfoBasicVC.h"
#import "HBVLinkedTextView.h"
#import "UIColor+HBVHarmonies.h"
#import "UserInfoBasicVC.h"
#import "WLCellHead.h"

#import "WLContentCellView.h"
#import "FeedAndZanView.h"

@interface WLStatusCell () <UIActionSheetDelegate>
{
    //** 头部view   *//
    WLCellHead *_cellHeadView;
//    /** 内容 */
    WLContentCellView *_contentView;
    
    FeedAndZanView *_feznView;
    
    UserInfoModel *_mode;
}
@end

@implementation WLStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"Cell";
    WLStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WLStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 清除cell默认的背景色(才能只显示背景view、背景图片)
        self.backgroundColor = [UIColor clearColor];
        _cellHeadView = [[WLCellHead alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70)];
        [_cellHeadView.iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapiconImage:)]];
        [self.contentView addSubview:_cellHeadView];

        _contentView = [[WLContentCellView alloc] init];
        [self.contentView addSubview:_contentView];
        
        
        _feznView = [[FeedAndZanView alloc] init];
        [_feznView setImage:[UIImage resizedImage:@"home_grc_background" leftScale:0.1 topScale:0.9]];
        [self.contentView addSubview:_feznView];
        
        // 8.更多按钮
        _moreBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBut setImage:[UIImage imageNamed:@"me_mywriten_more"] forState:UIControlStateNormal];
        // 8.3.设置按钮永远停留在右上角
        CGFloat btnWH = 35;
        CGFloat btnY = IWTableBorderWidth;
        CGFloat btnX = self.contentView.frame.size.width - btnWH-10;
        _moreBut.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
        _moreBut.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:_moreBut];
        
        // 4.设置背景
        [self setupBg];
    }
    return self;
}


/**
 *  设置背景
 */
- (void)setupBg
{
    // 1.默认
    UIImageView *bg = [[UIImageView alloc] init];
    bg.image = [UIImage resizedImage:@"cellbackground_normal" leftScale:0.9 topScale:0.5];
    self.backgroundView = bg;
    // 2.选中
    UIImageView *selectedBg = [[UIImageView alloc] init];
    selectedBg.image = [UIImage resizedImage:@"cellbackground_highlight" leftScale:0.9 topScale:0.5];
    self.selectedBackgroundView = selectedBg;
}

- (void)tapiconImage:(UITapGestureRecognizer *)tap
{
    WLBasicTrends *user = _statusFrame.status.user;
    UserInfoModel *mode = [[UserInfoModel alloc] init];
    [mode setUid:user.uid];
    [mode setAvatar:user.avatar];
    [mode setName:user.name];
    
    UserInfoBasicVC *userinfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:mode isAsk:NO];
    [self.homeVC.navigationController pushViewController:userinfoVC animated:YES];
}

- (void)setStatusFrame:(WLStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    WLStatusM *status = statusFrame.status;
    
    WLBasicTrends *user = status.user;
    WLContentCellFrame *contenFrame = statusFrame.contentFrame;
    
    if (!_mode) {
        _mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    }
    if ([_mode.uid integerValue]==[user.uid integerValue]) {
        [_moreBut setHidden:NO];
        
    }else{
        [_moreBut setHidden:YES];
    }

    [_cellHeadView setUser:user];
    
    [_contentView setStatusFrame:statusFrame];
    [_contentView setFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, contenFrame.cellHeight)];
    
    if (status.zansArray.count||status.forwardsArray.count) {
        [_feznView setHidden:NO];
        [_feznView setFrame:CGRectMake(60, CGRectGetMaxY(_contentView.frame)-5, [UIScreen mainScreen].bounds.size.width-60-10, statusFrame.feedAndZanFM.cellHigh)];
        [_feznView setFeedAndZanFrame:statusFrame.feedAndZanFM];
    }else{
        [_feznView setHidden:YES];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
