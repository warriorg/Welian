#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer(XibConfiguration)

@property(nonatomic, assign) UIColor* borderColorFromUIColor;
@property(nonatomic, assign) UIColor* shadowColorFromUIColor;

@property(nonatomic, assign) NSString* borderWidths;

@end
