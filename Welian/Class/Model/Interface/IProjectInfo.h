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
@property (nonatomic,strong) NSNumber *membercount;
@property (nonatomic,strong) NSNumber *isZan;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSNumber *status;
// 领域
@property (nonatomic,strong) NSArray *industrys;

//赞的数量
- (NSString *)displayZancountInfo;
//项目领域
- (NSString *)displayIndustrys;

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
 
 commentcount = 12;
 date = "2015-02-01";
 description = "\U5fae\U4fe1\U4f01\U4e1a\U53f7\U80fd\U5e2e\U52a9\U4f01\U4e1a\U3001\U653f\U5e9c\U673a\U5173\U3001\U5b66\U6821\U3001\U533b\U9662\U7b49\U4e8b\U4e1a\U5355\U4f4d\U548c\U975e\U653f\U5e9c\U7ec4\U7ec7\U5efa\U7acb\U4e0e\U5458\U5de5\U3001\U4e0a\U4e0b\U6e38\U5408\U4f5c\U4f19\U4f34\U53ca\U5185\U90e8IT\U7cfb\U7edf\U95f4\U7684\U8fde\U63a5\Uff0c\U5e76\U80fd\U6709\U6548\U5730\U7b80\U5316\U7ba1\U7406\U6d41\U7a0b\U3001\U63d0\U9ad8\U4fe1\U606f\U7684\U6c9f\U901a\U548c\U534f\U540c\U6548\U7387\U3001\U63d0\U5347\U5bf9\U4e00\U7ebf\U5458\U5de5\U7684\U670d\U52a1\U53ca\U7ba1\U7406\U80fd\U529b\U3002";
 industrys =             (
 {
 industryid = 1;
 industryname = "\U6e38\U620f
 \n";
 }
 );
 intro = "\U4f01\U4e1a\U53f7\Uff0c\U662f\U5fae\U4fe1\U4e3a\U4f01\U4e1a\U7528\U6237\U63d0\U4f9b\U7684\U79fb\U52a8\U5e94\U7528\U5165\U53e3";
 isZan = 1;
 membercount = 2;
 name = "\U5fae\U4fe1\U4f01\U4e1a\U53f7";
 pid = 10000;
 status = 1;
 zancount = 3;
 */
