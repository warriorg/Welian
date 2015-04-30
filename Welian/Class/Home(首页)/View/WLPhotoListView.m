//
//  WLPhotoListView.m
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLPhotoListView.h"
#import "WLPhotoView.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "WLPhoto.h"

#define kMarginLeft 15.f

@implementation WLPhotoListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // 1.初始化9个图片对象
        for (int i = 0; i<IWPhotoMaxCount; i++) {
            WLPhotoView *photoView = [[WLPhotoView alloc] init];
//            [photoView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            [self addSubview:photoView];
        }
    }
    return self;
}

/**
 *  根据图片个数展示对应的图片view
 *
 *  @param pic_urls 所有的图片数组（里面都是IWPhoto模型）
 *  根据图片个数 决定 哪些photoView需要显示 或者 隐藏
 */
- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    // 1.图片个数
    int picCount = photos.count;
    
    // 2.遍历所有的子控件(i --- 0 ~ 8)
    for (int i = 0; i<IWPhotoMaxCount; i++) {
        // 2.1.取出对应位置的子控件
        WLPhotoView *photoView = self.subviews[i];
        if (picCount == 1) {
            photoView.contentMode = UIViewContentModeScaleAspectFit;
            photoView.clipsToBounds = NO;
        } else { // 多张
            photoView.contentMode = UIViewContentModeScaleAspectFill;
            // 超出边界范围的内容都裁剪
            photoView.clipsToBounds = YES;
        }
        
        // UIViewContentModeScaleAspectFill 拉伸图片大小到跟imageView尺寸一致，只显示最中间的内容，会保持图片原来的宽高比
        // UIViewContentModeScaleAspectFit 拉伸图片大小，但是会保持图片原来的宽高比
        // UIViewContentModeScaleToFill  (默认)拉伸图片至填充整个imageView
        
        
        // 2.2.判断这个photoView有没有可展示的图片
        if (i < picCount) { // 有可以展示的图片
            
            // 4.显示图片
            photoView.photo = photos[i];
            
            photoView.hidden = NO;
            [photoView setTag:i];
            [photoView setUserInteractionEnabled:YES];
            [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            
            if (picCount == 1) { // 1张
                CGSize size = [self onePhotoSize:photoView.photo.photo];
                if (photoView.photo.imageDataStr) {
                    UIImage *image = photoView.image;
                    size = image.size;
                    CGFloat w = image.size.width;
                    CGFloat h = image.size.height;
                    if (w>h || w==h) {
                        CGFloat se = 1.0;
                        if (w>180) {
                            se = 180/w;
                            w = 180;
                        }
                        h = h*se;
                    }else{
                        CGFloat se = 1.0;
                        if (h>150) {
                            se = 150/h;
                            h= 150;
                        }
                        w = w*se;
                    }
                    size = CGSizeMake(w, h);
                }
                photoView.frame = CGRectMake(0, 0, size.width, size.height);
                continue;
            }
            
            // 3.设置图片的frame
            int maxColPerRow = picCount == 4 ? 2 : 3;
            
            // 第几列
            int col  = i % maxColPerRow;
            // 第几行
            int row = i / maxColPerRow;
            
            CGFloat windowWidth = [UIScreen mainScreen].bounds.size.width;
            CGFloat photoWidth = _needAutoSize ? (windowWidth - kMarginLeft * 2.f - IWPhotoMargin * 2) / 3 : IWPhotoWH;
            CGFloat photoHeight = _needAutoSize ? photoWidth : IWPhotoWH;
            
            // x 取决于 列
            CGFloat photoX = col * (photoWidth + IWPhotoMargin);
            // y 取决于 行
            CGFloat photoY = row * (photoHeight + IWPhotoMargin);
            
            photoView.frame = CGRectMake(photoX, photoY, photoWidth, photoHeight);
            
            
        } else { // 没有可以展示的图片
            photoView.hidden = YES;
        }
    }
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:_photos.count];
    for (int i = 0; i<_photos.count; i++) {
        WLPhotoView *photoView = self.subviews[i];
        // 替换为中等尺寸图片
        NSString *url = photoView.photo.photo;
        MJPhoto *photo = [[MJPhoto alloc] init];
        url = [url stringByReplacingOccurrencesOfString:@"_x.jpg" withString:@".jpg"];
        url = [url stringByReplacingOccurrencesOfString:@"_x.png" withString:@".png"];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = photoView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }

    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

