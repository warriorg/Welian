//
//  ResManager.m
//  Welian
//
//  Created by weLian on 15/1/26.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ResManager.h"
#import "NSFileManager+DoNotBackup.h"
#import <objc/runtime.h>

@implementation ResManager

#pragma mark - 自定义操作
//保存图片到本地路径
+ (NSString *)saveImage:(UIImage *)image ToFolder:(NSString *)toFolder WithName:(NSString *)imageName
{
    //保存到本地
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *folder = [[ResManager userResourcePath] stringByAppendingPathComponent:toFolder];
    if (![[NSFileManager defaultManager] fileExistsAtPath:folder]) {
        NSLog(@"创建home cover 目录!");
        [[NSFileManager defaultManager] createDirectoryAtPath:folder
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    //保持图片到本地
    NSString *fullPathToFile = [folder stringByAppendingPathComponent:imageName];
    //如果本地存在同名文件删除s
    if ([ResManager fileExistByPath:fullPathToFile]) {
        [ResManager fileDelete:fullPathToFile];
    }
    // 写入本地
    [imageData writeToFile:fullPathToFile atomically:YES];
    return [NSString stringWithFormat:@"%@/%@",toFolder,imageName];
}

#pragma mark - 根据路径取图片
+ (UIImage *)imageWithPath:(NSString *)path left:(NSInteger)left top:(NSInteger)top
{
    return [[self imageWithPath:path] stretchableImageWithLeftCapWidth:left topCapHeight:top];
}

+ (UIImage *)imageWithPath:(NSString *)path
{
    return [self imageWithPath:path isCache:NO];
}

+ (UIImage *)imageWithPath:(NSString *)path isCache:(BOOL)cache
{
    UIImage *image;
    if (cache) {
        image = [ResManager cacheForKey:path];
        if (image) {
            //LOG(@"%@ use cache!", path);
            image.cached = YES;
            return image;
        }
    }
    
    image = [[UIImage alloc] initWithContentsOfFile:[self filePathForRelativePath:path]];
    image.cached = NO;
    if (cache && image) {
        //LOG(@"%@ save to cache!", path);
        [ResManager setCache:image forKey:path];
    }
    
    return image;
}

+ (UIImage *)imageWithPath:(NSString *)path forLanguage:(NSString *)language
{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[self filePathForRelativePath:[NSString stringWithFormat:path, language]]];
    
    if (!image) {
        language = @"zh-Hans";
        image = [self imageWithPath:path forLanguage:language];
    }
    
    return image;
}

+ (NSArray *)imagesWithFolder:(NSString *)folder
{
    NSMutableArray *results = [NSMutableArray array];
    
    NSString *path = [[self userResourcePath] stringByAppendingPathComponent:folder];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    NSString *file;
    while (file = [dirEnum nextObject]) {
        if ([[file pathExtension] length] == 0) {
            continue;
        }
        file = [path stringByAppendingPathComponent:file];
        DLog(@"Document File:%@", file);
        [results addObject:file];
    }
    
    if (results.count) {
        return results;
    }
    
    path = [[self navResourcePath] stringByAppendingPathComponent:folder];
    dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    while (file = [dirEnum nextObject]) {
        if ([[file pathExtension] length] == 0) {
            continue;
        }
        
        file = [path stringByAppendingPathComponent:file];
        DLog(@"Nav File:%@", file);
        [results addObject:file];
    }
    
    return results;
}

#pragma mark - 资源路径
+ (NSString *)navResourcePath
{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Resource"];
}

+ (NSString *)userResourcePath
{
    NSString *result = [[self documentPath] stringByAppendingPathComponent:@"Resource"];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:result]) {
            [fileManager createDirectoryAtPath:result withIntermediateDirectories:YES attributes:nil error:nil];
            DLog(@"create user resource folder!");
            [fileManager addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:result isDirectory:YES]];
            DLog(@"addSkipBackupAttributeToItemAtURL:%@", result);
        } else {
            DLog(@"user resource folder exists");
        }
    });
    
    return result;
}

+ (NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)tempFolderPath
{
    return NSTemporaryDirectory();
}

+ (NSString *)filePathForRelativePath:(NSString *)path
{
    NSString *result = [[self userResourcePath] stringByAppendingPathComponent:path];
    if ([[NSFileManager defaultManager] fileExistsAtPath:result]) {
        return result;
    }
    
    result = [[self navResourcePath] stringByAppendingPathComponent:path];
    return result;
}

#pragma mark - 本地文件处理
// 获取文件的各类属性比较是否相同
+ (BOOL)getFileAttributes:(NSString *)fileName TargetSize:(NSInteger)curSize
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fileName error:nil];
    if (fileAttributes != nil) {
        NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
        DLog(@"File Size:%@ , New File Size:%d",fileSize,curSize);
        if ([fileSize intValue] == curSize) {
            return YES;
        }else {
            return NO;
        }
    }else {
        DLog(@"Local Image File Not Exist!");
        return NO;
    }
}

//检查本地文件是否存在
+ (BOOL)fileExistByPath:(NSString *)storePath
{
    BOOL rtn = NO;
    rtn = [[NSFileManager defaultManager] fileExistsAtPath:storePath];
    return rtn;
}

//删除文件
+ (void)fileDelete:(NSString *)sName
{
    if ([self fileExistByPath:sName]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error=nil;
        [fileManager removeItemAtPath:sName error:&error];
    }
    return;
}

//复制文件
+ (BOOL)filesCopy:(NSString *)sName TargetName:(NSString *)tName
{
    NSFileManager *fileManaget = [NSFileManager defaultManager];
    NSError *error=nil;
    return [fileManaget copyItemAtPath:sName toPath:tName error:&error];
}

+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - 缓存
static NSCache *sharedCache = nil;

+ (id)cacheForKey:(NSString *)key
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedCache) {
            DLog(@"cacheForKey alloc cache!");
            sharedCache = [[NSCache alloc] init];
            //sharedCache.countLimit = 60;
        }
    });
    
    return [sharedCache objectForKey:key];
}

+ (void)setCache:(id)cache forKey:(NSString *)key
{
    if (!cache) {
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedCache) {
            DLog(@"setCache alloc cache!");
            sharedCache = [[NSCache alloc] init];
            //sharedCache.countLimit = 60;
        }
    });
    
    [sharedCache setObject:cache forKey:key];
}

+ (void)cleanCache
{
    DLog(@"clean cache!");
    [sharedCache removeAllObjects];
}

@end

@implementation UIImage (ResCache)

static char imageCachedKey;

- (BOOL)isCached
{
    return [objc_getAssociatedObject(self, &imageCachedKey) boolValue];
}

- (void)setCached:(BOOL)cached
{
    [super willChangeValueForKey:@"cached"];
    objc_setAssociatedObject(self, &imageCachedKey, @(cached), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [super didChangeValueForKey:@"cached"];
}

@end
