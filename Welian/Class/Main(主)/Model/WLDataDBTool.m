//
//  WLDataDBTool.m
//  weLian
//
//  Created by dong on 14/10/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLDataDBTool.h"


@implementation WLDataDBTool


static WLDataDBTool *wlDataDBTool;

+ (WLDataDBTool*)sharedService
{
    if (wlDataDBTool == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            wlDataDBTool = [[self alloc] initDBWithName:KWLDataDBName];
        });
    }
    [wlDataDBTool createTableWithName:KHomeDataTableName];
    [wlDataDBTool createTableWithName:KWLStutarDataTableName];
    [wlDataDBTool createTableWithName:KInvestIndustryTableName];
    return wlDataDBTool;
}

//- (void)getAllFriendsData
//{
//    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
//    NSString *tabelName = [NSString stringWithFormat:@"u%@",mode.uid];
//   NSArray *myFriends = [wlDataDBTool getObjectById:KMyAllFriendsKey fromTable:tabelName];
//    if (myFriends==nil) {
//        [WLHttpTool loadFriendParameterDic:@{@"uid":@(0)} success:^(id JSON) {
//            [wlDataDBTool putObject:JSON withId:KMyAllFriendsKey intoTable:tabelName];
//            NSArray *json = JSON;
//            // 查询
//        NSMutableArray *mutabArray = [NSMutableArray arrayWithCapacity:json.count];
//        for (NSDictionary *modic in json) {
//
//            UserInfoModel *mode = [[UserInfoModel alloc] init];
//            [mode setKeyValues:modic];
//            [mutabArray addObject:mode];
//        }
//        
//        succeBlock ([self getChineseStringArr:mutabArray]);
//        } fail:^(NSError *error) {
//            
//        }];
//    }else{
//        
//    }
//}


@end
