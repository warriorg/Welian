//
//  POHorizontalList.h
//  POHorizontalList
//
//  Created by Polat Olu on 15/02/2013.
//  Copyright (c) 2013 Polat Olu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListItem.h"

#define DISTANCE_BETWEEN_ITEMS  20.0
#define LEFT_PADDING            20.0
#define ITEM_WIDTH              60.0
#define TITLE_HEIGHT            20.0

typedef void (^WLActivityCancelBlock)();

@interface POHorizontalList : UIView <UIScrollViewDelegate> {
    CGFloat scale;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, copy) WLActivityCancelBlock cancelBlock;

- (id)initWithButItems:(NSArray *)items;

@end
