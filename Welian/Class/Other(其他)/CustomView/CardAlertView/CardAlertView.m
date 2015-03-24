//
//  CardAlertView.m
//  Welian
//
//  Created by weLian on 15/3/20.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "CardAlertView.h"
#import "WLCellCardView.h"
#import "WLMessageTextView.h"

#define kContentViewHeight 180.f
#define kCardViewHeight 56.f
#define kMarginLeft 15.f

@interface CardAlertView ()<UIGestureRecognizerDelegate>

@property (strong,nonatomic) CardStatuModel *cardModel;
@property (assign,nonatomic) UIImageView *bgImageView;
@property (assign,nonatomic) UIView *contentView;
@property (assign,nonatomic) WLCellCardView *cardView;
@property (assign,nonatomic) WLMessageTextView *textView;
@property (assign,nonatomic) UIButton *cancelBtn;
@property (assign,nonatomic) UIButton *sendBtn;
@property (assign,nonatomic) MyFriendUser *selectFriendUser;

@end

@implementation CardAlertView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCardModel:(CardStatuModel *)cardModel Friend:(MyFriendUser *)friendUser
{
    self = [super init];
    if (self) {
        self.cardModel = cardModel;
        self.selectFriendUser = friendUser;
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _bgImageView.frame = self.bounds;
    
    _contentView.size = CGSizeMake(_bgImageView.width - 40.f, kContentViewHeight);
    _contentView.centerX = _bgImageView.width / 2.f;
    _contentView.centerY = _bgImageView.height / 2.f;
    
    _cardView.size = CGSizeMake(_contentView.width - kMarginLeft * 2.f, kCardViewHeight);
    _cardView.top = kMarginLeft;
    _cardView.centerX = _contentView.width / 2.f;
    
    _textView.size = CGSizeMake(_cardView.width , 35.f);
    _textView.top = _cardView.bottom + kMarginLeft;
    _textView.centerX = _contentView.width / 2.f;
    
    _cancelBtn.size = CGSizeMake(_contentView.width / 2.f, _contentView.height - _textView.bottom - kMarginLeft);
    _cancelBtn.left = 0.f;
    _cancelBtn.bottom = _contentView.height;
    
    _sendBtn.size = _cancelBtn.size;
    _sendBtn.left = _cancelBtn.right;
    _sendBtn.bottom = _cancelBtn.bottom;
    
    _cancelBtn.layer.borderColorFromUIColor = RGB(184.f, 185.f, 186.f);
    _cancelBtn.layer.borderWidths = @"{0.5,0.5,0,0}";
    _cancelBtn.layer.masksToBounds = YES;
    _sendBtn.layer.borderColorFromUIColor = RGB(184.f, 185.f, 186.f);
    _sendBtn.layer.borderWidths = @"{0.5,0,0,0}";
    _sendBtn.layer.masksToBounds = YES;
}

#pragma mark - Private
- (void)setup
{
    self.frame = [[UIScreen mainScreen] bounds];
    
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.backgroundColor = [UIColor blackColor];
    [self addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    //内容
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = RGB(239.f, 239.f, 239.f);
    contentView.layer.cornerRadius = 5.f;
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    self.contentView = contentView;
    
    ///卡片
    WLCellCardView *cardView = [[WLCellCardView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.cardM = _cardModel;
    [contentView addSubview:cardView];
    self.cardView = cardView;
    
    //文本输入框
    // 初始化输入框
    WLMessageTextView *textView = [[WLMessageTextView  alloc] initWithFrame:CGRectZero];
    textView.returnKeyType = UIReturnKeySend;
    textView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    textView.layer.borderColor = WLRGB(220, 220, 220).CGColor;
    textView.layer.borderWidth = 0.4f;
    textView.layer.cornerRadius = 5.f;
    textView.layer.masksToBounds = YES;
    textView.textColor = kTitleNormalTextColor;
    textView.placeHolder = @"给朋友留言";
//    textView.delegate = self;
    
    [contentView addSubview:textView];
    self.textView = textView;
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:KBlueTextColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    
    //发送按钮
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:KBlueTextColor forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sendBtn];
    self.sendBtn = sendBtn;
    
    //添加单击手势
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [[self findFirstResponder] resignFirstResponder];
    }];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    //添加键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//取消按钮
- (void)cancelBtnClicked:(UIButton *)sender
{
    [self dismiss];
}

//发送按钮
- (void)sendBtnClicked:(UIButton *)sender
{
    [self sendCardMessageToFriend];
}

//发送卡片消息给好友
- (void)sendCardMessageToFriend
{
    _cardModel.content = _textView.text;
    NSDictionary *cardDic = [_cardModel keyValues];
    NSDictionary *param = @{@"type":@(51),@"touser":_selectFriendUser.uid,@"card":cardDic,@"msg":_cardModel.content};
    [WLHttpTool sendMessageParameterDic:param success:^(id JSON) {
        //返回的是字典
        NSString *state = JSON[@"state"];
        NSString *time = JSON[@"created"];
        if ([state intValue] == -1) {
            //更新发送状态为失败
            [WLHUDView showErrorHUD:@"发送失败！"];
        }else{
            //创建数据库对象
            ChatMessage *chatMessage = [ChatMessage createChatMessageWithCard:_cardModel FriendUser:_selectFriendUser];
            //更新发送时间
            if (time) {
                [chatMessage updateTimeStampFromServer:time];
            }
            
            if (_sendSuccessBlock) {
                [self dismiss];
                _sendSuccessBlock();
            }
        }
    } fail:^(NSError *error) {
        //更新发送状态为失败
        [WLHUDView showErrorHUD:@"发送失败！"];
    }];
}

//显示
- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [self fadeIn];
}

- (void)dismiss
{
    [[self findFirstResponder] resignFirstResponder];
    [self fadeOut];
}

#pragma mark - KeyboardNoti
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.3 animations:^(void) {
        _contentView.bottom = self.height - kbSize.height - 2.f;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^(void) {
        _contentView.centerY = self.height / 2.f;
    }];
}

#pragma mark - Show Animations
- (void)fadeIn
{
    _bgImageView.alpha = .0f;
    _contentView.alpha = .0f;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _bgImageView.alpha = 0.4f;
                         _contentView.alpha = 1;
                     }
                     completion:nil];
}

#pragma mark - Hide Animations
- (void)fadeOut
{
    [UIView animateWithDuration:0.3f animations:^{
        _bgImageView.alpha = 0.0f;
        _contentView.alpha = 0.0f;
    } completion:^(BOOL completed) {
        [self.bgImageView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end
