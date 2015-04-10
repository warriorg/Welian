//
//  MJPhotoLoadingView.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MJPhotoProgressView.h"
#import "UCZProgressView.h"

#define kMinProgress 0.0001

@class MJPhotoBrowser;
@class MJPhoto;

@interface MJPhotoLoadingView : UIView
@property (nonatomic) float progress;

@property (nonatomic, strong) UCZProgressView *progressView;

- (void)showLoading;
- (void)showFailure;
@end