//
//  FeedAndZanCell.h
//  weLian
//
//  Created by dong on 14/11/13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedAndZanFrameM.h"

@interface FeedAndZanCell : UITableViewCell

@property (nonatomic, strong) FeedAndZanFrameM *feedAndZanFrame;

@property (nonatomic, weak) UIViewController *commentVC;

@end
