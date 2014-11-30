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
#import "UIImage+ImageEffects.h"
#import "WLStatusFrame.h"
#import "WLStatusM.h"
#import "WLStatusDock.h"
#import "UserInfoBasicVC.h"
#import "PublishStatusController.h"
#import "NavViewController.h"
#import "ShareEngine.h"
#import "CommentInfoController.h"
#import "CommentHeadFrame.h"
#import "TOWebViewController.h"
#import "MJExtension.h"
#import "M80AttributedLabel.h"

@interface WLContentCellView () <MLEmojiLabelDelegate,M80AttributedLabelDelegate>
{
    /** 内容 */
    MLEmojiLabel *_contentLabel;
    /** 配图 */
    WLPhotoListView *_photoListView;
    /** 转发微博的整体 */
    UIImageView *_retweetView;
    /** 转发微博的昵称 */
    M80AttributedLabel *_retweetNameLabel;
    /** 转发微博的配图 */
    WLPhotoListView *_retweetPhotoListView;
    /** 转发微博的内容 */
    MLEmojiLabel *_retweetContentLabel;
    
//    UIButton *_openupBut;
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
    _contentLabel.font = IWContentFont;
    _contentLabel.textColor = IWContentColor;
    _contentLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentLabel];
    
    // 收起-展开按钮
