//
//  WLMessageBubbleHelper.m
//  Welian
//
//  Created by weLian on 14/12/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLMessageBubbleHelper.h"
#import "SECompatibility.h"

@interface WLMessageBubbleHelper (){
    NSCache *_attributedStringCache;
}

@end

@implementation WLMessageBubbleHelper

+ (instancetype)sharedMessageBubbleHelper {
    static WLMessageBubbleHelper *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WLMessageBubbleHelper alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _attributedStringCache = [[NSCache alloc] init];
    }
    return self;
}

- (void)setDataDetectorsAttributedAttributedString:(NSMutableAttributedString *)attributedString
                                            atText:(NSString *)text
                             withRegularExpression:(NSRegularExpression *)expression
                                        attributes:(NSDictionary *)attributesDict {
    [expression enumerateMatchesInString:text
                                 options:0
                                   range:NSMakeRange(0, [text length])
                              usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                  NSRange matchRange = [result range];
                                  if (attributesDict) {
                                      [attributedString addAttributes:attributesDict range:matchRange];
                                  }
                                  
                                  if ([result resultType] == NSTextCheckingTypeLink) {
                                      NSURL *url = [result URL];
                                      [attributedString addAttribute:NSLinkAttributeName value:url range:matchRange];
                                  } else if ([result resultType] == NSTextCheckingTypePhoneNumber) {
                                      NSString *phoneNumber = [result phoneNumber];
                                      [attributedString addAttribute:NSLinkAttributeName value:phoneNumber range:matchRange];
                                  } else if ([result resultType] == NSTextCheckingTypeDate) {
                                      //                                      NSDate *date = [result date];
                                  }
                              }];
}

- (NSAttributedString *)bubbleAttributtedStringWithText:(NSString *)text{
    if (!text) {
        return [[NSAttributedString alloc] init];
    }
    if ([_attributedStringCache objectForKey:text]) {
        return [_attributedStringCache objectForKey:text];
    }
    
//    NSDictionary *textAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.185 green:0.583 blue:1.000 alpha:1.000]};
    
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber | NSTextCheckingTypeDate
                                                               error:nil];
    NSColor *textColor = [NSColor whiteColor];
    NSDictionary *textAttributes = @{(id)kCTForegroundColorAttributeName: (id)textColor.CGColor};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:textAttributes];
    
    NSColor *linkColor = [NSColor blueColor];
    //    NSDictionary *textAttributes = @{NSForegroundColorAttributeName : [UIColor redColor]};
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: (id)linkColor.CGColor};
    
    [self setDataDetectorsAttributedAttributedString:attributedString atText:text withRegularExpression:detector attributes:linkAttributes];
    
    
    //    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"/s(13[0-9]|15[0-35-9]|18[0-9]|14[57])[0-9]{8}"
    //                                                                           options:0
    //                                                                             error:nil];
    //    [self setDataDetectorsAttributedAttributedString:attributedString atText:text withRegularExpression:regex attributes:textAttributes];
    
    [_attributedStringCache setObject:attributedString forKey:text];
    
    return attributedString;
}

- (NSAttributedString *)bubbleAttributtedStringWithText:(NSString *)text withTextColor:(UIColor *)textColor {
    if (!text) {
        return [[NSAttributedString alloc] init];
    }
    if ([_attributedStringCache objectForKey:text]) {
        return [_attributedStringCache objectForKey:text];
    }
    
    //    NSDictionary *textAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.185 green:0.583 blue:1.000 alpha:1.000]};
    
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber | NSTextCheckingTypeDate
                                                               error:nil];
    //    NSColor *textColor = [NSColor whiteColor];
    NSDictionary *textAttributes = @{(id)kCTForegroundColorAttributeName: (id)textColor.CGColor};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:textAttributes];
    
    NSColor *linkColor = [NSColor blueColor];
    //    NSDictionary *textAttributes = @{NSForegroundColorAttributeName : [UIColor redColor]};
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: (id)linkColor.CGColor};
    
    [self setDataDetectorsAttributedAttributedString:attributedString atText:text withRegularExpression:detector attributes:linkAttributes];
    
    
    //    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"/s(13[0-9]|15[0-35-9]|18[0-9]|14[57])[0-9]{8}"
    //                                                                           options:0
    //                                                                             error:nil];
    //    [self setDataDetectorsAttributedAttributedString:attributedString atText:text withRegularExpression:regex attributes:textAttributes];
    
    [_attributedStringCache setObject:attributedString forKey:text];
    
    return attributedString;
}

