//
//  ResManager.h
//  Welian
//
//  Created by weLian on 15/1/26.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResManager : NSObject

#pragma mark - 自定义操作
//保存图片到本地路径，返回路径
+ (NSString *)saveImage:(UIImage *)image ToFolder:(NSString *)toFolder WithName:(NSString *)imageName;

#pragma mark - 根据路径取图片
+ (UIImage *)imageWithPath:(NSString *)path left:(NSInteger)left top:(NSInteger)top;
+ (UIImage *)imageWithPath:(NSString *)path;
+ (UIImage *)imageWithPath:(NSString *)path isCache:(BOOL)cache;
+ (UIImage *)imageWithPath:(NSString *)path forLanguage:(NSString *)language;
+ (NSArray *)imagesWithFolder:(NSString *)folder;

#pragma mark - 资源路径
+ (NSString *)navResourcePath;
+ (NSString *)userResourcePath;
+ (NSString *)documentPath;
+ (NSString *)tempFolderPath;
+ (NSString *)filePathForRelativePath:(NSString *)path;
+ (long long) fileSizeAtPath:(NSString*) filePath;

#pragma mark - 缓存
+ (id)cacheForKey:(NSString *)key;
+ (void)setCache:(id)cache forKey:(NSString *)key;
+ (void)cleanCache;

#pragma mark - 本地文件处理
+ (BOOL)getFileAttributes:(NSString *)fileName TargetSize:(NSInteger)curSize;// 获取文件的各类属性比较是否相同
+ (BOOL)fileExistByPath:(NSString *)storePath;//检查本地文件是否存在
+ (void)fileDelete:(NSString *)sName;//删除文件
+ (BOOL)filesCopy:(NSString *)sName TargetName:(NSString *)tName;//复制文件


@end

@interface UIImage (ResCache)

@property (assign, nonatomic, getter = isCached) BOOL cached;

@end
