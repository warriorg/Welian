//
//  AddWorkOrEducationController.h
//  Welian
//
//  Created by dong on 14-9-15.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "BasicTableViewController.h"
@class ISchoolResult;
@class ICompanyResult;

@interface AddWorkOrEducationController : BasicTableViewController

- (id)initWithStyle:(UITableViewStyle)style withType:(int)wlUserLoadType;
@property (nonatomic, strong) ISchoolResult *schoolM;
@property (nonatomic, strong) ICompanyResult *companyM;

@end
