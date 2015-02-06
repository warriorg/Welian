//
//  CollectionViewController.h
//  Welian
//
//  Created by dong on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateProjectModel.h"
//         self.investBlock(@{@"id":saveidArray,@"name":saveNameArray});
typedef void(^CollectionBlock)(NSArray *investDic);

@interface CollectionViewController : UICollectionViewController

@property (nonatomic, copy) CollectionBlock investBlock;
// 1 投资领域  2投资阶段
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout withType:(NSInteger)type withData:(IProjectDetailInfo*)projectModel;

@end
