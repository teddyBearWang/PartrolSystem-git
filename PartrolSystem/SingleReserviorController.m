//
//  SingleReserviorController.m
//  PartrolSystem
//******************水库详细信息**************
//  Created by teddy on 14-3-26.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "SingleReserviorController.h"
#import "ReserviorModal.h"
#import "ASIFormDataRequest.h"
#import "HistoryObject.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "ReserviorButton.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "NewPathViewController.h"

@interface SingleReserviorController ()

@end

@implementation SingleReserviorController
@synthesize reserviorModal = _reserviorModal;
@synthesize historyView = _historyView;
@synthesize imgView = _imgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self getCurrentScreenFrame];
    localDay = SHAREAPP.remDay;
    localMonth = SHAREAPP.remMonth;
    localYear = SHAREAPP.remYear;
    remBtnTag = 0;
   
   // [self initHistoryView];
   
    NSArray *itemArray = @[@"基本情况",@"巡查记录"];

    self.segmentedCtrl = [[UISegmentedControl alloc] initWithItems:itemArray];
    self.segmentedCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentedCtrl.selectedSegmentIndex = 0;
    self.segmentedCtrl.multipleTouchEnabled = NO;
    [self.segmentedCtrl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.segmentedCtrl.apportionsSegmentWidthsByContent = YES;
    self.navigationItem.titleView = self.segmentedCtrl;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backToViewAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //添加拍照Item
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takeCameraAction:)];
   // self.navigationItem.rightBarButtonItem = rightItem;
    
    self.reserviorModal = [ReserviorModal sharedReserviorModal];
    NSDictionary *singleReserviorDic = (NSDictionary *)[self.reserviorModal.singleArray objectAtIndex:0];
    self.view.backgroundColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 25, 280, (self.view.frame.size.height)/3 + 30)];
    self.imgView.layer.cornerRadius = 5.0f;
    self.imgView.layer.masksToBounds = YES;
    [self.view addSubview:self.imgView];
    self.imgView.image = [UIImage imageNamed:@"river"];
    self.nameLabel.text = [singleReserviorDic objectForKey:@"objname"];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.codeLabel.text = [singleReserviorDic objectForKey:@"objcode"];
    self.codeLabel.textColor = [UIColor whiteColor];
    self.capactiyLabel.text = [singleReserviorDic objectForKey:@"objcapacity"];
    self.capactiyLabel.textColor = [UIColor whiteColor];
    self.levelLabel.text = [singleReserviorDic objectForKey:@"objlevel"];
    self.levelLabel.textColor = [UIColor whiteColor];
    self.personLabel.text = [singleReserviorDic objectForKey:@"Ptruename"];
    self.personLabel.textColor = [UIColor whiteColor];
    NSString *firstMobileNum = [singleReserviorDic objectForKey:@"PMobile1"];
    NSString *secondMobileNum = [singleReserviorDic objectForKey:@"PMobile2"];
    [self.firstNumButton setTitle:firstMobileNum forState:UIControlStateNormal];
    self.firstNumButton.titleLabel.textColor = [UIColor whiteColor];
    self.firstNumButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.firstNumButton addTarget:self action:@selector(callPhoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.secondNumButtom setTitle:secondMobileNum forState:UIControlStateNormal];
    self.secondNumButtom.titleLabel.textColor = [UIColor whiteColor];
    self.secondNumButtom.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.secondNumButtom addTarget:self action:@selector(callPhoneAction:) forControlEvents:UIControlEventTouchUpInside];
    //注册通知观察者,接受下载类里面提交的通知，
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FileDownloadCompleteAction:) name:FILESDOWNLOADCOMPLETE object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化巡查记录页面
-(void)initHistoryView
{
    //创建日历view
    self.historyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.historyView.backgroundColor = [UIColor colorWithRed:33/255.0 green:50/255.0 blue:65/255.0 alpha:1];
    [self.view addSubview:self.historyView];
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, currentScreenFrame.size.height-44-20-90, currentScreenFrame.size.width, 90)];
    labelView.backgroundColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1];
    [self.historyView addSubview:labelView];
    
    UIView *imgview1 = [[UIView alloc] initWithFrame:CGRectMake(90, 10, 15, 15)];
    UIView *imgView2 = [[UIView alloc] initWithFrame:CGRectMake(90, 30, 15, 15)];
    UIView *imgview3 = [[UIView alloc] initWithFrame:CGRectMake(90, 50, 15, 15)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 150, 15)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 150, 15)];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(120, 50, 150, 15)];
    imgview1.backgroundColor = [UIColor redColor];
    imgView2.backgroundColor = [UIColor greenColor];
    imgview3.backgroundColor = [UIColor orangeColor];
    label1.text = @"红色代表工程有隐患";
    label2.text = @"绿色代表工程已巡查";
    label3.text = @"橙色代表工程未巡查";
    label1.font = [UIFont systemFontOfSize:13];
    label2.font = [UIFont systemFontOfSize:13];
    label3.font = [UIFont systemFontOfSize:13];
    label1.backgroundColor = [UIColor clearColor];
    label2.backgroundColor = [UIColor clearColor];
    label3.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor whiteColor];
    label2.textColor = [UIColor whiteColor];
    label3.textColor = [UIColor whiteColor];
    [labelView addSubview:imgview1];
    [labelView addSubview:imgView2];
    [labelView addSubview:imgview3];
    [labelView addSubview:label1];
    [labelView addSubview:label2];
    [labelView addSubview:label3];

}

