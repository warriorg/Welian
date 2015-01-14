//
//  InvestorUserCell.h
//  weLian
//
//  Created by dong on 14-10-16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestorUserCell : UITableViewCell

//** 头像图片 *//
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

//** 姓名 *//
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//** 职务 和 公司 *//
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

//** 投资案例 *//
@property (weak, nonatomic) IBOutlet UILabel *caseLabel;

@property (weak, nonatomic) IBOutlet UIImageView *investorauthImage;

@end
