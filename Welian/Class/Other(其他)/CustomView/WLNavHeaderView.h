//
//  WLNavHeaderView.h
//  Welian
//
//  Created by weLian on 15/3/31.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^leftBtnClickedBlock)(void);
typedef void(^rightBtnClickedBlock)(void);

@interface WLNavHeaderView : UIView

@property (strong,nonatomic) leftBtnClickedBlock leftClickecBlock;
@property (strong,nonatomic) rightBtnClickedBlock rightClickecBlock;

@property (strong,nonatomic) NSString *titleInfo;

- (void)setLeftBtnTitle:(NSString *)leftBtnTitle LeftBtnImage:(UIImage *)leftBtnImage;
- (void)setRightBtnTitle:(NSString *)rightBtnTitle RightBtnImage:(UIImage *)rightBtnImage;

@end
