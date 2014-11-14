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
#import "MLEmojiLabel.h"
#import "LXActivity.h"
#import "PublishStatusController.h"
#import "NavViewController.h"
#import "ShareEngine.h"
#import "ShareView.h"
#import "UserInfoBasicVC.h"
#import "HBVLinkedTextView.h"
#import "UIColor+HBVHarmonies.h"
#import "UserInfoBasicVC.h"

@interface WLStatusCell () <UIActionSheetDelegate,MLEmojiLabelDelegate,LXActivityDelegate>
{
    /** 头像 */
    UIImageView *_iconView;
    /** 昵称 */
    UILabel *_nameLabel;
    /** 时间 */
    UILabel *_timeLabel;
    // 投资认证图标
    UIImageView *_investImage;
    
    UILabel *_jobLabel;
    
    /** 来源 */
//    UILabel *_sourceLabel;
    /** 内容 */
    MLEmojiLabel *_contentLabel;
    /** 配图 */
    WLPhotoListView *_photoListView;
    /** 关系图标 */
    UIImageView *_mbView;
    
    /** 转发微博的整体 */
    UIImageView *_retweetView;
    /** 转发微博的昵称 */
    HBVLinkedTextView *_retweetNameLabel;
    /** 转发微博的配图 */
    WLPhotoListView *_retweetPhotoListView;
    /** 转发微博的内容 */
    MLEmojiLabel *_retweetContentLabel;
    
    UserInfoModel *_mode;

//    WLCellMoreBlock _cellMoreBlock;
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
//    _cellMoreBlock = moreBlock;
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
    bg.image = [UIImage resizedImage:@"cellbackground_normal"];
    self.backgroundView = bg;
    // 2.选中
    UIImageView *selectedBg = [[UIImageView alloc] init];
    selectedBg.image = [UIImage resizedImage:@"cellbackground_highlight"];
    self.selectedBackgroundView = selectedBg;
}

/**
 *  添加原创微博的子控件
 */
- (void)setupOriginalSubviews
{
// 清除cell默认的背景色(才能只显示背景view、背景图片)
    self.backgroundColor = [UIColor clearColor];
    // 1.头像
    _iconView = [[UIImageView alloc] init];
    [_iconView setUserInteractionEnabled:YES];
    [_iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapiconImage:)]];
    [self.contentView addSubview:_iconView];
    
    // 2.昵称
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = IWNameFont;
// 清除背景颜色
    _nameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_nameLabel];
    
    // 投资认证图标
    _investImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge_tou_big"]];
    [self.contentView addSubview:_investImage];
    
    // 3.时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = IWTimeFont;
    _timeLabel.textColor = IWSourceColor;
    _timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_timeLabel];
    
    _jobLabel = [[UILabel alloc] init];
    _jobLabel.font = IWTimeFont;
    _jobLabel.textColor = IWSourceColor;
    [_jobLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_jobLabel];

    // 5.内容
    _contentLabel = [[MLEmojiLabel alloc]init];
    _contentLabel.numberOfLines = 0;
    _contentLabel.emojiDelegate = self;
    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _contentLabel.isNeedAtAndPoundSign = YES;
    _contentLabel.font = IWContentFont;
    _contentLabel.textColor = IWContentColor;

// 自动换行
    //    _contentLabel.numberOfLines = 0;
    _contentLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_contentLabel];
    
    // 6.配图
    _photoListView = [[WLPhotoListView alloc] init];
    [self.contentView addSubview:_photoListView];
    
//    // 7.微博会员图标
    _mbView = [[UIImageView alloc] init];
    [self.contentView addSubview:_mbView];
    
    // 8.更多按钮
    _moreBut = [UIButton buttonWithType:UIButtonTypeCustom];
    // 8.1.设置内部的图片
    [_moreBut setImage:[UIImage imageNamed:@"me_mywriten_more"] forState:UIControlStateNormal];
//    [_moreBut setImage:[UIImage imageNamed:@"timeline_icon_more_highlighted"] forState:UIControlStateHighlighted];
    
    
    // 8.2.设置按钮的frame
    // 8.3.设置按钮永远停留在右上角
    CGFloat btnWH = 35;
    CGFloat btnY = IWTableBorderWidth;
    CGFloat btnX = self.contentView.frame.size.width - btnWH-10;
    _moreBut.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
    _moreBut.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.contentView addSubview:_moreBut];
}


