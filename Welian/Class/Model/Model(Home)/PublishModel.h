//
//  PublishModel.h
//  Welian
//
//  Created by dong on 14-9-23.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishModel : NSObject
/**  内容   */
@property (nonatomic, strong) NSString *content;
/**  纬度   */
@property (nonatomic, strong) NSString *x;
/**  经度   */
@property (nonatomic, strong) NSString *y;
/**  地址   */
@property (nonatomic, strong) NSString *address;

/**  图片   */
@property (nonatomic, strong) NSMutableArray *photos;

@end