#pragma mark - Action
- (void)backToViewAction
{
    if (_isLoad) {
        [[ASIHTTPRequest sharedQueue] cancelAllOperations];
        [SVProgressHUD dismiss];
        _isLoad = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//调用摄像头
- (void)takeCameraAction:(id)sender
{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
         NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imgPicker.sourceType];
        imgPicker.mediaTypes = temp_MediaTypes;
        imgPicker.delegate = self;
        imgPicker.allowsEditing = YES;
    }
    [self presentViewController:imgPicker animated:YES completion:nil];
}

#pragma mark - 切换至巡查记录方法

- (void)segmentAction:(id)sender
{
    UISegmentedControl *segmentCtrl = (UISegmentedControl *)sender;
    NSDate *Date = [NSDate date];
    NSDateFormatter *dateForamtter = [[NSDateFormatter alloc] init];
    [dateForamtter setDateFormat:@"YYYY-MM-dd"];
    NSString *nowDate = [dateForamtter stringFromDate:Date];
    _todayTime = nowDate;
    
    if (segmentCtrl.selectedSegmentIndex == 1 && isShow == NO) {
        //开始网络请求（获取日历数据）
        NSURL *url = [NSURL URLWithString:WebServiceUrl];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        request.delegate = self;
        [request setPostValue:@"getLog" forKey:@"t"];
        [request setPostValue: self.codeNum forKey:@"type"];
        [request setPostValue:_todayTime forKey:@"date"];
        [request setPostValue:self.reserviorModal.objType forKey:@"objtype"];
        
        [SVProgressHUD showWithStatus:@"加载中..."];
        _isLoad = YES;
        [request startAsynchronous];
        
    }else if(segmentCtrl.selectedSegmentIndex == 0 && isShow == YES){
        [self.historyView removeFromSuperview];
        dateLabel.text = nil;
        isShow = NO;
    }
}

//play phone call action
- (void)callPhoneAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *buttonTitle = [button currentTitle];
    //创建打电话界面
    if (![buttonTitle isEqualToString:@""]) {
        UIWebView *callView = [[UIWebView alloc] init];
        NSString *telePhoneNum = [NSString stringWithFormat:@"tel://%@",buttonTitle];
        NSURL *url = [NSURL URLWithString:telePhoneNum];
        [callView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:callView];
    }
}

