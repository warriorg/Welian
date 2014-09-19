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

@interface WLTool()

@end

@implementation WLTool

#pragma mark - 获取通讯录信息
+ (NSArray*)getAddressBookArray
{
    CFErrorRef error = nil;
    //新建一个通讯录类
    ABAddressBookRef addressBooks = ABAddressBookCreateWithOptions(nil, &error);
    
//    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
//    //这个只会在第一次访问时调用
//    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool greanted, CFErrorRef error){
//        dispatch_semaphore_signal(sema);
//        if (greanted) {
//            NSLog(@"ABAddressBookSetAuthorization success.");
//        }else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"  啊啊" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
//    });
    
    NSMutableArray* contactArray = [[NSMutableArray alloc]init];
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    if (CFArrayGetCount(allPeople)<=0) {
        return contactArray;
    }
    for(int i = 0; i < CFArrayGetCount(allPeople); i++)
    {
        PeopleAddressBook *peoAdd = [[PeopleAddressBook alloc] init];
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        
        if (ABRecordCopyValue(person, kABPersonLastNameProperty)&&(ABRecordCopyValue(person, kABPersonFirstNameProperty))== nil) {
            peoAdd.name = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
            
        }else if (ABRecordCopyValue(person, kABPersonLastNameProperty) == nil&&(ABRecordCopyValue(person, kABPersonFirstNameProperty))){
            peoAdd.name = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        }else if (ABRecordCopyValue(person, kABPersonLastNameProperty)&&(ABRecordCopyValue(person, kABPersonFirstNameProperty))){
            
            NSString *first =(NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            NSString *last = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
            peoAdd.name = [NSString stringWithFormat:@"%@%@",last,first];
        }
        
        //读取联系人公司信息
        
        peoAdd.company = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonOrganizationProperty));
        //读取电话信息，和emial类似，也分为工作电话，家庭电话，工作传真，家庭传真。。。。
        
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        if ((phone != nil)&&ABMultiValueGetCount(phone)>0) {
            
            for (int m = 0; m < ABMultiValueGetCount(phone); m++) {
                NSString * aPhone = (NSString *)CFBridgingRelease( ABMultiValueCopyValueAtIndex(phone, m));
                NSString * aLabel = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phone, m));
                
                if ([aLabel isEqualToString:@"_$!<Mobile>!$_"]&&aPhone) {
                    peoAdd.Aphone= aPhone;
                    
                }
                
                if ([aLabel isEqualToString:@"_$!<WorkFAX>!$_"]) {
                    peoAdd.Bphone = aPhone;
                }
                
                if ([aLabel isEqualToString:@"_$!<Work>!$_"]) {
                    peoAdd.Cphone= aPhone;
                }
            }
        }
        [contactArray addObject:peoAdd];
        
    }
    return contactArray;
}


@end