- (void)tapiconImage:(UITapGestureRecognizer *)tap
{
    WLBasicTrends *user = _statusFrame.status.user;
    UserInfoModel *mode = [[UserInfoModel alloc] init];
    [mode setUid:user.uid];
    [mode setAvatar:user.avatar];
    [mode setName:user.name];
    
    UserInfoBasicVC *userinfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:mode isAsk:NO];
    [self.homeVC.navigationController pushViewController:userinfoVC animated:YES];
}



/**
 *  添加转发微博的子控件
 */
- (void)setupRetweetSubviews
{
    // 0.整体
    _retweetView = [[UIImageView alloc] init];
    [_retweetView setUserInteractionEnabled:YES];
    _retweetView.image = [UIImage resizedImage:@"repost_bg_normal"];
    _retweetView.highlightedImage = [UIImage resizedImage:@"repost_bg_highlight"];
    [self.contentView addSubview:_retweetView];
    
    // 1.昵称
    _retweetNameLabel = [[HBVLinkedTextView alloc] init];
    [_retweetNameLabel setTextColor:[UIColor grayColor]];
    _retweetNameLabel.font = [UIFont systemFontOfSize:15];
//    _retweetNameLabel.textColor = IWRetweetNameColor;
    _retweetNameLabel.backgroundColor = [UIColor clearColor];
    [_retweetView addSubview:_retweetNameLabel];
    
    // 2.内容
    _retweetContentLabel = [[MLEmojiLabel alloc] init];
    _retweetContentLabel.font = IWRetweetContentFont;
    _retweetContentLabel.textColor = IWRetweetContentColor;
    _retweetContentLabel.backgroundColor = [UIColor clearColor];
    _retweetContentLabel.numberOfLines = 0;
    _retweetContentLabel.emojiDelegate = self;
    _retweetContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _retweetContentLabel.isNeedAtAndPoundSign = YES;
    
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
    CGFloat dockY = _statusFrame.dockY;
    CGFloat dockW = [[UIScreen mainScreen] bounds].size.width;
    CGRect dockF = CGRectMake(dockX, dockY, dockW, dockH);
    
    // 2.创建和添加dock
    _dock = [[WLStatusDock alloc] initWithFrame:dockF];
    _dock.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_dock.repostBtn addTarget:self action:@selector(transmitButClick:event:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_dock];
}

#pragma mark - 转发
- (void)transmitButClick:(UIButton*)but event:(id)event
{
    NSArray *shareButtonTitleArray = [[NSArray alloc] init];
    NSArray *shareButtonImageNameArray = [[NSArray alloc] init];
    shareButtonTitleArray = @[@"weLian动态",@"微信好友",@"微信朋友圈"];
    shareButtonImageNameArray = @[@"home_repost_welian",@"home_repost_wechat",@"home_repost_friendcirle"];
    LXActivity *lxActivity = [[LXActivity alloc] initWithDelegate:self ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];

    [lxActivity showInView:self.window];
}

#pragma mark - LXActivityDelegate
- (void)didClickOnImageIndex:(NSInteger)imageIndex
{
    WLStatusM *statusM = self.statusFrame.status;
    NSString *name = [NSString stringWithFormat:@"%@的动态",statusM.user.name];
    if (imageIndex == 0) {  // weLian
        
        PublishStatusController *publishVC = [[PublishStatusController alloc] initWithType:PublishTypeForward];
        [publishVC setStatusFrame:self.statusFrame];
        [self.homeVC presentViewController:[[NavViewController alloc] initWithRootViewController:publishVC] animated:YES completion:^{
            
        }];
        
    }else if (imageIndex == 1){  // 微信好友
        [[ShareEngine sharedShareEngine] sendWeChatMessage:name andDescription:statusM.content WithUrl:statusM.shareurl andImage:_iconView.image WithScene:weChat];
        
    }else if (imageIndex == 2){  // 微信朋友圈
        [[ShareEngine sharedShareEngine] sendWeChatMessage:name andDescription:statusM.content WithUrl:statusM.shareurl andImage:_iconView.image WithScene:weChatFriend];

    }else if (imageIndex == 3){  // 新浪微博
        
    }
}