#pragma  mark - UIImagePickerControllerDelegate
//拍照成功后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - ASIHTTPRequestDelegate 
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    _isLoad = NO;
    if (self.reserviorModal.dateArray.count == 0) {
        self.reserviorModal.dateArray = [NSMutableArray array];
    }else{
        [self.reserviorModal.dateArray removeAllObjects];
    }
    if (request.responseStatusCode == 200) {
        NSString *string = [request responseString];
        NSString *string1 = [[string substringFromIndex:1] substringToIndex:[string substringFromIndex:1].length - 1];
        NSString *jsonString = [string1 stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        //判断是否为获取隐患列表
        if (dangerArray == nil) {
            dangerArray = [NSMutableArray array];
        }else{
            [dangerArray removeAllObjects];
        }
        if (_isDanger) {
            //是隐患数据源
            for (int i = 0; i<jsonArray.count; i++) {
                HistoryObject *dateHistory = [[HistoryObject alloc] init];
                NSDictionary *dateDic = (NSDictionary *)[jsonArray objectAtIndex:i];
                dateHistory.skDate = [dateDic objectForKey:@"skdate"];
                dateHistory.SkImg = [dateDic objectForKey:@"skimg"];
                dateHistory.skRecode = [dateDic objectForKey:@"skrec"];
                [dangerArray addObject:dateHistory];
            }
            _isDanger = NO;
            if (_istap == YES) {
                [self showDangerView];
                _istap = NO;
            }
        }else{
            //非隐患数据源
            for (int i=0; i<jsonArray.count; i++) {
                HistoryObject *dateHistory = [[HistoryObject alloc] init];
                NSDictionary *dateDic = (NSDictionary *)[jsonArray objectAtIndex:i];
                dateHistory.sDateTime = [dateDic objectForKey:@"Sdatetime"];
                dateHistory.sKcontent = [dateDic objectForKey:@"Skcontent"];
                dateHistory.upLoadEvent = [[dateDic objectForKey:@"UploadEvent"] integerValue];
                [self.reserviorModal.dateArray addObject:dateHistory];
            }
        
        if (isShow == NO) {
            //网络数据请求结束后才开始画日历
            //将self.calendarView添加到self.view上面
            [self initHistoryView];
            isShow = YES;
            [self selfInitView];
            //开始画日历
            [self drawCalendar];
            dateLabel.text = [NSString stringWithFormat:@"%ld年 %ld月",localYear,localMonth];
            }
        }
        
        //表示切换月份
        if (_isMonthChanged) {
            //重新画日历
            [self removeCalenBtnFromCalenView];
            [self drawCalendar];
            _isMonthChanged = NO;
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithError:@"加载失败..."];
}

#pragma mark - Private Mothed
//初始化页面
- (void)selfInitView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake((currentScreenFrame.size.width - 200)/2, 0, 200, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.userInteractionEnabled = YES;
    
    UIView *titleBgView = [[UIView alloc]initWithFrame:CGRectMake((titleView.frame.size.width- 100)/2, 0, 100, 44)];
    titleBgView.clipsToBounds = YES;
    [titleView addSubview:titleBgView];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleBgView.frame.size.width, 44)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont systemFontOfSize:16];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [titleBgView addSubview:dateLabel];
    
    //创建两个切换月份的按钮
    NSArray *changeMonthBtnName = @[@"left",@"right"];
    for (int i=0; i<changeMonthBtnName.count; i++) {
        UIButton *LRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [LRBtn setImage:[UIImage imageNamed:[changeMonthBtnName objectAtIndex:i]] forState:UIControlStateNormal];
        if (i == 0) {
            LRBtn.frame = CGRectMake(0, (titleView.frame.size.height-37/1.8)/2, 22/1.8, 37/1.8);
        }
        if (i == 1) {
            LRBtn.frame = CGRectMake(titleView.frame.size.width-22/1.8, (titleView.frame.size.height-37/1.8)/2, 22/1.8, 37/1.8);
        }
        
        LRBtn.tag = 100+i;
        LRBtn.backgroundColor = [UIColor clearColor];
        [LRBtn addTarget:self action:@selector(selectMonth:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:LRBtn];
    }
    
    [self.historyView addSubview:titleView];
    
    count = 0;
    calendarBgView = [[UIView alloc] initWithFrame:CGRectMake(
                                                              12,
                                                              5+titleView.frame.size.height,
                                                              currentScreenFrame.size.width - 24, (currentScreenFrame.size.height-20-44-150))];
    calendarBgView.backgroundColor = CALENCOLOR;
    calendarBgView.layer.masksToBounds = YES;
    calendarBgView.layer.cornerRadius = 8.0;
    calendarBgView.layer.borderWidth = 1.0;
    calendarBgView.layer.borderColor = [[UIColor clearColor] CGColor];
    [self.historyView addSubview:calendarBgView];
    
    NSArray *weekArray = [NSArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
    for (int i=0; i<7; i++) {
        UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(41*i, 5, 41, 24)];
        weekLabel.backgroundColor = [UIColor clearColor];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.textColor = [UIColor grayColor];
        weekLabel.text = [weekArray objectAtIndex:i];
        weekLabel.font = [UIFont systemFontOfSize:12];
        [calendarBgView addSubview:weekLabel];
    }
}

