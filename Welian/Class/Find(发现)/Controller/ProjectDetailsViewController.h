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

- (instancetype)initWithProjectInfo:(IProjectInfo *)projectInfo;
- (instancetype)initWithProjectPid:(NSNumber *)projectPid;

- (instancetype)initWithProjectDetailInfo:(IProjectDetailInfo *)detailInfo;

@end
