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

@interface WLStatusDock ()
{
    UIButton *_repostBtn;
    UIButton *_commentBtn;
    UIButton *_attitudeBtn;
}
@end

@implementation WLStatusDock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizedImage:@"timeline_card_bottom_background"];
        
        // 0.顶部添加分割线
        UIView *divider = [[UIView alloc] init];
        divider.frame = CGRectMake(0, 0, frame.size.width, 0.5);
        divider.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:divider];
        
        // 1.添加转发
        _repostBtn = [self addBtn:@"转发" image:@"me_mywriten_repeat" background:@"timeline_card_leftbottom_highlighted" index:0];
        // 2.添加评论
        _commentBtn = [self addBtn:@"评论" image:@"me_mywriten_comment" background:@"timeline_card_middlebottom_highlighted" index:1];
        // 3.添加赞
        _attitudeBtn = [self addBtn:@"赞" image:@"me_mywriten_good" background:@"timeline_card_rightbottom_highlighted" index:2];
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
- (UIButton *)addBtn:(NSString *)title image:(NSString *)image background:(NSString *)background index:(int)index
{
    // 1.创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btn.adjustsImageWhenDisabled = NO;
    btn.adjustsImageWhenHighlighted = NO;
    
    // 2.设置按钮的frame
    CGFloat btnW = self.frame.size.width / 3;
    CGFloat btnH = self.frame.size.height;
    CGFloat btnX = index * btnW;
    btn.frame = CGRectMake(btnX, 0, btnW, btnH);
    
    // 3.设置图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    // 4.设置背景
    [btn setBackgroundImage:[UIImage resizedImage:background] forState:UIControlStateHighlighted];
    
    // 5.其他属性杂项
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 按钮文字
    [btn setTitle:title forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self addSubview:btn];
    
    // 6.添加分割线
    if (index != 0) { // 当是评论、赞按钮的时候，添加分割线
        UIImageView *divider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line"]];
        //        divider.backgroundColor = [UIColor redColor];
        CGFloat centerY = btnH * 0.5;
        CGFloat centerX = btnX;
        divider.center = CGPointMake(centerX, centerY);
        [self addSubview:divider];
    }
    
    return btn;
}

/**
 *  在这里根据模型数据  设置 三个按钮的文字
 *
 *  @param status 模型数据
 */
- (void)setStatus:(WLStatusM *)status
{
    _status = status;
    
    // 1.设置转发数
    [self setBtn:_repostBtn title:@"转发" count:status.forwardcount];
    
    // 2.设置评论数
    [self setBtn:_commentBtn title:@"评论" count:status.commentcount];
    
    // 3.设置赞数
    [self setBtn:_attitudeBtn title:@"赞" count:status.zan];
}

/**
 *  设置按钮文字
 *
 *  @param btn   哪个按钮需要文字
 *  @param title 个数为0时 显示的字符串
 *  @param count 按钮显示的个数
 */
- (void)setBtn:(UIButton *)btn title:(NSString *)title count:(int)count
{
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