//切换月份
- (void)selectMonth:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
        {
            localMonth -=1;
            if (localMonth<1) {
                localMonth = 12;
                localYear -= 1;
            }
        }
            break;
            
        case 101:
        {
            localMonth +=1;
            if (localMonth>12) {
                localMonth = 1;
                localYear +=1;
            }
        }
        default:
            break;
    }
    
    count = 0;
    nextDaysCount = 0;
    lastdaysCount = 0;
    dateLabel.text = [NSString stringWithFormat:@"%ld年 %ld月",localYear,localMonth];
    
    if (localMonth == 1||localMonth == 3||localMonth == 5||localMonth==7||localMonth==8||localMonth==10||localMonth==12 ) {
        currentMonthDays = 31;
    }else if (localMonth == 2){
        if ((localYear%4 ==0 && localYear%100 !=0)||localYear%400 == 0 ){
            currentMonthDays = 29;
        }else{
            currentMonthDays = 28;
        }
    }else{
        currentMonthDays = 30;
    }
    NSString *dateString = [NSString stringWithFormat:@"%d-%d-%d",localYear,localMonth,currentMonthDays];
   
    //切换月份的时候调用服务获取数据
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setPostValue:@"getLog" forKey:@"t"];
    [request setPostValue: self.codeNum forKey:@"type"];
    [request setPostValue:dateString forKey:@"date"];
    [request setPostValue:self.reserviorModal.objType forKey:@"objtype"];
   // [self removeCalenBtnFromCalenView];
   // [self drawCalendar];
    [SVProgressHUD showWithStatus:@"加载中..."];
    _isMonthChanged = YES;
    //发送一个异步请求
    [request startAsynchronous];

}
//画日历
- (void)drawCalendar
{
 
    NSRange range;
    //截取数据源的元素数量
    if (localMonth == SHAREAPP.remMonth) {
        range = NSMakeRange(0, SHAREAPP.remDay);
        
    }else if((localMonth > SHAREAPP.remMonth && localYear > SHAREAPP.remYear)||(localYear== SHAREAPP.remYear && localMonth > SHAREAPP.remMonth) ||(localYear < 2014 && localMonth < 6))
    {
        //若是当前时间大于实际时间，即未来的月份无数据
        range = NSMakeRange(0, 0);
    }else {
        //比今天以前的月份
        if (self.reserviorModal.dateArray.count <= currentMonthDays) {
            range = NSMakeRange(0, self.reserviorModal.dateArray.count);
        }else{
            range = NSMakeRange(0, currentMonthDays);//显示当前的数量
        }
    }

    //移除全局数组中的数据源
    if (historyArray.count != 0) {
        [historyArray removeAllObjects];
    }
    
    if (self.reserviorModal.dateArray.count > 0) {
        //本月的巡查记录数组
    NSArray *  history = [self.reserviorModal.dateArray subarrayWithRange:range];
    historyArray =(NSMutableArray *)[[history reverseObjectEnumerator] allObjects];
    }
    
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [currentCalendar setFirstWeekday:0]; //设置每周从周几开始，0为周一，1为周日
    [currentCalendar setMinimumDaysInFirstWeek:7]; //设置每周所含的最少天数
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:[SHAREAPP offSetTime]]]; //更新时差
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSDate *firstDayInAmonth = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld%.2ld01",localYear,localMonth]]; //每月1号字符串
    NSLog(@"firstDayInAmonth = %@",firstDayInAmonth);
    NSRange dateRange = [currentCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:firstDayInAmonth]; //时间range(该月天数)
    
    NSInteger weekday = [currentCalendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:firstDayInAmonth]; //每月1号是周几
    
    //开始画日历
    NSInteger weekSum = 6;
    NSInteger btnWidth = calendarBgView.frame.size.width/7;
    NSInteger btnHeight = calendarBgView.frame.size.height/7;
    //取出数据源数组中的最后一个元素
    NSInteger currentIndex;
    if (historyArray.count != 0) {
        HistoryObject *his_object = [historyArray objectAtIndex:0];
         currentIndex = [[his_object.sDateTime substringWithRange:NSMakeRange(6, 2)] integerValue];
    }
    //初始化，避免每次切换的时候都会改变上月和下月的遗留显示的问题
    lastdaysCount = 0;
    nextDaysCount = 0;
    //开始按行循环
    for (int i=0; i<weekSum; i++)
    {
        for (int j=0; j<7; j++)
        { //按列开始循环
            CGRect calenBtnFrame = CGRectMake(btnWidth*j+4, btnHeight*(i+1), btnWidth-2, btnHeight-2);
            if (i == 0) { //第一行
                if (j<weekday-1) { //显示上个月遗留的天数
                    lastdaysCount +=1;
                    
                    UILabel *temLabel = [[UILabel alloc] initWithFrame:calenBtnFrame];
                    temLabel.backgroundColor = [UIColor clearColor];
                    NSInteger month = localMonth;
                    NSInteger year = localYear;
                    if (month<2) {
                        month = 12;
                        year -= 1;
                    }
                    temLabel.text = [NSString stringWithFormat:@"%ld",[SHAREAPP daysOfAMonth:year month:(month - 1)]-weekday+lastdaysCount+1];
                    temLabel.textAlignment = NSTextAlignmentCenter;
                    temLabel.textColor = [UIColor grayColor];
                    temLabel.font = [UIFont systemFontOfSize:15];
                    temLabel.tag = 88;
                    [calendarBgView addSubview:temLabel];
                    
                    continue;
                }
            }
            if (count>=dateRange.length) {
                nextDaysCount +=1; //显示下个月的天数
                UILabel *tempLabel = [[UILabel alloc] initWithFrame:calenBtnFrame];
                tempLabel.backgroundColor = [UIColor clearColor];
                tempLabel.text = [NSString stringWithFormat:@"%ld",nextDaysCount];
                tempLabel.textAlignment = NSTextAlignmentCenter;
                tempLabel.textColor = [UIColor grayColor];
                tempLabel.tag = 88;
                tempLabel.font = [UIFont systemFontOfSize:15];
                [calendarBgView addSubview:tempLabel];
                continue;
            }
            //画本本月的日历
            count++;
            UIView *tempView = [[UIView alloc] initWithFrame:calenBtnFrame];
            tempView.tag = (localMonth*100 +count) * 100 + 88;
            tempView.userInteractionEnabled = YES;
            tempView.layer.masksToBounds = YES;
            tempView.layer.cornerRadius = 4.0;
            tempView.layer.borderColor = [[UIColor clearColor] CGColor];
            tempView.layer.borderWidth = 1.0;
            //本月到今天为止取出数组数据
            if ((count < currentMonthDays+1 || count < range.length + 1) && count > currentIndex-1) {
                HistoryObject *object = nil;
                if ((count-currentIndex) < historyArray.count) {
                    object = [historyArray objectAtIndex:count-currentIndex];
                }
                if ([object.sKcontent isEqualToString:@"未巡查"]) {
                    tempView.backgroundColor = [UIColor orangeColor];
                }
                else if ([object.sKcontent isEqualToString:@"已巡查"] && object.upLoadEvent == 0)
                {
                    tempView.backgroundColor = [UIColor greenColor];
                }
                else if ([object.sKcontent isEqualToString:@"已巡查"] && object.upLoadEvent != 0)
                {
                    tempView.backgroundColor = [UIColor redColor];
                }
            }
            
            [calendarBgView addSubview:tempView];
            
            //创建显示日期的label
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake((calenBtnFrame.size.width-27)/2, (calenBtnFrame.size.height-24)/2, 27, 24)];
            tempLabel.text = [NSString stringWithFormat:@"%ld",count];
            tempLabel.backgroundColor = [UIColor clearColor];
            tempLabel.textAlignment = NSTextAlignmentCenter;
            tempLabel.textColor = [UIColor blackColor];
            tempLabel.font = [UIFont systemFontOfSize:15];
            tempLabel.userInteractionEnabled = YES;
            [tempView addSubview:tempLabel];
            
            //显示今日
            if (localYear == SHAREAPP.remYear && localMonth == SHAREAPP.remMonth && count == SHAREAPP.remDay) {
                UILabel *todaytabel = [[UILabel alloc] initWithFrame:CGRectMake((calenBtnFrame.size.width-20)/2, 2, 20, 10)];
                todaytabel.textAlignment = NSTextAlignmentCenter;
                todaytabel.textColor = [UIColor blackColor];
                todaytabel.text = @"今日";
                todaytabel.backgroundColor = [UIColor clearColor];
                todaytabel.font = [UIFont boldSystemFontOfSize:9];
                [tempView addSubview:todaytabel];
            }
            UIButton *ttBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            ttBtn.backgroundColor = [UIColor clearColor];
            CGRect frame = tempView.frame;
            frame.origin.x = 0;
            frame.origin.y = 0;
            ttBtn.frame = frame;
            ttBtn.tag = localMonth*100+count;
            [ttBtn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
            [tempView addSubview:ttBtn];
        }
    }
}

