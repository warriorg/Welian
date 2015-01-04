//
//  InvestCollectionCell.h
//  Welian
//
//  Created by dong on 14/12/27.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *checkImageView;
@property (weak, nonatomic) IBOutlet UILabel *titeLabel;
@property (weak, nonatomic) IBOutlet UIButton *ClickBut;

@property (nonatomic, assign) BOOL iselected;

@end
