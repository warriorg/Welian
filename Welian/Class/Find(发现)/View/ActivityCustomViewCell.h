//
//  ActivityCustomViewCell.h
//  Welian
//
//  Created by weLian on 15/2/12.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCustomViewCell : UITableViewCell

@property (assign,nonatomic) BOOL showCustomInfo;

//返回cell的高度
+ (CGFloat)configureWithMsg:(NSString *)msg hasArrowImage:(BOOL)hasArrowImage;

@end
