//
//  ActivityTypeInfoCell.m
//  Welian
//
//  Created by weLian on 15/2/11.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityTypeInfoCell.h"

@interface ActivityTypeInfoCell ()

@end

@implementation ActivityTypeInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        //    cell.projectInfo = _datasource[indexPath.section][indexPath.row];
        UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_selected"]];
        self.accessoryView = accessoryImageView;
    }else{
        self.accessoryView = nil;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.detailTextLabel.left = self.textLabel.right + 10.f;
}

#pragma mark - Private
- (void)setup
{
    //设置选择效果
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.textLabel.font = kNormal16Font;
    self.detailTextLabel.textColor = RGB(79.f, 192.f, 232.f);
    self.detailTextLabel.font = kNormal12Font;
}

@end