//单机日期时间
- (void)btnPress:(UIButton *)btn
{
    if (btn.tag != 0 && btn.tag != remBtnTag / 100) {
        for (UIView *iView in calendarBgView.subviews) {
            if ([iView isKindOfClass:[UIView class]] && iView.tag == remBtnTag) {
                if ([iView isKindOfClass:[UILabel class]]) {
                    continue;
                }
                break;
            }
        }
    }
    if (btn.tag == remBtnTag/100) {
        return;
    }
    selecteDate = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",localYear,btn.tag/100,btn.tag%100];
    if ([selecteDate compare:_todayTime] != NSOrderedDescending) {
        //要将得到的数组里面的所有元素倒序才会正确，（数据源数组默认是倒序的）
        HistoryObject *object = [historyArray objectAtIndex:(btn.tag%100)-1];
    //若是点击已巡查的日期，则创建弹出视图
        if ([object.sKcontent isEqualToString:@"已巡查"]) {
            [self initClearView:object];
            _istap = YES;
        }
    }
}


- (void)removeCalenBtnFromCalenView
{
    for (UIView *obj in calendarBgView.subviews) {
        if ([obj isKindOfClass:[UIView class]] && obj.tag % 100 == 88) {
            [obj removeFromSuperview];
        }
    }
}

