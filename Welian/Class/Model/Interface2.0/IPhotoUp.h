//
//  IPhotoUp.h
//  Welian
//
//  Created by dong on 15/5/5.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface IPhotoUp : IFBase

/**   //  FeedID : 只有动态才有 每个动态的唯一标示   */
@property (nonatomic, strong) NSString *name;

/**  第几个图片   */
@property (nonatomic, assign) NSInteger order;

/**  图片URL   */
@property (nonatomic, strong) NSString *photo;

/**  //  type : avatar 头像, feed 动态,investor 投资人名片,project 项目   */
@property (nonatomic, strong) NSString *type;

@end
