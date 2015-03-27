//
//  UserInfoView.m
//  Welian
//
//  Created by weLian on 15/3/25.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "UserInfoView.h"

#define kBlueBgViewHeight 250.f
#define kLogoHeight 70.f
#define kButtonWidth 65.f
#define kButtonHeight 25.f

#define kMarginLeft 10.f
#define kMarginEdge 7.f

@interface UserInfoView ()<UIGestureRecognizerDelegate>

@property (assign,nonatomic) UIImageView *bgImageView;
@property (assign,nonatomic) UIImageView *logoImageView;
@property (assign,nonatomic) UIImageView *phoneRZImageView;
@property (assign,nonatomic) UILabel *nameLabel;
@property (assign,nonatomic) UILabel *companyLabel;
@property (assign,nonatomic) UIButton *touZiRenBtn;
@property (assign,nonatomic) UIButton *cityBtn;
@property (assign,nonatomic) UIButton *operateBtn;

@end

@implementation UserInfoView

- (void)dealloc
{
    _lookUserDetailBlock = nil;
    _loginUser = nil;
    _baseUserModel = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setLoginUser:(LogInUser *)loginUser
{
    [super willChangeValueForKey:@"loginUser"];
    _loginUser = loginUser;
    [super didChangeValueForKey:@"loginUser"];
    _operateBtn.hidden = YES;
    
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_loginUser.avatar]
                      placeholderImage:[UIImage imageNamed:@""]
                               options:SDWebImageRetryFailed|SDWebImageLowPriority];
    _nameLabel.text = _loginUser.name;
    _companyLabel.text = [NSString stringWithFormat:@"%@　%@",_loginUser.position,_loginUser.company];
    _touZiRenBtn.hidden = _loginUser.investorauth.integerValue == 1 ? NO : YES;
    //手机是否通过认证
    _phoneRZImageView.image = [UIImage imageNamed:_loginUser.checked.boolValue ? @"me_phone_yes" : @"me_phone_no"];
    if (_loginUser.cityname.length > 0) {
        _cityBtn.hidden = NO;
        [_cityBtn setTitle:_loginUser.cityname forState:UIControlStateNormal];
    }else{
        _cityBtn.hidden = YES;
    }
}

- (void)setBaseUserModel:(IBaseUserM *)baseUserModel
{
    [super willChangeValueForKey:@"baseUserModel"];
    _baseUserModel = baseUserModel;
    [super didChangeValueForKey:@"baseUserModel"];
    _operateBtn.hidden = NO;
    
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_baseUserModel.avatar]
                      placeholderImage:[UIImage imageNamed:@""]
                               options:SDWebImageRetryFailed|SDWebImageLowPriority];
    _nameLabel.text = _baseUserModel.name;
    _companyLabel.text = [NSString stringWithFormat:@"%@　%@",_baseUserModel.position,_baseUserModel.company];
    _touZiRenBtn.hidden = _baseUserModel.investorauth.integerValue == 1 ? NO : YES;
    //手机是否通过认证
    _phoneRZImageView.image = [UIImage imageNamed:_baseUserModel.checked.boolValue ? @"me_phone_yes" : @"me_phone_no"];
//    if (_baseUserModel.checked) {
//        
//    }else{
//        _phoneRZImageView.image = [UIImage imageNamed:@"me_phone_no"];
//    }
    
    if (_baseUserModel.cityname.length > 0) {
        _cityBtn.hidden = NO;
        [_cityBtn setTitle:_baseUserModel.cityname forState:UIControlStateNormal];
        [_cityBtn setImage:[UIImage imageNamed:@"me_myplace"] forState:UIControlStateNormal];
    }else{
        _cityBtn.hidden = YES;
    }
    _operateBtn.enabled = YES;
    /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
    if (_baseUserModel.friendship.integerValue == 1) {
        [_operateBtn setTitle:@"发消息" forState:UIControlStateNormal];
        [_operateBtn setImage:[UIImage imageNamed:@"me_button_chat"] forState:UIControlStateNormal];
    }else{
        [_operateBtn setTitle:@"加好友" forState:UIControlStateNormal];
        [_operateBtn setImage:[UIImage imageNamed:@"me_button_add"] forState:UIControlStateNormal];
    }
}

