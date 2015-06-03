//
//  AsyncDownloadFile.h
//  SingleTest
//****************************下载类***************************
//  Created by teddy on 14-7-3.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>


#define  FILESDOWNLOADCOMPLETE @"FilesDownloadComplete" //文件下载完成
@interface AsyncDownloadFile : NSObject

+(AsyncDownloadFile *)shareTheme;
- (void)DownloadFilesUrl:(NSString *)aFilesUrl;
@end
