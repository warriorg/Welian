//
//  ProjectDetailView.m
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectDetailView.h"
//#import "WLPhotoListView.h"
#import "WLPhoto.h"
#import "ProjcetDetailImageViewCell.h"

#define kMarginLeft 15.f
#define kMarginEdge 10.f
#define kItemWidth 107.f

@interface ProjectDetailView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (assign,nonatomic) UILabel *infoLabel;
//@property (assign,nonatomic) WLPhotoListView *photoListView;
@property (assign,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSArray *datasource;

@end

@implementation ProjectDetailView

- (void)dealloc
{
    _projectInfo = nil;
    _imageClickedBlock = nil;
}

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
//    CGSize photoListSize = _photoListView.photos.count > 0 ? [WLPhotoListView photoListSizeWithCount:_photoListView.photos needAutoSize:YES] : CGSizeMake(self.width, 0);
//    _photoListView.frame = CGRectMake(kMarginLeft, _infoLabel.bottom + (_projectInfo.photos > 0 ? kMarginEdge : 0), photoListSize.width, photoListSize.height);
    _collectionView.frame = CGRectMake(kMarginLeft, _infoLabel.bottom + (_projectInfo.photos > 0 ? kMarginEdge : 0), self.width - kMarginLeft , _projectInfo.photos.count > 0 ? kItemWidth : 0);
}

- (void)setProjectInfo:(IProjectDetailInfo *)projectInfo
{
    [super willChangeValueForKey:@"projectInfo"];
    _projectInfo = projectInfo;
    [super didChangeValueForKey:@"projectInfo"];
    _infoLabel.text = _projectInfo.des;
    
    NSMutableArray *photos = [NSMutableArray array];
    if (_projectInfo.photos > 0) {
        for (int i = 0; i<_projectInfo.photos.count; i++) {
            WLPhoto *wlphoto = [[WLPhoto alloc] init];
            wlphoto.url = [_projectInfo.photos[i] photo];
            [photos addObject:wlphoto];
        }
    }
    self.datasource = photos;
//    _photoListView.photos = photos;
    [_collectionView reloadData];
}

#pragma mark - Private
- (void)setup{
    //项目信息
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = [UIFont systemFontOfSize:16.f];
    infoLabel.textColor = [UIColor blackColor];
//    infoLabel.text = @"互联网创业，就是要开放协作。微链专注于互联网创业社交，链接创业者及创业者的朋友，让创业成为一种生活方式。";
    infoLabel.numberOfLines = 0;
    [self addSubview:infoLabel];
    self.infoLabel = infoLabel;
    
    // 6.配图
//    WLPhotoListView *photoListView = [[WLPhotoListView alloc] init];
//    photoListView.needAutoSize = YES;
//    [self addSubview:photoListView];
//    self.photoListView = photoListView;
    
    //项目列表
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    flowLayOut.itemSize = CGSizeMake(kItemWidth, kItemWidth);
    flowLayOut.sectionInset = UIEdgeInsetsMake(0, 1, 0, 5);//设置边距
    //    flowLayOut.minimumLineSpacing = 5.f;//每个相邻layout的上下
    flowLayOut.minimumInteritemSpacing = 6.f;//每个相邻layout的左右
    // 移动方向的设置
    [flowLayOut setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                          collectionViewLayout:flowLayOut];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    // 注册cell
    [collectionView registerClass:[ProjcetDetailImageViewCell class] forCellWithReuseIdentifier:@"ProjectDetailImageViewCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjcetDetailImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProjectDetailImageViewCell" forIndexPath:indexPath];
//    [cell setDebug:YES];
//    [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:[_projectInfo.photos[indexPath.row] photo]] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    cell.photoView.photo = _datasource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjcetDetailImageViewCell *cell = (ProjcetDetailImageViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (_imageClickedBlock) {
        _imageClickedBlock(indexPath,cell.photoView);
    }
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
//    CGSize size2 = images.count > 0 ? [WLPhotoListView photoListSizeWithCount:images needAutoSize:YES] : CGSizeMake(maxWidth, 0);
    CGSize size2 = images.count > 0 ? CGSizeMake(kItemWidth, kItemWidth) : CGSizeMake(maxWidth, 0);
    
    float height = size1.height + size2.height + kMarginLeft * 2.f + (images.count > 0 ? kMarginEdge : 0);
    return height;
}

@end