- (void)setStatusFrame:(WLStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    WLStatusM *status = statusFrame.status;
    
    WLBasicTrends *user = status.user;
    if (!_mode) {
        _mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    }
    
    // 1.头像
    _iconView.frame = statusFrame.iconViewF;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:status.user.avatar] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    [_iconView.layer setMasksToBounds:YES];
    [_iconView.layer setCornerRadius:statusFrame.iconViewF.size.height*0.5];
    
//    [_iconView setUser:user iconType:IWIconTypeSmall];
    
    // 2.昵称
    _nameLabel.frame = statusFrame.nameLabelF;
    _nameLabel.text = user.name;

    // 认证图标
    [_investImage setFrame:statusFrame.inversImageF];
    
    if (user.investorauth==WLVerifiedTypeInvestor) {
        [_investImage setHidden:NO];
    }else{
        [_investImage setHidden:YES];
    }
    
    [_jobLabel setFrame:statusFrame.jobLabelF];
    [_jobLabel setText:[NSString stringWithFormat:@"%@   %@",user.position,user.company]];
    
    
    _mbView.hidden = NO;
    _mbView.frame = statusFrame.mbViewF;
    
    if ([_mode.uid integerValue]==[user.uid integerValue]) {
        [_moreBut setHidden:NO];
        [_mbView setHidden:YES];
    }else{
        [_moreBut setHidden:YES];
        [_mbView setHidden:NO];
        // 3.会员图标
        if (user.friendship == WLRelationTypeNone) { // 关系无
            _mbView.hidden = YES;
        } else if(user.friendship == WLRelationTypeFriend){ // 朋友
            [_mbView setImage:[UIImage imageNamed:@"home_label_friend"]];
            
        }else if (user.friendship == WLRelationTypeFriendsFriend){
            [_mbView setImage:[UIImage imageNamed:@"home_label_friendsfriend"]];
        }
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
        [_retweetNameLabel setText:[NSString stringWithFormat:@"该动态最早由 %@ 发布", retweetStatus.user.name]];
        //Pass in the string, attributes, and a tap handling block
        [_retweetNameLabel linkString:retweetStatus.user.name
      defaultAttributes:[self exampleAttributes]
  highlightedAttributes:[self exampleAttributes]
             tapHandler:[self exampleHandlerWithTitle:@"Link a single string"]];
        [_retweetNameLabel sizeToFit];
        
        
        // 5.2.正文
        _retweetContentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _retweetContentLabel.customEmojiPlistName = @"expressionImage_custom";
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
    _contentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _contentLabel.customEmojiPlistName = @"expressionImage_custom";
    _contentLabel.frame = statusFrame.contentLabelF;
    _contentLabel.text = status.content;
//    CGSize sizelabel = [_contentLabel preferredSizeWithMaxWidth:statusFrame.contentLabelF.size.width];
//    [_contentLabel setBounds:CGRectMake(0, 0, sizelabel.width, sizelabel.height)];

    
    // 7.时间
    _timeLabel.text = status.created;
    _timeLabel.frame = statusFrame.timeLabelF;
    
    // 9.给dock传递微博模型数据
    _dock.status = status;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (LinkedStringTapHandler)exampleHandlerWithTitle:(NSString *)title
{
    LinkedStringTapHandler exampleHandler = ^(NSString *linkedString) {
        WLBasicTrends *status = _statusFrame.status.relationfeed.user;
        UserInfoModel *mode = [[UserInfoModel alloc] init];
        [mode setName:status.name];
        [mode setAvatar:status.avatar];
        [mode setUid:status.uid];
        UserInfoBasicVC *userinfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:mode isAsk:NO];
        [self.homeVC.navigationController pushViewController:userinfoVC animated:YES];
    };
    return exampleHandler;
}



- (NSMutableDictionary *)exampleAttributes
{
    return [@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
              NSForegroundColorAttributeName:IWRetweetNameColor}mutableCopy];
}


@end
