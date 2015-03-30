//
//  WorksListController.h
//  Welian
//
//  Created by dong on 14-9-14.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WLSchool = 1,   // 教育
    WLCompany = 2,  // 工作
} WLUserLoadType;


@interface WorksListController : UIViewController

- (instancetype)init;

@end
