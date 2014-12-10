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

+ (CGSize)photoListSizeWithCount:(NSArray *)count;

@end
