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
#import "ActivityViewController.h"

@interface WLContentCellView () <MLEmojiLabelDelegate,M80AttributedLabelDelegate>
{
    /** 内容 */
    MLEmojiLabel *_contentLabel;
    /** 配图 */
    WLPhotoListView *_photoListView;
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
    
    BOOL isDock = NO;
    if (status.content || status.photos.count) {
        isDock = YES;
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
    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
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
    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
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
            wlStatusM = _statusFrame.status;
        }
        
        if (wlStatusM) {
            //活动动态
            if (wlStatusM.type == 3) {
                NSArray *info = [link componentsSeparatedByString:@"/"];
                NSString *sessionId = [info lastObject];
                //活动页面，进行phoneGap页面加载
                ActivityViewController *activityVC = [[ActivityViewController alloc] init];
                activityVC.title = @"活动详情";
                activityVC.wwwFolderName = @"www";
                activityVC.startPage = [NSString stringWithFormat:@"activity_detail.html?%@",sessionId];
                [self.homeVC.navigationController pushViewController:activityVC animated:YES];
            }else{
                //普通链接
                TOWebViewController *webVC = [[TOWebViewController alloc] initWithURLString:link];
                [webVC setShowActionButton:NO];
                webVC.navigationButtonsHidden = YES;//隐藏底部操作栏目
                [self.homeVC.navigationController pushViewController:webVC animated:YES];
            }
        }
    }
}

@end
