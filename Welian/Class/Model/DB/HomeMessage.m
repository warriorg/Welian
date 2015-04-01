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
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    HomeMessage *homeMessage = [loginUser getHomeMessageWithUid:messageM.commentid];
    if (!homeMessage) {
        homeMessage = [HomeMessage MR_createEntityInContext:loginUser.managedObjectContext];
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
    
    [loginUser addRsHomeMessagesObject:homeMessage];
    [loginUser.managedObjectContext MR_saveToPersistentStoreAndWait];
//    homeMessage.rsLogInUser = [LogInUser getCurrentLoginUser];
//    [MOC save];
    return homeMessage;
}

//创建项目推送数据
+ (HomeMessage *)createHomeMessageProjectModel:(NSDictionary *)dict
{
    /*
     "type":1,//1 赞，0评论
     "msg": "好好学习，天天向上",
     "uid": 115,
     "name": "马良",
     "avatar": "http://img.welian.com/12123123.jpg",
     "projectid":10078,
     "projectintro":"创业者社交平台",//项目介绍
     ”projectname“:"微链"
     */
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    
    HomeMessage *homeMessage = [HomeMessage MR_createEntityInContext:loginUser.managedObjectContext];
//    homeMessage.commentid = messageM.commentid;
    homeMessage.isLook = @(NO);
    homeMessage.avatar = dict[@"avatar"];
    homeMessage.name = dict[@"name"];
    homeMessage.uid = @([dict[@"uid"] integerValue]);
    homeMessage.feedcontent = [NSString stringWithFormat:@"%@:%@",dict[@"projectname"],dict[@"projectintro"]];
    homeMessage.feedid = dict[@"projectid"];
//    homeMessage.feedpic = messageM.feedpic;
    homeMessage.msg = dict[@"msg"];
    homeMessage.type = [dict[@"type"] integerValue] == 0 ? @"projectComment" : @"projectCommentZan";
    homeMessage.created = dict[@"created"];
    
    [loginUser addRsHomeMessagesObject:homeMessage];
    [loginUser.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    return homeMessage;
    
}

//改变所有未读消息状态为已读
- (void)updateHomeMessageIsLook
{
    self.isLook = @(YES);
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
}

//// 获取未读消息
//+ (NSArray *)getIsLookNotMessages
//{
//    NSArray *homearray = [[[[HomeMessage queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"isLook" isTrue:NO] results];
//    for (HomeMessage *meee  in homearray) {
//        meee.isLook = @(1);
//    }
//    [MOC save];
//    return homearray;
//}
//
//// 获取全部消息
//+ (NSArray *)getAllMessages
//{
//    NSSortDescriptor *bookNameDes=[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO];
//    
//   return [[[[HomeMessage queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] results]  sortedArrayUsingDescriptors:@[bookNameDes]];
//}
//
//// //通过commentid查询
//+ (HomeMessage *)getHomeMessageWithUid:(NSNumber *)commentid
//{
//    HomeMessage *homeMessage = [[[[[HomeMessage queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"commentid" equals:commentid] results] firstObject];
//    return homeMessage;
//}

@end
