//
//  NeedAddUser.m
//  Welian
//
//  Created by weLian on 15/1/9.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "NeedAddUser.h"
#import "LogInUser.h"


@implementation NeedAddUser

@dynamic pinyin;
@dynamic wlname;
@dynamic userType;
@dynamic rsLoginUser;

//创建需要添加的好友对象
+ (void)createNeedAddUserWithDict:(NSDictionary *)dict  withType:(NSInteger)type
{
    //通讯录返回    avatar = "http://img.welian.com/1418279171961-200-194_x.png";
    //    friendship = 1;
    //    mobile = 15068114669;
    //    name = "\U590f\U663e\U6797\Uff0c\U4f20\U9001\U95e8";
    //    uid = 10071;
    //    wlname = "\U590f\U663e\U6797";
    
    /*微信返回
     "name": "田英",
     "uid":1,//用户id，大于0位微链用户的id
     "avatar":"http://img.welian.com/1334345345.jpg",
     “mobile":"13878887878",
     "company":"杭州科技有限公司"
     "position":"总经理"
     
     avatar = "http://my.welian.com/uploads/join_avatar/13a199b1c9ca9ec37ccd3a34c6b91b15.png";
     company = "\U91d1\U5ba2\U79d1\U6280";
     investorauth = 0;
     name = "\U5b59\U6960";
     position = "\U4ea7\U54c1\U7ecf\U7406";
     type = 1;
     uid = 0;
     */
    NSNumber *uid = dict[@"uid"] == nil ? nil : @([dict[@"uid"] integerValue]);
    NSString *name = dict[@"name"];
    NSString *wlName = dict[@"wlname"];
    NSString *mobile = dict[@"mobile"];
    NSString *avatar = dict[@"avatar"];
    NSString *company = dict[@"company"];
    NSString *position = dict[@"position"];
    //是否投资认证人
    NSNumber *investorauth = @([dict[@"investorauth"] integerValue]);
    NSNumber *friendship = dict[@"friendship"] == nil ? @(0) : @([dict[@"friendship"] integerValue]);
    //如果未返回uid的微信好友，不展示
    if (!uid && type == 2) {
        //设置为好友
        friendship = @(1);
        return;
    }
    if (friendship.integerValue == -1) {
        //自己
        return;
    }
    
    NeedAddUser *needAddUser = (uid != nil ? [self getNeedAddUserWithUid:uid] : [self getNeedAddUserWithMobile:mobile]);
    if (!needAddUser) {
        needAddUser = [NeedAddUser create];
    }
    needAddUser.uid = uid;
    needAddUser.avatar = avatar;
    needAddUser.friendship = friendship;
    needAddUser.mobile = mobile;
    needAddUser.name = name.length > 0 ? name : (wlName.length > 0 ? wlName : @"未知");
    needAddUser.wlname = wlName.length > 0 ? wlName : (name.length > 0 ? name : @"未知");
    needAddUser.pinyin = [needAddUser.name getHanziFirstString];
    needAddUser.userType = @(type);
    needAddUser.company = company;
    needAddUser.position = position;
    needAddUser.investorauth = investorauth;
    needAddUser.rsLoginUser = [LogInUser getNowLogInUser];
    [MOC save];
}

//获取已经存在的好友对象
+ (NeedAddUser *)getNeedAddUserWithUid:(NSNumber *)uid
{
    return [[[[[NeedAddUser queryInManagedObjectContext:MOC] where:@"rsLoginUser" equals:[LogInUser getNowLogInUser]] where:@"uid" equals:uid.stringValue] results] firstObject];
}

//获取已经存在的好友对象
+ (NeedAddUser *)getNeedAddUserWithMobile:(NSString *)mobile
{
    NSArray *all = [[[[NeedAddUser queryInManagedObjectContext:MOC] where:@"rsLoginUser" equals:[LogInUser getNowLogInUser]] where:@"mobile" equals:mobile] results];
    return [all firstObject];
}

//获取排序后的通讯录联系人
+ (NSMutableArray *)allNeedAddUserWithType:(NSInteger)type
{
    //friendship /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
    LogInUser *loginUser = [LogInUser getNowLogInUser];
    //系统非好友联系人
    NSArray *systemNoFriendArray = [[[[[[NeedAddUser queryInManagedObjectContext:MOC] where:@"rsLoginUser" equals:loginUser] where:@"userType" equals:@(type).stringValue] where:@"friendship" equals:@"2"] orderBy:@"pinyin" ascending:YES] results];
    
    //系统好友联系人
    NSArray *systemFriendArray = [[[[[[NeedAddUser queryInManagedObjectContext:MOC] where:@"rsLoginUser" equals:loginUser] where:@"userType" equals:@(type).stringValue] where:@"friendship" equals:@"1"] orderBy:@"pinyin" ascending:YES] results];
    
    //获取按照首字母排序的，其他联系人
    NSArray *otherUserArray = [[[[[[NeedAddUser queryInManagedObjectContext:MOC] where:@"rsLoginUser" equals:loginUser] where:@"userType" equals:@(type).stringValue] where:@"friendship" equals:@"0"] orderBy:@"pinyin" ascending:YES] results];
    
    //排序
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    //    NSMutableArray *headerKeys = [NSMutableArray array];
    //    BOOL checkValueAtIndex = NO;
    //    NSMutableArray *tempFroGroup = nil;
    //
    //    NSMutableArray *allUserArray = [NSMutableArray arrayWithArray:otherUserArray];
    //    //按照拼音首字母对这些Strings进行排序
    //    for (int i = 0; i < allUserArray.count; i++) {
    //        NeedAddUser *needUser = allUserArray[i];
    //        //监测数组中是否包含该首字母，没有创建
    //        if (![headerKeys containsObject:needUser.pinyin]) {
    //            [headerKeys addObject:needUser.pinyin];
    //            tempFroGroup = [NSMutableArray array];
    //            checkValueAtIndex = NO;
    //        }
    //
    //        //有就把数据添加进去
    //        if ([headerKeys containsObject:needUser.pinyin]) {
    //            [tempFroGroup addObject:needUser];
    //            if (checkValueAtIndex == NO) {
    //                [arrayForArrays addObject:tempFroGroup];
    //                checkValueAtIndex = YES;
    //            }
    //        }
    //    }
    //    NSArray *sortedCitys = @[headerKeys,arrayForArrays];
//    NSArray *systemNoFriendArray = [[[NeedAddUser queryInManagedObjectContext:MOC] where:@"rsLoginUser" equals:loginUser] results];
    
    [arrayForArrays addObjectsFromArray:systemNoFriendArray];
    [arrayForArrays addObjectsFromArray:systemFriendArray];
    [arrayForArrays addObjectsFromArray:otherUserArray];
    return arrayForArrays;
}

//更新好友关系状态
- (NeedAddUser *)updateFriendShip:(NSInteger)type
{
    //friendship /**  好友关系，1好友，2好友的好友,-1自己，0没关系  4.等待验证 */
    self.friendship = @(type);
    [MOC save];
    return self;
}

@end
