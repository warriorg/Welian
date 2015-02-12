//
//  WLHttpTool.m
//  Welian
//
//  Created by dong on 14-9-21.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLHttpTool.h"
#import "HttpTool.h"
#import "WLHUDView.h"
#import "WLUserStatusesResult.h"
#import "MJExtension.h"
#import "InvestAuthModel.h"
#import "CommentCellFrame.h"
#import "InvestorUserM.h"
#import "pinyin.h"
#import "PinYin4Objc.h"
#import "ChineseString.h"
#import "WLStatusM.h"
#import "FriendsUserModel.h"
#import "FriendsAddressBook.h"
#import "WLDataDBTool.h"
#import "UIImageView+WebCache.h"
#import "ICompanyResult.h"
#import "ISchoolResult.h"
#import "MyFriendUser.h"
#import "FriendsinfoModel.h"
#import "IIMeInvestAuthModel.h"
#import "NewFriendUser.h"

@implementation WLHttpTool

#pragma mark - 取消所有请求
+ (void)cancelAllRequestHttpTool
{
    [[[HttpTool sharedService] operationQueue] cancelAllOperations];
}


#pragma mark - 版本号更新提示
+ (void)updateParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"update",@"data":parameterDic};
    
    [[HttpTool sharedService] reqestParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 微信注册:  请求
+ (void)weixinRegisterParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"weixinRegister",@"data":parameterDic};
    [[HttpTool sharedService] reqestParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 获取好友  上传通讯录，返回通讯录好友和微信好友
+ (void)uploadPhonebook2ParameterDic:(NSMutableArray *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"uploadPhonebook2",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}




#pragma mark - 忘记密码
+ (void)forgetPasswordParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"forgetPassword",@"data":parameterDic};
    
    [[HttpTool sharedService] reqestParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:YES];
}


#pragma mark - 获取验证码
+ (void)getCheckCodeParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
     NSDictionary *dic = @{@"type":@"getCheckCode",@"data":parameterDic};
    [[HttpTool sharedService] reqestParameters:dic successBlock:^(id JSON) {
        [LogInUser setUserSessionid:[JSON objectForKey:@"sessionid"]];
        [UserDefaults setObject:[JSON objectForKey:@"sessionid"] forKey:@"SID"];
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:YES];
}


#pragma mark - 验证 验证码
+ (void)checkCodeParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"checkCode",@"data":parameterDic};
    [[HttpTool sharedService] reqestParameters:dic successBlock:^(id JSON) {
        
        DLog(@"%@",JSON);
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:YES];
}


#pragma mark - 用户登陆
+ (void)loginParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock isHUD:(BOOL)ishud
{
    NSDictionary *dic = @{@"type":@"login",@"data":parameterDic};
    [[HttpTool sharedService] reqestParameters:dic successBlock:^(id JSON) {
        [UserDefaults removeObjectForKey:@"sid"];
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:ishud andDim:ishud];
}

#pragma mark - 用户注册填写信息
+ (void)registerParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"register",@"data":parameterDic};
    
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock (error);
    } withHUD:YES andDim:YES];
}


#pragma mark - 上传所有通讯录
+ (void)uploadPhonebookParameterDic:(NSMutableArray *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"uploadPhonebook",@"data":parameterDic};
    
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        NSArray *datajson = JSON;
        succeBlock (datajson);
    } failure:^(NSError *error) {
        failurBlock (error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 获取微信好友列表
+ (void)loadWxFriendParameterDic:(NSMutableArray *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadWxFriend",@"data":parameterDic};
    
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        NSArray *datajson = JSON;
        succeBlock (datajson);
    } failure:^(NSError *error) {
        failurBlock (error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 修改用户信息
+ (void)saveProfileParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"saveProfile",@"data":parameterDic};
    BOOL ishud = YES;
    if ([parameterDic objectForKey:@"x"]) {
        ishud = NO;
    }
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock (error);
    } withHUD:ishud andDim:NO];
}

#pragma mark - 修改用户头像
+ (void)uploadAvatarParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"uploadAvatar",@"data":parameterDic};
    
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}


#pragma mark - 发布状态
+ (void)addFeedParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"addFeed",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock (error);
    } withHUD:YES andDim:YES];
}

