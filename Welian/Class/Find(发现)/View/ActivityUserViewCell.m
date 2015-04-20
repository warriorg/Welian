//
//  ActivityUserViewCell.m
//  Welian
//
//  Created by weLian on 15/1/20.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityUserViewCell.h"

#define kLogoWidth 40.f
#define kMarginLeft 15.f
#define kMarginTop 10.f
#define kButtonWidth 50.f
#define kButtonHeight 30.f

#define BtnTianJiaColor RGB(247.f, 247.f, 247.f)
#define BtnJieShouColor RGB(79.f, 191.f, 232.f)
#define LayerBorderColor RGB(231.f, 231.f, 231.f)

@interface ActivityUserViewCell ()

@property (assign, nonatomic) UIImageView *logoImageView;
@property (assign, nonatomic) UILabel *nameLabel;
@property (assign, nonatomic) UILabel *messageLabel;
@property (assign, nonatomic) UIButton *operateBtn;
@property (assign, nonatomic) UIImageView *iconImageView;
@property (assign, nonatomic) UIButton *wxBtn;//微信用户标记

@end

@implementation ActivityUserViewCell

- (void)dealloc
{
    _addFriendBlock = nil;
    _indexPath = nil;
    _activityUserData = nil;
    _baseUser = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setBaseUser:(IBaseUserM *)baseUser
{
    [super willChangeValueForKey:@"baseUser"];
    _baseUser = baseUser;
    [super didChangeValueForKey:@"baseUser"];
    
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_baseUser.avatar]
                      placeholderImage:[UIImage imageNamed:@"user_small"]
                               options:SDWebImageRetryFailed|SDWebImageLowPriority];
    _nameLabel.text = _baseUser.name;
    
    NSString *company = _baseUser.company.length < 1 ? @"" : _baseUser.company;
    NSString *position = _baseUser.position.length < 1 ? @"" : _baseUser.position;
    _messageLabel.text = [NSString stringWithFormat:@"%@%@",position,(position.length > 0 ? [NSString stringWithFormat:@" %@",company] : company)];
    _messageLabel.numberOfLines = 1;
    
    //是否是认证投资人 /**  投资者认证  0 默认状态  1  认证成功  -2 正在审核  -1 认证失败 */
    _iconImageView.hidden = [_activityUserData[@"investorauth"] integerValue] == 1 ? NO : YES;
   
    if (_baseUser.uid == nil) {
        //微信用户
        _wxBtn.hidden = NO;
        _operateBtn.hidden = YES;
        [_wxBtn setTitle:@"微信用户" forState:UIControlStateNormal];
        [_wxBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
        [_wxBtn setTitle:@"微链好友" forState:UIControlStateNormal];
        [_wxBtn setTitleColor:RGB(72.f, 130.f, 193.f) forState:UIControlStateNormal];
        _wxBtn.hidden = _baseUser.friendship.integerValue == 1 ? NO : YES;
        _operateBtn.hidden = _baseUser.friendship.integerValue != 1 ? NO : YES;
    }
    //等待验证
    if(_baseUser.friendship.integerValue == 4){
        _operateBtn.titleLabel.font = kNormal16Font;
        [_operateBtn setImage:nil forState:UIControlStateNormal];
        [_operateBtn setTitle:@"待验证" forState:UIControlStateNormal];
        [_operateBtn setTitleColor:RGB(72.f, 130.f, 193.f) forState:UIControlStateNormal];
        _operateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _operateBtn.layer.borderWidth = 0;
    }else{
        if (_baseUser.friendship.integerValue == -1) {
            _operateBtn.hidden = YES;
        }else{
            _operateBtn.titleLabel.font = kNormal13Font;
            [_operateBtn addTarget:self action:@selector(operateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_operateBtn setImage:[UIImage imageNamed:@"osusume_friend_add"] forState:UIControlStateNormal];
            [_operateBtn setTitle:@"添加" forState:UIControlStateNormal];
            [_operateBtn setTitleColor:RGB(72.f, 130.f, 193.f) forState:UIControlStateNormal];
            _operateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
            _operateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
            _operateBtn.layer.borderColor = RGB(72.f, 130.f, 193.f).CGColor;
            _operateBtn.layer.borderWidth = 1.f;
            _operateBtn.layer.cornerRadius = 5.f;
            _operateBtn.layer.masksToBounds = YES;
        }
    }
}

- (void)setHidOperateBtn:(BOOL)hidOperateBtn
{
    [super willChangeValueForKey:@"hidOperateBtn"];
    _hidOperateBtn = hidOperateBtn;
    [super didChangeValueForKey:@"hidOperateBtn"];
    
    //判断是否隐藏操作按钮
    _operateBtn.hidden = _hidOperateBtn;
}

//报名列表的字典用户
- (void)setActivityUserData:(NSDictionary *)activityUserData
{
    [super willChangeValueForKey:@"activityUserData"];
    _activityUserData = activityUserData;
    [super didChangeValueForKey:@"activityUserData"];
    
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_activityUserData[@"avatar"]]
                      placeholderImage:[UIImage imageNamed:@"user_small"]
                               options:SDWebImageRetryFailed|SDWebImageLowPriority];
    _nameLabel.text = _activityUserData[@"name"];
    
    NSString *company = _activityUserData[@"company"] == nil ? @"" : _activityUserData[@"company"];
    NSString *position = _activityUserData[@"position"] == nil ? @"" : _activityUserData[@"position"];
    _messageLabel.text = [NSString stringWithFormat:@"%@%@",position,(position.length > 0 ? [NSString stringWithFormat:@" %@",company] : company)];
    _messageLabel.numberOfLines = 1;
    
    //是否是认证投资人 /**  投资者认证  0 默认状态  1  认证成功  -2 正在审核  -1 认证失败 */
    _iconImageView.hidden = [_activityUserData[@"investorauth"] integerValue] == 1 ? NO : YES;
    NSString *uid = _activityUserData[@"uid"];
    //friendship /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
    NSString *friendship = _activityUserData[@"friendship"];
    if (uid == nil) {
        //微信用户
        _wxBtn.hidden = NO;
        _operateBtn.hidden = YES;
        [_wxBtn setTitle:@"微信用户" forState:UIControlStateNormal];
        [_wxBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        [_wxBtn setTitle:@"微链好友" forState:UIControlStateNormal];
        [_wxBtn setTitleColor:RGB(72.f, 130.f, 193.f) forState:UIControlStateNormal];
        _wxBtn.hidden = friendship.integerValue == 1 ? NO : YES;
        _operateBtn.hidden = friendship.integerValue != 1 ? NO : YES;
    }
    //等待验证
    if(friendship.integerValue == 4){
        _operateBtn.titleLabel.font = kNormal16Font;
        [_operateBtn setImage:nil forState:UIControlStateNormal];
        [_operateBtn setTitle:@"待验证" forState:UIControlStateNormal];
        [_operateBtn setTitleColor:RGB(72.f, 130.f, 193.f) forState:UIControlStateNormal];
        _operateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _operateBtn.layer.borderWidth = 0;
    }else{
        if (friendship.integerValue == -1) {
            _operateBtn.hidden = YES;
        }else{
            _operateBtn.titleLabel.font = kNormal13Font;
            [_operateBtn addTarget:self action:@selector(operateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_operateBtn setImage:[UIImage imageNamed:@"osusume_friend_add"] forState:UIControlStateNormal];
            [_operateBtn setTitle:@"添加" forState:UIControlStateNormal];
            [_operateBtn setTitleColor:RGB(72.f, 130.f, 193.f) forState:UIControlStateNormal];
            _operateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
            _operateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
            _operateBtn.layer.borderColor = RGB(72.f, 130.f, 193.f).CGColor;
            _operateBtn.layer.borderWidth = 1.f;
            _operateBtn.layer.cornerRadius = 5.f;
            _operateBtn.layer.masksToBounds = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _logoImageView.size = CGSizeMake(kLogoWidth, kLogoWidth);
    _logoImageView.top = kMarginTop;
    _logoImageView.left = kMarginLeft;
    
    [_iconImageView sizeToFit];
    _iconImageView.bottom = _logoImageView.bottom;
    _iconImageView.right = _logoImageView.right;
    
    [_operateBtn sizeToFit];
    if (_operateBtn.width < kButtonWidth) {
        _operateBtn.width = kButtonWidth;
    }
    _operateBtn.height = kButtonHeight;
    _operateBtn.right = self.width - kMarginLeft;
    _operateBtn.centerY = self.height / 2.f;
    
    [_wxBtn sizeToFit];
    _wxBtn.width = _wxBtn.width + 10.f;
    _wxBtn.height = _wxBtn.height - 5.f;
    _wxBtn.centerY = self.height / 2.f;
    _wxBtn.right = self.width - kMarginLeft;
    
    [_nameLabel sizeToFit];
    _nameLabel.left = _logoImageView.right + kMarginLeft;
    if (_messageLabel.text.length == 0) {
        _nameLabel.centerY = self.height / 2.f;
    }else{
        _nameLabel.top = kMarginTop;
    }
    
    _messageLabel.width = self.width - (_wxBtn.hidden == YES ? 0 : _wxBtn.width) - (_operateBtn.hidden == YES ? 0 : _operateBtn.width) - _nameLabel.left - kMarginLeft;
    [_messageLabel sizeToFit];
    if (_messageLabel.numberOfLines == 1) {
        //固定宽度
        _messageLabel.width = self.width - (_wxBtn.hidden == YES ? 0 : _wxBtn.width) - (_operateBtn.hidden == YES ? 0 : _operateBtn.width) - _nameLabel.left - kMarginLeft;
    }
    _messageLabel.top = _nameLabel.bottom + 5.f;
    _messageLabel.left = _nameLabel.left;
}

#pragma mark - Private
- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //头像
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.backgroundColor = [UIColor clearColor];
    logoImageView.layer.cornerRadius = 20.f;
    logoImageView.layer.masksToBounds = YES;
    [self addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    //认证透过投资人标志
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_mycard_tou_big"]];
    iconImageView.backgroundColor = [UIColor clearColor];
    iconImageView.hidden = YES;
    [self addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    //名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = kNormal16Font;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //内容
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = [UIColor lightGrayColor];
    messageLabel.font = kNormal12Font;
    messageLabel.numberOfLines = 0.f;
    [self addSubview:messageLabel];
    self.messageLabel = messageLabel;
    
    //操作按钮
    UIButton *operateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:operateBtn];
    self.operateBtn = operateBtn;
    
    //微信用户标志
    UIButton *wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wxBtn.backgroundColor = RGB(248.f, 248.f, 248.f);
    wxBtn.titleLabel.font = kNormal12Font;
    wxBtn.layer.cornerRadius = 10.f;
    wxBtn.layer.masksToBounds = YES;
    wxBtn.hidden = YES;
    [self addSubview:wxBtn];
    self.wxBtn = wxBtn;
}

- (void)operateBtnClicked:(UIButton *)sender
{
    if (_addFriendBlock) {
        _addFriendBlock(_indexPath);
    }
}

@end
