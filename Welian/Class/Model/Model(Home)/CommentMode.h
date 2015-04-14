//
//  CommentMode.h
//  weLian
//
//  Created by dong on 14-10-13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLBasicTrends.h"

@interface CommentMode : NSObject

/**  fcid   */
@property (nonatomic, strong) NSNumber *fcid;

/**  comment评论   */
@property (nonatomic, strong) NSString *comment;

/**  评论时间   */
@property (nonatomic, strong) NSString *created;

/**  评论人   */
@property (nonatomic, strong) WLBasicTrends *user;

/**  对该评论的评论人   */
@property (nonatomic, strong) WLBasicTrends *touser;


@property (nonatomic, strong) NSString *commentAndName;

@end
