//
//  ISchoolResult.h
//  Welian
//
//  Created by dong on 14/12/17.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface ISchoolResult : IFBase

/**  专业id   */
@property (nonatomic, retain) NSNumber * specialtyid;
/**  专业名称   */
@property (nonatomic, retain) NSString * specialtyname;
/**  usid   */
@property (nonatomic, retain) NSNumber * usid;
/**  学校名称   */
@property (nonatomic, retain) NSString * schoolname;
/**  学校id   */
@property (nonatomic, retain) NSNumber * schoolid;

//** 开始年**//
@property (nonatomic, retain) NSNumber * startyear;
//** 结束年**//
@property (nonatomic, retain) NSNumber * endyear;
//** 开始月**//
@property (nonatomic, retain) NSNumber * startmonth;
//** 结束月**//
@property (nonatomic, retain) NSNumber * endmonth;


@end
