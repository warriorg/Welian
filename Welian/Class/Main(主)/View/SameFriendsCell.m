//
//  SameFriendsCell.m
//  weLian
//
//  Created by dong on 14/10/21.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "SameFriendsCell.h"
#import "UIImageView+WebCache.h"
#import "FriendsUserModel.h"

@implementation SameFriendsCell

- (void)awakeFromNib {
    [_oneImage.layer setMasksToBounds:YES];
    [_oneImage.layer setCornerRadius:_oneImage.bounds.size.height*0.5];
    [_twoImage.layer setMasksToBounds:YES];
    [_twoImage.layer setCornerRadius:_twoImage.bounds.size.height*0.5];
    [_threeImage.layer setMasksToBounds:YES];
    [_threeImage.layer setCornerRadius:_threeImage.bounds.size.height*0.5];
    [_fourImage.layer setMasksToBounds:YES];
    [_fourImage.layer setCornerRadius:_fourImage.bounds.size.height*0.5];
}

- (void)setImageURLArray:(NSMutableArray *)imageURLArray
{
    _imageURLArray = imageURLArray;
    NSInteger i = 0;
    for (FriendsUserModel *modeurlStr  in imageURLArray) {
        NSString *urlStr = modeurlStr.avatar;
        if (i==0) {
            [_oneImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil options:SDWebImageRetryFailed];
        }else if (i==1){
            [_twoImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed];
        }else if (i==2){
            [_threeImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil options:SDWebImageRetryFailed];
        }else if (i==3){
            [_fourImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil options:SDWebImageRetryFailed];
            break;
        }
        i++;
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
