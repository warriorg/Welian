//
//  jianjuTextField.m
//  Welian
//
//  Created by dong on 14-9-11.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "jianjuTextField.h"

@implementation jianjuTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawRect:frame];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSelectFont (context, [self.font.fontName cStringUsingEncoding:NSASCIIStringEncoding], self.font.pointSize, kCGEncodingMacRoman);
    CGContextSetCharacterSpacing(context, 1);
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGAffineTransform myTextTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f );
    CGContextSetTextMatrix (context, myTextTransform);
    
    // draw 1 but invisbly to get the string length.
    CGPoint p =CGContextGetTextPosition(context);
    float centeredY = (self.font.pointSize + (self.frame.size.height- self.font.pointSize)/2)-2;
    CGContextShowTextAtPoint(context, 0, centeredY, [self.text cStringUsingEncoding:NSASCIIStringEncoding], [self.text length]);
    CGPoint v =CGContextGetTextPosition(context);
    
    // calculate width and draw second one.
    float width = v.x - p.x;
    float centeredX =(self.frame.size.width- width)/2;
    CGContextSetFillColorWithColor(context, [self.textColor CGColor]);
    CGContextShowTextAtPoint(context, centeredX, centeredY, [self.text cStringUsingEncoding:NSASCIIStringEncoding], [self.text length]);

}


@end
