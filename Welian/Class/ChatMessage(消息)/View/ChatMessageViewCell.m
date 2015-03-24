//
//  ChatMessageViewCell.m
//  Welian
//
//  Created by weLian on 14/12/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "ChatMessageViewCell.h"
#import "ChatMessage.h"

#define kLogoImageWidth 40.f
#define kMarginLeft 15.f
#define kBadgeHeight 17.f
#define kBadge2Width 24.f

@interface ChatMessageViewCell ()

@property (assign,nonatomic) UIImageView *logoImageView;
@property (assign, nonatomic) UIImageView *iconImageView;
@property (assign,nonatomic) UIButton *numBtn;
@property (assign,nonatomic) UILabel *nickNameLabel;
@property (assign,nonatomic) UILabel *timeLabel;
@property (assign,nonatomic) UIImageView *messageSendTypeImageView;
@property (assign,nonatomic) UILabel *messageLabel;

- (void)setup;

@end

@implementation ChatMessageViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMyFriendUser:(MyFriendUser *)myFriendUser
{
    [super willChangeValueForKey:@"myFriendUser"];
    _myFriendUser = myFriendUser;
    [super didChangeValueForKey:@"myFriendUser"];
    //设置头像
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_myFriendUser.avatar] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    
    //是否是认证投资人
    _iconImageView.hidden = _myFriendUser.investorauth.integerValue == 1 ? NO : YES;
    
    _nickNameLabel.text = _myFriendUser.name;
    
    //未读取消息数量
    NSInteger unRead = _myFriendUser.unReadChatMsg.integerValue;
    //是否隐藏
    _numBtn.hidden = unRead <= 0 ? YES : NO;
    if (unRead < 100) {
        [_numBtn setTitle:[NSString stringWithFormat:@"%d",(int)unRead] forState:UIControlStateNormal];
        [_numBtn setBackgroundImage:[UIImage imageNamed:@"notification_badge1"] forState:UIControlStateNormal];
    }else{
        [_numBtn setTitle:@"99+" forState:UIControlStateNormal];
        [_numBtn setBackgroundImage:[UIImage imageNamed:@"notification_badge2"] forState:UIControlStateNormal];
    }
    
    ChatMessage *chatMessage = [_myFriendUser getTheNewChatMessage];
    _timeLabel.text = [chatMessage.timestamp timeAgoSinceNow];
    
    //消息状态
    NSString *typeName = @"";
    if (chatMessage.sendStatus.intValue == 0) {
        typeName = @"circle_chatlist_sending";
        _messageSendTypeImageView.image = [UIImage imageNamed:typeName];
        _messageSendTypeImageView.hidden = NO;
    }else if (chatMessage.sendStatus.intValue == 2){
        typeName = @"circle_chatlist_sendfailed";
        _messageSendTypeImageView.hidden = NO;
        _messageSendTypeImageView.image = [UIImage imageNamed:typeName];
    }else{
        _messageSendTypeImageView.hidden = YES;
        _messageSendTypeImageView.image = nil;
    }
    
    //消息内容
    _messageLabel.text = [chatMessage displayChatListMessageInfo];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置下边边线
    self.layer.borderColor = RGB(230, 230, 230).CGColor;
    self.layer.borderWidths = @"{0,0,0.5,0}";
    
    //设置头像
    _logoImageView.size = CGSizeMake(kLogoImageWidth, kLogoImageWidth);
    _logoImageView.left = kMarginLeft;
    _logoImageView.centerY = self.height / 2.f;
    
    [_iconImageView sizeToFit];
    _iconImageView.bottom = _logoImageView.bottom;
    _iconImageView.right = _logoImageView.right;
    
    //消息数量
    _numBtn.size = CGSizeMake([_myFriendUser unReadChatMessageNum] < 100 ? kBadgeHeight : kBadge2Width, kBadgeHeight);
    _numBtn.top = _logoImageView.top - 1;
    _numBtn.right = _logoImageView.right + 3;
    
    //时间
    [_timeLabel sizeToFit];
    _timeLabel.top = _logoImageView.top;
    _timeLabel.right = self.width - kMarginLeft;
    
    //昵称
    [_nickNameLabel sizeToFit];
    _nickNameLabel.width = _timeLabel.left - _logoImageView.right - kMarginLeft * 2;
    _nickNameLabel.left = _logoImageView.right + kMarginLeft;
    _nickNameLabel.top = _logoImageView.top;
    
    //消息发送状态
    [_messageSendTypeImageView sizeToFit];
    _messageSendTypeImageView.left = _nickNameLabel.left;
    _messageSendTypeImageView.top = _nickNameLabel.bottom + 5.f;
    
    //消息
    [_messageLabel sizeToFit];
    _messageLabel.width = self.width - kMarginLeft * 2.f - _messageSendTypeImageView.right;
    _messageLabel.left = _messageSendTypeImageView.hidden == NO ? _messageSendTypeImageView.right + 3 : _messageSendTypeImageView.right;
    if(_messageSendTypeImageView.hidden == NO){
        _messageLabel.centerY = _messageSendTypeImageView.centerY;
    }else{
        _messageLabel.top = _nickNameLabel.bottom + 5.f;
    }
    
}

#pragma mark - Private
- (void)setup
{
    //头像
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.backgroundColor = [UIColor clearColor];
    logoImageView.layer.cornerRadius = 20;
    logoImageView.layer.masksToBounds = YES;
    [self addSubview:logoImageView];
    self.logoImageView = logoImageView;
//    [logoImageView setDebug:YES];
    
    [_logoImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    
    //认证透过投资人标志
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_mycard_tou_big"]];
    iconImageView.backgroundColor = [UIColor clearColor];
    iconImageView.hidden = YES;
    [self addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    //消息数量
    UIButton *numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    numBtn.backgroundColor = [UIColor clearColor];
    numBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    numBtn.titleEdgeInsets = UIEdgeInsetsMake(.0, 2, .0, .0);
//    [numBtn setTitle:@"99" forState:UIControlStateNormal];
    [numBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [numBtn setBackgroundImage:[UIImage imageNamed:@"notification_badge1"] forState:UIControlStateNormal];
    [self addSubview:numBtn];
    self.numBtn = numBtn;
    
    //昵称
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.backgroundColor = [UIColor clearColor];
    nickNameLabel.textColor = RGB(51.f, 51.f, 51.f);
    nickNameLabel.font = [UIFont systemFontOfSize:16.f];
    nickNameLabel.text = @"";
    [self addSubview:nickNameLabel];
    self.nickNameLabel = nickNameLabel;
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = RGB(173.f, 173.f, 173.f);
    timeLabel.font = [UIFont systemFontOfSize:12.f];
    timeLabel.text = @"";
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    //消息发送状态
    UIImageView *messageSendTypeImageView = [[UIImageView alloc] init];
    messageSendTypeImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:messageSendTypeImageView];
    self.messageSendTypeImageView = messageSendTypeImageView;
    
    //消息
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = RGB(173.f, 173.f, 173.f);
    messageLabel.font = [UIFont systemFontOfSize:14.f];
    messageLabel.text = @"";
    [self addSubview:messageLabel];
    self.messageLabel = messageLabel;
}

@end
