//
//  CommentMode.h
//  weLian
//
//  Created by dong on 14-10-13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface CommentMode : IFBase

/**  fcid   */
@property (nonatomic, strong) NSNumber *fcid;

/**  comment评论   */
@property (nonatomic, strong) NSString *comment;

/**  评论时间   */
@property (nonatomic, strong) NSString *created;

/**  评论人   */
@property (nonatomic, strong) IBaseUserM *user;

/**  对该评论的评论人   */
@property (nonatomic, strong) IBaseUserM *touser;


@property (nonatomic, strong) NSString *commentAndName;

@end
