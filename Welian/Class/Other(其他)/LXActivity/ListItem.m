//
//  ListItem.m
//  POHorizontalList
//
//  Created by Polat Olu on 15/02/2013.
//  Copyright (c) 2013 Polat Olu. All rights reserved.
//

#import "ListItem.h"

@implementation ListItem

- (id)initWithImageName:(NSString *)imageName text:(NSString *)imageTitle selectionStyle:(ShareType)style
{
    self = [super init];
    
    if (self) {
        [self setUserInteractionEnabled:YES];
        self.seleStyle = style;
        
        UIButton *imageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageBut setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [imageBut addTarget:self action:@selector(itemTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *title = [[UILabel alloc] init];
        [title setBackgroundColor:[UIColor clearColor]];
        [title setFont:[UIFont systemFontOfSize:12.0]];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor darkGrayColor];
        title.numberOfLines = 2;
        [title setOpaque: NO];
        [title setText:imageTitle];
        
        imageRect = CGRectMake(0.0, 0.0, 60.0, 60.0);
        textRect = CGRectMake(0.0, 60, 60.0, 30.0);
        
        [title setFrame:textRect];
        [imageBut setFrame:imageRect];
        
        [self addSubview:title];
        [self addSubview:imageBut];
    }
    
    return self;
}

- (void)itemTapped:(UIButton *)recognizer {
    if (self.activityBlock) {
        self.activityBlock(self.seleStyle);
    }
}

@end
