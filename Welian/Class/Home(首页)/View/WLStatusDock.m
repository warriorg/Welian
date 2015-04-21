//
//  WLStatusDock.m
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLStatusDock.h"
#import "WLStatusM.h"
#import "UIImage+ImageEffects.h"
#import "WLContentCellFrame.h"

@interface WLStatusDock ()
{
    UILabel *_timeLabel;
}
@end

@implementation WLStatusDock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //0.添加时间
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = kNormal12Font;
        _timeLabel.textColor = WLRGB(173, 173, 173);
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_timeLabel];
        
        // 重新发送
        _sendAgainBtn = [[UIButton alloc] init];
        [_sendAgainBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_sendAgainBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_sendAgainBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [_sendAgainBtn setTitle:@"发送中..." forState:UIControlStateDisabled];
        [_sendAgainBtn.titleLabel setFont:kNormal14Font];
        [self addSubview:_sendAgainBtn];
        
        // 1.添加赞
        _attitudeBtn = [self addBtn:@"赞" image:@"me_mywriten_good"];
        
        // 2.添加评论
        _commentBtn = [self addBtn:@"评论" image:@"me_mywriten_comment"];
        
        // 3.添加转发
        _repostBtn = [self addBtn:@"转推" image:@"me_mywriten_repeat"];
        [_repostBtn setImage:[UIImage imageNamed:@"me_mywriten_repeat_no"] forState:UIControlStateDisabled];
    }
    return self;
}

/**
 *  添加一个按钮
 *
 *  @param title      标题
 *  @param image      内部的小图标
 *  @param background 高亮背景
 *  @param index      按钮索引（0~2）
 */
- (UIButton *)addBtn:(NSString *)title image:(NSString *)image
{
    // 1.创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.adjustsImageWhenHighlighted = NO;
    
    // 3.设置图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        
    // 5.其他属性杂项
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    // 按钮文字
    [btn setTitle:title forState:UIControlStateNormal];
    
    btn.titleLabel.font = WLFONT(10);
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [self addSubview:btn];
    
    return btn;
}

/**
 *  在这里根据模型数据  设置 三个按钮的文字
 *
 *  @param status 模型数据
 */
- (void)setContentFrame:(WLContentCellFrame *)contentFrame
{
    _contentFrame = contentFrame;
    
    WLStatusM *status = contentFrame.status;
    //* 自己发送  重新发送 0无状态  1 重新发送  2 发送中... *//
    [_sendAgainBtn setFrame:CGRectMake(0, 0, contentFrame.dockFrame.size.width*0.4, contentFrame.dockFrame.size.height)];
    [_sendAgainBtn setHidden:!status.sendType];
    [_timeLabel setHidden:status.sendType];
    if (status.sendType==1) {
        [_sendAgainBtn setEnabled:YES];
    }else if (status.sendType ==2){
        [_sendAgainBtn setEnabled:NO];
    }
    
    
    // 0.设置时间
    [_timeLabel setText:status.created];
    [_timeLabel setFrame:CGRectMake(0, 0, contentFrame.dockFrame.size.width*0.3, contentFrame.dockFrame.size.height)];
    [_timeLabel setDebug:YES];
    
    // 1.设置赞数
    [self setBtn:_attitudeBtn title:@"赞" count:status.zan index:0];
    
    // 2.设置评论数
    [self setBtn:_commentBtn title:@"评论" count:status.commentcount index:1];
    
    // 3.设置转发数
    [self setBtn:_repostBtn title:@"转推" count:status.forwardcount index:2];
    
    
    if (status.iszan==1) { // 已赞
        [_attitudeBtn setImage:[UIImage imageNamed:@"me_mywriten_good_pre"] forState:UIControlStateNormal];
    }else {
        [_attitudeBtn setImage:[UIImage imageNamed:@"me_mywriten_good"] forState:UIControlStateNormal];
    }
//    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    LogInUser *mode = [LogInUser getCurrentLoginUser];
    if ([status.user.uid integerValue]==[mode.uid integerValue]) {
        [_repostBtn setEnabled:NO];
    }else{
        [_repostBtn setEnabled:YES];
        if (status.isforward == 1) { // 已推
            [_repostBtn setImage:[UIImage imageNamed:@"me_mywriten_repea_pre"] forState:UIControlStateNormal];
        }else{
            [_repostBtn setImage:[UIImage imageNamed:@"me_mywriten_repeat"] forState:UIControlStateNormal];
        }
    }
    // 推荐好友 不进详情
    if (status.type==2) {
        [_commentBtn setEnabled:NO];
    }else{
        [_commentBtn setEnabled:YES];
    }
}


/**
 *  设置按钮文字
 *
 *  @param btn   哪个按钮需要文字
 *  @param title 个数为0时 显示的字符串
 *  @param count 按钮显示的个数
 */
- (void)setBtn:(UIButton *)btn title:(NSString *)title count:(int)count index:(int)index
{
    // 0.设置按钮的frame
    CGFloat btnW = (_contentFrame.dockFrame.size.width*0.6)/ 3;
    CGFloat btnH = _contentFrame.dockFrame.size.height;
    CGFloat btnX = index * btnW+_contentFrame.dockFrame.size.width*0.4;
    btn.frame = CGRectMake(btnX, 0, btnW, btnH);
    
    // 1.得出title的内容
    if (count >= 10000) {
        NSString *old = [NSString stringWithFormat:@"%.1f万", count/10000.0];
        // 将.0换成空串
        title = [old stringByReplacingOccurrencesOfString:@".0" withString:@""];
    } else if (count != 0) {
        title = [NSString stringWithFormat:@"%d", count];
    }
    
    // 2.设置按钮文字
    [btn setTitle:title forState:UIControlStateNormal];
}



@end
