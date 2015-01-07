//
//  BiaoQianView.m
//  Athena
//
//  Created by 张艳东 on 14-7-9.
//  Copyright (c) 2014年 souche. All rights reserved.
//

#import "BiaoQianView.h"
#import "BiaoqainCell.h"

@interface BiaoQianView() <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *cellArrayM;
@end

@implementation BiaoQianView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.cellArrayM = [NSMutableArray array];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setSectionInset:UIEdgeInsetsMake(0, 20, 10, 20)];
        UICollectionView *biaoqianview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, frame.size.height) collectionViewLayout:layout];
        [biaoqianview setBackgroundColor:[UIColor whiteColor]];
        biaoqianview.alwaysBounceVertical = YES;
        [biaoqianview setDataSource:self];
        [biaoqianview setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        [biaoqianview setDelegate:self];
        [biaoqianview registerClass:[BiaoqainCell class] forCellWithReuseIdentifier:@"cellid"];
//        [biaoqianview setBackgroundColor:[UIColor redColor]];
//        [biaoqianview setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin];
        [self addSubview:biaoqianview];
        //        [biaoqianview sizeToFit];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
    CGSize size = [[dic objectForKey:@"name"] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil]  context:nil].size;
    return CGSizeMake(size.width+20, 30);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BiaoqainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    NSDictionary *dic = self.dataArray[indexPath.row];
    //    CGSize size = [[dic objectForKey:@"name"] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil]  context:nil].size;
    [cell.burt setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
    //    [cell.burt setFrame:CGRectMake(0, 0, size.width, 30)];
    [cell.burt sizeToFit];
    CGRect butframe = cell.burt.frame;
    butframe.size.width+=10;
    [cell.burt setFrame:butframe];
    [self.cellArrayM addObject:cell];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BiaoqainCell *cell = (BiaoqainCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.burt setSelected:!cell.burt.selected];
    if ([_delegate respondsToSelector:@selector(biaoQianView:selectBiaoqian:)]) {
        NSMutableString *stringM = [NSMutableString string];
        for (BiaoqainCell *cella in self.cellArrayM) {
            if (cella.burt.selected) {
                [stringM appendFormat:@"%@     ",cella.burt.titleLabel.text];
            }
        }
        [_delegate biaoQianView:self selectBiaoqian:stringM];
    }
    
}


@end