#pragma mark - 加载好友最新动态
+ (void)loadFeedParameterDic:(NSDictionary *)parameterDic andLoadType:(NSNumber *)uid success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic;
    
    if (uid) {
        dic = @{@"type":@"loadUserFeed",@"data":parameterDic};
    }else {
        dic = @{@"type":@"loadFeed",@"data":parameterDic};    
    }
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        NSArray *jsonarray = [NSArray arrayWithArray:JSON];
        
        if (jsonarray.count) {
            BOOL isok = NO;
            if (!uid&&[[parameterDic objectForKey:@"start"] integerValue]==0) {
                isok = YES;
                [[WLDataDBTool sharedService] clearTable:KHomeDataTableName];
            }
            for (NSDictionary *dicJson in jsonarray) {
                if (isok) {
                    [[WLDataDBTool sharedService] putObject:dicJson  withId:[dicJson objectForKey:@"fid"] intoTable:KHomeDataTableName];
                }
                [[WLDataDBTool sharedService] putObject:dicJson withId:[NSString stringWithFormat:@"%@",[dicJson objectForKey:@"fid"]] intoTable:KWLStutarDataTableName];
            }
        }
        succeBlock (jsonarray);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    } withHUD:NO andDim:NO];
}


#pragma mark - loadFeeds取动态（新）
+(void)loadFeedsParameterDic:(NSDictionary *)parameterDic andLoadType:(NSNumber *)uid success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic;
    
    if (uid) {
        dic = @{@"type":@"loadUserFeed2",@"data":parameterDic};
    }else {
        dic = @{@"type":@"loadFeeds",@"data":parameterDic};
    }
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        NSArray *jsonarray = [NSArray arrayWithArray:JSON];
        
        if (jsonarray.count) {
            BOOL isok = NO;
            if (!uid&&[[parameterDic objectForKey:@"start"] integerValue]==0) {
                isok = YES;
                [[WLDataDBTool sharedService] clearTable:KHomeDataTableName];
            }
            for (NSDictionary *dicJson in jsonarray) {
                if (isok) {
                    [[WLDataDBTool sharedService] putObject:dicJson  withId:[dicJson objectForKey:@"fid"] intoTable:KHomeDataTableName];
                }
                [[WLDataDBTool sharedService] putObject:dicJson withId:[NSString stringWithFormat:@"%@",[dicJson objectForKey:@"fid"]] intoTable:KWLStutarDataTableName];
            }
        }
        succeBlock (jsonarray);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    } withHUD:NO andDim:NO];
}


#pragma mark - 关键字搜索公司
+ (void)getCompanyParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"getCompany",@"data":parameterDic};
    [[HttpTool sharedService] reqestParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];

}


#pragma mark - 关键字搜索学校
+ (void)getSchoolParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"getSchool",@"data":parameterDic};
    [[HttpTool sharedService] reqestParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 关键字搜索职位
+ (void)getJobParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"getJob",@"data":parameterDic};
    [[HttpTool sharedService] reqestParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 投资者认证
+ (void)investAuthParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"investAuth",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:YES];
}

#pragma mark - 取消认证
+ (void)deleteInvestorParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"deleteInvestor",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:YES];
}

#pragma mark - 取投资者认证信息
+ (void)getInvestAuthParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"getInvestAuth",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        NSDictionary *datadic = [NSDictionary dictionaryWithDictionary:JSON];
        
        succeBlock (datadic);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 取行业 投资领域
+ (void)getIndustryParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"getIndustry",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        NSArray *dataArray = [NSArray arrayWithArray:JSON];
        
        [[WLDataDBTool sharedService] putObject:dataArray  withId:KInvestIndustryTableName intoTable:KInvestIndustryTableName];
        succeBlock (dataArray);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}



#pragma mark - 取动态评论
+ (void)loadFeedCommentParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadFeedComment",@"data":parameterDic};
    
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        NSArray *dataArray = [NSArray arrayWithArray:JSON];
        NSMutableArray *dataAM = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *dic in dataArray) {
            
            CommentMode *commentM = [CommentMode objectWithKeyValues:dic];
            CommentCellFrame *commentFrame = [[CommentCellFrame alloc] init];
            [commentFrame setCommentM:commentM];
            
            [dataAM addObject:commentFrame];
        }
        succeBlock (dataAM);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 添加动态评论
+ (void)addFeedCommentParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    
     NSDictionary *dic = @{@"type":@"addFeedComment",@"data":parameterDic};
    
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 删除评论
+ (void)deleteFeedCommentParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"deleteFeedComment",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 删除自己动态
+ (void)deleteFeedParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"deleteFeed",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 转推评论
+ (void)forwardFeedParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"forwardFeed",@"data":parameterDic};
    
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 添加动态赞
+ (void)addFeedZanParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"addFeedZan",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];

}


