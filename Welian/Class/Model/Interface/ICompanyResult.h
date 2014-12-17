//
//  ICompanyResult.h
//  Welian
//
//  Created by dong on 14/12/17.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface ICompanyResult : IFBase

/**  企业id   */
@property (nonatomic, retain) NSNumber * companyid;
/**  企业名称   */
@property (nonatomic, retain) NSString * companyname;
/**  职位id   */
@property (nonatomic, retain) NSNumber * jobid;
/**  职位名称   */
@property (nonatomic, retain) NSString * jobname;
/**  ucid   */
@property (nonatomic, retain) NSNumber * ucid;

//** 开始年**//
@property (nonatomic, retain) NSNumber * startyear;
//** 结束年**//
@property (nonatomic, retain) NSNumber * endyear;
//** 开始月**//
@property (nonatomic, retain) NSNumber * startmonth;
//** 结束月**//
@property (nonatomic, retain) NSNumber * endmonth;



@end
