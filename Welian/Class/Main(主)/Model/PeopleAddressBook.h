//
//  PeopleAddressBook.h
//  Welian
//
//  Created by dong on 14-9-17.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeopleAddressBook : NSObject
/**
 *  姓名
 */
@property (nonatomic, strong) NSString *name;
/**
 *  电话
 */
@property (nonatomic, strong) NSString *Aphone;
@property (nonatomic, strong) NSString *Bphone;
@property (nonatomic, strong) NSString *Cphone;



/**
 *  公司
 */
@property (nonatomic, strong) NSString *company;
/**
 *  职位
 */
@property (nonatomic, strong) NSString *job;
/**
 *  邮箱
 */
@property (nonatomic, strong) NSString *email;
/**
 *  头像
 */
@property (nonatomic, strong) UIImage *iconImage;
/**
 *  地址
 */
@property (nonatomic, strong) NSString *address;
@end
