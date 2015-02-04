//
//  CreateProjectController.h
//  Welian
//
//  Created by dong on 15/1/30.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BasicViewController.h"
#import "CreateProjectModel.h"

@interface CreateProjectController : BasicViewController

@property (nonatomic, strong) CreateProjectModel *projectModel;

- (instancetype)initIsEdit:(BOOL)isEdit;

@end
