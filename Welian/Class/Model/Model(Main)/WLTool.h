//
//  WLTool.h
//  Welian
//
//  Created by dong on 14-9-17.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendsAddressBook.h"

typedef void(^WLToolBlock)(NSMutableArray *friendsAddress);
typedef void (^UpVersionBlock)(NSDictionary *versionDic);

@interface WLTool : NSObject

+ (void)getAddressBookArray:(WLToolBlock)friendsAddressBlock;

+ (NSMutableArray *)getAddressBookArray;

+ (void)updateVersions:(UpVersionBlock)versionBlock;

@end