#pragma mark - 取动态赞
+ (void)loadFeedZanParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestWithSessIDParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 取消赞
+ (void)deleteFeedZanParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"deleteFeedZan",@"data":parameterDic};
    
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 根据uid取用户信息  0取自己
+ (void)loadProfileParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadProfile",@"data":parameterDic};
    
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 根据uid取用户好友列表  0取自己
+ (void)loadFriendWithSQL:(BOOL)isSQL ParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    NSArray *myFriends = [loginUser getAllMyFriendUsers];
    if (isSQL) {
        succeBlock (@{@"count":@(myFriends.count),@"array":[self getChineseStringArr:myFriends]});
        
    }else{
        NSDictionary *dic = @{@"type":@"loadFriend",@"data":parameterDic};
        [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
            
//                NSArray  *json = [NSArray arrayWithArray:JSON];
//                
//                //循环，删除本地数据库多余的缓存数据
//                for (int i = 0; i < [myFriends count]; i++){
//                    MyFriendUser *myFriendUser = myFriends[i];
//                    //判断返回的数组是否包含
//                    BOOL isHave = [json bk_any:^BOOL(id obj) {
//                        //判断是否包含对应的
//                        return [[obj objectForKey:@"uid"] integerValue] == [myFriendUser uid].integerValue;
//                    }];
//                    if(!isHave){
//                        //删除新的好友本地数据库
//                        NewFriendUser *newFuser = [loginUser getNewFriendUserWithUid:myFriendUser.uid];
//                        if (newFuser) {
//                            //更新好友请求列表数据为 添加
//                            [newFuser updateOperateType:0];
//                        }
//                        
//                        //如果uid大于100的为普通好友，刷新的时候可以删除本地，系统好友，保留
//                        if(myFriendUser.uid.integerValue > 100){
//                            //不包含，删除当前数据
////                            [myFriendUser delete];
//                            [myFriendUser MR_deleteEntityInContext:loginUser.managedObjectContext];
//                        }
//                    }
//                }
//                
//                NSArray *myFriends = [NSArray array];
//                if (json.count) {
//                    //循环添加数据库数据
//                    for (NSDictionary *modic in json) {
//                        FriendsUserModel *friendM = [FriendsUserModel objectWithKeyValues:modic];
//                        [MyFriendUser createMyFriendUserModel:friendM];
//                        //                    [mutabArray addObject:friendM];
//                    }
//                    myFriends = [loginUser getAllMyFriendUsers];
//                }
//                succeBlock (@{@"count":@(json.count),@"array":[self getChineseStringArr:myFriends]});
            succeBlock (JSON);
//            });
            
        } failure:^(NSError *error) {
            failurBlock(error);
        } withHUD:NO andDim:NO];
    }
}

#pragma mark - 请求添加为好友
+ (void)requestFriendParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"requestFriend",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}



+ (NSMutableArray *)getChineseStringArr:(NSArray *)arrToSort {
   
    NSMutableArray *_sectionHeadsKeys = [NSMutableArray array];
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for (FriendsUserModel *mode in arrToSort) {
        if (!mode.name) continue;
        ChineseString *chineseString=[[ChineseString alloc]init];
        chineseString.string=[[NSString stringWithString:mode.name] substringToIndex:1];
        chineseString.modeUser = mode;
        
        if(![chineseString.string isEqualToString:@""]){
            NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                             pinyinFirstLetter([chineseString.string characterAtIndex:0])]uppercaseString];
            chineseString.pinYin = singlePinyinLetter;
        } else {
            chineseString.pinYin = @"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        //sr containing here the first character of each string
        if(![_sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [_sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
            checkValueAtIndex = NO;
        }
        if([_sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:chineseStr.modeUser];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:@{@"key":sr,@"userF":TempArrForGrouping}];
                checkValueAtIndex = YES;
            }
        }
    }
    return arrayForArrays;
}


#pragma mark - 根据fid取一条动态信息
+ (void)loadOneFeedParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
     NSDictionary *dic = @{@"type":@"loadOneFeed2",@"data":parameterDic};

    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 取发现
+ (void)loadFoundParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadFound",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 取投资人列表
+ (void)loadInvestorUserParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadInvestorUser",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        NSArray *dataArray = [NSArray arrayWithArray:JSON];
         NSArray *result = [InvestorUserM objectsWithInfo:dataArray];
        succeBlock (result);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}



#pragma mark - 添加教育经历
+ (void)addSchoolParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    
    NSDictionary *dic = @{@"type":@"addSchool",@"data":parameterDic};
    
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:YES];
}

#pragma mark - 取教育经历
+ (void)loadUserSchoolParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadUserSchool",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        NSArray *dataA = [NSArray arrayWithArray:JSON];
        NSArray *result = [ISchoolResult objectsWithInfo:dataA];
