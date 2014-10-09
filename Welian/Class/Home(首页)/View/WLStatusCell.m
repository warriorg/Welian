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

@interface WLStatusCell ()
{
    /** 头像 */
    UIImageView *_iconView;
    /** 昵称 */
    UILabel *_nameLabel;
    /** 时间 */
    UILabel *_timeLabel;
    /** 来源 */
//    UILabel *_sourceLabel;
    /** 内容 */
    TQRichTextView *_contentLabel;
    /** 配图 */
    WLPhotoListView *_photoListView;
    
    /** 关系图标 */
    UIImageView *_mbView;
    
    /** 转发微博的整体 */
    UIImageView *_retweetView;
    /** 转发微博的昵称 */
    UILabel *_retweetNameLabel;
    /** 转发微博的配图 */
    WLPhotoListView *_retweetPhotoListView;
    /** 转发微博的内容 */
    TQRichTextView *_retweetContentLabel;
    
    /** 微博工具条 */
    WLStatusDock *_dock;
    /** 右上角按钮 */


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
        // 1.添加原创微博的子控件
        [self setupOriginalSubviews];
        
        // 2.添加转发微博的子控件
        [self setupRetweetSubviews];
        
        // 3.添加工具条
        [self setupStatusDock];
        
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
    bg.image = [UIImage resizedImage:@"background_white"];
    self.backgroundView = bg;
    
    // 2.选中
    UIImageView *selectedBg = [[UIImageView alloc] init];
    selectedBg.image = [UIImage resizedImage:@"background_grey"];
    self.selectedBackgroundView = selectedBg;
}

/**
 *  添加原创微博的子控件
 */
- (void)setupOriginalSubviews
{
#warning 清除cell默认的背景色(才能只显示背景view、背景图片)
    self.backgroundColor = [UIColor clearColor];
    
    // 1.头像
    _iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconView];
    
    // 2.昵称
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = IWNameFont;
#warning 清除背景颜色
    _nameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_nameLabel];
    
    // 3.时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = IWTimeFont;
    _timeLabel.textColor = [UIColor darkGrayColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_timeLabel];
    
//    // 4.来源
//    _sourceLabel = [[UILabel alloc] init];
//    _sourceLabel.font = IWSourceFont;
//    _sourceLabel.textColor = IWSourceColor;
//    _sourceLabel.backgroundColor = [UIColor clearColor];
//    [self.contentView addSubview:_sourceLabel];
    
    // 5.内容
    _contentLabel = [[TQRichTextView alloc] init];
    _contentLabel.font = IWContentFont;
    _contentLabel.textColor = IWContentColor;
#warning 自动换行
    //    _contentLabel.numberOfLines = 0;
    _contentLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_contentLabel];
    
    // 6.配图
    _photoListView = [[WLPhotoListView alloc] init];
    [self.contentView addSubview:_photoListView];
    
//    // 7.微博会员图标
    _mbView = [[UIImageView alloc] init];
    [self.contentView addSubview:_mbView];

}

/**
 *  添加转发微博的子控件
 */
- (void)setupRetweetSubviews
{
    // 0.整体
    _retweetView = [[UIImageView alloc] init];
    [_retweetView setUserInteractionEnabled:YES];
//    _retweetView.image = [UIImage resizedImage:@"timeline_retweet_background" leftScale:0.9 topScale:0.7];
    [self.contentView addSubview:_retweetView];
    
    // 1.昵称
    _retweetNameLabel = [[UILabel alloc] init];
    _retweetNameLabel.font = IWRetweetNameFont;
    _retweetNameLabel.textColor = IWRetweetNameColor;
    _retweetNameLabel.backgroundColor = [UIColor clearColor];
    [_retweetView addSubview:_retweetNameLabel];
    
    // 2.内容
    _retweetContentLabel = [[TQRichTextView alloc] init];
    _retweetContentLabel.font = IWRetweetContentFont;
    _retweetContentLabel.textColor = IWRetweetContentColor;
    //    _retweetContentLabel.numberOfLines = 0;
    _retweetContentLabel.backgroundColor = [UIColor clearColor];
    [_retweetView addSubview:_retweetContentLabel];
    
    // 3.配图
    _retweetPhotoListView = [[WLPhotoListView alloc] init];
    [_retweetView addSubview:_retweetPhotoListView];
}

