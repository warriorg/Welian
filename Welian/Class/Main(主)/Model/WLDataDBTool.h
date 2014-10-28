//
//  WLDataDBTool.h
//  weLian
//
//  Created by dong on 14/10/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "YTKKeyValueStore.h"
#import "Singleton.h"
#import "YTKKeyValueStore.h"

@interface WLDataDBTool : YTKKeyValueStore

+ (WLDataDBTool *)sharedService;

@end
