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

- (instancetype)initWithWidth:(CGFloat)width;

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign, readonly) CGRect zanImageF;
@property (nonatomic, assign, readonly) CGRect zanLabelF;
@property (nonatomic, assign, readonly) CGRect feedImageF;
@property (nonatomic, assign, readonly) CGRect feedLabelF;

@property (nonatomic, assign, readonly) CGFloat cellHigh;

@property (nonatomic, strong, readonly) NSMutableString *zanNameStr;
@property (nonatomic, strong, readonly) NSMutableString *feedNameStr;

@property (nonatomic, strong) NSDictionary *feedAndzanDic;
@end