////操作类型0：添加 1：接受  2:已添加 3：待验证
- (void)setOperateType:(NSNumber *)operateType
{
    [super willChangeValueForKey:@"operateType"];
    _operateType = operateType;
    [super didChangeValueForKey:@"operateType"];
    /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
    _operateBtn.enabled = YES;
    if (_baseUserModel.friendship.integerValue == 1) {
        [_operateBtn setTitle:@"发消息" forState:UIControlStateNormal];
        [_operateBtn setImage:[UIImage imageNamed:@"me_button_chat"] forState:UIControlStateNormal];
    }else{
        switch (_operateType.integerValue) {
            case 0:
            {
                [_operateBtn setTitle:@"加好友" forState:UIControlStateNormal];
                [_operateBtn setImage:[UIImage imageNamed:@"me_button_add"] forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
                [_operateBtn setTitle:@"通过验证" forState:UIControlStateNormal];
                [_operateBtn setImage:nil forState:UIControlStateNormal];
            }
                break;
            case 3:
            {
                [_operateBtn setTitle:@"待验证" forState:UIControlStateNormal];
                [_operateBtn setImage:nil forState:UIControlStateNormal];
                _operateBtn.enabled = NO;
            }
                break;
            default:
                break;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _bgImageView.size = CGSizeMake(self.width, kBlueBgViewHeight);
    _bgImageView.top = 0.f;
    _bgImageView.centerX = self.width / 2.f;
    
    _logoImageView.size = CGSizeMake(kLogoHeight, kLogoHeight);
    _logoImageView.bottom = _bgImageView.height + 23.f;
    _logoImageView.left = kMarginLeft;
    
    [_nameLabel sizeToFit];
    _nameLabel.left = _logoImageView.right + kMarginEdge;
    _nameLabel.top = _logoImageView.top;
    
    [_phoneRZImageView sizeToFit];
    _phoneRZImageView.left = _nameLabel.right + kMarginEdge;
    _phoneRZImageView.centerY = _nameLabel.centerY;
    
    [_companyLabel sizeToFit];
    _companyLabel.width = self.width - _logoImageView.right - kMarginEdge - kMarginLeft;
    _companyLabel.bottom = _bgImageView.height - 6.f;
    _companyLabel.left = _nameLabel.left;
    
    [_touZiRenBtn sizeToFit];
    _touZiRenBtn.width = _touZiRenBtn.width + 10.f;
    _touZiRenBtn.left = _logoImageView.right - 20.f;
    _touZiRenBtn.bottom = _logoImageView.bottom;
    
    [_cityBtn sizeToFit];
    _cityBtn.width = _cityBtn.width + 10.f;
    if (_touZiRenBtn.hidden) {
        _cityBtn.left = _nameLabel.left;
        _cityBtn.top = _bgImageView.bottom + kMarginEdge;
    }else{
        _cityBtn.left = _touZiRenBtn.right + 10.f;
        _cityBtn.centerY =  _touZiRenBtn.centerY;
    }
    
    _operateBtn.size = CGSizeMake(kButtonWidth, kButtonHeight);
    _operateBtn.right = self.width - kMarginLeft;
    _operateBtn.centerY = _nameLabel.centerY;
}

#pragma mark - Private
- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    
    //蓝色背景
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_background"]];
    bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    //头像
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.backgroundColor = RGB(229.f, 229.f, 229.f);
    logoImageView.layer.borderWidth = 0.5f;
    logoImageView.layer.borderColor = RGB(229.f, 229.f, 229.f).CGColor;
    logoImageView.layer.cornerRadius = kLogoHeight / 2.f;
    logoImageView.layer.masksToBounds = YES;
    [self addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:14.f];
    nameLabel.text = @"陈日沙";
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //公司信息
    UILabel *companyLabel = [[UILabel alloc] init];
    companyLabel.backgroundColor = [UIColor clearColor];
    companyLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
    companyLabel.font = [UIFont systemFontOfSize:12.f];
    companyLabel.text = @"产品经理　杭州传送门网络技术有限公司asdfasdf";
    [self addSubview:companyLabel];
    self.companyLabel = companyLabel;
    
    //手机是否认证  me_phone_no
    UIImageView *phoneRZImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_phone_yes"]];
    phoneRZImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:phoneRZImageView];
    self.phoneRZImageView = phoneRZImageView;
    
    //是否认证投资人
    UIButton *touZiRenBtn = [UIView getBtnWithTitle:@"认证投资人" image:[UIImage imageNamed:@"me_mycard_tou_big2"]];
    touZiRenBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [touZiRenBtn setTitleColor:kNormalTextColor forState:UIControlStateNormal];
    touZiRenBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:touZiRenBtn];
    self.touZiRenBtn = touZiRenBtn;
    
    //城市
    UIButton *cityBtn = [UIView getBtnWithTitle:@"杭州" image:[UIImage imageNamed:@"me_myplace"]];
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [cityBtn setTitleColor:kNormalTextColor forState:UIControlStateNormal];
    cityBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:cityBtn];
    self.cityBtn = cityBtn;
//    [cityBtn setDebug:YES];
    
    //操作按钮 me_button_chat
    UIButton *operateBtn = [UIView getBtnWithTitle:@"加好友" image:[UIImage imageNamed:@"me_button_add"]];
    operateBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [operateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    operateBtn.backgroundColor = [UIColor clearColor];
    operateBtn.layer.borderWidth = 1.f;
    operateBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    operateBtn.imageEdgeInsets = UIEdgeInsetsMake(0.f, -5.f, 0.f, 0.f);
    [operateBtn addTarget:self action:@selector(operateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:operateBtn];
    self.operateBtn = operateBtn;
    
    //添加点击事件
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        if (_lookUserDetailBlock) {
            _lookUserDetailBlock();
        }
    }];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)operateBtnClicked:(UIButton *)sender
{
    if (_operateClickedBlock) {
        _operateClickedBlock();
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    DLog(@"UserInfoView touch.view：%@",[touch.view class]);
    if ([[NSString stringWithFormat:@"%@",[touch.view class]] isEqualToString:@"UIButton"]) {
        return NO;
    }
    return YES;
}

@end
