//
//  IProjectInfo.h
//  Welian
//
//  Created by weLian on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface IProjectInfo : IFBase

@property (nonatomic,strong) NSNumber *pid;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *intro;
@property (nonatomic,strong) NSString *des;
@property (nonatomic,strong) NSNumber *zancount;
@property (nonatomic,strong) NSNumber *commentcount;
@property (nonatomic,strong) NSNumber *iszan;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSNumber *status;

@end
/*
 "pid":10056, //项目id
 "name":"微链",
 "intro":"互联网移动互联网创业者社区",
 "description":"互联网移动互联网创业者社区撒的发生的发生的发生的飞洒地方",
 "zancount"：128，
 "commentcount"：123123，
 "iszan":0，//0 没赞过，1赞过
 "date":"2015-02-01",
 "status":// 0 暂不融资   1正在融资
 */
