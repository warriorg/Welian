//
//  UserInfoViewCell.m
//  Welian
//
//  Created by weLian on 15/3/26.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "UserInfoViewCell.h"

#define kMarginLeft 30.f

@implementation UserInfoViewCell

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
    
    [self.textLabel sizeToFit];
    self.textLabel.left = kMarginLeft;
    self.textLabel.bottom = self.contentView.height / 2.f;
    
    if (_isInTwoLine) {
        self.detailTextLabel.width = self.width - kMarginLeft - 15 - self.textLabel.width;
        [self.detailTextLabel sizeToFit];
        self.detailTextLabel.left = self.textLabel.right;
        
        if(self.detailTextLabel.text.length > 0){
            self.detailTextLabel.centerY = self.contentView.height / 2.f;
            self.textLabel.top = self.detailTextLabel.top;
        }else{
            self.textLabel.centerY = self.contentView.height / 2.f;
            self.detailTextLabel.top = self.textLabel.top;
        }
        
    }else{
        self.detailTextLabel.width = self.width - kMarginLeft - self.textLabel.left;
        [self.detailTextLabel sizeToFit];
        if (self.detailTextLabel.width > self.width - kMarginLeft - self.textLabel.left) {
            self.detailTextLabel.width = self.width - kMarginLeft - self.textLabel.left;
        }
        self.detailTextLabel.top = self.textLabel.bottom + 3.f;
        self.detailTextLabel.left = kMarginLeft;
    }
    
    self.bottomLineView.left = self.textLabel.left;
}

#pragma mark - Private
- (void)setup
{
    
}

//返回cell的高度
+ (CGFloat)configureWithMsg:(NSString *)msg detailMsg:(NSString *)detailMsg
{
    float maxWidth = [[UIScreen mainScreen] bounds].size.width - kMarginLeft - 15.f;
    //计算第一个label的高度
    CGSize size1 = [msg calculateSize:CGSizeMake(maxWidth, FLT_MAX) font:kNormal14Font];
    CGSize size2 = [detailMsg calculateSize:CGSizeMake(maxWidth - size1.width, FLT_MAX) font:kNormal14Font];
    
    float height = size2.height + 15.f;
    if (height > 33.f) {
        return height;
    }else{
        return 33.f;
    }
}

@end
