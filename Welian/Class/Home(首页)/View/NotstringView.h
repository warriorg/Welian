//
//  NotstringView.h
//  weLian
//
//  Created by dong on 14/11/15.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NotstringViewBtnClickedBlock)(void);

@interface NotstringView : UIView

@property (strong,nonatomic) NotstringViewBtnClickedBlock BtnClickedBlock;

//1个标题和图片
- (instancetype)initWithFrame:(CGRect)frame
                   withTitStr:(NSString *)titStr
                 andImageName:(NSString *)imageName;

//单个标题
- (instancetype)initWithFrame:(CGRect)frame
                 withTitleStr:(NSString *)titleStr;

///2个标题
- (instancetype)initWithFrame:(CGRect)frame
                 withTitleStr:(NSString *)titleStr
                     SubTitle:(NSString *)subTitle;

//单个图片
- (instancetype)initWithFrame:(CGRect)frame
                    ImageName:(NSString *)imageName;

///2个标题
- (instancetype)initWithFrame:(CGRect)frame
                 withTitleStr:(NSString *)titleStr
                     SubTitle:(NSString *)subTitle
                     BtnTitle:(NSString *)btnTitle
                 BtnImageName:(NSString *)btnImageName;

///2个标题 1个操作按钮
- (instancetype)initWithFrame:(CGRect)frame
                    ImageName:(NSString *)imageName
                 withTitleStr:(NSString *)titleStr
                     SubTitle:(NSString *)subTitle
                     BtnTitle:(NSString *)btnTitle
                 BtnImageName:(NSString *)btnImageName;

@end