/**
 *  添加工具条
 */
- (void)setupStatusDock
{
    // 1.计算dock的frame
    CGFloat dockH = IWStatusDockH;
    CGFloat dockX = 0;
    CGFloat dockY = self.contentView.frame.size.height - dockH;
    CGFloat dockW = self.contentView.frame.size.width;
    CGRect dockF = CGRectMake(dockX, dockY, dockW, dockH);
    
    // 2.创建和添加dock
    _dock = [[WLStatusDock alloc] initWithFrame:dockF];
    _dock.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.contentView addSubview:_dock];
}

- (void)setStatusFrame:(WLStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    WLStatusM *status = statusFrame.status;
    
    WLBasicTrends *user = status.user;
    
    // 1.头像
    _iconView.frame = statusFrame.iconViewF;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:status.user.avatar] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    [_iconView.layer setMasksToBounds:YES];
    [_iconView.layer setCornerRadius:statusFrame.iconViewF.size.height*0.5];
    
//    [_iconView setUser:user iconType:IWIconTypeSmall];
    
    // 2.昵称
    _nameLabel.frame = statusFrame.nameLabelF;
    _nameLabel.text = user.name;

    _mbView.hidden = NO;
    _mbView.frame = statusFrame.mbViewF;
    // 3.会员图标
    if (user.relation == WLRelationTypeNone) { // 关系无
        _mbView.hidden = YES;
    } else if(user.relation == WLRelationTypeFriend){ // 朋友
        [_mbView setImage:[UIImage imageNamed:@"home_label_friend"]];

    }else if (user.relation == WLRelationTypeFriendsFriend){
        [_mbView setImage:[UIImage imageNamed:@"home_label_friendsfriend"]];
    }
    
    // 4.配图
    if (status.photos.count) {
        _photoListView.hidden = NO;
        _photoListView.frame = statusFrame.photoListViewF;
        // 传递图片数组给相册控件
        _photoListView.photos = status.photos;
    } else {
        _photoListView.hidden = YES;
    }
    
    // 5.转发微博
    WLStatusM *retweetStatus = status.relationfeed;
    if (retweetStatus) {
        _retweetView.hidden = NO;
        _retweetView.frame = statusFrame.retweetViewF;
        
        // 5.1.昵称
        _retweetNameLabel.frame = statusFrame.retweetNameLabelF;
        _retweetNameLabel.text = [NSString stringWithFormat:@"@%@", retweetStatus.user.name];
        
        // 5.2.正文
        _retweetContentLabel.frame = statusFrame.retweetContentLabelF;
        _retweetContentLabel.text = retweetStatus.content;
        
        // 5.3.配图
        if (retweetStatus.photos.count) {
            _retweetPhotoListView.hidden = NO;
            _retweetPhotoListView.frame = statusFrame.retweetPhotoListViewF;
            _retweetPhotoListView.photos = retweetStatus.photos;
        } else {
            _retweetPhotoListView.hidden = YES;
        }
    } else { // 没有转发
        _retweetView.hidden = YES;
    }
    
    // 6.正文
    _contentLabel.frame = statusFrame.contentLabelF;
    _contentLabel.text = status.content;
    
    // 7.时间
    _timeLabel.text = status.created;
    CGFloat timeX = CGRectGetMinX(_nameLabel.frame);
    CGFloat timeY = CGRectGetMaxY(_nameLabel.frame) + IWCellBorderWidth * 0.5;
    CGSize timeSize = [_timeLabel.text sizeWithFont:IWTimeFont];
    _timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    
//    // 8.来源
//    _sourceLabel.text = status.source;
//    CGFloat sourceX = CGRectGetMaxX(_timeLabel.frame) + IWCellBorderWidth * 0.5;
//    CGFloat sourceY = timeY;
//    CGSize sourceSize = [_sourceLabel.text sizeWithFont:IWSourceFont];
//    _sourceLabel.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    
    // 9.给dock传递微博模型数据
    _dock.status = status;
}

- (void)setFrame:(CGRect)frame
{
//    frame.origin.x = 0;
//    frame.size.width -= 2 * IWTableBorderWidth;
    
    frame.origin.y += IWTableBorderWidth;
    frame.size.height -= IWCellMargin*2;
    
    [super setFrame:frame];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
