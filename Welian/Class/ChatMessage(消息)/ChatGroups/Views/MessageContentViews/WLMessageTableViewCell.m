//
//  WLMessageTableViewCell.m
//  Welian
//
//  Created by weLian on 14/12/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLMessageTableViewCell.h"

static const CGFloat kWLLabelPadding = 5.0f;
static const CGFloat kWLTimeStampLabelHeight = 20.0f;

static const CGFloat kWLAvatorPaddingX = 9.0;
static const CGFloat kWLAvatorPaddingY = 15;
static const CGFloat kWLAvatorPaddingBubble = 6.0;

static const CGFloat kWLBubbleMessageViewPadding = 8;

@interface WLMessageTableViewCell ()

@property (nonatomic, weak, readwrite) WLMessageBubbleView *messageBubbleView;

@property (nonatomic, weak, readwrite) UIButton *avatorButton;

@property (nonatomic, weak, readwrite) UILabel *userNameLabel;

@property (nonatomic, weak, readwrite) LKBadgeView *timestampLabel;

/**
 *  是否显示时间轴Label
 */
@property (nonatomic, assign) BOOL displayTimestamp;

/**
 *  1、是否显示Time Line的label
 *
 *  @param message 需要配置的目标消息Model
 */
- (void)configureTimestamp:(BOOL)displayTimestamp atMessage:(id <WLMessageModel>)message;

/**
 *  2、配置头像
 *
 *  @param message 需要配置的目标消息Model
 */
- (void)configAvatorWithMessage:(id <WLMessageModel>)message;

/**
 *  3、配置需要显示什么消息内容，比如语音、文字、视频、图片
 *
 *  @param message 需要配置的目标消息Model
 */
- (void)configureMessageBubbleViewWithMessage:(id <WLMessageModel>)message;

/**
 *  头像按钮，点击事件
 *
 *  @param sender 头像按钮对象
 */
- (void)avatorButtonClicked:(UIButton *)sender;

/**
 *  统一一个方法隐藏MenuController，多处需要调用
 */
- (void)setupNormalMenuController;

/**
 *  点击Cell的手势处理方法，用于隐藏MenuController的
 *
 *  @param tapGestureRecognizer 点击手势对象
 */
- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer;

/**
 *  长按Cell的手势处理方法，用于显示MenuController的
 *
 *  @param longPressGestureRecognizer 长按手势对象
 */
- (void)longPressGestureRecognizerHandle:(UILongPressGestureRecognizer *)longPressGestureRecognizer;

/**
 *  单击手势处理方法，用于点击多媒体消息触发方法，比如点击语音需要播放的回调、点击图片需要查看大图的回调
 *
 *  @param tapGestureRecognizer 点击手势对象
 */
- (void)sigleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer;

/**
 *  双击手势处理方法，用于双击文本消息，进行放大文本的回调
 *
 *  @param tapGestureRecognizer 双击手势对象
 */
- (void)doubleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer;

@end

@implementation WLMessageTableViewCell

