//
//  WLNoteInfoView.h
//  Welian
//
//  Created by weLian on 15/3/27.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loadFailedBlock)(void);

@interface WLNoteInfoView : UIView

@property (assign,nonatomic) BOOL isLoaded;//加载完成
@property (strong,nonatomic) NSString *noteInfo;//提醒信息
@property (assign,nonatomic) BOOL loadFailed;//加载失败

@property (strong,nonatomic) loadFailedBlock reloadBlock;

@end
