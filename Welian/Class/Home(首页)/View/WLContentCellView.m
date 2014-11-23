//
//  WLContentCellView.m
//  weLian
//
//  Created by dong on 14/11/22.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLContentCellView.h"
#import "MLEmojiLabel.h"
#import "WLPhotoListView.h"
#import "HBVLinkedTextView.h"
#import "UIImage+ImageEffects.h"
#import "WLStatusFrame.h"
#import "WLStatusM.h"
#import "WLStatusDock.h"
#import "UserInfoBasicVC.h"
#import "LXActivity.h"
#import "PublishStatusController.h"
#import "NavViewController.h"
#import "ShareEngine.h"

@interface WLContentCellView () <MLEmojiLabelDelegate,LXActivityDelegate>
{
    /** 内容 */
    MLEmojiLabel *_contentLabel;
    /** 配图 */
    WLPhotoListView *_photoListView;
    /** 转发微博的整体 */
    UIImageView *_retweetView;
    /** 转发微博的昵称 */
    HBVLinkedTextView *_retweetNameLabel;
    /** 转发微博的配图 */
    WLPhotoListView *_retweetPhotoListView;
    /** 转发微博的内容 */
    MLEmojiLabel *_retweetContentLabel;
}
@end


@implementation WLContentCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 1.添加原创微博的子控件
        [self setupOriginalSubviews];
        
        // 2.添加转发微博的子控件
        [self setupRetweetSubviews];

    }
    return self;
}

/**
 *  添加原创微博的子控件
 */
- (void)setupOriginalSubviews
{
    // 5.内容
    _contentLabel = [[MLEmojiLabel alloc]init];
    _contentLabel.numberOfLines = 0;
    _contentLabel.emojiDelegate = self;
    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _contentLabel.isNeedAtAndPoundSign = YES;
    _contentLabel.font = IWContentFont;
    _contentLabel.textColor = IWContentColor;
    _contentLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentLabel];
    
    // 6.配图
    _photoListView = [[WLPhotoListView alloc] init];
    [self addSubview:_photoListView];
    
    // 添加工具条
    _dock = [[WLStatusDock alloc] init];
    [_dock.repostBtn addTarget:self action:@selector(transmitButClick:event:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dock];
}

/**
 *  添加转发微博的子控件
 */
- (void)setupRetweetSubviews
{
    // 0.整体
    _retweetView = [[UIImageView alloc] init];
    [_retweetView setUserInteractionEnabled:YES];
    _retweetView.image = [UIImage resizedImage:@"repost_bg"];
    [self addSubview:_retweetView];
    
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


- (void)setStatusFrame:(WLStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    WLStatusM *status = statusFrame.status;
    WLContentCellFrame *contenFrame = statusFrame.contentFrame;
    
    // 4.配图
    if (status.photos.count) {
        _photoListView.hidden = NO;
        _photoListView.frame = contenFrame.photoListViewF;
        // 传递图片数组给相册控件
        _photoListView.photos = status.photos;
    } else {
        _photoListView.hidden = YES;
    }
    
    // 5.转发微博
    WLStatusM *retweetStatus = status.relationfeed;
    if (retweetStatus) {
        _retweetView.hidden = NO;
        _retweetView.frame = contenFrame.retweetViewF;
        
        // 5.1.昵称
        _retweetNameLabel.frame = contenFrame.retweetNameLabelF;
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
        _retweetContentLabel.frame = contenFrame.retweetContentLabelF;
        _retweetContentLabel.text = retweetStatus.content;
        
        // 5.3.配图
        if (retweetStatus.photos.count) {
            _retweetPhotoListView.hidden = NO;
            _retweetPhotoListView.frame = contenFrame.retweetPhotoListViewF;
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
    _contentLabel.frame = contenFrame.contentLabelF;
    _contentLabel.text = status.content;
    
    // 9.给dock传递微博模型数据
    _dock.contentFrame = contenFrame;
    [_dock setFrame:contenFrame.dockFrame];
}

#pragma mark - 转发
- (void)transmitButClick:(UIButton*)but event:(id)event
{
    NSArray *shareButtonTitleArray = [[NSArray alloc] init];
    NSArray *shareButtonImageNameArray = [[NSArray alloc] init];
    shareButtonTitleArray = @[@"微链动态",@"微信好友",@"微信朋友圈"];
    shareButtonImageNameArray = @[@"home_repost_welian",@"home_repost_wechat",@"home_repost_friendcirle"];
    LXActivity *lxActivity = [[LXActivity alloc] initWithDelegate:self ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    
    [lxActivity showInView:self.window];
}

#pragma mark - LXActivityDelegate
- (void)didClickOnImageIndex:(NSInteger)imageIndex
{
    WLStatusM *statusM = self.statusFrame.status;
    NSString *name = [NSString stringWithFormat:@"%@在微链上说",statusM.user.name];
    if (imageIndex == 0) {  // weLian
        
        PublishStatusController *publishVC = [[PublishStatusController alloc] initWithType:PublishTypeForward];
        [publishVC setStatusFrame:self.statusFrame];
        [self.homeVC presentViewController:[[NavViewController alloc] initWithRootViewController:publishVC] animated:YES completion:^{
            
        }];
        
    }else if (imageIndex == 1){  // 微信好友
//        [[ShareEngine sharedShareEngine] sendWeChatMessage:name andDescription:statusM.content WithUrl:statusM.shareurl andImage:_cellHeadView.iconImageView.image WithScene:weChat];
        
    }else if (imageIndex == 2){  // 微信朋友圈
//        [[ShareEngine sharedShareEngine] sendWeChatMessage:name andDescription:statusM.content WithUrl:statusM.shareurl andImage:_cellHeadView.iconImageView.image WithScene:weChatFriend];
        
    }else if (imageIndex == 3){  // 新浪微博
        
    }
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