//    _openupBut = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_openupBut setBackgroundColor:[UIColor redColor]];
//    [_openupBut setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    [_openupBut addTarget:self action:@selector(openupisok:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_openupBut];
    
    
    // 6.配图
    _photoListView = [[WLPhotoListView alloc] init];
    [self addSubview:_photoListView];
    
    // 添加工具条
    _dock = [[WLStatusDock alloc] init];
    // 赞
    [_dock.attitudeBtn addTarget:self action:@selector(attitudeBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    
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
    _retweetNameLabel = [[M80AttributedLabel alloc] init];
    [_retweetNameLabel setTextColor:[UIColor grayColor]];
    _retweetNameLabel.font = [UIFont systemFontOfSize:15];
    _retweetNameLabel.delegate = self;
    [_retweetNameLabel setUnderLineForLink:NO];
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
    [_retweetView addSubview:_retweetContentLabel];
    
    // 3.配图
    _retweetPhotoListView = [[WLPhotoListView alloc] init];
    [_retweetView addSubview:_retweetPhotoListView];
}


- (void)setCommentFrame:(CommentHeadFrame *)commentFrame
{
    _commentFrame = commentFrame;
    WLStatusM *status = commentFrame.status;
    WLContentCellFrame *contenFrame = commentFrame.contentFrame;
    [self setViewDataAndFrame:status frame:contenFrame];
}

- (void)setStatusFrame:(WLStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    WLStatusM *status = statusFrame.status;
    WLContentCellFrame *contenFrame = statusFrame.contentFrame;
    [self setViewDataAndFrame:status frame:contenFrame];
    
}


- (void)setViewDataAndFrame:(WLStatusM *)status frame:(WLContentCellFrame *)contenFrame
{
    // 3.正文
    _contentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _contentLabel.customEmojiPlistName = @"expressionImage_custom";
    CGRect textFrame = contenFrame.contentLabelF;
//    if (contenFrame.contentLabelF.size.height>140) {
//        textFrame.size.height=140;
//        [_openupBut setHidden:NO];
//        [_openupBut setFrame:CGRectMake(textFrame.origin.x, CGRectGetMaxY(textFrame)+5, 30, 30)];
//        [_openupBut.titleLabel setText:@"展开"];
//    }else{
//        [_openupBut setHidden:YES];
//    }
    _contentLabel.frame = textFrame;
    _contentLabel.text = status.content;
    
    
    
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
        NSString *nametext = [NSString stringWithFormat:@"该动态最早由 %@ 发布", retweetStatus.user.name];
        [_retweetNameLabel setText:nametext];
        NSRange range = [nametext rangeOfString:retweetStatus.user.name];
        [_retweetNameLabel addCustomLink:[NSValue valueWithRange:range]
                    forRange:range
                   linkColor:IWRetweetNameColor];
        
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
    
    // 9.给dock传递微博模型数据
    _dock.contentFrame = contenFrame;
    [_dock setFrame:contenFrame.dockFrame];
}

#pragma mark - 收起or展开
- (void)openupisok:(UIButton*)but
{
    if ([but.titleLabel.text isEqualToString:@"收起"]) {
        self.openupBlock(NO);
        
    }else if ([but.titleLabel.text isEqualToString:@"展开"]){
        self.openupBlock(YES);
    }
}


#pragma mark - 赞
- (void)attitudeBtnClick:(UIButton*)but event:(id)event
{
    [but setEnabled:NO];
    WLStatusM *statM;
    if (_statusFrame) {
        
        statM = _statusFrame.status;
    }else if(_commentFrame){
        
        statM = _commentFrame.status;
    }
        if (statM.iszan==1) {
            NSMutableArray *zans = [NSMutableArray arrayWithArray:statM.zansArray];
            UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
            
            for (FeedAndZanModel *zanM in statM.zansArray) {
                if ([zanM.user.uid integerValue] == [mode.uid integerValue]) {
                    [zans removeObject:zanM];
                }
            }
            [statM setZansArray:zans];
            [statM setIszan:0];
            statM.zan -= 1;
            
            [WLHttpTool deleteFeedZanParameterDic:@{@"fid":@(statM.fid)} success:^(id JSON) {
                [but setEnabled:YES];
            } fail:^(NSError *error) {
                [but setEnabled:YES];
            }];
        }else{
            NSMutableArray *zans = [NSMutableArray arrayWithArray:statM.zansArray];
            FeedAndZanModel *zanmodel = [[FeedAndZanModel alloc] init];
            [zanmodel setUser:[[UserInfoTool sharedUserInfoTool] getUserInfoModel]];
            [zans insertObject:zanmodel atIndex:0];
            [statM setZansArray:zans];
            [statM setIszan:1];
            statM.zan +=1;
            [WLHttpTool addFeedZanParameterDic:@{@"fid":@(statM.fid)} success:^(id JSON) {
                [but setEnabled:YES];
            } fail:^(NSError *error) {
                [but setEnabled:YES];
            }];
        }
    
    if (self.feedzanBlock) {
        self.feedzanBlock (statM);
    }
}

#pragma mark - 转发
#warning  - +——+——+————+-=——+——++——+——+——+——转发
- (void)transmitButClick:(UIButton*)but event:(id)event
{
    WLStatusM *statusM = _statusFrame.status;
    if (!statusM) {
        statusM = _commentFrame.status;
    }
    PublishStatusController *publishVC = [[PublishStatusController alloc] initWithType:PublishTypeForward];
    [publishVC setStatus:statusM];
    [self.homeVC presentViewController:[[NavViewController alloc] initWithRootViewController:publishVC] animated:YES completion:^{
        
    }];

//    NSArray *shareButtonTitleArray = [[NSArray alloc] init];
//    NSArray *shareButtonImageNameArray = [[NSArray alloc] init];
//    shareButtonTitleArray = @[@"微链动态",@"微信好友",@"微信朋友圈"];
//    shareButtonImageNameArray = @[@"home_repost_welian",@"home_repost_wechat",@"home_repost_friendcirle"];
//    LXActivity *lxActivity = [[LXActivity alloc] initWithDelegate:self ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
//    
//    [lxActivity showInView:self.window];
}

//#pragma mark - LXActivityDelegate
//- (void)didClickOnImageIndex:(NSInteger)imageIndex
//{
//    WLStatusM *statusM = self.statusFrame.status;
//    if (!self.statusFrame) {
//        statusM = self.commentFrame.status;
//    }
//    
//    NSString *name = [NSString stringWithFormat:@"%@在微链上说",statusM.user.name];
//    if (imageIndex == 0) {  // weLian
//        
//        PublishStatusController *publishVC = [[PublishStatusController alloc] initWithType:PublishTypeForward];
//        [publishVC setStatus:statusM];
//        [self.homeVC presentViewController:[[NavViewController alloc] initWithRootViewController:publishVC] animated:YES completion:^{
//            
//        }];
//        
//    }else if (imageIndex == 1){  // 微信好友
//        [[ShareEngine sharedShareEngine] sendWeChatMessage:name andDescription:statusM.content WithUrl:statusM.shareurl andImage:nil WithScene:weChat];
//        
//    }else if (imageIndex == 2){  // 微信朋友圈
//        [[ShareEngine sharedShareEngine] sendWeChatMessage:name andDescription:statusM.content WithUrl:statusM.shareurl andImage:nil WithScene:weChatFriend];
//        
//    }else if (imageIndex == 3){  // 新浪微博
//        
//    }
//}

- (void)m80AttributedLabel:(M80AttributedLabel *)label clickedOnLink:(id)linkData
{
    WLBasicTrends *status = _statusFrame.status.relationfeed.user;
    UserInfoModel *mode = [[UserInfoModel alloc] init];
    [mode setName:status.name];
    [mode setAvatar:status.avatar];
    [mode setUid:status.uid];
    UserInfoBasicVC *userinfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:mode isAsk:NO];
    [self.homeVC.navigationController pushViewController:userinfoVC animated:YES];
}

//- (LinkedStringTapHandler)exampleHandlerWithTitle:(NSString *)title
//{
//    LinkedStringTapHandler exampleHandler = ^(NSString *linkedString) {
//        WLBasicTrends *status = _statusFrame.status.relationfeed.user;
//        UserInfoModel *mode = [[UserInfoModel alloc] init];
//        [mode setName:status.name];
//        [mode setAvatar:status.avatar];
//        [mode setUid:status.uid];
//        UserInfoBasicVC *userinfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:mode isAsk:NO];
//        [self.homeVC.navigationController pushViewController:userinfoVC animated:YES];
//    };
//    return exampleHandler;
//}
//
//
//
//- (NSMutableDictionary *)exampleAttributes
//{
//    return [@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
//              NSForegroundColorAttributeName:IWRetweetNameColor}mutableCopy];
//}


- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type
{
    if (type == MLEmojiLabelLinkTypeURL) {
        TOWebViewController *webVC = [[TOWebViewController alloc] initWithURLString:link];
        [webVC setShowActionButton:NO];
        [self.homeVC.navigationController pushViewController:webVC animated:YES];
    }
}

@end
