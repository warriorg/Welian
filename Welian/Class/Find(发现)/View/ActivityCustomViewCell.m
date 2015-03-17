//
//  ActivityCustomViewCell.m
//  Welian
//
//  Created by weLian on 15/2/12.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityCustomViewCell.h"

@interface ActivityCustomViewCell ()

//@property (assign,nonatomic) UILabel *readyJoinLabel;
//@property (assign,nonatomic) UILabel *totalLabel;

@end

@implementation ActivityCustomViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShowCustomInfo:(BOOL)showCustomInfo
{
    [super willChangeValueForKey:@"showCustomInfo"];
    _showCustomInfo = showCustomInfo;
    [super didChangeValueForKey:@"showCustomInfo"];
//    _readyJoinLabel.hidden = !showCustomInfo;
//    _totalLabel.hidden = !showCustomInfo;
    self.detailTextLabel.hidden = !showCustomInfo;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.textLabel sizeToFit];
    self.textLabel.centerY = self.height / 2.f;
    
    [self.detailTextLabel sizeToFit];
    self.detailTextLabel.left = self.textLabel.right;
    self.detailTextLabel.centerY = self.textLabel.centerY;
    
//    [_readyJoinLabel sizeToFit];
//    _readyJoinLabel.left = self.textLabel.left;
//    _readyJoinLabel.centerY = self.textLabel.centerY;
    
//    [_totalLabel sizeToFit];
//    _totalLabel.left = self.textLabel.right;
//    _totalLabel.centerY = self.textLabel.centerY;
}

#pragma mark - Private
- (void)setup
{
    //标题
    self.textLabel.textColor = RGB(125.f, 125.f, 125.f);
    self.textLabel.font = [UIFont systemFontOfSize:14.f];
    self.textLabel.numberOfLines = 0.f;
    
    self.detailTextLabel.textColor = RGB(125.f, 125.f, 125.f);
    self.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
    
    //已报名人数
//    UILabel *readyJoinLabel = [[UILabel alloc] init];
//    readyJoinLabel.backgroundColor = [UIColor clearColor];
//    readyJoinLabel.textColor = KBlueTextColor;
//    readyJoinLabel.font = [UIFont systemFontOfSize:14.f];
//    readyJoinLabel.text = @"已报名5";
//    [readyJoinLabel setAttributedText:[self getAttributedInfoString:readyJoinLabel.text searchStr:@"5"]];
//    readyJoinLabel.hidden = YES;
//    [self.contentView addSubview:readyJoinLabel];
//    self.readyJoinLabel = readyJoinLabel;
    
    //标题
//    UILabel *totalLabel = [[UILabel alloc] init];
//    totalLabel.backgroundColor = [UIColor clearColor];
//    totalLabel.textColor = RGB(125.f, 125.f, 125.f);
//    totalLabel.font = [UIFont systemFontOfSize:14.f];
//    totalLabel.text = @"人/限额10人";
//    totalLabel.hidden = YES;
//    //设置特殊颜色
//    [totalLabel setAttributedText:[NSObject getAttributedInfoString:totalLabel.text searchStr:@"10" color:KBlueTextColor font:[UIFont systemFontOfSize:14.f]]];
//    [self.contentView addSubview:totalLabel];
//    self.totalLabel = totalLabel;
}

//返回cell的高度
+ (CGFloat)configureWithMsg:(NSString *)msg hasArrowImage:(BOOL)hasArrowImage
{
    float maxWidth = [[UIScreen mainScreen] bounds].size.width - 47.f - (hasArrowImage ? 40.f : 15.f);
    //计算第一个label的高度
    CGSize size = [msg calculateSize:CGSizeMake(maxWidth, FLT_MAX) font:[UIFont systemFontOfSize:14.f]];
    
    float height = size.height + 10.f;
    if (height > 30.f) {
        return height;
    }else{
        return 30.f;
    }
}

@end
