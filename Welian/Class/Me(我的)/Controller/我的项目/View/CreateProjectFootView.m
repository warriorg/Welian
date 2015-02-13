//
//  CreateProjectFootView.m
//  Welian
//
//  Created by dong on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "CreateProjectFootView.h"

@implementation CreateProjectFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        _titLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SuperSize.width-30, 25)];
        [_titLabel setFont:WLFONT(16)];
        [self addSubview:_titLabel];
        
        _lentLabel = [[UILabel alloc] initWithFrame:CGRectMake(SuperSize.width-50, 10, 50, 25)];
        [_lentLabel setFont:WLFONT(15)];
        [self addSubview:_lentLabel];
        
        _textView = [[IWTextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titLabel.frame), SuperSize.width-20, 140)];
        [self.textView setBaseWritingDirection:UITextWritingDirectionLeftToRight forRange:nil];
        [self.textView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        [self.textView setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:_textView];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
//        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView setScrollEnabled:NO];
        [self addSubview:_collectionView];
        
        // 选择照片
        UIImage *butImage = [UIImage imageNamed:@"home_new_picture"];
        _photBut = [[UIButton alloc] init];
        [_photBut setImage:butImage forState:UIControlStateNormal];
        [self addSubview:_photBut];
    }
    return self;
}


@end
