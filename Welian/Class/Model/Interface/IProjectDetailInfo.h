//
//  IProjectDetailInfo.h
//  Welian
//
//  Created by weLian on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IFBase.h"
#import "IBaseUserM.h"

@interface IProjectDetailInfo : IFBase

@property (nonatomic,strong) NSNumber *pid;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *intro;
@property (nonatomic,strong) NSString *des;
@property (nonatomic,strong) NSString *website;
@property (nonatomic,strong) NSNumber *zancount;
@property (nonatomic,strong) NSNumber *commentcount;
@property (nonatomic,strong) NSNumber *isZan;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSNumber *status;
@property (nonatomic,strong) NSNumber *memebercount;
@property (nonatomic,strong) IBaseUserM *user;
@property (nonatomic,strong) NSArray *photos;
@property (nonatomic,strong) NSArray *industrys;
@property (nonatomic,strong) NSArray *comments;
@property (nonatomic,strong) NSArray *zanusers;

@end
/*
 {
 
 "pid":10056, //项目id
 "name":"微链",
 "intro":"互联网移动互联网创业者社区",
 "website":"http://www.welian.com",
 "description": "互联网移动互联网创业者社区,为创业者和投资者建设沟通桥梁",
 "iszan":0，//0 没赞过，1赞过
 "zancount"：128，//赞数
 "commentcount":189,//评论数
 "memebercount":189,//团队成员个数
 "date":"2015-02-01"，
 "user":{
 "uid":10056,
 "name":"吴玉启",
 "avatar":"http://img.welian.com/123123123.jpg"
 }
 
 "photos":[
 {
 "photo":"http://img.welian.com/123123123123_x.jpg",
 },
 
 {
 "photo":"http://img.welian.com/123123123123_x.jpg",
 }
 
 ],
 
 "industrys":
 [{
 
 "industryid":1,
 
 "industryname":"互联网"
 
 }，
 
 {
 
 "industryid":1,
 
 "industryname":"移动互联网"
 
 }
 
 ]，
 
 "comments":[   //10条评论
 
 {
 
 "uid":10056,
 
 "name":"吴玉启",
 
 "avatar":"http://img.welian.com/123123123.jpg"
 
 "comment":"很不错"，
 
 "created:":"2015-01-29 11:23:42"
 
 }
 
 ],
 
 "zanusers":[  //10个赞的用户
 
 {
 
 "uid":10056,
 
 "name":"吴玉启",
 
 "avatar":"http://img.welian.com/123123123.jpg"
 
 }
 
 ]
 
 }
 

 */