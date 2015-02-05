//
//  MemberProjectController.h
//  Welian
//
//  Created by dong on 15/1/30.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BasicViewController.h"
#import "CreateProjectModel.h"

@interface MemberProjectController : BasicViewController
@property (nonatomic, strong) NSMutableArray *selectArray;

- (instancetype)initIsEdit:(BOOL)isEdit withData:(CreateProjectModel *)projectModel;

@end