- (void)getCurrentScreenFrame
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    currentScreenFrame = [[UIScreen mainScreen] bounds];
}

#pragma mark - Button Action
bool _istap; //用于判断是否点击日期
- (void)initClearView:(HistoryObject *)object
{
    UIView *clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44)];
    clearView.backgroundColor = [UIColor lightGrayColor];
    clearView.alpha = 0.2;
    clearView.tag = 201;
    [self.view addSubview:clearView];
    //禁止操作
    [self.segmentedCtrl setEnabled:NO forSegmentAtIndex:0];
    [self.segmentedCtrl setEnabled:NO forSegmentAtIndex:1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction:)];
    tap.numberOfTapsRequired = 1;
    [clearView addGestureRecognizer:tap];
    
    UIView *selectView = [[UIView alloc] init];
    
    
    UIButton *pathButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //判断是否存在隐患选项
    if (object.upLoadEvent != 0) {
        selectView.frame = CGRectMake((320-280)/2, (clearView.center.y)-122/2, 280, 122);
        ReserviorButton *dangerButton = [ReserviorButton buttonWithType:UIButtonTypeCustom];
        dangerButton.frame = CGRectMake(0, 0, selectView.frame.size.width, (selectView.frame.size.height-2)/3);
        [dangerButton addTarget:self action:@selector(LookPictureAudioAction:) forControlEvents:UIControlEventTouchUpInside];
        [dangerButton setBackgroundColor:[UIColor clearColor]];
        [dangerButton setTitle:@"隐患照片与录音" forState:UIControlStateNormal];
        dangerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        dangerButton.titleLabel.textColor = [UIColor whiteColor];
        dangerButton.clickDate = object.sDateTime; //点击的当前时间
        [selectView addSubview:dangerButton];
        
         pathButton.frame = CGRectMake(0, (selectView.frame.size.height-2)/3+1, selectView.frame.size.width, (selectView.frame.size.height-2)/3);
        
        cancelButton.frame = CGRectMake(0, (selectView.frame.size.height-2)/3 *2+2, selectView.frame.size.width, (selectView.frame.size.height-2)/3);
        
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, (selectView.frame.size.height-2)/3, selectView.frame.size.width, 1)];
        img1.image = [UIImage imageNamed:@"menu_line"];
        [selectView addSubview:img1];
        
        UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, (selectView.frame.size.height-2)/3 *2 +1, selectView.frame.size.width, 1)];
        img2.image = [UIImage imageNamed:@"menu_line"];
        [selectView addSubview:img2];
        
    }else{
        selectView.frame = CGRectMake((320-280)/2, clearView.center.y-81/2, 280, 81);
         pathButton.frame = CGRectMake(0, 0, selectView.frame.size.width, (81-1)/2);
        cancelButton.frame = CGRectMake(0, 41, selectView.frame.size.width, (81-1)/2);
        //添加划分线
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, selectView.frame.size.width, 1)];
        imgView.image = [UIImage imageNamed:@"menu_line"];
        [selectView addSubview:imgView];
    }
    selectView.layer.cornerRadius = 6.0f;
    selectView.layer.borderWidth = 1.0f;
    selectView.layer.borderColor = [UIColor clearColor].CGColor;
    selectView.alpha = 1;
    selectView.tag = 202;
    selectView.backgroundColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1.0];
    [self.view addSubview:selectView];
    
    [pathButton setBackgroundColor:[UIColor clearColor]];
    [pathButton addTarget:self action:@selector(lookPathAction:) forControlEvents:UIControlEventTouchUpInside];
    [pathButton setTitle:@"查看巡查轨迹" forState:UIControlStateNormal];
    pathButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    pathButton.titleLabel.textColor = [UIColor whiteColor];
    [selectView addSubview:pathButton];
    
    [cancelButton setBackgroundColor:[UIColor clearColor]];
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    cancelButton.titleLabel.textColor = [UIColor whiteColor];
    [selectView addSubview:cancelButton];
}
//查看巡查轨迹
- (void)lookPathAction:(UIButton *)btn
{
    NewPathViewController *pathCtrl = [[NewPathViewController alloc] init];
    pathCtrl.objcode = self.codeLabel.text;
    pathCtrl.date = selecteDate;
    [self.navigationController pushViewController:pathCtrl animated:YES];

    //推入下个控制器之后，将clearView移除掉
    UIView *clearView = (UIView *)[self.view viewWithTag:201];
    UIView *selectedView = (UIView *)[self.view viewWithTag:202];
    [clearView removeFromSuperview];
    [selectedView removeFromSuperview];
    
    //禁止操作
    [self.segmentedCtrl setEnabled:YES forSegmentAtIndex:0];
    [self.segmentedCtrl setEnabled:YES forSegmentAtIndex:1];
    self.segmentedCtrl.selectedSegmentIndex = 1;

}