#pragma mark - TableViewCell
- (void)dealloc {
    _avatorButton = nil;
    _timestampLabel = nil;
    _messageBubbleView = nil;
    _indexPath = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForReuse {
    // 这里做清除工作
    [super prepareForReuse];
    self.messageBubbleView.animationVoiceImageView.image = nil;
    self.messageBubbleView.displayTextView.text = nil;
    self.messageBubbleView.displayTextView.attributedText = nil;
    self.messageBubbleView.bubblePhotoImageView.messagePhoto = nil;
    self.messageBubbleView.emotionImageView.animatedImage = nil;
    self.timestampLabel.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    CGFloat layoutOriginY = kWLAvatorPaddingY + (self.displayTimestamp ? kWLTimeStampLabelHeight : 0);
    CGFloat layoutOriginY = (self.displayTimestamp ? kWLTimeStampLabelHeight : 0) + kWLBubbleMessageViewPadding;
    CGRect avatorButtonFrame = self.avatorButton.frame;
    avatorButtonFrame.origin.y = layoutOriginY;
    avatorButtonFrame.origin.x = ([self bubbleMessageType] == WLBubbleMessageTypeReceiving) ? kWLAvatorPaddingX : ((CGRectGetWidth(self.bounds) - kWLAvatorPaddingX - kWLAvatarImageSize));
    
//    layoutOriginY = kWLBubbleMessageViewPadding + (self.displayTimestamp ? kWLTimeStampLabelHeight : 0);
    layoutOriginY = self.displayTimestamp ? kWLTimeStampLabelHeight + kWLLabelPadding : 0;
    CGRect bubbleMessageViewFrame = self.messageBubbleView.frame;
    bubbleMessageViewFrame.origin.y = layoutOriginY;
    
    CGFloat bubbleX = 0.0f;
    if ([self bubbleMessageType] == WLBubbleMessageTypeReceiving)
        bubbleX = kWLAvatarImageSize + kWLAvatorPaddingX + kWLAvatorPaddingBubble;
    bubbleMessageViewFrame.origin.x = bubbleX;
    
    self.avatorButton.frame = avatorButtonFrame;
    
//    self.userNameLabel.center = CGPointMake(CGRectGetMidX(avatorButtonFrame), CGRectGetMaxY(avatorButtonFrame) + CGRectGetMidY(self.userNameLabel.bounds));
    
    self.messageBubbleView.frame = bubbleMessageViewFrame;
}

- (instancetype)initWithMessage:(id <WLMessageModel>)message
              displaysTimestamp:(BOOL)displayTimestamp
                reuseIdentifier:(NSString *)cellIdentifier {
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if (self) {
        // 如果初始化成功，那就根据Message类型进行初始化控件，比如配置头像，配置发送和接收的样式
        
        // 1、是否显示Time Line的label
        if (!_timestampLabel) {
            LKBadgeView *timestampLabel = [[LKBadgeView alloc] initWithFrame:CGRectMake(0, kWLLabelPadding, 160, kWLTimeStampLabelHeight)];
            timestampLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
            timestampLabel.badgeColor = RGB(212.f, 214.f, 216.f);//[UIColor colorWithWhite:0.000 alpha:0.380];
            timestampLabel.textColor = [UIColor whiteColor];
            timestampLabel.font = [UIFont systemFontOfSize:13.0f];
            timestampLabel.center = CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) / 2.0, timestampLabel.center.y);
            [self.contentView addSubview:timestampLabel];
            [self.contentView bringSubviewToFront:timestampLabel];
            _timestampLabel = timestampLabel;
//            [timestampLabel setDebug:YES];
        }
        
        // 2、配置头像
        // avator
        CGRect avatorButtonFrame;
        switch (message.bubbleMessageType) {
            case WLBubbleMessageTypeReceiving:
                avatorButtonFrame = CGRectMake(kWLAvatorPaddingX, kWLAvatorPaddingY + (self.displayTimestamp ? kWLTimeStampLabelHeight : 0), kWLAvatarImageSize, kWLAvatarImageSize);
                break;
            case WLBubbleMessageTypeSending:
                avatorButtonFrame = CGRectMake(CGRectGetWidth(self.bounds) - kWLAvatarImageSize - kWLAvatorPaddingX, kWLAvatorPaddingY + (self.displayTimestamp ? kWLTimeStampLabelHeight : 0), kWLAvatarImageSize, kWLAvatarImageSize);
                break;
            default:
                break;
        }
        
        UIButton *avatorButton = [[UIButton alloc] initWithFrame:avatorButtonFrame];
        [avatorButton setImage:[WLMessageAvatorFactory avatarImageNamed:[UIImage imageNamed:@"avator"] messageAvatorType:WLMessageAvatorTypeCircle] forState:UIControlStateNormal];
        [avatorButton addTarget:self action:@selector(avatorButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:avatorButton];
        self.avatorButton = avatorButton;
        
        // 3、配置用户名
//        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.avatorButton.bounds) + 20, 20)];
//        userNameLabel.textAlignment = NSTextAlignmentCenter;
//        userNameLabel.backgroundColor = [UIColor clearColor];
//        userNameLabel.font = [UIFont systemFontOfSize:12];
//        userNameLabel.textColor = [UIColor colorWithRed:0.140 green:0.635 blue:0.969 alpha:1.000];
//        [self.contentView addSubview:userNameLabel];
//        self.userNameLabel = userNameLabel;
//        [userNameLabel setDebug:YES];
        
        // 4、配置需要显示什么消息内容，比如语音、文字、视频、图片
        if (!_messageBubbleView) {
            CGFloat bubbleX = 0.0f;
            
            CGFloat offsetX = 0.0f;
            
            if (message.bubbleMessageType == WLBubbleMessageTypeReceiving)
                bubbleX = kWLAvatarImageSize + kWLAvatorPaddingX + kWLAvatorPaddingBubble;
            else
                offsetX = kWLAvatarImageSize + kWLAvatorPaddingX + kWLAvatorPaddingBubble;
            
            CGRect frame = CGRectMake(bubbleX,
                                      kWLBubbleMessageViewPadding + (self.displayTimestamp ? (kWLTimeStampLabelHeight + kWLLabelPadding) : kWLLabelPadding),
                                      self.contentView.frame.size.width - bubbleX - offsetX,
                                      self.contentView.frame.size.height - (kWLBubbleMessageViewPadding + (self.displayTimestamp ? (kWLTimeStampLabelHeight + kWLLabelPadding) : kWLLabelPadding)));
            
            // bubble container
            WLMessageBubbleView *messageBubbleView = [[WLMessageBubbleView alloc] initWithFrame:frame message:message];
            messageBubbleView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                                  | UIViewAutoresizingFlexibleHeight
                                                  | UIViewAutoresizingFlexibleBottomMargin);
            [self.contentView addSubview:messageBubbleView];
            [self.contentView sendSubviewToBack:messageBubbleView];
            self.messageBubbleView = messageBubbleView;
//            [messageBubbleView setDebug:YES];
        }
    }
    return self;
}

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
    [self setup];
}

