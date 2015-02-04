//
//  FinancingCell.m
//  Welian
//
//  Created by dong on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "FinancingCell.h"

@implementation FinancingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SuperSize.width-30, 25)];
        [self.contentView addSubview:_titLabel];
        _textView = [[IWTextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titLabel.frame), SuperSize.width-20, 160)];
        [self.textView setBaseWritingDirection:UITextWritingDirectionLeftToRight forRange:nil];
        [self.textView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        [self.textView setFont:[UIFont systemFontOfSize:16]];
        [self.contentView addSubview:_textView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
