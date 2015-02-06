//
//  ProjectFavorteViewCell.m
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectFavorteViewCell.h"
#import "ProjectFavorteItemView.h"

#define kMarginLeft 15.f
#define kItemWidth 30.f
#define kMaxItems 10.f

@interface ProjectFavorteViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (assign,nonatomic) UICollectionView *collectionView;

@end

@implementation ProjectFavorteViewCell

- (void)dealloc
{
    _projectInfo = nil;
    _block = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setProjectInfo:(IProjectDetailInfo *)projectInfo
{
    [super willChangeValueForKey:@"projectInfo"];
    _projectInfo = projectInfo;
    [super didChangeValueForKey:@"projectInfo"];
    [_collectionView reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _collectionView.frame = CGRectMake(kMarginLeft, 0.f, self.width - kMarginLeft * 2.f, self.height - 1.f);
}

#pragma mark - Private
- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //项目列表
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    flowLayOut.itemSize = CGSizeMake(kItemWidth, kItemWidth);
    flowLayOut.sectionInset = UIEdgeInsetsMake(0, 1, 0, 5);//设置边距
//    flowLayOut.minimumLineSpacing = 5.f;//每个相邻layout的上下
    flowLayOut.minimumInteritemSpacing = (ScreenWidth - kMarginLeft * 2.f - kMaxItems * kItemWidth) / (kMaxItems - 1);//每个相邻layout的左右
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
    [collectionView registerClass:[ProjectFavorteItemView class] forCellWithReuseIdentifier:@"ProjectFavrteViewCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _projectInfo.zanusers.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectFavorteItemView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProjectFavrteViewCell" forIndexPath:indexPath];
    
    if (indexPath.row < _projectInfo.zanusers.count) {
        IBaseUserM *user = _projectInfo.zanusers[indexPath.row];
        cell.numLabel.text = @"";
        [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    }else{
        cell.numLabel.text = [_projectInfo displayZancountInfo];
        cell.logoImageView.image = nil;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_block) {
        _block(indexPath);
    }
}

@end
