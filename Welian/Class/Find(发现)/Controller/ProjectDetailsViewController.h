//
//  ProjectDetailsViewController.h
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BasicViewController.h"

typedef void (^ProjectFavoriteBlock)(void);

@interface ProjectDetailsViewController : BasicViewController

@property (nonatomic, strong) ProjectFavoriteBlock favoriteBlock;

//通过I模型展示
- (instancetype)initWithIProjectInfo:(IProjectInfo *)iProjectInfo;
//通过数据库模型展示
- (instancetype)initWithProjectInfo:(ProjectInfo *)projectInfo;
//通过pid查询
- (instancetype)initWithProjectPid:(NSNumber *)projectPid;

- (instancetype)initWithProjectDetailInfo:(IProjectDetailInfo *)detailInfo;

@end
