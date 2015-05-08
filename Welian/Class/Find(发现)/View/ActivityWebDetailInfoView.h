//
//  ActivityWebDetailInfoView.h
//  Welian
//
//  Created by weLian on 15/5/8.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^backToMainViewBlock)(void);

@interface ActivityWebDetailInfoView : UIView

@property (assign,nonatomic) BOOL isShow;
@property (strong,nonatomic) NSString *urlStr;
@property (strong,nonatomic) backToMainViewBlock backBlock;

@end
