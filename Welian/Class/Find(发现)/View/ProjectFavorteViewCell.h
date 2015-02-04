//
//  ProjectFavorteViewCell.h
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void(^ProjectFavorteClickedBlock)(NSIndexPath *indexPath);

@interface ProjectFavorteViewCell : BaseTableViewCell

@property (strong,nonatomic) IProjectDetailInfo *projectInfo;
@property (strong,nonatomic) ProjectFavorteClickedBlock block;

@end
