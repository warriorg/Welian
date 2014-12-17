//
//  SchoolCompanyDate.h
//  Welian
//
//  Created by dong on 14/12/16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SchoolCompanyDate : NSManagedObject

//** 开始年**//
@property (nonatomic, retain) NSNumber * startyear;
//** 结束年**//
@property (nonatomic, retain) NSNumber * endyear;
//** 开始月**//
@property (nonatomic, retain) NSNumber * startmonth;
//** 结束月**//
@property (nonatomic, retain) NSNumber * endmonth;

@end
