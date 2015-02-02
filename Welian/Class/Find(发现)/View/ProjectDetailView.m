//
//  ProjectDetailView.m
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectDetailView.h"
#import "WLPhotoListView.h"
#import "WLPhoto.h"

#define kMarginLeft 15.f
#define kMarginEdge 10.f

@interface ProjectDetailView ()

@property (assign,nonatomic) UILabel *infoLabel;
@property (assign,nonatomic) WLPhotoListView *photoListView;

@end

@implementation ProjectDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _infoLabel.width = self.width - kMarginLeft * 2.f;
    [_infoLabel sizeToFit];
    _infoLabel.top = kMarginLeft;
    _infoLabel.left = kMarginLeft;
    
    // 根据图片数量计算相册的尺寸
    CGSize photoListSize = [WLPhotoListView photoListSizeWithCount:@[@"http://img.welian.com/1422852770307-200-266_x.jpg",@"http://img.welian.com/1422852770307-200-266_x.jpg"] needAutoSize:YES];
    _photoListView.frame = CGRectMake(kMarginLeft, _infoLabel.bottom + kMarginEdge, photoListSize.width, photoListSize.height);
}

#pragma mark - Private
- (void)setup{
    //项目信息
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = [UIFont systemFontOfSize:16.f];
    infoLabel.textColor = [UIColor blackColor];
    infoLabel.text = @"互联网创业，就是要开放协作。微链专注于互联网创业社交，链接创业者及创业者的朋友，让创业成为一种生活方式。";
    infoLabel.numberOfLines = 0;
    [self addSubview:infoLabel];
    self.infoLabel = infoLabel;
    
    // 6.配图
    WLPhotoListView *photoListView = [[WLPhotoListView alloc] init];
    photoListView.needAutoSize = YES;
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i<6; i++) {
        WLPhoto *wlphoto = [[WLPhoto alloc] init];
        wlphoto.url = @"http://img.welian.com/1422852770307-200-266_x.jpg";
        [photos addObject:wlphoto];
    }
    photoListView.photos = photos;
    [self addSubview:photoListView];
    self.photoListView = photoListView;
}

/**
 *  计算自定义Cell的高度
 *
 *  @param name 第一个label的高度
 *  @param msg  第二个label的高度
 *
 *  @return 返回最终的高度
 */
+ (CGFloat)configureWithInfo:(NSString *)info Images:(NSArray *)images
{
    float maxWidth = [[UIScreen mainScreen] bounds].size.width  - kMarginLeft * 2.f;
    //计算第一个label的高度
    CGSize size1 = [info calculateSize:CGSizeMake(maxWidth, FLT_MAX) font:[UIFont systemFontOfSize:16.f]];
    //计算第二个label的高度
    CGSize size2 = [WLPhotoListView photoListSizeWithCount:images needAutoSize:YES];
    
    float height = size1.height + size2.height + kMarginLeft + kMarginEdge;
    if (height > 60) {
        return height;
    }else{
        return 60;
    }
}

@end