// 一张图片时计算宽高
- (CGSize)onePhotoSize:(NSString *)urlStr
{
    NSArray *array = [urlStr componentsSeparatedByString:@"-"];
    CGFloat w = 180;
    CGFloat h = 150;
    if (array.count>1) {
        w = [array[1] floatValue];
        h = [[array[2] stringByReplacingOccurrencesOfString:@"_x.jpg" withString:@""] floatValue];
        h = [[array[2] stringByReplacingOccurrencesOfString:@".jpg" withString:@""] floatValue];
        h = [[array[2] stringByReplacingOccurrencesOfString:@"_x.png" withString:@""] floatValue];
        h = [[array[2] stringByReplacingOccurrencesOfString:@".png" withString:@""] floatValue];
        if (w>h || w==h) {
            CGFloat se = 1.0;
            if (w>180) {
                se = 180/w;
                w = 180;
            }
            h = h*se;
        }else{
            CGFloat se = 1.0;
            if (h>150) {
                se = 150/h;
                h= 150;
            }
            w = w*se;
        }
    }
    return CGSizeMake(w, h);
}

+ (CGSize)photoListSizeWithCount:(NSArray *)count needAutoSize:(BOOL)needAutoSize
{
    // 1.只有1张图片
    if (count.count == 1) {
        WLPhoto *photo = count[0];
        NSArray *array = [photo.photo componentsSeparatedByString:@"-"];
        CGFloat w = 180;
        CGFloat h = 150;
        if (array.count>1) {
            w = [array[1] floatValue];
            h = [[array[2] stringByReplacingOccurrencesOfString:@"_x.jpg" withString:@""] floatValue];
            h = [[array[2] stringByReplacingOccurrencesOfString:@".jpg" withString:@""] floatValue];
            h = [[array[2] stringByReplacingOccurrencesOfString:@"_x.png" withString:@""] floatValue];
            h = [[array[2] stringByReplacingOccurrencesOfString:@".png" withString:@""] floatValue];
            if (w>h || w==h) {
                CGFloat se = 1.0;
                if (w>180) {
                    se = 180/w;
                    w = 180;
                }
                h = h*se;
            }else{
                CGFloat se = 1.0;
                if (h>150) {
                    se = 150/h;
                    h= 150;
                }
                w = w*se;
            }
        }
        return CGSizeMake(w, h);

    }

    // 1.每一行的最大列数
    NSUInteger maxColPerRow = count.count == 4 ? 2 : 3;
    
    // 2.列数
    NSUInteger colCount = count.count >= maxColPerRow ? maxColPerRow : count.count;
    
    // 3.行数
    // 行数 = (总个数 + 每行最多显示数 - 1) / 每行最多显示数
    NSUInteger rowCount = (count.count + maxColPerRow - 1) / maxColPerRow;
    
    CGFloat photoWidth = needAutoSize ? ([UIScreen mainScreen].bounds.size.width - kMarginLeft * 2.f) / colCount : IWPhotoWH;
    CGFloat photoHeight = needAutoSize ? photoWidth : IWPhotoWH;
    CGFloat photoListW = colCount * photoWidth + (colCount - 1) * IWPhotoMargin;
    CGFloat photoListH = rowCount * photoHeight + (rowCount - 1) * IWPhotoMargin;
    
    return CGSizeMake(photoListW, photoListH);
}


@end
