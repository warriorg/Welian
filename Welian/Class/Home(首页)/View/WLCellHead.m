//
//  WLCellHead.m
//  微链
//
//  Created by dong on 14/11/19.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLCellHead.h"
#import "WLStatusM.h"
#import "UIImageView+WebCache.h"
#import "UserInfoBasicVC.h"
#import "UIImage+ImageEffects.h"


#define KIconX 10

#define KTouImageW 11
#define KFriendLW 80

@interface WLCellHead() <UIAlertViewDelegate>
{
    // 投资认证
    UIImageView *_touziImageView;
    // 创业认证
    UIImageView *_chuangImageView;
    // 姓名
    UILabel *_nameLabel;
    // 朋友关系
    UILabel *_friendLabel;
    // 职务和公司
    UILabel *_zhiwulncLabel;
    // 添加好友
    UIButton *_addFriendBut;
}

@end

@implementation WLCellHead

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:frame];
    }
    return self;
}

- (void)setup:(CGRect)frame
{
    // 1.头像图片
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KIconX, KIconX, IWIconWHSmall, IWIconWHSmall)];
    [_iconImageView.layer setMasksToBounds:YES];
    [_iconImageView.layer setCornerRadius:IWIconWHSmall*0.5];
    [_iconImageView setUserInteractionEnabled:YES];
    [_iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapiconImage:)]];
    [self addSubview:_iconImageView];
    
    // 投资者
    _touziImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IWIconWHSmall-KTouImageW+KIconX, IWIconWHSmall-KTouImageW+KIconX, KTouImageW, KTouImageW)];
    [_touziImageView setHidden:YES];
    [_touziImageView setImage:[UIImage imageNamed:@"me_mycard_tou"]];
    [self addSubview:_touziImageView];
    
    // 创业者
    _chuangImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KIconX, KIconX, KTouImageW, KTouImageW)];
    [_chuangImageView setHidden:YES];
    [_chuangImageView setImage:[UIImage imageNamed:@"me_mycard_chuang"]];
    [self addSubview:_chuangImageView];
    
    // 姓名
    CGFloat nameX = CGRectGetMaxX(_iconImageView.frame)+8;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, KIconX, frame.size.width-nameX-90, 20)];
    _nameLabel.font = WLFONTBLOD(15);
    _nameLabel.textColor = WLRGB(51, 51, 51);
    _nameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_nameLabel];
    
    // 职务和公司
    _zhiwulncLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, CGRectGetMaxY(_nameLabel.frame)+5, frame.size.width-nameX-KIconX, 15)];
    [_zhiwulncLabel setBackgroundColor:[UIColor clearColor]];
    _zhiwulncLabel.font = WLFONT(12);
    _zhiwulncLabel.textColor = WLRGB(178, 178, 178);
    [self addSubview:_zhiwulncLabel];
    
    // 朋友关系
    _friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-KFriendLW-KIconX, KIconX, KFriendLW, 15)];
    [_friendLabel setTextAlignment:NSTextAlignmentRight];
    [_friendLabel setHidden:YES];
    [_friendLabel setFont:WLFONT(11)];
    [_friendLabel setTextColor:WLRGB(173, 173, 173)];
    [self addSubview:_friendLabel];
    
    _addFriendBut = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-70, 5, 60, 25)];
    [_addFriendBut setImage:[UIImage imageNamed:@"osusume_friend_add"] forState:UIControlStateNormal];
    [_addFriendBut setBackgroundImage:[UIImage resizedImage:@"osusume_add_bg"] forState:UIControlStateNormal];
    
    [_addFriendBut setTitle:@"加好友" forState:UIControlStateNormal];
    [_addFriendBut setTitleColor:WLRGB(40, 94, 172) forState:UIControlStateNormal];
    [_addFriendBut.titleLabel setFont:WLFONT(12)];

    [_addFriendBut addTarget:self action:@selector(addFriendButClick:) forControlEvents:UIControlEventTouchUpInside];
    [_addFriendBut setImage:[UIImage imageNamed:@"osusume_friend_add_already"] forState:UIControlStateDisabled];
    [_addFriendBut setTitleColor:WLRGB(173, 173, 173) forState:UIControlStateDisabled];
    [_addFriendBut setBackgroundImage:[UIImage resizedImage:@"osusume_already_bg"] forState:UIControlStateDisabled];
    [_addFriendBut setTitle:@"已发送" forState:UIControlStateDisabled];
    [self addSubview:_addFriendBut];
}

- (void)setUserStat:(WLStatusM *)userStat
{
    _userStat = userStat;
    WLBasicTrends *user = userStat.user;
    // 姓名
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    
    // 姓名
    [_nameLabel setText:user.name];
    
    // 职务和公司
    if (user.position) {
        [_zhiwulncLabel setText:[NSString stringWithFormat:@"%@   %@",user.position,user.company]];
    }

    // 好友关系
    if (user.friendship == WLRelationTypeFriend) {
        [_friendLabel setText:@"朋友"];
        [_friendLabel setHidden:NO];
    }else if (user.friendship == WLRelationTypeFriendsFriend){
        [_friendLabel setText:@"朋友的朋友"];
        [_friendLabel setHidden:NO];
    }else{
        [_friendLabel setHidden:YES];
    }
    if (userStat.type==2) {
        [_friendLabel setHidden:YES];
        [_addFriendBut setHidden:NO];
        
    }else{
        [_addFriendBut setHidden:YES];
    }
    
    // 是否创业和投资者
    if (user.investorauth == WLVerifiedTypeInvestor) {
        [_touziImageView setHidden:NO];
    }else if (user.investorauth == WLVerifiedTypeCarver) {
        [_chuangImageView setHidden:NO];
    }else if (user.investorauth == WLVerifiedTypeInvestorAndCarver) {
        [_touziImageView setHidden:NO];
        [_chuangImageView setHidden:NO];
    }else{
        [_touziImageView setHidden:YES];
        [_chuangImageView setHidden:YES];
    }
}

- (void)tapiconImage:(UITapGestureRecognizer *)tap
{
    UserInfoModel *mode = [[UserInfoModel alloc] init];
    WLBasicTrends *user = _userStat.user;
    [mode setUid:user.uid];
    [mode setAvatar:user.avatar];
    [mode setName:user.name];
    NSString *da = [NSString stringWithFormat:@"%d",user.friendship];
    
    [mode setFriendship:da];
    
    UserInfoBasicVC *userinfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:mode isAsk:NO];
    [self.controllVC.navigationController pushViewController:userinfoVC animated:YES];
}


#pragma mark - 添加推荐好友
- (void)addFriendButClick:(UIButton *)but
{
//    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    LogInUser *mode = [LogInUser getCurrentLoginUser];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友验证" message:[NSString stringWithFormat:@"发送至好友：%@",_userStat.user.name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"我是%@的%@",mode.company,mode.position]];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [WLHttpTool requestFriendParameterDic:@{@"fid":_userStat.user.uid,@"message":[alertView textFieldAtIndex:0].text} success:^(id JSON) {
            [_addFriendBut setEnabled:NO];
        } fail:^(NSError *error) {
            
        }];
    }
}

/**
 *  重写setFrame:和setBounds:方法的目的：不让别人修改自己内部的尺寸
 */
//- (void)setFrame:(CGRect)newFrame
//{
//    newFrame.size = self.frame.size;
//    [super setFrame:newFrame];
//}
//
//- (void)setBounds:(CGRect)newBounds
//{
//    newBounds.size = self.bounds.size;
//    [super setBounds:newBounds];
//}

@end
