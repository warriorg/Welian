//
//  WLTool.m
//  Welian
//
//  Created by dong on 14-9-17.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLTool.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "NSString+val.h"
#import "YTKKeyValueStore.h"
#import "MJExtension.h"

@interface WLTool()

@end

@implementation WLTool

//获取通讯录中的所有属性，并存储在 textView 中，已检验，切实可行。兼容io6 和 ios 7 ，而且ios7还没有权限确认提示。
+ (void)getAddressBookArray:(WLToolBlock)friendsAddressBlock
{
    CFErrorRef error = nil;
    //新建一个通讯录类
    ABAddressBookRef addressBooks = ABAddressBookCreateWithOptions(nil, &error);
    
    
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    NSMutableArray* contactArray = [[NSMutableArray alloc]init];
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        //读取firstname
        NSString *personName = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));

        //读取lastname
        NSString *lastname = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));

        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
//              PeopleAddressBook *peoAdd = [[PeopleAddressBook alloc] init];
            
            //获取該Label下的电话值
            NSString * personPhone = (NSString *)CFBridgingRelease( ABMultiValueCopyValueAtIndex(phone, k));
            
            personPhone = [personPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            if ([NSString phoneValidate:personPhone]) {
                NSMutableString *name = [[NSMutableString alloc] init];
                if (personName) {
                    [name appendString:personName];
                }
                if (lastname) {
                    [name appendString:lastname];
                }
//                [peoAdd setName:name];
//                [peoAdd setMobile:personPhone];
                
                [contactArray addObject:@{@"name":name,@"mobile":personPhone}];
            }
        }
    }
    CFRelease(results);
    CFRelease(addressBooks);
    
    [WLHttpTool uploadPhonebookParameterDic:contactArray success:^(id JSON) {
        NSArray *array = JSON;
        NSMutableArray *friends = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary *dic  in array) {
            FriendsAddressBook *friendBook = [[FriendsAddressBook alloc] init];
            [friendBook setKeyValues:dic];
            [friends addObject:friendBook];
        }
//        YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"aaa.db"];
//        
//        NSString *friendTableName = @"friendTableName";
//        [store createTableWithName:friendTableName];
//        
//        // 保存
//        NSString *key = @"1";
//        [store putObject:JSON withId:key intoTable:friendTableName];
//        
//        // 查询
//        NSLog(@"query data result: %@", [store getObjectById:key fromTable:friendTableName]);
        
        friendsAddressBlock(friends);
    } fail:^(NSError *error) {
        
    }];
}


@end
