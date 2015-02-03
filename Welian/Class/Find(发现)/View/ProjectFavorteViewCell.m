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
#define kItemEdge 10.f

@interface ProjectFavorteViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (assign,nonatomic) UICollectionView *collectionView;

@end

@implementation ProjectFavorteViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _collectionView.frame = CGRectMake(kMarginLeft, 0.f, self.width - kMarginLeft * 2.f, self.height);
}

#pragma mark - Private
- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //项目列表
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = (ScreenWidth - kMarginLeft * 2.f - 9 * kItemEdge) / 10.f;
    flowLayOut.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowLayOut.sectionInset = UIEdgeInsetsMake(0, 1, 0, 5);//设置边距
//    flowLayOut.minimumLineSpacing = 5.f;//每个相邻layout的上下
    flowLayOut.minimumInteritemSpacing = kItemEdge;//每个相邻layout的左右
    // 移动方向的设置
    [flowLayOut setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                          collectionViewLayout:flowLayOut];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView setDebug:YES];
    // 注册cell
    [collectionView registerClass:[ProjectFavorteItemView class] forCellWithReuseIdentifier:@"ProjectFavrteViewCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectFavorteItemView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProjectFavrteViewCell" forIndexPath:indexPath];
    [cell setDebug:YES];
    [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img.welian.com/1419346781840-177-177_x.jpg"] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
