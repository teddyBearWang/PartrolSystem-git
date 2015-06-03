//
//  DangerViewController.m
//  PartrolSystem
//
//******************历史隐患控制器*************
//  Created by teddy on 14-4-21.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "DangerViewController.h"
#import "CustomCell.h"
#import "DangerObject.h"
#import "ASIFormDataRequest.h"
#import "ReserviorButton.h"
#import <QuartzCore/QuartzCore.h>


#define PHONEVIEWWIDTH 200
#define PHONEVIEWHEIGHT 60
@interface DangerViewController ()

@end

@implementation DangerViewController
@synthesize pullTableView = pullTableView;
@synthesize dangerArray = _dangerArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"历史隐患";
        _isLoadMore = NO;
        _isRefresh = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initNavigationBar];
    self.pullTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    //设置背景颜色
    self.pullTableView.backgroundColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    self.pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pullTableView.rowHeight = 460;
    self.pullTableView.dataSource = self;
    self.pullTableView.pullDelegate = self;
    
    //注册通知观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FileDownloadCompleteAction:) name:FILESDOWNLOADCOMPLETE object:nil];
}

//view即将出现时
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    if(!self.pullTableView.pullTableIsRefreshing) {
        self.pullTableView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.5];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationBar
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)getWebData
{
    UserModal *user = [UserModal sharedUserModal];

    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //第一次获取数据不需要时间参数的
    [request setPostValue:@"getEventList" forKey:@"t"];
    [request setPostValue:user.loginName forKey:@"areaId"];
    
    if (!isFirstLand && _isLoadMore) {
        //第二次获取数据需要时间参数
        DangerObject *danger = [self.dangerArray lastObject];
        NSArray *array = [danger.eventTime componentsSeparatedByString:@" "];
        NSArray *array1 = [[array objectAtIndex:0] componentsSeparatedByString:@"/"];
        NSString *time = [NSString stringWithFormat:@"%@-%.2d-%.2d",[array1 objectAtIndex:0],[[array1 objectAtIndex:1] intValue],[[array1 objectAtIndex:2] intValue]];
        [request setPostValue:time forKey:@"rightTime"];
    }
    request.delegate = self;
    _isload = YES;
    [request startSynchronous];
    isFirstLand = NO;
}
#pragma mark - Refresh and load more methods
//下拉刷新
bool isFirstLand = YES; //第一次加载数据
- (void) refreshTable
{
    //刷新数据
    _isRefresh = YES;
    //获取网络数据
    [self getWebData];
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = NO;
    [self.pullTableView reloadData];
}

//上拉加载结束
- (void)loadMoreDataToTable
{
    _isLoadMore = YES;
    [self getWebData]; //获取网络数据
     self.pullTableView.pullTableIsLoadingMore = NO;
    [self.pullTableView reloadData];
}
#pragma mark - UIBarButtonItem Action
- (void)backAction
{
    if (_isload) {
        [[ASIHTTPRequest sharedQueue] cancelAllOperations];
        _isload = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dangerArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    CustomCell *cell = (CustomCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1];
        
        UIButton *Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        Button.frame = CGRectMake(160-50/2, 390, 50, 50);
        Button.tag = indexPath.row;
        [Button setBackgroundColor:[UIColor whiteColor]];
        Button.layer.borderColor = [[UIColor clearColor] CGColor];
        Button.layer.borderWidth = 1.0f;
        Button.layer.cornerRadius = 6.0f;
        [Button setTitle:@"播放" forState:UIControlStateNormal];
        [Button addTarget:self action:@selector(playAudioAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:Button];
       
    }
    DangerObject *danger = [self.dangerArray objectAtIndex:indexPath.row];
    cell.reserviorImage.image = [UIImage imageNamed:@"river_small"];
    cell.reserviorLabel.text = danger.objName;
    cell.timeLabel.text = danger.eventTime;
    if (![danger.imgUrl isEqualToString:@""]) {
        cell.dangerImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:danger.imgUrl]]];
    }else
    {
        cell.dangerImage.image = [UIImage imageNamed:@"NoPicture.png"];
    }
    [cell.personButton setTitle:danger.personName forState:UIControlStateNormal];
    [cell.personButton addTarget:self action:@selector(takePhoneCallAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.personButton.buttonNumber = danger.mobile;
    cell.locationLabel.text = danger.locationName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)playAudioAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)[button superview];
    [button removeFromSuperview];
    //添加旋转图片
    [self addRotationView:cell];
    DangerObject *danger = [self.dangerArray objectAtIndex:button.tag];
    
    //下载文件
    [[AsyncDownloadFile shareTheme] DownloadFilesUrl:danger.voiceUrl];
    
}

//添加旋转图片
- (void)addRotationView:(id)sender
{
    UITableViewCell *cell = (UITableViewCell *)sender;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(160-50/2, 400, 50, 50)];
    imgView.tag = 3001;
    imgView.image = [UIImage imageNamed:@"refresh_loading"];
    [cell addSubview:imgView];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2];
    rotationAnimation.duration = 1.0f;
    rotationAnimation.repeatCount = 1000;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.cumulative = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [imgView.layer addAnimation:rotationAnimation forKey:@"Rotation"];
}

