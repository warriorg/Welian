//
//  BiaoQianView.h
//  Athena
//
//  Created by 张艳东 on 14-7-9.
//  Copyright (c) 2014年 souche. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BiaoQianView;

@protocol BiaoQianViewDelegate <NSObject>

- (void)biaoQianView:(BiaoQianView*)biaoqian selectBiaoqian:(NSString *)selectString;

@end

@interface BiaoQianView : UIView
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) id<BiaoQianViewDelegate>delegate;

@end