- (void)setup {
//    [self setDebug:YES];
    self.backgroundColor = [UIColor clearColor];
    //选中效果
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerHandle:)];
    [recognizer setMinimumPressDuration:0.4f];
    [self addGestureRecognizer:recognizer];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerHandle:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

// 头像按钮，点击事件
- (void)avatorButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectedAvatorOnMessage:atIndexPath:)]) {
        [self.delegate didSelectedAvatorOnMessage:self.messageBubbleView.message atIndexPath:self.indexPath];
    }
}

#pragma mark - Setterss
- (void)configureCellWithMessage:(id <WLMessageModel>)message
               displaysTimestamp:(BOOL)displayTimestamp {
    // 1、是否显示Time Line的label
    [self configureTimestamp:displayTimestamp atMessage:message];
    
    // 2、配置头像
    [self configAvatorWithMessage:message];
    
    // 3、配置用户名
    [self configUserNameWithMessage:message];
    
    // 4、配置需要显示什么消息内容，比如语音、文字、视频、图片
    [self configureMessageBubbleViewWithMessage:message];
}

- (void)configureTimestamp:(BOOL)displayTimestamp atMessage:(id <WLMessageModel>)message {
    self.displayTimestamp = displayTimestamp;
    self.timestampLabel.hidden = !self.displayTimestamp;
    if (displayTimestamp) {
        self.timestampLabel.text = [[message timestamp] timeAgoSinceNow];// [NSDateFormatter localizedStringFromDate:message.timestamp
//                                                                  dateStyle:NSDateFormatterMediumStyle
//                                                                  timeStyle:NSDateFormatterShortStyle];
    }
}

- (void)configAvatorWithMessage:(id <WLMessageModel>)message {
    if (message.avator) {
        [self.avatorButton setImage:message.avator forState:UIControlStateNormal];
        if (message.avatorUrl) {
            self.avatorButton.messageAvatorType = WLMessageAvatorTypeCircle;
            [self.avatorButton setImageWithURL:[NSURL URLWithString:message.avatorUrl] placeholer:[UIImage imageNamed:@"avator"]];
        }
    } else {
        [self.avatorButton setImage:[WLMessageAvatorFactory avatarImageNamed:[UIImage imageNamed:@"avator"] messageAvatorType:WLMessageAvatorTypeCircle] forState:UIControlStateNormal];
    }
}

- (void)configUserNameWithMessage:(id <WLMessageModel>)message {
    self.userNameLabel.text = [message sender];
}

