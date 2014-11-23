//
//  CommentHomeViewFrame.h
//  weLian
//
//  Created by dong on 14/11/23.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WLStatusM;

@interface CommentHomeViewFrame : NSObject

- (instancetype)initWithWidth:(CGFloat)width;

@property (nonatomic, assign, readonly) CGRect oneLabelFrame;
@property (nonatomic, assign, readonly) CGRect twoLabelFrame;
@property (nonatomic, assign, readonly) CGRect threeLabelFrame;
@property (nonatomic, assign, readonly) CGRect fourLabelFrame;
@property (nonatomic, assign, readonly) CGRect fiveLabelFrame;
@property (nonatomic, assign, readonly) CGRect moreLabelFrame;

/**  <#Description#>   */
@property (nonatomic, strong, readonly) NSString *oneLabelStr;
/**  <#Description#>   */
@property (nonatomic, strong, readonly) NSString *twoLabelStr;
/**  <#Description#>   */
@property (nonatomic, strong, readonly) NSString *threeLabelStr;
/**  <#Description#>   */
@property (nonatomic, strong, readonly) NSString *fourLabelStr;
/**  <#Description#>   */
@property (nonatomic, strong, readonly) NSString *fiveLabelStr;
/**  <#Description#>   */
@property (nonatomic, strong, readonly) NSString *moreLabelStr;

@property (nonatomic, assign ,readonly) CGFloat cellHigh;

@property (nonatomic, strong) WLStatusM *statusM;

@end
