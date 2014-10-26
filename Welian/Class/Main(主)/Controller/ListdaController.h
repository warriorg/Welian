//
//  ListdaController.h
//  weLian
//
//  Created by dong on 14/10/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "BasicTableViewController.h"

@interface ListdaController : BasicTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style WithList:(NSArray*)listData andType:(NSString*)type;

@end
