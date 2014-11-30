//
//  WLStatusCell.m
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLStatusCell.h"
#import "UIImage+ImageEffects.h"
#import "WLStatusFrame.h"
#import "WLStatusM.h"
#import "WLBasicTrends.h"
#import "UIImageView+WebCache.h"
#import "PublishStatusController.h"
#import "ShareEngine.h"
#import "WLCellHead.h"
#import "WLContentCellView.h"
#import "FeedAndZanView.h"
#import "CommentCellView.h"
#import "WLStatusDock.h"
#import "CommentInfoController.h"
#import "MJExtension.h"

@interface WLStatusCell () <UIActionSheetDelegate>
{
    //** 头部view   *//
    WLCellHead *_cellHeadView;
//    /** 内容 */
    WLContentCellView *_contentView;
    // 赞和转发
    FeedAndZanView *_feznView;
    
    // 评论
    CommentCellView *_commentView;
    
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
        
        _cellHeadView = [[WLCellHead alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
        [self.contentView addSubview:_cellHeadView];

        _contentView = [[WLContentCellView alloc] init];
        __weak WLStatusCell *weakcell = self;
        _contentView.feedzanBlock = ^(WLStatusM *statusM){
            if (weakcell.feedzanBlock) {
                weakcell.feedzanBlock (statusM);
            }
        };
        _contentView.openupBlock = ^(BOOL isopen){
            if (isopen) {

            }else{
                
            }
        };
        //    // 评论
        [_contentView.dock.commentBtn addTarget:self action:@selector(commentBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_contentView];
        
        _feznView = [[FeedAndZanView alloc] init];
        [_feznView setImage:[UIImage resizedImage:@"home_grc_background" leftScale:0.1 topScale:0.9]];
        [self.contentView addSubview:_feznView];
        
        _commentView = [[CommentCellView alloc] init];
        [_commentView setImage:[UIImage resizedImage:@"repost_bg"]];
        [self.contentView addSubview:_commentView];
        
        // 8.更多按钮
        _moreBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBut setImage:[UIImage imageNamed:@"me_mywriten_more"] forState:UIControlStateNormal];
        // 8.3.设置按钮永远停留在右上角
        CGFloat btnWH = 35;
        CGFloat btnY = 0;
        CGFloat btnX = self.contentView.frame.size.width - btnWH;
        _moreBut.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
        _moreBut.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:_moreBut];
        
        // 4.设置背景
        [self setupBg];
    }
    return self;
}


#pragma mark- 评论
- (void)commentBtnClick:(UIButton*)but event:(id)event
{
    CommentInfoController *commentInfo = [[CommentInfoController alloc] init];
    [commentInfo setStatusM:_statusFrame.status];
    [commentInfo setBeginEdit:YES];
    [self.homeVC.navigationController pushViewController:commentInfo animated:YES];
}


/**
 *  设置背景
 */
- (void)setupBg
{
    // 1.默认
    UIImageView *bg = [[UIImageView alloc] init];
    bg.image = [UIImage resizedImage:@"homeCellbackground_normal" leftScale:0.9 topScale:0.5];
    self.backgroundView = bg;
    // 2.选中
    UIImageView *selectedBg = [[UIImageView alloc] init];
    selectedBg.image = [UIImage resizedImage:@"homeCellbackground_highlight" leftScale:0.9 topScale:0.5];
    self.selectedBackgroundView = selectedBg;
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
    [_cellHeadView setControllVC:self.homeVC];
    
    [_contentView setStatusFrame:statusFrame];
    [_contentView setFrame:CGRectMake(50, 60, [UIScreen mainScreen].bounds.size.width-50, contenFrame.cellHeight)];
    [_contentView setHomeVC:self.homeVC];
    
    CGFloat commenY = CGRectGetMaxY(_contentView.frame);
    
    if (status.zansArray.count||status.forwardsArray.count) {
        [_feznView setHidden:NO];
        [_feznView setFrame:CGRectMake(60, CGRectGetMaxY(_contentView.frame)-5, [UIScreen mainScreen].bounds.size.width-60-10, statusFrame.feedAndZanFM.cellHigh)];
        [_feznView setFeedAndZanFrame:statusFrame.feedAndZanFM];
        commenY = CGRectGetMaxY(_feznView.frame);
        [_feznView setCommentVC:self.homeVC];
    }else{
        [_feznView setHidden:YES];
    }
    
    if (status.commentcount) {
        [_commentView setHidden:NO];
        [_commentView setCommenFrame:statusFrame.commentListFrame];
        [_commentView setFrame:CGRectMake(60, commenY+2, [UIScreen mainScreen].bounds.size.width-60-10, statusFrame.commentListFrame.cellHigh)];
        [_commentView setCommentVC:self.homeVC];
    }else{
        [_commentView setHidden:YES];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
