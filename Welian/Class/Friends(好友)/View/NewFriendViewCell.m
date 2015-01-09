//
//  NewFriendViewCell.m
//  Welian
//
//  Created by weLian on 15/1/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "NewFriendViewCell.h"

#define kLogoWidth 40.f
#define kMarginLeft 15.f
#define kMarginTop 10.f
#define kButtonWidth 50.f
#define kButtonHeight 30.f

#define BtnTianJiaColor RGB(247.f, 247.f, 247.f)
#define BtnJieShouColor RGB(79.f, 191.f, 232.f)
#define LayerBorderColor RGB(231.f, 231.f, 231.f)

@interface NewFriendViewCell ()

@property (assign, nonatomic) UIImageView *logoImageView;
@property (assign, nonatomic) UILabel *nameLabel;
@property (assign, nonatomic) UILabel *messageLabel;
@property (assign, nonatomic) UIButton *operateBtn;
@property (assign, nonatomic) UIImageView *iconImageView;

- (void)setup;

@end

@implementation NewFriendViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    _nameLabel.text = nil;
    _messageLabel.text = nil;
    _logoImageView.image = nil;
}

- (void)dealloc
{
    _dicData = nil;
    _nFriendUser = nil;
    _newFriendBlock = nil;
    _userInfoModel = nil;
    _needAddUser = nil;
    _needAddBlock = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setUserInfoModel:(UserInfoModel *)userInfoModel
{
    [super willChangeValueForKey:@"userInfoModel"];
    _userInfoModel = userInfoModel;
    [super didChangeValueForKey:@"userInfoModel"];
    _operateBtn.hidden = YES;
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_userInfoModel.avatar]
                      placeholderImage:[UIImage imageNamed:@"user_small"]
                               options:SDWebImageRetryFailed|SDWebImageLowPriority];
    _nameLabel.text = _userInfoModel.name;
    _messageLabel.text = [NSString stringWithFormat:@"%@　%@",_userInfoModel.company,_userInfoModel.position];
    //是否是认证投资人
    _iconImageView.hidden = _userInfoModel.investorauth.integerValue == 1 ? NO : YES;
}

- (void)setDicData:(NSDictionary *)dicData
{
    [super willChangeValueForKey:@"dicData"];
    _dicData = dicData;
    [super didChangeValueForKey:@"dicData"];
    _operateBtn.hidden = YES;
    _logoImageView.image = [UIImage imageNamed:_dicData[@"logo"]];
    _nameLabel.text = _dicData[@"name"];
    _messageLabel.text = @"";
}

