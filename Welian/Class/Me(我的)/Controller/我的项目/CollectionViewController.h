//
//  CollectionViewController.h
//  Welian
//
//  Created by dong on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UICollectionViewController

// 1 投资领域  2投资阶段
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout withType:(NSInteger)type;

@end
