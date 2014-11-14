//
//  MessageHomeModel.h
//  weLian
//
//  Created by dong on 14/11/14.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageHomeModel : NSObject

/**  该条消息的id   */
@property (nonatomic, strong) NSString *comentid;

/**  是否看过   */
@property (nonatomic, strong) NSString *isLook;

/**  评论人头像   */
@property (nonatomic, strong) NSString *avatar;

/**  评论人姓名   */
@property (nonatomic, strong) NSString *name;

/**  评论人uid   */
@property (nonatomic, strong) NSString *uid;

/**  动态信息   */
@property (nonatomic, strong) NSString *feedcontent;

/**  动态id   */
@property (nonatomic, strong) NSString *feedid;

/**  动态图片   */
@property (nonatomic, strong) NSString *feedpic;

/**  对该动态的评论   */
@property (nonatomic, strong) NSString *msg;

/**  类型   */
@property (nonatomic, strong) NSString *type;


/**  时间   */
@property (nonatomic, strong) NSString *tiem;

@end
