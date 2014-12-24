

#import "CALayer+XibConfiguration.h"

@implementation CALayer(XibConfiguration)

-(UIColor*)borderColorFromUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}
-(UIColor*)shadowColorFromUIColor
{
    return [UIColor colorWithCGColor:self.shadowColor];
}
-(NSString*)borderWidths
{
    return self.borderWidths;
}

-(void)setBorderColorFromUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}
-(void)setShadowColorFromUIColor:(UIColor*)color
{
    self.shadowColor = color.CGColor;
}

-(void)setBorderWidths:(NSString*)borderWidths
{
    NSString *widthsStr = [[borderWidths stringByReplacingOccurrencesOfString:@"{" withString:@""]
                           stringByReplacingOccurrencesOfString:@"}" withString:@""];
    //widths:[top,right,bottom,left]
    NSArray *widths = [widthsStr componentsSeparatedByString:@","];
    float topWidth = [[widths objectAtIndex:0] floatValue];
    float rightWidth = [[widths objectAtIndex:1] floatValue];
    float bottomWidth = [[widths objectAtIndex:2] floatValue];
    float leftWidth = [[widths objectAtIndex:3] floatValue];
    
    if (topWidth!=0) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = self.borderColor;
        border.frame = CGRectMake(0, 0, self.frame.size.width, topWidth);
        [self addSublayer:border];
    }
    if (rightWidth!=0) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = self.borderColor;
        border.frame = CGRectMake(self.frame.size.width - rightWidth, 0, rightWidth, self.frame.size.height);
        [self addSublayer:border];
    }
    if (bottomWidth!=0) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = self.borderColor;
        border.frame = CGRectMake(0, self.frame.size.height - bottomWidth, self.frame.size.width, bottomWidth);
        [self addSublayer:border];
    }
    if (leftWidth!=0) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = self.borderColor;
        border.frame = CGRectMake(0, 0, leftWidth, self.frame.size.height);;
        [self addSublayer:border];
    }
}


@end
