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
#import "UserInfoBasicVC.h"
#import "PublishStatusController.h"
#import "NavViewController.h"
#import "ShareEngine.h"
#import "CommentInfoController.h"
#import "CommentHeadFrame.h"
#import "TOWebViewController.h"
#import "MJExtension.h"
#import "M80AttributedLabel.h"
//#import "ActivityViewController.h"
#import "ActivityDetailViewController.h"
#import "WLCellCardView.h"
#import "ActivityDetailInfoViewController.h"
#import "ProjectDetailsViewController.h"

@interface WLContentCellView () <MLEmojiLabelDelegate,M80AttributedLabelDelegate>
{
    /** 内容 */
    MLEmojiLabel *_contentLabel;
    /** 配图 */
    WLPhotoListView *_photoListView;
    // 项目和活动
    WLCellCardView *_cellCardView;
}

@end

@implementation WLContentCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.添加原创微博的子控件
        [self setupOriginalSubviews];
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
    _contentLabel.font = WLFONT(15);
    _contentLabel.textColor = WLRGB(51, 51, 51);
    _contentLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentLabel];
    // 长按手势 复制
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerHandle:)];
    [recognizer setMinimumPressDuration:0.4f];
    [_contentLabel addGestureRecognizer:recognizer];
    
    // 6.配图
    _photoListView = [[WLPhotoListView alloc] init];
    [self addSubview:_photoListView];
    
    // 活动和项目
    _cellCardView = [[WLCellCardView alloc] init];
    [_cellCardView.tapBut addTarget:self action:@selector(projectAndActivityBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cellCardView];
    
    // 添加工具条
    _dock = [[WLStatusDock alloc] init];
    // 赞
    [_dock.attitudeBtn addTarget:self action:@selector(attitudeBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    
    [_dock.repostBtn addTarget:self action:@selector(transmitButClick:event:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dock];
}

#pragma mark - Copying Method
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [super becomeFirstResponder];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copyText:));
}
//针对于copy的实现
-(void)copyText:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    if (_statusFrame) {
        WLStatusM *status = _statusFrame.status;
        pboard.string = status.content;
    }else if(_commentFrame){
        WLStatusM *status = _commentFrame.status;
        pboard.string = status.content;
    }
    
}

- (void)longPressGestureRecognizerHandle:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (longPressGestureRecognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
        return;
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyText:)];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:@[copyItem]];
    CGRect targetRect = [self convertRect:_contentLabel.frame
                                 fromView:self];
    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    [menu setMenuVisible:YES animated:YES];
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
    if (status.type==6||status.type==5||status.type==12) {
        _contentLabel.hidden = YES;
        _photoListView.hidden = YES;
    }else{
        _contentLabel.hidden = NO;
        // 3.正文
        _contentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _contentLabel.customEmojiPlistName = @"expressionImage_custom";
        CGRect textFrame = contenFrame.contentLabelF;
        
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
    }
    
    if (status.card) {
        _cellCardView.hidden = NO;
        _cellCardView.frame = contenFrame.cellCardF;
        _cellCardView.cardM = status.card;
    }else{
        _cellCardView.hidden = YES;
    }
    
    BOOL isDock = YES;
    if (status.type==4||status.type==5||status.type==6||status.type==12) {
        isDock = NO;
    }
    
    if (isDock) {
        [_dock setHidden:NO];
        // 9.给dock传递微博模型数据
        _dock.contentFrame = contenFrame;
        [_dock setFrame:contenFrame.dockFrame];
    }else{
        [_dock setHidden:YES];
    }
    
}

#pragma mark - 项目或活动点击
- (void)projectAndActivityBtnClick:(UIButton*)but event:(id)event
{
    CardStatuModel *card = self.statusFrame.status.card;
    if (card.type.integerValue == 3||card.type.integerValue == 5) {   // 活动
        
        //查询本地有没有该活动
        ActivityInfo *activityInfo = [ActivityInfo getActivityInfoWithActiveId:card.cid Type:@(0)];
        ActivityDetailInfoViewController *activityInfoVC = nil;
        if(activityInfo){
            activityInfoVC = [[ActivityDetailInfoViewController alloc] initWithActivityInfo:activityInfo];
        }else{
            activityInfoVC = [[ActivityDetailInfoViewController alloc] initWIthActivityId:card.cid];
        }
        if (activityInfoVC) {
            [self.homeVC.navigationController pushViewController:activityInfoVC animated:YES];
        }
        
    }else if (card.type.integerValue ==10||card.type.integerValue==12){ // 项目
        
        //查询数据库是否存在
        ProjectInfo *projectInfo = [ProjectInfo getProjectInfoWithPid:card.cid Type:@(0)];
        ProjectDetailsViewController *projectDetailVC = nil;
        if (projectInfo) {
            projectDetailVC = [[ProjectDetailsViewController alloc] initWithProjectInfo:projectInfo];
        }else{
            IProjectInfo *iProjectInfo = [[IProjectInfo alloc] init];
            iProjectInfo.name = card.title;
            iProjectInfo.pid = card.cid;
            iProjectInfo.intro = card.intro;
            projectDetailVC = [[ProjectDetailsViewController alloc] initWithIProjectInfo:iProjectInfo];
        }
        if (projectDetailVC) {
            [self.homeVC.navigationController pushViewController:projectDetailVC animated:YES];
        }
        
    }else if (card.type.integerValue == 11){  // 网页
        //普通链接
        TOWebViewController *webVC = [[TOWebViewController alloc] initWithURLString:card.url];
        [webVC setShowActionButton:NO];
        webVC.navigationButtonsHidden = YES;//隐藏底部操作栏目
        webVC.showRightShareBtn = YES;//现实右上角分享按钮
        [self.homeVC.navigationController pushViewController:webVC animated:YES];
    }else if (card.type.integerValue==4||card.type.integerValue==6){   // 个人信息
        UserInfoModel *mode = [[UserInfoModel alloc] init];
        WLBasicTrends *user = self.statusFrame.status.user?self.statusFrame.status.user:self.commentFrame.status.user;
        [mode setUid:user.uid];
        [mode setAvatar:user.avatar];
        [mode setName:user.name];
        
        UserInfoBasicVC *userinfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:mode isAsk:NO];
        [self.homeVC.navigationController pushViewController:userinfoVC animated:YES];
    }
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
    NSMutableArray *zans = [NSMutableArray arrayWithArray:statM.zansArray];
    LogInUser *mode = [LogInUser getCurrentLoginUser];
        if (statM.iszan==1) {
            
            for (UserInfoModel *zanM in statM.zansArray) {
                if ([zanM.uid integerValue] == [mode.uid integerValue]) {
                    [zans removeObject:zanM];
                }
            }
            [statM setZansArray:zans];
            [statM setIszan:0];
            statM.zan -= 1;
            
            [WLHttpTool deleteFeedZanParameterDic:@{@"fid":@(statM.topid)} success:^(id JSON) {
                [but setEnabled:YES];
            } fail:^(NSError *error) {
                [but setEnabled:YES];
            }];
        }else{
            [zans insertObject:mode atIndex:0];
            [statM setZansArray:zans];
            [statM setIszan:1];
            statM.zan +=1;
            [WLHttpTool addFeedZanParameterDic:@{@"fid":@(statM.topid)} success:^(id JSON) {
                [but setEnabled:YES];
            } fail:^(NSError *error) {
                [but setEnabled:YES];
            }];
        }
    
    if (self.feedzanBlock) {
        self.feedzanBlock (statM);
    }
}

