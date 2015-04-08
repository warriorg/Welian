//
//  MessageCell.h
//  weLian
//
//  Created by dong on 14/11/13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageFrameModel.h"
#import "BaseTableViewCell.h"

@interface MessageCell : BaseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) MessageFrameModel *messageFrameModel;

@end
