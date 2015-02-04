//
//  IUserInfo.h
//  Welian
//
//  Created by weLian on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface IUserInfo : IFBase

@property (nonatomic,strong) NSNumber *uid;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *avatar;

@end

/*
 "uid":10056,
 
 "name":"吴玉启",
 
 "avatar":"http://img.welian.com/123123123.jpg"
 */
