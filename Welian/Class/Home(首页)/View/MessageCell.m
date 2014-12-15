//
//  MessageCell.m
//  weLian
//
//  Created by dong on 14/11/13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "MessageCell.h"
#import "MLEmojiLabel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"

@interface MessageCell ()<MLEmojiLabelDelegate>
{
    // 头像
    UIImageView *_iconImage;
    // 姓名
    UILabel *_nameLabel;
    // 对我的评论
    MLEmojiLabel *_commentLabel;
    // 时间
    UILabel *_timeLabel;
    // 动态图片
    UIImageView *_photImage;
    // 动态说说
    MLEmojiLabel *_trendsLabel;
    // 赞转发图片
    UIImageView *_zanfeedImage;
}

@end

@implementation MessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *messageCellid = @"messageCellid";
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCellid];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageCellid];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 设置背景
//        [self setupBg];
        
        // 加载ui
        [self loadUIview];
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
    bg.image = [UIImage resizedImage:@"tabbar_b"];
    self.backgroundView = bg;
    // 2.选中
    UIImageView *selectedBg = [[UIImageView alloc] init];
    selectedBg.image = [UIImage resizedImage:@"tabbar_b"];
    self.selectedBackgroundView = selectedBg;
}


- (void)loadUIview
{
    _iconImage = [[UIImageView alloc] init];
    [_iconImage.layer setMasksToBounds:YES];
    [_iconImage.layer setCornerRadius:IWIconWHSmall*0.5];
    [self.contentView addSubview:_iconImage];
    
    _nameLabel = [[UILabel alloc] init];
    [_nameLabel setFont:IWContentFont];
    [self.contentView addSubview:_nameLabel];
    
    _commentLabel = [[MLEmojiLabel alloc]init];
    _commentLabel.emojiDelegate = self;
    _commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _commentLabel.isNeedAtAndPoundSign = YES;
    _commentLabel.font = WLFONT(14);
    _commentLabel.textColor = WLRGB(125, 125, 125);
    _commentLabel.backgroundColor = [UIColor clearColor];
    _commentLabel.numberOfLines = 0;
    [self.contentView addSubview:_commentLabel];
    
    
    _timeLabel = [[UILabel alloc] init];
    [_timeLabel setTextColor:WLRGB(173, 173, 173)];
    [_timeLabel setFont:IWTimeFont];
    [self.contentView addSubview:_timeLabel];
    
    _photImage = [[UIImageView alloc] init];
    _photImage.contentMode = UIViewContentModeScaleAspectFill;
    // 超出边界范围的内容都裁剪
    _photImage.clipsToBounds = YES;
    [self.contentView addSubview:_photImage];
    
    _trendsLabel = [[MLEmojiLabel alloc]init];
    _trendsLabel.numberOfLines = 0;
    _trendsLabel.emojiDelegate = self;
    _trendsLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _trendsLabel.isNeedAtAndPoundSign = YES;
    _trendsLabel.font = WLFONT(12);
    _trendsLabel.textColor = WLRGB(173, 173, 173);
    _trendsLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_trendsLabel];
    
    _zanfeedImage = [[UIImageView alloc] init];
    [self.contentView addSubview:_zanfeedImage];
    
}


- (void)setMessageFrameModel:(MessageFrameModel *)messageFrameModel
{
    _messageFrameModel = messageFrameModel;
    MessageHomeModel *messageDataM = messageFrameModel.messageDataM;
    
    [_iconImage setFrame:messageFrameModel.iconImageF];
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:messageDataM.avatar] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    
    [_nameLabel setFrame:messageFrameModel.nameLabelF];
    [_nameLabel setText:messageDataM.name];
    if ([messageDataM.type isEqualToString:@"feedComment"]) {
        [_zanfeedImage setHidden:YES];
        [_commentLabel setHidden:NO];
        _commentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _commentLabel.customEmojiPlistName = @"expressionImage_custom";
        [_commentLabel setFrame:messageFrameModel.commentLabelF];
        [_commentLabel setText:messageDataM.msg];

    }else{
        [_commentLabel setHidden:YES];
        [_zanfeedImage setHidden:NO];
        
        [_zanfeedImage setFrame:messageFrameModel.zanfeedImageF];
        
        if ([messageDataM.type isEqualToString:@"feedZan"]){
            [_zanfeedImage setImage:[UIImage imageNamed:@"good_small"]];
            
        }else if ([messageDataM.type isEqualToString:@"feedForward"]){
            [_zanfeedImage setImage:[UIImage imageNamed:@"repost_small"]];
        }
        [_zanfeedImage sizeToFit];
    }
    [_timeLabel setText:[self created:messageDataM.created]];
    [_timeLabel setFrame:messageFrameModel.timeLabelF];

    [_photImage setFrame:messageFrameModel.photImageF];
    if (messageDataM.feedpic.length) {
        [_trendsLabel setHidden:YES];
        [_photImage sd_setImageWithURL:[NSURL URLWithString:messageDataM.feedpic] placeholderImage:[UIImage resizedImage:@"repost_bg"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    }else if(messageDataM.feedcontent.length){
        [_trendsLabel setHidden:NO];
        [_photImage setImage:[UIImage resizedImage:@"repost_bg"]];
        _trendsLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _trendsLabel.customEmojiPlistName = @"expressionImage_custom";
        [_trendsLabel setFrame:messageFrameModel.trendsLabelF];
        [_trendsLabel setText:messageDataM.feedcontent];
        [_trendsLabel sizeToFit];
        if (_trendsLabel.frame.size.height>messageFrameModel.trendsLabelF.size.height) {
            [_trendsLabel setFrame:messageFrameModel.trendsLabelF];
        }
    }
   
}


- (NSString *)created:(NSString *)time
{
    // 1.获得微博的发送时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *send = [fmt dateFromString:time];
    
    // 2.当前时间
    NSDate *now = [NSDate date];
    
    // 3.获得当前时间和发送时间 的 间隔  (now - send)
    NSString *timeStr = nil;
    NSTimeInterval delta = [now timeIntervalSinceDate:send];
    if (delta < 60) { // 一分钟内
        timeStr = @"刚刚";
    } else if (delta < 60 * 60) { // 一个小时内
        timeStr = [NSString stringWithFormat:@"%.f分钟前", delta/60];
    } else if (delta < 60 * 60 * 24) { // 一天内
        timeStr = [NSString stringWithFormat:@"%.f小时前", delta/60/60];
    } else { // 几天前
        fmt.dateFormat = @"MM-dd";
        timeStr = [fmt stringFromDate:send];
    }
    return timeStr;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
