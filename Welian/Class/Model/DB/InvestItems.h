//
//  InvestItems.h
//  Welian
//
//  Created by dong on 14/12/29.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LogInUser, InvestItemM;

@interface InvestItems : NSManagedObject

@property (nonatomic, retain) NSString * item;
@property (nonatomic, retain) NSNumber * itemid;
@property (nonatomic, retain) LogInUser *rsLogInUser;

//创建新收据
+ (InvestItems *)createInvestItems:(InvestItemM *)investItemM;

// //通过item查询
+ (InvestItems *)getInvestItemsWithItem:(NSString *)item;

@end
