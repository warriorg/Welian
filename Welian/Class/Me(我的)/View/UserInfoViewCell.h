//
//  UserInfoViewCell.h
//  Welian
//
//  Created by weLian on 15/3/26.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface UserInfoViewCell : BaseTableViewCell

@property (assign,nonatomic) BOOL isInTwoLine;//第二个内容分割开



+ (CGFloat)configureWithMsg:(NSString *)msg detailMsg:(NSString *)detailMsg;

@end
