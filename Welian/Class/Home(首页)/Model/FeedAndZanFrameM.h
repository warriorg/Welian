//
//  FeedAndZanFrameM.h
//  weLian
//
//  Created by dong on 14/11/13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedAndZanModel.h"

@interface FeedAndZanFrameM : NSObject

@property (nonatomic, assign) CGRect zanImageF;
@property (nonatomic, assign) CGRect zanLabelF;
@property (nonatomic, assign) CGRect feedImageF;
@property (nonatomic, assign) CGRect feedLabelF;

@property (nonatomic, assign) CGFloat cellHigh;

@property (nonatomic, strong) NSMutableString *zanNameStr;
@property (nonatomic, strong) NSMutableString *feedNameStr;

@property (nonatomic, strong) NSDictionary *feedAndzanDic;
@end
