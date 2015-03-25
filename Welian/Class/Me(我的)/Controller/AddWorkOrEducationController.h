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
@class SchoolModel;
@class CompanyModel;

typedef void (^RecordBlock)(void);

@interface AddWorkOrEducationController : BasicTableViewController

- (id)initWithStyle:(UITableViewStyle)style withType:(int)wlUserLoadType isNew:(BOOL)isNew;
@property (nonatomic, strong) SchoolModel *coerSchoolM;
@property (nonatomic, strong) CompanyModel *coerCompanyM;

@property (nonatomic, strong) ISchoolResult *schoolM;
@property (nonatomic, strong) ICompanyResult *companyM;

@property (nonatomic, copy) RecordBlock recorBlock;

@end