//获取缓存中的文件路径
- (NSString *)getCacheFilePath:(NSString *) urlstring
{
    //指定缓存文件路径
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]; //缓存路径
    //存在缓存中文件的路径
    cacheFolder = [cacheFolder stringByAppendingPathComponent:@"音频类附件"];
    
    NSArray *paths = [urlstring componentsSeparatedByString:@"/"];
    if (paths.count == 0) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/%@",cacheFolder,[paths lastObject]];
}

- (void)FileDownloadCompleteAction:(NSNotification *)notification
{
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:3001];
    UITableViewCell *cell = (UITableViewCell *)[imgView superview];
    [imgView.layer removeAllAnimations];
    [imgView removeFromSuperview];
    
    //添加进度视图
    processView = [[UIProgressView alloc] initWithFrame:CGRectMake(30, 415, 260, 20)];
    processView.progressViewStyle = UIProgressViewStyleDefault;
    processView.progressTintColor = [UIColor blueColor];
    processView.progress = 0.0f;
    processView.trackTintColor = [UIColor redColor];
    [cell addSubview:processView];
    //创建播放按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = (CGRect){160-50/2, 390, 50, 50};
    btn.tag = 3002;
    btn.layer.cornerRadius = 5.0f;
    [btn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(palyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];
    
    //下载结束之后开始播放
    //播放本地文件
    NSString *filePath = [self getCacheFilePath:notification.object];
    NSURL *mp3Url = [NSURL fileURLWithPath:filePath];
    audioPlay = [[AVAudioPlayer alloc] initWithContentsOfURL:mp3Url error:NULL];
    audioPlay.delegate = self;
    totalTime = audioPlay.duration; //音频的总时间
    [audioPlay play];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerAction:) userInfo:nil repeats:YES];
    
}
//暂停、播放功能
- (void)palyButtonAction:(UIButton *)btn
{
    if (audioPlay.playing) {
        [audioPlay pause];
        [btn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal
         ];
    }else{
        [audioPlay play];
        [btn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}

- (void)TimerAction:(NSTimer *)timer
{

    if (audioPlay.playing) {
        double currentTime = audioPlay.currentTime; //当前播放时间
       // NSLog(@"当前的播放时间是：%lf",currentTime);
        processView.progress = currentTime/totalTime; // 显示进度
    }
}
#pragma mark - 播放结束
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"播放结束");
    processView.progress = 0.0f;
    UIButton *button = (UIButton *)[self.view viewWithTag:3002];
    [button setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
}

#pragma mark - PullTableViewDelegate

//下拉放开触发的代理
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:1.0f];
}

//上拉加载更多触发的代理
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:1.0f];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    _isload = NO;
    _isLoadMore = NO;
    if (request.responseStatusCode == 200) {
        NSString *string1 = [request responseString];
        NSString *dealString1 = [string1 substringFromIndex:1];
        NSString *dealString2 = [dealString1 substringToIndex:dealString1.length-1];
        NSString *jsonString = [dealString2 stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        NSData *jsondata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *jsonArray =  (NSArray *)[NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableLeaves error:nil];
        
        if (jsonArray.count == 0 && !isFirstLand) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"加载完毕" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        //第一次加载的时候初始化
        if (isFirstLand || _isRefresh) {
            if (self.dangerArray.count != 0) {
                [self.dangerArray removeAllObjects];
            }
            self.dangerArray = [NSMutableArray arrayWithCapacity:jsonArray.count];
            _isRefresh = NO;
        }
        for (int i=0; i<jsonArray.count; i++) {
            DangerObject *danger = [[DangerObject alloc] init];
            NSDictionary *dangerDic = [jsonArray objectAtIndex:i];
            danger.eventId = [dangerDic objectForKey:@"eventId"];
            danger.objCode = [dangerDic objectForKey:@"objCode"];
            danger.objName = [dangerDic objectForKey:@"objName"];
            danger.objType = [dangerDic objectForKey:@"objType"];
            danger.eventTime = [dangerDic objectForKey:@"eventTime"];
            danger.eventType = [dangerDic objectForKey:@"eventType"];
            danger.ps = [dangerDic objectForKey:@"ps"];
            danger.imgUrl = [dangerDic objectForKey:@"imgUrl"];
            danger.voiceUrl = [dangerDic objectForKey:@"voiceUrl"];
            danger.objUrl = [dangerDic objectForKey:@"objUrl"];
            danger.personName = [dangerDic objectForKey:@"personName"];
            danger.mobile = [dangerDic objectForKey:@"mobile"];
            danger.locationName = [dangerDic objectForKey:@"area"];
            
            [self.dangerArray addObject:danger];
        }
        [self.pullTableView reloadData];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

#pragma mark - PalyPhoneCallAction
bool isShow = NO;
- (void)takePhoneCallAction:(id)sender
{
    ReserviorButton *touchButton = (ReserviorButton *)sender;
    UIWebView *callView = [[UIWebView alloc] init];
    NSString *teleUrl = [NSString stringWithFormat:@"tel://%@",touchButton.buttonNumber];
    NSURL *url = [NSURL URLWithString:teleUrl];
    [callView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:callView];
}
@end
