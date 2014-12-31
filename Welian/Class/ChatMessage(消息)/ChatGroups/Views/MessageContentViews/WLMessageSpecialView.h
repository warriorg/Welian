//
//  WLMessageSpecialView.h
//  Welian
//
//  Created by weLian on 14/12/31.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

// Model
#import "WLMessage.h"

#import "SETextView.h"

@interface WLMessageSpecialView : UIView

//目标消息Model对象
@property (nonatomic, strong, readonly)  id <WLMessageModel> message;

//自定义显示文本消息控件，子类化的原因有两个，第一个是屏蔽Menu的显示。第二是传递手势到下一层，因为文本需要双击的手势
@property (nonatomic, weak, readonly) SETextView *specialTextView;



/**
 *  初始化消息内容显示控件的方法
 *
 *  @param frame   目标Frame
 *  @param message 目标消息Model对象
 *
 *  @return 返回XHMessageBubbleView类型的对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                      message:(id <WLMessageModel>)message;

@end