- (void)configureMessageBubbleViewWithMessage:(id <WLMessageModel>)message {
    WLBubbleMessageMediaType currentMediaType = message.messageMediaType;
    for (UIGestureRecognizer *gesTureRecognizer in self.messageBubbleView.bubbleImageView.gestureRecognizers) {
        [self.messageBubbleView.bubbleImageView removeGestureRecognizer:gesTureRecognizer];
    }
    for (UIGestureRecognizer *gesTureRecognizer in self.messageBubbleView.bubblePhotoImageView.gestureRecognizers) {
        [self.messageBubbleView.bubblePhotoImageView removeGestureRecognizer:gesTureRecognizer];
    }
    switch (currentMediaType) {
        case WLBubbleMessageMediaTypePhoto:
        case WLBubbleMessageMediaTypeVideo:
        case WLBubbleMessageMediaTypeLocalPosition: {
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapGestureRecognizerHandle:)];
            [self.messageBubbleView.bubblePhotoImageView addGestureRecognizer:tapGestureRecognizer];
            break;
        }
        case WLBubbleMessageMediaTypeText:
        case WLBubbleMessageMediaTypeVoice: {
            self.messageBubbleView.voiceDurationLabel.text = [NSString stringWithFormat:@"%@\'\'", message.voiceDuration];
            //            break;
        }
        case WLBubbleMessageMediaTypeEmotion: {
            UITapGestureRecognizer *tapGestureRecognizer;
            if (currentMediaType == WLBubbleMessageMediaTypeText) {
                tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizerHandle:)];
            } else {
                tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapGestureRecognizerHandle:)];
            }
            tapGestureRecognizer.numberOfTapsRequired = (currentMediaType == WLBubbleMessageMediaTypeText ? 2 : 1);
            [self.messageBubbleView.bubbleImageView addGestureRecognizer:tapGestureRecognizer];
            break;
        }
        default:
            break;
    }
    [self.messageBubbleView configureCellWithMessage:message];
}

#pragma mark - Gestures
- (void)setupNormalMenuController {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
}

- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self updateMenuControllerVisiable];
}

- (void)updateMenuControllerVisiable {
    [self setupNormalMenuController];
}

- (void)longPressGestureRecognizerHandle:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (longPressGestureRecognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
        return;
    
    UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"copy", @"MessageDisplayKitString", @"复制文本消息") action:@selector(copyed:)];
    UIMenuItem *transpond = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"transpond", @"MessageDisplayKitString", @"转发") action:@selector(transpond:)];
    UIMenuItem *favorites = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"favorites", @"MessageDisplayKitString", @"收藏") action:@selector(favorites:)];
    UIMenuItem *more = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"more", @"MessageDisplayKitString", @"更多") action:@selector(more:)];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:[NSArray arrayWithObjects:copy, transpond, favorites, more, nil]];
    
    
    CGRect targetRect = [self convertRect:[self.messageBubbleView bubbleFrame]
                                 fromView:self.messageBubbleView];
    
    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

- (void)sigleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self setupNormalMenuController];
        if ([self.delegate respondsToSelector:@selector(multiMediaMessageDidSelectedOnMessage:atIndexPath:onMessageTableViewCell:)]) {
            [self.delegate multiMediaMessageDidSelectedOnMessage:self.messageBubbleView.message atIndexPath:self.indexPath onMessageTableViewCell:self];
        }
    }
}

- (void)doubleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(didDoubleSelectedOnTextMessage:atIndexPath:)]) {
            [self.delegate didDoubleSelectedOnTextMessage:self.messageBubbleView.message atIndexPath:self.indexPath];
        }
    }
}

#pragma mark - Copying Method

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copyed:) || action == @selector(transpond:) || action == @selector(favorites:) || action == @selector(more:));
}

#pragma mark - Menu Actions

- (void)copyed:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.messageBubbleView.displayTextView.text];
    [self resignFirstResponder];
    DLog(@"Cell was copy");
}

- (void)transpond:(id)sender {
    DLog(@"Cell was transpond");
}

- (void)favorites:(id)sender {
    DLog(@"Cell was favorites");
}

- (void)more:(id)sender {
    DLog(@"Cell was more");
}

#pragma mark - Notifications
- (void)handleMenuWillHideNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

#pragma mark - Getters
- (WLBubbleMessageType)bubbleMessageType {
    return self.messageBubbleView.message.bubbleMessageType;
}

+ (CGFloat)calculateCellHeightWithMessage:(id <WLMessageModel>)message
                        displaysTimestamp:(BOOL)displayTimestamp {
    
    CGFloat timestampHeight = displayTimestamp ? (kWLTimeStampLabelHeight + kWLLabelPadding * 2) : 0;//kWLLabelPadding;
    CGFloat avatarHeight = kWLAvatarImageSize;
    
    //隐藏用户名
//    CGFloat userNameHeight = 20;
    
//    CGFloat subviewHeights = timestampHeight + kWLBubbleMessageViewPadding * 2 + userNameHeight;
    CGFloat subviewHeights = timestampHeight + kWLBubbleMessageViewPadding * 2 ;//+ userNameHeight;
    
    CGFloat bubbleHeight = [WLMessageBubbleView calculateCellHeightWithMessage:message];
    
    return subviewHeights + MAX(avatarHeight, bubbleHeight);
}

@end
