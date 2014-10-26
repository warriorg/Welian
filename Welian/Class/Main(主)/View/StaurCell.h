//
//  StaurCell.h
//  weLian
//
//  Created by dong on 14/10/21.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLStatusM.h"

@interface StaurCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *oneImage;

@property (weak, nonatomic) IBOutlet UIImageView *twoImage;

@property (weak, nonatomic) IBOutlet UIImageView *threeImage;

@property (nonatomic, strong) WLStatusM *statusM;

@end
