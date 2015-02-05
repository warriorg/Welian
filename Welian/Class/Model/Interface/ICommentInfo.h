//
//  ICommentInfo.h
//  Welian
//
//  Created by weLian on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IFBase.h"
#import "IBaseUserM.h"

@interface ICommentInfo : IFBase

@property (nonatomic,strong) NSNumber *pcid;
@property (nonatomic,strong) NSString *comment;
@property (nonatomic,strong) NSString *created;
@property (nonatomic,strong) IBaseUserM *user;
@property (nonatomic,strong) IBaseUserM *touser;

@end

/*
 comment = "\U6211\U6765\U4e5f";
 created = "2015-02-02 17:03:42";
 pcid = 3;
 user =                 {
 avatar = "http://img.welian.com/1420763765558-200-193_x.png";
 company = "\U5fae\U94fe";
 investorauth = "-1";
 name = "\U9648\U65e5\U6c99";
 position = "\U4ea7\U54c1\U7ecf\U7406";
 uid = 10047;
 };
 */