//        NSMutableArray *dataArrayM = [NSMutableArray arrayWithCapacity:dataA.count];
//        for (NSDictionary *dic in dataA) {
//            SchoolModel *schoolM = [[SchoolModel alloc] init];
//            [schoolM setKeyValues:dic];
//            [dataArrayM addObject:schoolM];
//        }
        succeBlock(result);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 删除教育经历
+ (void)deleteUserSchoolParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"deleteUserSchool",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}



#pragma mark - 取工作经历
+ (void)loadUserCompanyParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadUserCompany",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        NSArray *dataA = [NSArray arrayWithArray:JSON];
        NSArray *result = [ICompanyResult objectsWithInfo:dataA];
        DLog(@"reuslt:   %@",result);
//        NSMutableArray *dataArrayM = [NSMutableArray arrayWithCapacity:dataA.count];
//        for (NSDictionary *dic in dataA) {
//            CompanyModel *companyM= [[CompanyModel alloc] init];
//            [companyM setKeyValues:dic];
//            [dataArrayM addObject:companyM];
//        }
        succeBlock(result);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 添加工作经历
+ (void)addCompanyParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"addCompany",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 删除工作经历
+ (void)deleteUserCompanyParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"deleteUserCompany",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        [WLHUDView showSuccessHUD:@"删除成功"];
        succeBlock(JSON);
    } failure:^(NSError *error) {
        [WLHUDView showErrorHUD:@"删除失败"];
        failurBlock(error);
    } withHUD:YES andDim:YES];
}


#pragma mark - 取用户详细信息
+ (void)loadUserInfoParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadUserInfo",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:JSON];
        // 详细信息
        NSDictionary *profile = [dataDic objectForKey:@"profile"];
        [[WLDataDBTool sharedService] putObject:dataDic withId:[[profile objectForKey:@"uid"] stringValue] intoTable:KWLUserInfoTableName];
//        UserInfoModel *profileM = [UserInfoModel objectWithKeyValues:profile];
//        // 动态
//        NSDictionary *feed = [dataDic objectForKey:@"feed"];
//        WLStatusM *feedM = [WLStatusM objectWithKeyValues:feed];
//        
//        // 投资案例
//        NSDictionary *investor = [dataDic objectForKey:@"investor"];
//        IIMeInvestAuthModel *investorM = [IIMeInvestAuthModel objectWithDict:investor];
//        
//        // 创业者
////        NSDictionary *startup = [dataDic objectForKey:@"startup"];
//        
//        // 工作经历列表
//        NSArray *usercompany = [dataDic objectForKey:@"usercompany"];
//        NSMutableArray *companyArrayM = [NSMutableArray arrayWithCapacity:usercompany.count];
//        for (NSDictionary *dic in usercompany) {
//            ICompanyResult *usercompanyM = [ICompanyResult objectWithKeyValues:dic];
//            [companyArrayM addObject:usercompanyM];
//        }
//        
//        // 教育经历列表
//        NSArray *userschool = [dataDic objectForKey:@"userschool"];
//        NSMutableArray *schoolArrayM = [NSMutableArray arrayWithCapacity:userschool.count];
//        for (NSDictionary *dic  in userschool) {
//            ISchoolResult *userschoolM = [ISchoolResult objectWithKeyValues:dic];
//            [schoolArrayM addObject:userschoolM];
//        }
    succeBlock(dataDic);
    } failure:^(NSError *error) {
        [WLHUDView showErrorHUD:@""];
        failurBlock(error);
    } withHUD:NO andDim:NO];
}


#pragma mark - 取共同好友
+ (void)loadSameFriendParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadSameFriend",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:JSON];
        succeBlock(dataDic);
    } failure:^(NSError *error) {

        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 搜索用户
+(void)searchUserParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"searchUser",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        NSArray *json = JSON;
        NSMutableArray *mutabArray = [NSMutableArray arrayWithCapacity:json.count];
        for (NSDictionary *modic in json) {
            
            UserInfoModel *mode = [[UserInfoModel alloc] init];
            [mode setKeyValues:modic];
            [mutabArray addObject:mode];
        }
        succeBlock(mutabArray);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    } withHUD:YES andDim:YES];
}

#pragma mark - 取新好友请求列表
+ (void)loadFriendRequestParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadFriendRequest",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 删除好友请求
+ (void)deleteFriendRequestParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"deleteFriendRequest",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    } withHUD:NO andDim:NO];
}




