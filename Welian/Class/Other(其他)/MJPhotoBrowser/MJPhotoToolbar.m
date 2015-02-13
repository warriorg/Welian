//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
#import "WLHUDView.h"
//#import "MBProgressHUD+Add.h"

@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    BOOL _isdelete;
}
@end

@implementation MJPhotoToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setIsDelete:(BOOL)isDelete
{
    _isDelete = isDelete;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = self.bounds;
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
    }
    // 保存图片按钮
    CGFloat btnWidth = self.bounds.size.height;
    self.saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveImageBtn.frame = CGRectMake(20, 0, btnWidth-5, btnWidth-5);
    self.saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.saveImageBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [self addSubview:self.saveImageBtn];
    
    
    if (_isDelete) {
        [self.saveImageBtn setImage:[UIImage imageNamed:@"home_new_upload_picture_enlarge_delete.png"] forState:UIControlStateNormal];
//        [self.saveImageBtn setImage:[UIImage imageNamed:@"home_new_upload_picture_enlarge_delete.png"] forState:UIControlStateHighlighted];
    }else{
        
        [self.saveImageBtn setImage:[UIImage imageNamed:@"home_picture_enlarge_download.png"] forState:UIControlStateNormal];
//        [self.saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
        [self.saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)saveImage
{
//    NSMutableArray *photArrayM = [NSMutableArray arrayWithArray:_photos];
//    [photArrayM removeObjectAtIndex:_currentPhotoIndex];
//    self.photos = [NSArray arrayWithArray:photArrayM];
//    [self setCurrentPhotoIndex:_currentPhotoIndex+1];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [WLHUDView showErrorHUD:@"保存失败"];

    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _saveImageBtn.enabled = NO;
        [WLHUDView showSuccessHUD:@"成功保存到相册"];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%d / %d", _currentPhotoIndex + 1, _photos.count];
    
//    MJPhoto *photo = _photos[_currentPhotoIndex];
    // 按钮
//    _saveImageBtn.enabled = photo.image != nil && !photo.save;
}

@end
