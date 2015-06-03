//
//  AsyncDownloadFile.m
//  SingleTest
// *********************下载工具类*********************
//  Created by teddy on 14-7-3.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "AsyncDownloadFile.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h" //设置缓存类

@implementation AsyncDownloadFile


#pragma mark - 单例
+ (AsyncDownloadFile *)shareTheme
{
    static dispatch_once_t onceToken;
    static AsyncDownloadFile *loadFile = nil;
    dispatch_once(&onceToken, ^{
        loadFile = [[AsyncDownloadFile alloc] init];
    });
    return loadFile;
}

- (void) DownloadFilesUrl:(NSString *)aFilesUrl
{
    //首先判断请求连接是否存在文件
    NSString *cacheFile = [self cacheFileImage:aFilesUrl]; //文件的路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cacheFile]) {
        //若文件存在,直接提交通知
        [[NSNotificationCenter defaultCenter] postNotificationName:FILESDOWNLOADCOMPLETE object:cacheFile];
    }else
    {
        //若是不存在，则下载文件
        [self loadFileFromUrl:[NSURL URLWithString:aFilesUrl] fileInfoDic:nil];
    }
}

#pragma mark - 通过请求得到文件的全路径
- (NSString *)cacheFileImage:(NSString *)fileName
{
    //指定缓存文件路径
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]; //缓存路径
    //存在缓存中文件的路径
    cacheFolder = [cacheFolder stringByAppendingPathComponent:@"音频类附件"];
    //创建文件管理对象，实现对文件的操作
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cacheFolder]) {
        //如果文件不存在,创建
        NSError *error = nil;
        [fileManager createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"创建文件失败");
            return nil;
        }
    }
    
    //文件名字以斜线“/”分割,fileName为传递过来的文件名称(带名称的链接)
    NSArray *paths = [fileName componentsSeparatedByString:@"/"];
    if (paths.count == 0) {
        return nil;
    }
    //返回文件的唯一路径（标识）
    return [NSString stringWithFormat:@"%@/%@",cacheFolder,[paths lastObject]];
    
    
}

#pragma mark - 下载文件，并且附带缓存
- (void)loadFileFromUrl:(NSURL *)url fileInfoDic:(NSDictionary *)dic
{
    __block ASIHTTPRequest *request = nil; //__block修饰的变量可以修改
    if (url) {
        request = [ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        [request setTimeOutSeconds:60];//设置下载超时时间
        
        //设置下载缓存
        [request setDownloadCache:[ASIDownloadCache sharedCache]];
        //设置储存策略
        [request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
        
        //设置缓存保存数据时间
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy]; //永久保存
        [request setShouldContinueWhenAppEntersBackground:YES]; //设置后台运行
        //设置缓存路径（绝对路径）
        [request setDownloadDestinationPath:[self cacheFileImage:[url absoluteString]]];
    }
    else
    {
        return;
    }
    
    //下载完成
    [request setCompletionBlock:^{
        //提交通知
        [[NSNotificationCenter defaultCenter] postNotificationName:FILESDOWNLOADCOMPLETE object:[self cacheFileImage:[url absoluteString]] userInfo:nil];
        NSLog(@"下载完成");
    }];
    
    //下载失败
    [request setFailedBlock:^{
        NSError *error = request.error;
        NSLog(@"error reason:%@",error);
    }];
    
    [request startAsynchronous]; //发送异步请求
    
}
@end
