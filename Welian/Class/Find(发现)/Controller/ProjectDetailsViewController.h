//
//  ProjectDetailsViewController.h
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BasicViewController.h"

@interface ProjectDetailsViewController : BasicViewController

- (instancetype)initWithProjectInfo:(IProjectInfo *)projectInfo;
- (instancetype)initWithProjectPid:(NSNumber *)projectPid;

@end
