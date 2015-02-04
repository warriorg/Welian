//
//  ProjectUserListViewController.h
//  Welian
//
//  Created by weLian on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BasicPlainTableViewController.h"

typedef enum{
    UserInfoTypeProjectZan = 0,
    UserInfoTypeProjectGroup
} UserInfoType;

@interface ProjectUserListViewController : BasicPlainTableViewController

@property (assign,nonatomic) UserInfoType infoType;

@end
