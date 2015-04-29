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
#import "UIImage+ImageEffects.h"
#import "UserInfoViewController.h"


#define KIconX 10

#define KTouImageW 11
#define KFriendLW 80

@interface WLCellHead() <UIAlertViewDelegate>
{
    // 投资认证
    UIImageView *_touziImageView;
//    // 创业认证
//    UIImageView *_chuangImageView;
    // 姓名
    UILabel *_nameLabel;
    // 朋友关系
    UILabel *_friendLabel;
    // 职务和公司
    UILabel *_zhiwulncLabel;
    // 添加好友
    UIButton *_addFriendBut;
    
    // 点评，报名项目
    UILabel *_mesLabel;
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
    self.backgroundColor= [UIColor clearColor];
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
    
//    // 创业者
//    _chuangImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KIconX, KIconX, KTouImageW, KTouImageW)];
//    [_chuangImageView setHidden:YES];
//    [_chuangImageView setImage:[UIImage imageNamed:@"me_mycard_chuang"]];
//    [self addSubview:_chuangImageView];
    
    CGFloat nameX = CGRectGetMaxX(_iconImageView.frame)+8;
    
    
    _mesLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, KIconX, frame.size.width-nameX-15, IWIconWHSmall)];
    _mesLabel.numberOfLines = 0;
    _mesLabel.font = WLFONT(13);
    _mesLabel.textColor = WLRGB(178, 178, 178);
    _mesLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_mesLabel];
    
    // 姓名
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
    IBaseUserM *user = userStat.user;
    // 头像
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    // 是否创业
    [_touziImageView setHidden:!user.investorauth.integerValue];

    if (userStat.type.integerValue==5||userStat.type.integerValue==12) {
        NSMutableString *nameStr = [NSMutableString string];
        NSInteger conut = 0;
        for (IBaseUserM *userM in userStat.joinedusers) {
            if (conut<=1) {
                if (conut==0) {
                    if (userStat.joinedusers.count==1) {
                        [nameStr appendString:[NSString stringWithFormat:@"%@",userM.name]];
                    }else{
                        [nameStr appendString:[NSString stringWithFormat:@"%@，",userM.name]];
                    }

                }else{
                    if (userStat.joinedusers.count>2) {
                        [nameStr appendString:[NSString stringWithFormat:@"%@等%lu位好友",userM.name,(unsigned long)userStat.joinedusers.count]];
                    }else{
                        [nameStr appendString:userM.name];
                    }
                }
            }
            conut++;
        }
        if (userStat.type.integerValue==5) { // 参加活动
            _mesLabel.text = [NSString stringWithFormat:@"%@报名了该活动",nameStr];
        }else if (userStat.type.integerValue==12){  // 点评了项目
            _mesLabel.text = [NSString stringWithFormat:@"%@点评了该项目",nameStr];
        }
        [_mesLabel setHidden:NO];
        [_nameLabel setHidden:YES];
        [_friendLabel setHidden:YES];
        [_zhiwulncLabel setHidden:YES];
        [_addFriendBut setHidden:YES];
        
    }else{
        [_mesLabel setHidden:YES];
        [_nameLabel setHidden:NO];
        [_zhiwulncLabel setHidden:NO];
        // 姓名
        [_nameLabel setText:user.name];
        
        // 职务和公司
        if (user.position) {
            [_zhiwulncLabel setText:[NSString stringWithFormat:@"%@   %@",user.position,user.company]];
        }
        
        // 好友关系
        if (user.friendship.integerValue == 1) {
            [_friendLabel setText:@"朋友"];
            [_friendLabel setHidden:NO];
        }else if (user.friendship.integerValue == 2){
            [_friendLabel setText:@"朋友的朋友"];
            [_friendLabel setHidden:NO];
        }else{
            [_friendLabel setHidden:YES];
        }
        if (userStat.type.integerValue==2) {
            [_friendLabel setHidden:YES];
            [_addFriendBut setHidden:NO];
            
        }else{
            [_addFriendBut setHidden:YES];
        }
    }
}

- (void)tapiconImage:(UITapGestureRecognizer *)tap
{
    IBaseUserM *mode = _userStat.user;
//    WLBasicTrends *user = _userStat.user;
//    [mode setUid:user.uid];
//    [mode setAvatar:user.avatar];
//    [mode setName:user.name];
    
//    UserInfoBasicVC *userinfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:mode isAsk:NO];
//    [self.controllVC.navigationController pushViewController:userinfoVC animated:YES];
    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithBaseUserM:mode OperateType:nil HidRightBtn:NO];
    [self.controllVC.navigationController pushViewController:userInfoVC animated:YES];
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
        [WeLianClient requestAddFriendWithID:_userStat.user.uid
                                     Message:[alertView textFieldAtIndex:0].text
                                     Success:^(id resultInfo) {
                                         [_addFriendBut setEnabled:NO];
                                     } Failed:^(NSError *error) {
                                         
                                     }];
        
//        [WLHttpTool requestFriendParameterDic:@{@"fid":_userStat.user.uid,@"message":[alertView textFieldAtIndex:0].text} success:^(id JSON) {
//            [_addFriendBut setEnabled:NO];
//        } fail:^(NSError *error) {
//            
//        }];
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
