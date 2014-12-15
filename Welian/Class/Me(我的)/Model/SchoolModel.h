//
//  SchoolModel.h
//  Welian
//
//  Created by dong on 14-9-20.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "SchoolCompanyDate.h"

@interface SchoolModel : SchoolCompanyDate
/**  学校id   */
@property (nonatomic, assign) NSInteger schoolid;
/**  学校名称   */
@property (nonatomic, strong) NSString *schoolname;

/**  usid   */
@property (nonatomic, assign) NSInteger usid;

/**  专业名称   */
@property (nonatomic, strong) NSString *specialtyname;

/**  专业id   */
@property (nonatomic, assign) NSInteger specialtyid;

@end
