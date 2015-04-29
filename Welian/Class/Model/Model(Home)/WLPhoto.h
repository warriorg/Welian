//
//  WLPhoto.h
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface WLPhoto : IFBase

/**  图片url   */
@property (nonatomic, strong) NSString *url;

//*   直接用图片 *//
@property (nonatomic, strong) NSData *imageData;

@end
