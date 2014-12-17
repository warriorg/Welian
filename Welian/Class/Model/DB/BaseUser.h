//
//  BaseUser.h
//  Welian
//
//  Created by dong on 14/12/16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BaseUser : NSManagedObject
//** 头像**//
@property (nonatomic, retain) NSString * avatar;
//** 姓名**//
@property (nonatomic, retain) NSString * name;
//** uid**//
@property (nonatomic, retain) NSNumber * uid;

@end
