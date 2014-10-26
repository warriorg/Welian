//
//  HaderInfoCell.h
//  weLian
//
//  Created by dong on 14/10/21.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HaderInfoCell : UITableViewCell

@property (nonatomic, strong) UserInfoModel *userM;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
