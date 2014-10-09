//
//  WorksListController.h
//  Welian
//
//  Created by dong on 14-9-14.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "BasicTableViewController.h"

typedef enum {
    WLSchool = 0,   // 教育
    WLCompany = 1,  // 工作
} WLUserLoadType;


@interface WorksListController : BasicTableViewController

@property (nonatomic, assign) WLUserLoadType wlUserLoadType;

@end
