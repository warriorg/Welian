//
//  ProjectViewCell.h
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ProjectViewCell : BaseTableViewCell

@property (strong,nonatomic) IProjectInfo *iProjectInfo;
@property (strong,nonatomic) ProjectInfo *projectInfo;

@end