//查看隐患照片与录音
- (void)LookPictureAudioAction:(UIButton *)btn
{
    _isDanger = YES;
    ReserviorButton *button = (ReserviorButton *)btn;
    //将clearView移除掉
    UIView *clearView = (UIView *)[self.view viewWithTag:201];
    [clearView removeFromSuperview];
    
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setPostValue:@"SerXcInfo" forKey:@"t"];
    [request setPostValue: self.reserviorModal.objType forKey:@"objtype"];
    [request setPostValue: self.codeLabel.text forKey:@"type"];
    [request setPostValue:button.clickDate forKey:@"date"];
    
    [SVProgressHUD show];
    _isLoad = YES;
    [request startAsynchronous];
}

//显示隐患视图
- (void)showDangerView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    float centerPoint_y = (bgView.frame.size.height - 20 - 44)/2;
    bgView.backgroundColor = [UIColor lightGrayColor];
    bgView.alpha = 0.25;
    bgView.tag = 3001;
    [self.view addSubview:bgView];
    //禁止操作
    [self.segmentedCtrl setEnabled:NO forSegmentAtIndex:0];
    [self.segmentedCtrl setEnabled:NO forSegmentAtIndex:1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelDangerViewAction:)];
    tap.numberOfTapsRequired = 1;
    [bgView addGestureRecognizer:tap];
    
    HistoryObject *object = [dangerArray objectAtIndex:0];
    //整个dangerView
    UIView *dangerView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-280)/2, centerPoint_y-442/2, 280, 442)];
    dangerView.layer.cornerRadius = 6.0f;
    dangerView.layer.borderColor = [UIColor clearColor].CGColor;
    dangerView.layer.borderWidth = 1.0f;
    dangerView.layer.masksToBounds = YES;
    dangerView.backgroundColor = [UIColor colorWithRed:33/255.0 green:44/255.0 blue:54/255.0 alpha:1.0];
    dangerView.tag = 3000;
    [self.view addSubview:dangerView];
    
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dangerView.frame.size.width, 40)];
    dateView.backgroundColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1.0];
    [dangerView addSubview:dateView];
    
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dangerView.frame.size.width, 38)];
    date.backgroundColor = [UIColor clearColor];
    date.textColor = [UIColor whiteColor];
    date.textAlignment = NSTextAlignmentCenter;
    date.text = object.skDate;
    [dateView addSubview:date];
    
    //分割图片
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, dangerView.frame.size.width, 1)];
    imgView1.image = [UIImage imageNamed:@"menu_line"];
    [dangerView addSubview:imgView1];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, dateView.frame.size.height+1+10, dangerView.frame.size.width-10, 360-20)];
    imgView.contentMode = UIViewContentModeScaleAspectFit; //按比例缩放
    imgView.clipsToBounds = YES;
    imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:object.SkImg]]];
    imgView.backgroundColor = [UIColor colorWithRed:33/255.0 green:44/255.0 blue:54/255.0 alpha:1.0];
    [dangerView addSubview:imgView];
    
    float h = dateView.frame.size.height+imgView.frame.size.height + 2+20; //button 的Y坐标
    //分割图片
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, h-1, dangerView.frame.size.width, 1)];
    imgView2.image = [UIImage imageNamed:@"menu_line"];
    [dangerView addSubview:imgView2];
    
    UIView  *actionView = [[UIView alloc] initWithFrame:CGRectMake(0, h, dangerView.frame.size.width, 40)];
    actionView.backgroundColor =[UIColor colorWithRed:33/255.0 green:44/255.0 blue:54/255.0 alpha:1.0];
    [dangerView addSubview:actionView];
    
    float w = dangerView.frame.size.width/2-1;
    ReserviorButton *recodeButton = [ReserviorButton buttonWithType:UIButtonTypeCustom];
    recodeButton.frame = CGRectMake(0, 0, w,40);
    recodeButton.tag = 800;
    [recodeButton setBackgroundColor:[UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1.0]];
    [recodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [recodeButton setTitle:@"录音" forState:UIControlStateNormal];
    [recodeButton addTarget:self action:@selector(playAudioActin:) forControlEvents:UIControlEventTouchUpInside];
    recodeButton.audioString = object.skRecode;
    [actionView addSubview:recodeButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(actionView.frame.size.width/2+1, 0, w, 40);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1.0]];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelDangerViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:cancelButton];
    
    UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(actionView.frame.size.width/2, 0, 1, 40)];
    imgView3.image = [UIImage imageNamed:@"menu_line_vertical"];
    [actionView addSubview:imgView3];
}

