//
//  HomeMessage.m
//  Welian
//
//  Created by dong on 14/12/26.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "HomeMessage.h"
#import "LogInUser.h"
#import "MessageHomeModel.h"

@implementation HomeMessage

@dynamic commentid;
@dynamic isLook;
@dynamic avatar;
@dynamic name;
@dynamic uid;
@dynamic feedcontent;
@dynamic feedid;
@dynamic feedpic;
@dynamic msg;
@dynamic type;
@dynamic created;
@dynamic rsLogInUser;

//创建新收据
+ (HomeMessage *)createHomeMessageModel:(MessageHomeModel *)messageM
{
    HomeMessage *homeMessage = [HomeMessage getHomeMessageWithUid:messageM.commentid];
    if (!homeMessage) {
        homeMessage = [HomeMessage create];
    }
    
    homeMessage.commentid = messageM.commentid;
    homeMessage.isLook = messageM.isLook != nil?messageM.isLook:NO;
    homeMessage.avatar = messageM.avatar;
    homeMessage.name = messageM.name;
    homeMessage.uid = messageM.uid;
    homeMessage.feedcontent = messageM.feedcontent;
    homeMessage.feedid = messageM.feedid;
    homeMessage.feedpic = messageM.feedpic;
    homeMessage.msg = messageM.msg;
    homeMessage.type = messageM.type;
    homeMessage.created = messageM.created;
    homeMessage.rsLogInUser = [LogInUser getNowLogInUser];
    [MOC save];
    return homeMessage;
}

// 获取未读消息
+ (NSArray *)getIsLookNotMessages
{
    NSArray *homearray = [[[[HomeMessage queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getNowLogInUser]] where:@"isLook" isTrue:NO] results];
    for (HomeMessage *meee  in homearray) {
        meee.isLook = @(1);
    }
    [MOC save];
    return homearray;
}

// 获取全部消息
+ (NSArray *)getAllMessages
{
    NSSortDescriptor *bookNameDes=[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO];
    
   return [[[[HomeMessage queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getNowLogInUser]] results]  sortedArrayUsingDescriptors:@[bookNameDes]];
}

// //通过commentid查询
+ (HomeMessage *)getHomeMessageWithUid:(NSNumber *)commentid
{
    HomeMessage *homeMessage = [[[[[HomeMessage queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getNowLogInUser]] where:@"commentid" equals:commentid] results] firstObject];
    return homeMessage;
}

@end
