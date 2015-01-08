//
//  HaderInfoCell.m
//  weLian
//
//  Created by dong on 14/10/21.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "HaderInfoCell.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface HaderInfoCell()
{
    // 头像
    UIImageView *_iconImage;
    // 姓名
    UILabel *_nameLabel;
    // 投资者图
    UIImageView *_investorImage;
    // 创业者图
    UIImageView *_startupImage;
    // 公司职务信息
    UILabel *_infoLabel;
}
@end


@implementation HaderInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"haderCell";
    HaderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HaderInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadUI];
    }
    return self;
}




- (void)loadUI
{
    CGFloat x = 20.0;
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, x, 50, 50)];
    [_iconImage.layer setMasksToBounds:YES];
    [_iconImage.layer setCornerRadius:25.0];
    [self.contentView addSubview:_iconImage];
    _investorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_mycard_tou"]];
    [_investorImage setFrame:CGRectMake(CGRectGetMaxX(_iconImage.frame)-15, CGRectGetMaxY(_iconImage.frame)-15, 15, 15)];
    [_investorImage setHidden:YES];
    [self.contentView addSubview:_investorImage];
    
    
    _nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_nameLabel];
    
    _infoLabel = [[UILabel alloc] init];
    [_infoLabel setFont:[UIFont systemFontOfSize:14]];
    [_infoLabel setNumberOfLines:2];
    [_infoLabel setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:_infoLabel];
    
    
    _startupImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge_chuang_big"]];
    [_startupImage setHidden:YES];
    [self.contentView addSubview:_startupImage];
}

- (void)setUserM:(IBaseUserM *)userM
{
    _userM = userM;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_userM.avatar] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    [_iconImage setUserInteractionEnabled:YES];
    [_iconImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
    
    CGSize timeSize = [userM.name sizeWithFont:[UIFont systemFontOfSize:17]];
    CGFloat labelx = CGRectGetMaxX(_iconImage.frame)+10;
    [_nameLabel setFrame:CGRectMake(labelx, 20.0, timeSize.width, timeSize.height)];
    [_nameLabel setText:userM.name];
    
    if ([userM.investorauth integerValue]==1) {
        [_investorImage setHidden:NO];
    }
    
    if (userM.position&&userM.company) {
        NSString *infostr = [NSString stringWithFormat:@"%@   %@",userM.position,userM.company];
        // 3
        CGSize contentSize = [infostr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.bounds.size.width - 95, MAXFLOAT)];
        [_infoLabel setText:infostr];
        CGFloat infLabelY =CGRectGetMaxY(_nameLabel.frame);
        if (contentSize.height<20) {
            infLabelY += 10;
        }
        [_infoLabel setFrame:CGRectMake(labelx, infLabelY, contentSize.width, contentSize.height)];
    }
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    // 1.封装图片数据
    // 替换为中等尺寸图片
    NSString *url = _userM.avatar;
    MJPhoto *photo = [[MJPhoto alloc] init];
    url = [url stringByReplacingOccurrencesOfString:@"_x.jpg" withString:@".jpg"];
    url = [url stringByReplacingOccurrencesOfString:@"_x.png" withString:@".png"];
    photo.url = [NSURL URLWithString:url]; // 图片路径
    photo.srcImageView = _iconImage; // 来源于哪个UIImageView
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = @[photo]; // 设置所有的图片
    [browser show];
    [browser.toolbar setHidden:YES];
}


@end
