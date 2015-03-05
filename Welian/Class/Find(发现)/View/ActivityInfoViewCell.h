//
//  ActivityInfoViewCell.h
//  Welian
//
//  Created by weLian on 15/2/12.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActivityDetailInfoBlock)(void);

@interface ActivityInfoViewCell : UITableViewCell

@property (strong,nonatomic) ActivityDetailInfoBlock block;


//返回cell的高度
+ (CGFloat)configureWithTitle:(NSString *)title Msg:(NSString *)msg;

@end