- (NSAttributedString *)attributedStringWithSpecial:(NSString *)text
{
    if (!text) {
        return [[NSAttributedString alloc] init];
    }
    if ([_attributedStringCache objectForKey:text]) {
//        return [_attributedStringCache objectForKey:text];
    }
    
    NSFont *font = [NSFont systemFontOfSize:16.0f];
    CTFontRef tweetfont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    
    NSColor *tweetColor = [NSColor whiteColor];
//    NSColor *hashtagColor = [NSColor grayColor];
//    UIColor *cashtagColor = [UIColor grayColor];
    NSColor *linkColor = [NSColor blueColor];
    
    NSDictionary *attributes = @{(id)kCTForegroundColorAttributeName: (id)tweetColor.CGColor, (id)kCTFontAttributeName: (__bridge id)tweetfont};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    CFRelease(tweetfont);
    
//    NSDictionary *entities = tweet[@"entities"];
//    NSArray *userMentions = entities[@"user_mentions"];
//    for (NSDictionary *userMention in userMentions) {
//        NSArray *indices = userMention[@"indices"];
//        NSInteger first = [indices.firstObject integerValue];
//        NSInteger last = [indices.lastObject integerValue];
//        [attributedString addAttributes:@{NSLinkAttributeName: userMention, (id)kCTForegroundColorAttributeName: (id)linkColor.CGColor}
//                                  range:NSMakeRange(first, last - first)];
//    }
//    NSArray *hashtags = entities[@"hashtags"];
//    for (NSDictionary *hashtag in hashtags) {
//        NSArray *indices = hashtag[@"indices"];
//        NSInteger first = [indices.firstObject integerValue];
//        NSInteger last = [indices.lastObject integerValue];
//        [attributedString addAttributes:@{NSLinkAttributeName: hashtag, (id)kCTForegroundColorAttributeName: (id)hashtagColor.CGColor}
//                                  range:NSMakeRange(first, last - first)];
//    }
//    NSArray *symbols = entities[@"symbols"];
//    for (NSDictionary *symbol in symbols) {
//        NSArray *indices = symbol[@"indices"];
//        NSInteger first = [indices.firstObject integerValue];
//        NSInteger last = [indices.lastObject integerValue];
//        [attributedString addAttributes:@{NSLinkAttributeName: symbol, (id)kCTForegroundColorAttributeName: (id)cashtagColor.CGColor}
//                                  range:NSMakeRange(first, last - first)];
//    }
//    
//    NSArray *urls = entities[@"urls"];
//    NSArray *media = entities[@"media"];
//    urls = [urls arrayByAddingObjectsFromArray:media];
//    for (NSDictionary *url in urls.reverseObjectEnumerator) {
//        NSArray *indices = url[@"indices"];
//        
//        NSInteger first = [indices[0] integerValue];
//        NSInteger last = [indices[1] integerValue];
//        for (NSInteger i = 0; i < first; i++) {
//            unichar c = [text characterAtIndex:i];
//            if (CFStringIsSurrogateHighCharacter(c)) {
//                first++;
//                last++;
//            }
//        }
//        for (NSInteger i = first; i < last; i++) {
//            unichar c = [text characterAtIndex:i];
//            if (CFStringIsSurrogateHighCharacter(c)) {
//                last++;
//            }
//        }
//        
//        NSString *replace = url[@"display_url"];
//        
//        [attributedString replaceCharactersInRange:NSMakeRange(first, last - first) withString:replace];
//        [attributedString addAttributes:@{NSLinkAttributeName: url[@"expanded_url"], (id)kCTForegroundColorAttributeName: (id)linkColor.CGColor}
//                                  range:NSMakeRange(first, replace.length)];
//    }
    
//    NSDictionary *refs = @{@"&amp;": @"&", @"&lt;": @"<", @"&gt;": @">", @"&quot;": @"\"", @"&apos;": @"'"};
//    for (NSString *key in refs.allKeys.reverseObjectEnumerator) {
//        NSRange range = [attributedString.string rangeOfString:key];
//        while (range.location != NSNotFound) {
//            [attributedString replaceCharactersInRange:range withString:refs[key]];
//            range = [attributedString.string rangeOfString:key];
//        }
//    }
    
    ///发送好友请求
    NSRange search = [text rangeOfString:@"&sendAddFriend" options:NSCaseInsensitiveSearch];
    if (search.location != NSNotFound) {
        [attributedString addAttributes:@{NSLinkAttributeName: @{@"&sendAddFriend":@"发送好友请求"}, (id)kCTForegroundColorAttributeName: (id)linkColor.CGColor} range:search];
    }
    
//    NSDictionary *entities = tweet[@"entities"];
//    NSArray *userMentions = entities[@"user_mentions"];
//    for (NSDictionary *userMention in userMentions) {
//        NSArray *indices = userMention[@"indices"];
//        NSInteger first = [indices.firstObject integerValue];
//        NSInteger last = [indices.lastObject integerValue];
//        [attributedString addAttributes:@{NSLinkAttributeName: userMention, (id)kCTForegroundColorAttributeName: (id)linkColor.CGColor}
//                                  range:NSMakeRange(first, last - first)];
//    }
    
    //替换指定的
    NSDictionary *refs = @{@"&sendAddFriend": @"发送好友请求", @"&lt;": @"<", @"&gt;": @">", @"&quot;": @"\"", @"&apos;": @"'"};
    for (NSString *key in refs.allKeys.reverseObjectEnumerator) {
        NSRange range = [attributedString.string rangeOfString:key];
        while (range.location != NSNotFound) {
            [attributedString replaceCharactersInRange:range withString:refs[key]];
            range = [attributedString.string rangeOfString:key];
        }
    }
    
    [_attributedStringCache setObject:attributedString forKey:text];
    
    return attributedString;
}


@end
