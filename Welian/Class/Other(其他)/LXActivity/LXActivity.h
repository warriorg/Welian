//
//  LXActivity.h
//  LXActivityDemo
//
//  Created by lixiang on 14-3-17.
//  Copyright (c) 2014年 lcolco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LXActivityDelegate <NSObject>
- (void)didClickOnImageIndex:(NSString *)imageIndex;
@optional
- (void)didClickOnCancelButton;
@end

@interface LXActivity : UIView

- (id)initWithDelegate:(id<LXActivityDelegate>)delegate WithTitle:(NSString *)title otherButtonTitles:(NSArray*)buttonsTitle ShareButtonTitles:(NSArray *)shareButtonTitlesArray withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray;

- (void)showInView:(UIView *)view;

@end