#pragma mark - 转推
#warning  - +——+——+————+-=——+——++——+——+——+——转推
- (void)transmitButClick:(UIButton*)but event:(id)event
{
    [but setEnabled:NO];
    WLStatusM *statM;
    if (_statusFrame) {
        
        statM = _statusFrame.status;
    }else if(_commentFrame){
        
        statM = _commentFrame.status;
    }
    NSMutableArray *forwards = [NSMutableArray arrayWithArray:statM.forwardsArray];
//    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    LogInUser *mode = [LogInUser getCurrentLoginUser];
    if (statM.isforward==1) {
        
        for (UserInfoModel *forwardM in statM.forwardsArray) {
            if ([forwardM.uid integerValue] == [mode.uid integerValue]) {
                [forwards removeObject:forwardM];
            }
        }
        [statM setForwardsArray:forwards];
        [statM setIsforward:0];
        statM.forwardcount -= 1;
        
        [WLHttpTool deleteFeedForwardParameterDic:@{@"fid":@(statM.topid)} success:^(id JSON) {
            [but setEnabled:YES];
        } fail:^(NSError *error) {
            [but setEnabled:YES];
        }];
    }else{
        [forwards insertObject:mode atIndex:0];
        [statM setForwardsArray:forwards];
        [statM setIsforward:1];
        statM.forwardcount +=1;
        [WLHttpTool forwardFeedParameterDic:@{@"fid":@(statM.topid)} success:^(id JSON) {
            [WLHUDView showCustomHUD:@"已转推给你的好友！" imageview:nil];
            [but setEnabled:YES];
        } fail:^(NSError *error) {
            [but setEnabled:YES];
        }];
    }
    
    if (self.feedTuiBlock) {
        self.feedTuiBlock (statM);
    }
}

- (void)m80AttributedLabel:(M80AttributedLabel *)label clickedOnLink:(id)linkData
{
    
}

- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type
{
    if (type == MLEmojiLabelLinkTypeURL) {
        WLStatusM *wlStatusM = nil;
        if (_statusFrame) {
            wlStatusM = _statusFrame.status;
        }
        if (_commentFrame) {
            wlStatusM = _commentFrame.status;
        }
        
        if (wlStatusM) {
            //活动动态
            if (wlStatusM.type == 3) {
                NSArray *info = [link componentsSeparatedByString:@"#"];
                NSString *sessionId = [info lastObject];
                //活动页面，进行phoneGap页面加载
//                ActivityDetailViewController *activityDetailVC = [[ActivityDetailViewController alloc] init];
//                activityDetailVC.wwwFolderName = @"www";
//                activityDetailVC.startPage = [NSString stringWithFormat:@"activity_detail.html?%@?t=%@",sessionId,[NSString getNowTimestamp]];//sessionId
//                [self.homeVC.navigationController pushViewController:activityDetailVC animated:YES];
                
                //查询本地有没有该活动
                ActivityInfo *activityInfo = [ActivityInfo getActivityInfoWithActiveId:@(sessionId.integerValue) Type:@(0)];
                ActivityDetailInfoViewController *activityInfoVC = nil;
                if(activityInfo){
                    activityInfoVC = [[ActivityDetailInfoViewController alloc] initWithActivityInfo:activityInfo];
                }else{
                    activityInfoVC = [[ActivityDetailInfoViewController alloc] initWIthActivityId:@(sessionId.integerValue)];
                }
                if (activityInfoVC) {
                    [self.homeVC.navigationController pushViewController:activityInfoVC animated:YES];
                }
            }else{
                //普通链接
                TOWebViewController *webVC = [[TOWebViewController alloc] initWithURLString:link];
                [webVC setShowActionButton:NO];
                webVC.navigationButtonsHidden = YES;//隐藏底部操作栏目
                webVC.showRightShareBtn = YES;//现实右上角分享按钮
                [self.homeVC.navigationController pushViewController:webVC animated:YES];
            }
        }
    }
}

@end
