//
//  MessageFrameModel.h
//  weLian
//
//  Created by dong on 14/11/13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageHomeModel.h"

@interface MessageFrameModel : NSObject

@property (nonatomic, assign) CGRect iconImageF;
@property (nonatomic, assign) CGRect nameLabelF;
@property (nonatomic, assign) CGRect commentLabelF;
@property (nonatomic, assign) CGRect timeLabelF;
@property (nonatomic, assign) CGRect photImageF;
@property (nonatomic, assign) CGRect trendsLabelF;
@property (nonatomic, assign) CGRect zanfeedImageF;

@property (nonatomic, assign) CGFloat cellHigh;

@property (nonatomic, strong) MessageHomeModel *messageDataM;

@end
