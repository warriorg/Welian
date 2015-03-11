//
//  SEImageCache.h
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/13.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
//#import "SECompatibility.h"

typedef void(^SEImageDownloadCompletionBlock)(UIImage *image, NSError *error);

@interface SEImageCache : NSObject

+ (SEImageCache *)sharedInstance;

- (UIImage *)imageForURL:(NSURL *)imageURL completionBlock:(SEImageDownloadCompletionBlock)block;
- (UIImage *)imageForURL:(NSURL *)imageURL defaultImage:(UIImage *)defaultImage completionBlock:(SEImageDownloadCompletionBlock)block;

@end
