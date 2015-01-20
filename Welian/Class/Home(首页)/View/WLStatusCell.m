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
#import "FeedAndZanView.h"
#import "CommentCellView.h"
#import "WLStatusDock.h"
#import "CommentInfoController.h"
#import "MJExtension.h"
#import "M80AttributedLabel.h"

@interface WLStatusCell () <UIActionSheetDelegate,M80AttributedLabelDelegate>
{
    UIImageView *_imageV;
    M80AttributedLabel *_tuiUserLabel;
    
    //** 头部view   *//
    WLCellHead *_cellHeadView;
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
        
        _tuiUserLabel = [[M80AttributedLabel alloc] init];
        [_tuiUserLabel setTextColor:WLRGB(52, 116, 186)];
        _tuiUserLabel.font = WLFONT(13);
        [_tuiUserLabel setUnderLineForLink:NO];
        [_tuiUserLabel setDelegate:self];
        _tuiUserLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_tuiUserLabel];
        
        _imageV = [[UIImageView alloc] init];
        [_imageV setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:_imageV];
        
        _cellHeadView = [[WLCellHead alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
        [self.contentView addSubview:_cellHeadView];

        _contentAndDockView = [[WLContentCellView alloc] init];
        __weak WLStatusCell *weakcell = self;
        _contentAndDockView.feedzanBlock = ^(WLStatusM *statusM){
            if (weakcell.feedzanBlock) {
                weakcell.feedzanBlock (statusM);
            }
        };
        _contentAndDockView.feedTuiBlock = ^(WLStatusM *statusM){
            if (weakcell.feedTuiBlock) {
                weakcell.feedTuiBlock (statusM);
            }
        };
        _contentAndDockView.openupBlock = ^(BOOL isopen){
            if (isopen) {

            }else{
                
            }
        };
        
        [self.contentView addSubview:_contentAndDockView];
        
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
    selectedBg.image = [UIImage resizedImage:@"homeCellbackground_highlight" leftScale:0.98 topScale:0.5];
    self.selectedBackgroundView = selectedBg;
}

- (void)setStatusFrame:(WLStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    WLStatusM *status = statusFrame.status;
    WLBasicTrends *user = status.user;
    WLBasicTrends *tuiuser = status.tuiuser;
    WLContentCellFrame *contenFrame = statusFrame.contentFrame;
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    if (!_mode) {
//        _mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    }
    if ([[LogInUser getCurrentLoginUser].uid integerValue]==[user.uid integerValue]) {
        [_moreBut setHidden:NO];
    }else{
        [_moreBut setHidden:YES];
    }
    
    [_cellHeadView setUserStat:status];
    [_cellHeadView setControllVC:self.homeVC];
    CGFloat y = 0;
    CGRect headFrame = _cellHeadView.frame;
    if (status.type==1||status.type==2) {
        y= 30;
        headFrame.origin.y = 30;
        [_cellHeadView setFrame:headFrame];
        [_imageV setFrame:CGRectMake(60, 17, 15, 15)];
        [_imageV setHidden:NO];
        [_tuiUserLabel setHidden:NO];
        [_tuiUserLabel setFrame:CGRectMake(CGRectGetMaxX(_imageV.frame)+5, 17, mainSize.width-CGRectGetMaxX(_imageV.frame)-10, 20)];
        if (status.type==1) { // 转推
            NSString *tuiname = [NSString stringWithFormat:@"%@转推了",tuiuser.name];
            [_imageV setImage:[UIImage imageNamed:@"tui"]];
            [_tuiUserLabel setText:tuiname];
            NSRange range = [tuiname rangeOfString:tuiname];
            [_tuiUserLabel addCustomLink:[NSValue valueWithRange:range]
                                forRange:range
                               linkColor:WLRGB(52, 116, 186)];
            
        }else if (status.type ==2){  // 推荐好友
            [_imageV setImage:[UIImage imageNamed:@"osusume"]];
            [_tuiUserLabel setText:status.commandmsg];
        }
    }else{
        y= 0;
        headFrame.origin.y = 0;
        [_cellHeadView setFrame:headFrame];
        [_imageV setHidden:YES];
        [_tuiUserLabel setHidden:YES];
    }
    
    [_contentAndDockView setStatusFrame:statusFrame];
    [_contentAndDockView setFrame:CGRectMake(50, CGRectGetMaxY(_cellHeadView.frame), mainSize.width-50, contenFrame.cellHeight)];
    [_contentAndDockView setHomeVC:self.homeVC];
    
    CGFloat commenY = CGRectGetMaxY(_contentAndDockView.frame);
    
    if (status.zansArray.count||status.forwardsArray.count) {
        [_feznView setHidden:NO];
        [_feznView setFrame:CGRectMake(61,CGRectGetMaxY(_contentAndDockView.frame)-5, mainSize.width-61-10, statusFrame.feedAndZanFM.cellHigh)];
        [_feznView setFeedAndZanFrame:statusFrame.feedAndZanFM];
        commenY = CGRectGetMaxY(_feznView.frame);
        [_feznView setCommentVC:self.homeVC];
    }else{
        [_feznView setHidden:YES];
    }
    
    if (status.commentcount) {
        [_commentView setHidden:NO];
        [_commentView setCommenFrame:statusFrame.commentListFrame];
        [_commentView setFrame:CGRectMake(61, commenY+1, mainSize.width-61-10, statusFrame.commentListFrame.cellHigh)];
        [_commentView setCommentVC:self.homeVC];
    }else{
        [_commentView setHidden:YES];
    }
}

- (void)m80AttributedLabel:(M80AttributedLabel *)label clickedOnLink:(id)linkData
{
    NSLog(@"fasdfa");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
