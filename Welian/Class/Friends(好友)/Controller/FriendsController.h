//
//  FriendsController.h
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLTool.h"

typedef void(^FriendBlock)(NSMutableArray *frienArray);

@interface FriendsController : UIViewController

@property (nonatomic, strong) NSMutableArray *seleArray;

- (instancetype)initWithFrienBlock:(FriendBlock)frienBlock;

@end
