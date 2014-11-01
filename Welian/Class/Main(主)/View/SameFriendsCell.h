//
//  SameFriendsCell.h
//  weLian
//
//  Created by dong on 14/10/21.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SameFriendsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *oneImage;

@property (weak, nonatomic) IBOutlet UIImageView *twoImage;

@property (weak, nonatomic) IBOutlet UIImageView *threeImage;

@property (weak, nonatomic) IBOutlet UIImageView *fourImage;

@property (nonatomic, strong) NSMutableArray *imageURLArray;


@end
