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
        _lentLabel = [[UILabel alloc] initWithFrame:CGRectMake(SuperSize.width-50, 10, 50, 25)];
        [_lentLabel setFont:WLFONT(15)];
        [self.contentView addSubview:_lentLabel];
        
        _titLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SuperSize.width-30, 25)];
        [self.contentView addSubview:_titLabel];
        [_titLabel setFont:WLFONT(15)];
        _textView = [[IWTextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titLabel.frame), SuperSize.width-20, 140)];
        [_textView setBaseWritingDirection:UITextWritingDirectionLeftToRight forRange:nil];
        [_textView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        [_textView setFont:kNormal15Font];
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
