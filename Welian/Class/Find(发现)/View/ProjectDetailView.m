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
#import "MJPhoto.h"
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
    _datasource = nil;
    _projectInfo = nil;
    _iProjectInfo = nil;
    _projectDetailInfo = nil;
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
    _infoLabel.width = self.width - kMarginLeft;
    [_infoLabel sizeToFit];
    _infoLabel.top = kMarginLeft;
    _infoLabel.left = kMarginLeft;
    
    // 根据图片数量计算相册的尺寸
//    CGSize photoListSize = _photoListView.photos.count > 0 ? [WLPhotoListView photoListSizeWithCount:_photoListView.photos needAutoSize:YES] : CGSizeMake(self.width, 0);
//    _photoListView.frame = CGRectMake(kMarginLeft, _infoLabel.bottom + (_projectInfo.photos > 0 ? kMarginEdge : 0), photoListSize.width, photoListSize.height);
    if (_projectDetailInfo) {
        _collectionView.frame = CGRectMake(kMarginLeft, _infoLabel.bottom + (_projectDetailInfo.rsPhotoInfos.count > 0 ? kMarginEdge : 0), self.width - kMarginLeft , _projectDetailInfo.rsPhotoInfos.count > 0 ? kItemWidth : 0);
        if (_projectDetailInfo.des.length == 0) {
            _collectionView.centerY = self.height / 2.f;
        }
    }
}

- (void)setProjectDetailInfo:(ProjectDetailInfo *)projectDetailInfo
{
    [super willChangeValueForKey:@"projectDetailInfo"];
    _projectDetailInfo = projectDetailInfo;
    [super didChangeValueForKey:@"projectDetailInfo"];
    _infoLabel.text = _projectDetailInfo.des;
    
    NSMutableArray *photos = [NSMutableArray array];
    NSArray *photoInfos = _projectDetailInfo.rsPhotoInfos.allObjects;
    if (photoInfos > 0) {
        for (int i = 0; i< photoInfos.count; i++) {
            WLPhoto *wlphoto = [[WLPhoto alloc] init];
            wlphoto.url = [photoInfos[i] photo];
            [photos addObject:wlphoto];
        }
    }
    self.datasource = photos;
    _collectionView.hidden = NO;
    //    _photoListView.photos = photos;
    [_collectionView reloadData];
}

- (void)setProjectInfo:(ProjectInfo *)projectInfo
{
    [super willChangeValueForKey:@"projectInfo"];
    _projectInfo = projectInfo;
    [super didChangeValueForKey:@"projectInfo"];
    _infoLabel.text = _projectInfo.des;
    _collectionView.hidden = YES;
}

- (void)setIProjectInfo:(IProjectInfo *)iProjectInfo
{
    [super willChangeValueForKey:@"iProjectInfo"];
    _iProjectInfo = iProjectInfo;
    [super didChangeValueForKey:@"iProjectInfo"];
    _infoLabel.text = _projectInfo.des;
    _collectionView.hidden = YES;
}

#pragma mark - Private
- (void)setup{
//    [self setDebug:YES];
    //项目信息
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = [UIFont systemFontOfSize:14.f];
    infoLabel.textColor = RGB(125.f, 125.f, 125.f);
//    infoLabel.text = @"互联网创业，就是要开放协作。微链专注于互联网创业社交，链接创业者及创业者的朋友，让创业成为一种生活方式。";
    infoLabel.numberOfLines = 0;
    [self addSubview:infoLabel];
    self.infoLabel = infoLabel;
//    [infoLabel setDebug:YES];
    
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
//    ProjcetDetailImageViewCell *cell = (ProjcetDetailImageViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < _datasource.count; i++) {
        ProjcetDetailImageViewCell *cell = (ProjcetDetailImageViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        WLPhoto *wlPhoto = _datasource[i];
        MJPhoto *mjPhoto = [[MJPhoto alloc] init];
        if (cell) {
            mjPhoto.srcImageView = cell.photoView; // 来源于哪个UIImageView
        }else{
            WLPhotoView *wlPhotoView = [[WLPhotoView alloc] init];
            mjPhoto.srcImageView = wlPhotoView; // 来源于哪个UIImageView
            mjPhoto.hasNoImageView = YES;
        }
        //去除，现实高清图地址
        NSString *photoUrl = wlPhoto.url;
        photoUrl = [photoUrl stringByReplacingOccurrencesOfString:@"_x.jpg" withString:@".jpg"];
        photoUrl = [photoUrl stringByReplacingOccurrencesOfString:@"_x.png" withString:@".png"];
        mjPhoto.url = [NSURL URLWithString:photoUrl]; // 图片路径
        
        [photos addObject:mjPhoto];
    }
    if (_imageClickedBlock) {
        _imageClickedBlock(indexPath,photos);
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
    if(info.length > 0 || images.count > 2){
        float maxWidth = [[UIScreen mainScreen] bounds].size.width  - kMarginLeft;
        //计算第一个label的高度
        CGSize size1 = [info calculateSize:CGSizeMake(maxWidth, FLT_MAX) font:[UIFont systemFontOfSize:14.f]];
        //计算第二个label的高度
        //    CGSize size2 = images.count > 0 ? [WLPhotoListView photoListSizeWithCount:images needAutoSize:YES] : CGSizeMake(maxWidth, 0);
        CGSize size2 = images.count > 0 ? CGSizeMake(kItemWidth, kItemWidth) : CGSizeMake(maxWidth, 0);
        
        float height = size1.height + size2.height + (info.length > 0 ? kMarginLeft * 2.f : 0) + (images.count > 0 ? kMarginEdge : 0);
        return height;
    }else{
        return 0.f;
    }
}

@end