- (void)setNFriendUser:(NewFriendUser *)nFriendUser
{
    [super willChangeValueForKey:@"nFriendUser"];
    _nFriendUser = nFriendUser;
    [super didChangeValueForKey:@"nFriendUser"];
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_nFriendUser.avatar]
                      placeholderImage:[UIImage imageNamed:@"user_small"]
                               options:SDWebImageRetryFailed|SDWebImageLowPriority];
    _nameLabel.text = _nFriendUser.name;
    _messageLabel.text = _nFriendUser.msg;
    //是否是认证投资人
    _iconImageView.hidden = _nFriendUser.investorauth.integerValue == 1 ? NO : YES;
    
    _operateBtn.hidden = NO;
    //控制按钮显示内容，和样式
    switch (_nFriendUser.operateType.integerValue) {
        case FriendOperateTypeAdd:
            //添加
            [_operateBtn setTitle:@"添加" forState:UIControlStateNormal];
            [_operateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            //圆角
            _operateBtn.layer.cornerRadius = 5.f;
            _operateBtn.layer.masksToBounds = YES;
            _operateBtn.layer.borderWidth = 0.5;
            _operateBtn.layer.borderColor = LayerBorderColor.CGColor;
            _operateBtn.backgroundColor = BtnTianJiaColor;
            [_operateBtn addTarget:self action:@selector(operateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case FriendOperateTypeAccept:
            //接受
            [_operateBtn setTitle:@"接受" forState:UIControlStateNormal];
            [_operateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //圆角
            _operateBtn.layer.cornerRadius = 5.f;
            _operateBtn.layer.masksToBounds = YES;
            _operateBtn.backgroundColor = BtnJieShouColor;
            [_operateBtn addTarget:self action:@selector(operateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case FriendOperateTypeAdded:
            //已添加
            [_operateBtn setTitle:@"已添加" forState:UIControlStateNormal];
            [_operateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _operateBtn.backgroundColor = [UIColor clearColor];
            break;
        case FriendOperateTypeWait:
            //待验证
            [_operateBtn setTitle:@"待验证" forState:UIControlStateNormal];
            [_operateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _operateBtn.backgroundColor = [UIColor clearColor];
            break;
        default:
            break;
    }
}

- (void)setNeedAddUser:(NeedAddUser *)needAddUser
{
    [super willChangeValueForKey:@"needAddUser"];
    _needAddUser = needAddUser;
    [super didChangeValueForKey:@"needAddUser"];
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_needAddUser.avatar]
                      placeholderImage:[UIImage imageNamed:@"user_small"]
                               options:SDWebImageRetryFailed|SDWebImageLowPriority];
    if (_needAddUser.userType.integerValue == 1) {
        _nameLabel.text = _needAddUser.friendship.integerValue == 0 ? _needAddUser.name : _needAddUser.wlname;
        //手机联系人
        _messageLabel.text = _needAddUser.friendship.integerValue == 0 ? [NSString stringWithFormat:@"手机号码：%@",_needAddUser.mobile] : [NSString stringWithFormat:@"手机联系人：%@",_needAddUser.name];
    }else{
        //微信联系人
        _messageLabel.text = _needAddUser.friendship.integerValue == 0 ? [NSString stringWithFormat:@"微信好友：%@",_needAddUser.wlname] : [NSString stringWithFormat:@"微信好友：%@",_needAddUser.name];
    }
    
    //是否是认证投资人
    _iconImageView.hidden = _nFriendUser.investorauth.integerValue == 1 ? NO : YES;
    
    _operateBtn.hidden = NO;
    //friendship /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
    switch (_needAddUser.friendship.integerValue) {
        case 0:
        {
            [_operateBtn setTitle:@"邀请" forState:UIControlStateNormal];
            [_operateBtn setTitleColor:BtnJieShouColor forState:UIControlStateNormal];
            _operateBtn.backgroundColor = [UIColor clearColor];
            [_operateBtn addTarget:self action:@selector(operateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 1:
        {
            [_operateBtn setTitle:@"已添加" forState:UIControlStateNormal];
            [_operateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _operateBtn.backgroundColor = [UIColor clearColor];
        }
            break;
        case 2:
        {
            //添加
            [_operateBtn setTitle:@"添加" forState:UIControlStateNormal];
            [_operateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            //圆角
            _operateBtn.layer.cornerRadius = 5.f;
            _operateBtn.layer.masksToBounds = YES;
            _operateBtn.layer.borderWidth = 0.5;
            _operateBtn.layer.borderColor = LayerBorderColor.CGColor;
            _operateBtn.backgroundColor = BtnTianJiaColor;
            [_operateBtn addTarget:self action:@selector(operateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 4:
        {
            [_operateBtn setTitle:@"等待验证" forState:UIControlStateNormal];
            [_operateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _operateBtn.backgroundColor = [UIColor clearColor];
        }
            break;
        default:
            break;
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
    
    _operateBtn.size = CGSizeMake(kButtonWidth, kButtonHeight);
    _operateBtn.right = self.width - kMarginLeft;
    _operateBtn.top = kMarginLeft;
    
    [_nameLabel sizeToFit];
    _nameLabel.left = _logoImageView.right + kMarginLeft;
    if (_messageLabel.text.length == 0) {
        _nameLabel.centerY = self.height / 2.f;
    }else{
       _nameLabel.top = kMarginTop;
    }
    
    _messageLabel.width = self.width - (_operateBtn.hidden ? 0 : _operateBtn.width) - _nameLabel.left - kMarginLeft * 2.f;
    [_messageLabel sizeToFit];
    _messageLabel.top = _nameLabel.bottom + 5.f;
    _messageLabel.left = _nameLabel.left;
}

#pragma mark - Private
- (void)setup
{
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
    nameLabel.font = [UIFont systemFontOfSize:16.f];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //内容
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = [UIColor lightGrayColor];
    messageLabel.font = [UIFont systemFontOfSize:14.f];
    messageLabel.numberOfLines = 0.f;
    [self addSubview:messageLabel];
    self.messageLabel = messageLabel;
    
    //操作按钮
    UIButton *operateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    operateBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self addSubview:operateBtn];
    self.operateBtn = operateBtn;
}

//好友关系操作
- (void)operateBtnClicked:(UIButton *)sender
{
    //新的好友操作
    if (_newFriendBlock) {
        _newFriendBlock(_nFriendUser.operateType.integerValue,_nFriendUser,_indexPath);
    }
    
    if (_needAddBlock) {
        _needAddBlock(_needAddUser.friendship.integerValue,_needAddUser,_indexPath);
    }
}

//返回cell的高度
+ (CGFloat)configureWithName:(NSString *)name message:(NSString *)msg
{
    float maxWidth = [[UIScreen mainScreen] bounds].size.width - kLogoWidth - kButtonWidth - kMarginLeft * 4.f;
    //计算第一个label的高度
    CGSize size1 = [name calculateSize:CGSizeMake(maxWidth, FLT_MAX) font:[UIFont systemFontOfSize:16.f]];
    //计算第二个label的高度
    CGSize size2 = [msg calculateSize:CGSizeMake(maxWidth, FLT_MAX) font:[UIFont systemFontOfSize:14.f]];
    
    float height = size1.height + size2.height + kMarginTop * 2.f;
    if (height > 60) {
        return height;
    }else{
        return 60;
    }
}

@end
