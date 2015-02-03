//
//  WLPhotoListView.h
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLPhotoListView : UIView

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) BOOL needAutoSize;//是否需要根据屏幕宽度计算大小

+ (CGSize)photoListSizeWithCount:(NSArray *)count needAutoSize:(BOOL)needAutoSize;

@end
