//
//  ProjectInfoView.h
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ProjectInfoClickedBlock)(void);
typedef void(^ProjectShowUserClickedBlock)(void);

@interface ProjectInfoView : UIView

@property (strong,nonatomic) IProjectInfo *iProjectInfo;
@property (strong,nonatomic) ProjectInfo *projectInfo;
@property (strong,nonatomic) ProjectDetailInfo *projectDetailInfo;
@property (strong,nonatomic) ProjectInfoClickedBlock infoBlock;
@property (strong,nonatomic) ProjectShowUserClickedBlock userShowBlock;

//获取页面的高度
+ (CGFloat)configureWithInfo:(ProjectDetailInfo *)detailInfo;
+ (CGFloat)configureWithProjectInfo:(ProjectInfo *)projectInfo;
+ (CGFloat)configureWithIProjectInfo:(IProjectInfo *)iProjectInfo;

@end