//取消事件
- (void)cancelAction:(UIButton *)btn
{
    UIView *dangerView = (UIView *)[self.view viewWithTag:201];
    UIView *selectView = (UIView *)[self.view viewWithTag:202];
    if (_isPlay) {
        [audioPlay stop]; //停止播放
    }
    [selectView removeFromSuperview];
    [dangerView removeFromSuperview];
    //允许操作
    [self.segmentedCtrl setEnabled:YES forSegmentAtIndex:0];
    [self.segmentedCtrl setEnabled:YES forSegmentAtIndex:1];
    self.segmentedCtrl.selectedSegmentIndex = 1;
}

//取消dangerView
- (void)cancelDangerViewAction:(UIButton *)btn
{
    UIView *clearView = (UIView *)[self.view viewWithTag:3000];
    UIView *bgView = (UIView *)[self.view viewWithTag:3001];
    UIView *selectView = (UIView *)[self.view viewWithTag:202];
    if (_isPlay) {
        [audioPlay stop]; //停止播放
    }
    [selectView removeFromSuperview];
    [clearView removeFromSuperview];
    [bgView removeFromSuperview];
    //允许操作
    [self.segmentedCtrl setEnabled:YES forSegmentAtIndex:0];
    [self.segmentedCtrl setEnabled:YES forSegmentAtIndex:1];
    self.segmentedCtrl.selectedSegmentIndex = 1;
}

//播放录音
bool _isPlay = NO;
- (void)playAudioActin:(ReserviorButton *)btn
{
    _isPlay = YES;
    ReserviorButton *button = (ReserviorButton *)btn;
    [button setTitle:@"暂停" forState:UIControlStateNormal];
    //下载文件
    [[AsyncDownloadFile shareTheme] DownloadFilesUrl:button.audioString];
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

//下载完成后接受的通知，参数是NSNotification，可以接受下载类里面提交通知的时候传递出来的参数
- (void)FileDownloadCompleteAction:(NSNotification *)notification
{
    //下载结束之后开始播放
    //播放本地文件
    NSString *filePath = [self getCacheFilePath:notification.object];
    NSURL *mp3Url = [NSURL fileURLWithPath:filePath];
    audioPlay = [[AVAudioPlayer alloc] initWithContentsOfURL:mp3Url error:NULL];
    audioPlay.delegate = self;
    [audioPlay play];
}

#pragma mark - 播放结束
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:800];
    [btn setTitle:@"录音" forState:UIControlStateNormal];
    NSLog(@"播放结束");
}
@end
