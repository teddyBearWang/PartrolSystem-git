//
//  DangerViewController.h
//  PartrolSystem
//
//  Created by teddy on 14-4-21.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
#import "ASIHTTPRequest.h"
#import "UserModal.h"
#import "AsyncDownloadFile.h"
#import <AVFoundation/AVFoundation.h>


@interface DangerViewController : UIViewController<UITableViewDataSource,PullTableViewDelegate,ASIHTTPRequestDelegate,UITableViewDelegate,AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlay;
    PullTableView *pullTableView;
    NSMutableArray *_dangerArray;
    double totalTime;
    UIProgressView *processView; //进度视图
    BOOL _isload;
    BOOL _isRefresh; //表示下拉刷新
    BOOL _isLoadMore;//表示加载更多
    NSTimer *timer;
    
}
@property (strong, nonatomic) IBOutlet PullTableView *pullTableView;
@property (strong, nonatomic) NSMutableArray *dangerArray;
@end