#pragma mark - 确认添加好友
+ (void)addFriendParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"addFriend",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 删除好友
+ (void)deleteFriendParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"deleteFriend",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 取好友的好友（二度好友）
+ (void)loadUser2FriendParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadUser2Friend",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 取最新动态更新数量
+ (void)loadNewFeedCountParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadNewFeedCount",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    } withHUD:NO andDim:NO];
}


#pragma mark - 取转发和点赞人
+ (void)loadFeedZanAndForwardParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadFeedZanAndForward2",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 更新BaiduId请求
+ (void)updateClientSuccess:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    LogInUser *mode = [LogInUser getCurrentLoginUser];
    if (mode.sessionid) {
        NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
        [parameterDic setObject:KPlatformType forKey:@"platform"];
        
        if ([UserDefaults objectForKey:BPushRequestChannelIdKey]) {
            [parameterDic setObject:[UserDefaults objectForKey:BPushRequestChannelIdKey] forKey:@"clientid"];
        }
        NSDictionary *dic = @{@"type":@"updateClient",@"data":parameterDic};
        
        [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
            
            succeBlock(JSON);
        } failure:^(NSError *error) {
            
            failurBlock(error);
        } withHUD:NO andDim:NO];
    }
    
}


#pragma mark - 取一条评论、赞、转发
+ (void)loadOneFeedRelationParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    
    NSDictionary *dic = @{@"type":@"loadOneFeedRelation",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    } withHUD:NO andDim:NO];
}


#pragma mark - 取动态消息列表
+ (void)loadFeedRelationParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    
    NSDictionary *dic = @{@"type":@"loadFeedRelation",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 举报--投诉
+ (void)complainParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"complain",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 退出登录
+ (void)logoutParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"logout",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 转推
+ (void)addFeedTuiParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"addFeedTui",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 取消转推
+ (void)deleteFeedForwardParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"deleteFeedForward",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 发送聊天消息
+ (void)sendMessageParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"IM",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic path:@"server/im" successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 取活动报名用户列表
+ (void)loadActiveRecordsParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadActiveRecords",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 创建活动报名订单
+ (void)createTicketOrderParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"ticketOrder",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 修改活动支付订单状态
+ (void)updateTicketOrderStatusParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"ticketOrderStatus",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 创建项目 & 修改项目
+ (void)createProjectParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    //项目id，0标示创建新的项目，大于零为项目的id，修改项目信息
    NSDictionary *dic = @{@"type":@"saveProject",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 取项目列表
+ (void)getProjectsParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    //"uid":10086,// -1 取自己，0 取推荐的项目，大于0取id为uid的用户
    NSString *type = @"loadProjects";
    if (![parameterDic objectForKey:@"uid"]) {
        
    }
    NSDictionary *dic = @{@"type":@"loadProjects",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 取项目详情
+ (void)getProjectDetailParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadOneProject",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:YES];
}

#pragma mark - 取项目赞的用户列表
+ (void)getProjectZanUsersParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadProjectZanUsers",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 取项目评论
+ (void)getProjectCommentsParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadProjectComments",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 项目点赞
+ (void)zanProjectParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"zanProject",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 项目评论
+ (void)commentProjectParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"commentProject",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 删除项目评论
+ (void)deleteProjectCommentParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"deleteProjectComment",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 删除项目赞
+ (void)deleteProjectZanParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"deleteProjectZan",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 添加项目成员
+ (void)addProjectMembersParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"saveProjectMember",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 删除项目成员
+ (void)deleteProjectMemberParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"deleteProjectMember",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 取项目成员
+ (void)getProjectMembersParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadProjectMembers",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 取收藏项目列表
+ (void)getFavoriteProjectsParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadFavoriteProjects",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:NO andDim:NO];
}

#pragma mark - 收藏项目
+ (void)favoriteProjectParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"favoriteProject",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 取消收藏项目
+ (void)deleteFavoriteProjectParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"deleteFavoriteProject",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 检测项目是否有同名
+ (void)checkProjectParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"checkProject",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 添加项目图片
+ (void)saveProjectPicParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"saveProjectPic",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:NO];
}

#pragma mark - 删除项目图片
+ (void)deleteProjectPicParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"deleteProjectPic",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    } withHUD:YES andDim:YES];
}

#pragma mark - 解析短链接
+ (void)getLongUrlFromShort:(NSString *)shortUrl success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestGetWithPath:shortUrl
                                   successBlock:^(id JSON) {
                                       succeBlock(JSON);
                                   } failure:^(NSError *error) {
                                       failurBlock(error);
                                   } withHUD:NO andDim:NO];
}


@end
