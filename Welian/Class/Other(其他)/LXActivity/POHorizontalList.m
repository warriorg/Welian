//
//  POHorizontalList.m
//  POHorizontalList
//
//  Created by Polat Olu on 15/02/2013.
//  Copyright (c) 2013 Polat Olu. All rights reserved.
//

#import "POHorizontalList.h"

@implementation POHorizontalList

- (id)initWithButItems:(NSArray *)items
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 110)];
    
    if (self) {
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, TITLE_HEIGHT, self.frame.size.width, self.frame.size.height)];

        CGSize pageSize = CGSizeMake(ITEM_WIDTH, self.scrollView.frame.size.height);
        NSUInteger page = 0;
        WEAKSELF
        for(ListItem *item in items) {
            [item setFrame:CGRectMake(LEFT_PADDING + (pageSize.width + DISTANCE_BETWEEN_ITEMS) * page++, 0, pageSize.width, pageSize.height)];
            item.canleBlock = ^(){
                if (weakSelf.cancelBlock) {
                    weakSelf.cancelBlock();
                }
            };
            [self.scrollView addSubview:item];
        }
        CGFloat contentW = LEFT_PADDING + (pageSize.width + DISTANCE_BETWEEN_ITEMS) * [items count];
        if (contentW <= SuperSize.width) {
            contentW = SuperSize.width+1;
        }
        self.scrollView.contentSize = CGSizeMake(contentW, pageSize.height);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        [self addSubview:self.scrollView];
    }

    return self;
}

@end
