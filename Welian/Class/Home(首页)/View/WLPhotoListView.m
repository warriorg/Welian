//
//  WLPhotoListView.m
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLPhotoListView.h"
#import "WLPhotoView.h"

@implementation WLPhotoListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.初始化9个图片对象
        for (int i = 0; i<IWPhotoMaxCount; i++) {
            WLPhotoView *photoView = [[WLPhotoView alloc] init];
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
    
    // 1.图片个数 3
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
            photoView.hidden = NO;
            
            // 3.设置图片的frame
            int maxColPerRow = picCount == 4 ? 2 : 3;
            
            // 第几列
            int col  = i % maxColPerRow;
            // 第几行
            int row = i / maxColPerRow;
            
            // x 取决于 列
            CGFloat photoX = col * (IWPhotoWH + IWPhotoMargin);
            // y 取决于 行
            CGFloat photoY = row * (IWPhotoWH + IWPhotoMargin);
            photoView.frame = CGRectMake(photoX, photoY, IWPhotoWH, IWPhotoWH);
            
            // 4.显示图片
            photoView.photo = photos[i];
            
        } else { // 没有可以展示的图片
            photoView.hidden = YES;
        }
    }
}

+ (CGSize)photoListSizeWithCount:(int)count
{
    // 1.每一行的最大列数
    int maxColPerRow = count == 4 ? 2 : 3;
    
    // 2.列数
    int colCount = count >= maxColPerRow ? maxColPerRow : count;
    
    // 3.行数
    // 行数 = (总个数 + 每行最多显示数 - 1) / 每行最多显示数
    int rowCount = (count + maxColPerRow - 1) / maxColPerRow;
    
    CGFloat photoListW = colCount * IWPhotoWH + (colCount - 1) * IWPhotoMargin;
    CGFloat photoListH = rowCount * IWPhotoWH + (rowCount - 1) * IWPhotoMargin;
    
    return CGSizeMake(photoListW, photoListH);
}

@end
