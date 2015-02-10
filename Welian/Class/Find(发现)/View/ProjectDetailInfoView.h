//
//  ProjectDetailInfoView.h
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ProjectDetailInfoClosedBlock)(void);

@interface ProjectDetailInfoView : UIView

@property (strong,nonatomic) IProjectDetailInfo *projectDetailInfo;
@property (strong,nonatomic) ProjectDetailInfoClosedBlock closeBlock;

@end
