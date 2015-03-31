//
//  WUDemoKeyboardBuilder.m
//  WUEmoticonsKeyboardDemo
//
//  Created by YuAo on 7/20/13.
//  Copyright (c) 2013 YuAo. All rights reserved.
//

#import "WUDemoKeyboardBuilder.h"
#import "WUDemoKeyboardPressedCellPopupView.h"

@implementation WUDemoKeyboardBuilder

+ (WUEmoticonsKeyboard *)sharedEmoticonsKeyboard {
    static WUEmoticonsKeyboard *_sharedEmoticonsKeyboard;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //create a keyboard of default size
        WUEmoticonsKeyboard *keyboard = [WUEmoticonsKeyboard keyboard];
        NSArray *iconKeys = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expression_custom" ofType:@"plist"]];
        NSDictionary *iconImageDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expressionImage_custom" ofType:@"plist"]];
        
        NSMutableArray *iconKeyItems = [NSMutableArray array];
        for (NSString *text in iconKeys) {
            WUEmoticonsKeyboardKeyItem *keyItem = [[WUEmoticonsKeyboardKeyItem alloc] init];
            keyItem.image = [UIImage imageNamed:[iconImageDic objectForKey:text]];
            keyItem.textToInput = text;
            [iconKeyItems addObject:keyItem];
        }
        //Text key group
        WUEmoticonsKeyboardKeysPageFlowLayout *imageIconsLayout = [[WUEmoticonsKeyboardKeysPageFlowLayout alloc] init];
        imageIconsLayout.itemSize = CGSizeMake(52, 142/3.0);
        imageIconsLayout.itemSpacing = 0;
        imageIconsLayout.lineSpacing = 0;
        imageIconsLayout.pageContentInsets = UIEdgeInsetsMake(0,5,0,0);
        
        //Icon key group
        WUEmoticonsKeyboardKeyItemGroup *imageIconsGroup = [[WUEmoticonsKeyboardKeyItemGroup alloc] init];
        imageIconsGroup.keyItems = iconKeyItems;
        UIImage *keyboardEmotionImage = [UIImage imageNamed:@"keyboard_emotion"];
        UIImage *keyboardEmotionSelectedImage = [UIImage imageNamed:@"keyboard_emotion_selected"];
        if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)]) {
            keyboardEmotionImage = [keyboardEmotionImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            keyboardEmotionSelectedImage = [keyboardEmotionSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        imageIconsGroup.image = keyboardEmotionImage;
        imageIconsGroup.selectedImage = keyboardEmotionSelectedImage;
        imageIconsGroup.keyItemsLayout = imageIconsLayout;
        
        //Set keyItemGroups
        keyboard.keyItemGroups = @[imageIconsGroup];
        
        //Setup cell popup view
        [keyboard setKeyItemGroupPressedKeyCellChangedBlock:^(WUEmoticonsKeyboardKeyItemGroup *keyItemGroup, WUEmoticonsKeyboardKeyCell *fromCell, WUEmoticonsKeyboardKeyCell *toCell) {
            [WUDemoKeyboardBuilder sharedEmotionsKeyboardKeyItemGroup:keyItemGroup pressedKeyCellChangedFromCell:fromCell toCell:toCell];
        }];

        //Custom utility keys
        [keyboard setImage:[UIImage imageNamed:@"DeleteEmoticonBtn_ios7"] forButton:WUEmoticonsKeyboardButtonBackspace state:UIControlStateNormal];
        //Keyboard background
        
        _sharedEmoticonsKeyboard = keyboard;
    });
    return _sharedEmoticonsKeyboard;
}

+ (void)sharedEmotionsKeyboardKeyItemGroup:(WUEmoticonsKeyboardKeyItemGroup *)keyItemGroup
             pressedKeyCellChangedFromCell:(WUEmoticonsKeyboardKeyCell *)fromCell
                                    toCell:(WUEmoticonsKeyboardKeyCell *)toCell
{
    static WUDemoKeyboardPressedCellPopupView *pressedKeyCellPopupView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pressedKeyCellPopupView = [[WUDemoKeyboardPressedCellPopupView alloc] initWithFrame:CGRectMake(0, 0, 83, 110)];
        pressedKeyCellPopupView.hidden = YES;
        [[self sharedEmoticonsKeyboard] addSubview:pressedKeyCellPopupView];
    });
    
    if ([[self sharedEmoticonsKeyboard].keyItemGroups indexOfObject:keyItemGroup] == 0) {
        [[self sharedEmoticonsKeyboard] bringSubviewToFront:pressedKeyCellPopupView];
        if (toCell) {
            pressedKeyCellPopupView.keyItem = toCell.keyItem;
            pressedKeyCellPopupView.hidden = NO;
            CGRect frame = [[self sharedEmoticonsKeyboard] convertRect:toCell.bounds fromView:toCell];
            pressedKeyCellPopupView.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame)-CGRectGetHeight(pressedKeyCellPopupView.frame)/2);
        }else{
            pressedKeyCellPopupView.hidden = YES;
        }
    }
}


+ (void)hideSendBut:(BOOL)isHide
{
    if (isHide) {
      WUEmoticonsKeyboard *keyboard = [self sharedEmoticonsKeyboard];
        [keyboard setHideSendBut:isHide];
    }
}

@end
