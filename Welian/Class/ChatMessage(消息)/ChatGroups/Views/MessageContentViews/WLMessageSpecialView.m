//
//  WLMessageSpecialView.m
//  Welian
//
//  Created by weLian on 14/12/31.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLMessageSpecialView.h"
#import "WLMessageBubbleHelper.h"

@interface WLMessageSpecialView ()

@end

@implementation WLMessageSpecialView


/**
 *  初始化消息内容显示控件的方法
 *
 *  @param frame   目标Frame
 *  @param message 目标消息Model对象
 *
 *  @return 返回XHMessageBubbleView类型的对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                      message:(id <WLMessageModel>)message{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _message = message;
        
        self.backgroundColor = RGB(213.f, 214.f, 216.f);
        
        
    }
    return self;
}


@end
