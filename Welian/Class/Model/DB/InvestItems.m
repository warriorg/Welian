//
//  InvestItems.m
//  Welian
//
//  Created by dong on 14/12/29.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "InvestItems.h"
#import "LogInUser.h"
#import "InvestItemM.h"

@implementation InvestItems

@dynamic item;
@dynamic itemid;
@dynamic time;
@dynamic rsLogInUser;

//创建新收据
+ (InvestItems *)createInvestItems:(InvestItemM *)investItemM
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    InvestItems *investitem = [loginUser getInvestItemsWithItem:investItemM.item];
    if (!investitem) {
        investitem = [InvestItems MR_createEntityInContext:loginUser.managedObjectContext];
    }
    investitem.item = investItemM.item;
    investitem.itemid = investItemM.itemid;
    if (investItemM.time) {
        investitem.time = investItemM.time;
    }
    [loginUser addRsInvestItemsObject:investitem];
    [loginUser.managedObjectContext MR_saveToPersistentStoreAndWait];
//    investitem.rsLogInUser = [LogInUser getCurrentLoginUser];
//    [MOC save];
    return investitem;
}

//// 获取全部消息
//+ (NSArray *)getAllInvestItems
//{
//    NSSortDescriptor *bookNameDes=[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
//    
//    return [[[[InvestItems queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] results]  sortedArrayUsingDescriptors:@[bookNameDes]];
//}
//
//
//// //通过item查询
//+ (InvestItems *)getInvestItemsWithItem:(NSString *)item
//{
//    InvestItems *investItem = [[[[[InvestItems queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"item" equals:item] results] firstObject];
//    return investItem;
//}

@end
