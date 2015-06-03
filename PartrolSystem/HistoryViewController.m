//
//  HistoryViewController.m
//  PartrolSystem
//********************历史记录控制器******************
//  Created by teddy on 14-4-11.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "HistoryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Reservior.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"


#define TITLVIEWHEIGHT 30
#define LABELVIEWHEIGHT 50
#define SUBVIEWWIDTH self.view.frame.size.width
#define SUBVIEWHEIGHT self.view.frame.size.height

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         isFirst = YES;
         isSelected = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    modal = [ReserviorModal sharedReserviorModal];
    user = [UserModal sharedUserModal];
    [self initNavigatinbar];

    [self getCurrentScreenFrame];
    [self initLabelView];
    self.view.backgroundColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1];

    localDay = SHAREAPP.remDay;
    localMonth = SHAREAPP.remMonth;
    localYear = SHAREAPP.remYear;
    remBtnTag = 0;
    
   
    selectedObjectType = [[modal.reserviorArray objectAtIndex:0] objectType];
        //获取网络数据
    [self getWebServiceData:[NSString stringWithFormat:@"%d",selectedObjectType] Year:[NSString stringWithFormat:@"%ld",localYear] Month:[NSString stringWithFormat:@"%ld",localMonth]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化UINavigationBar
- (void)initNavigatinbar
{
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backitem;
    
    //right item
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    customView.backgroundColor = [UIColor clearColor];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (customView.frame.size.height-24)/2, customView.frame.size.width, 24)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    
    //设置区域名称
    Reservior *reservior = [modal.reserviorArray objectAtIndex:0];
    nameLabel.text = reservior.adcdName;
    [customView addSubview:nameLabel];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *titleCustomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
    
    titleCustomView.backgroundColor = [UIColor clearColor];
    UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clickButton.frame = CGRectMake(0, 0, 70, 44);
    clickButton.titleLabel.backgroundColor = [UIColor clearColor];
    clickButton.titleLabel.font = [UIFont systemFontOfSize:15];
    clickButton.titleLabel.textAlignment = NSTextAlignmentRight;
    //设置标题
    [clickButton setTitle:reservior.typeName forState:UIControlStateNormal];
    [clickButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clickButton addTarget:self action:@selector(selectedObjTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleCustomView addSubview:clickButton];
    
    //创建图片视图
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 17, 15, 10)];
    imgView.image = [UIImage imageNamed:@"down"];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.tag = 3001;
    [titleCustomView addSubview:imgView];
    
    self.navigationItem.titleView = titleCustomView;
}

//获取网络数据
- (void)getWebServiceData:(NSString *)objectType Year:(NSString *)year Month:(NSString *)month
{
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setPostValue:@"getHistory" forKey:@"t"];
    [request setPostValue:year forKey:@"year"];
    [request setPostValue:month forKey:@"month"];
    [request setPostValue: user.loginName forKey:@"padcd"];
    [request setPostValue:@"0" forKey:@"objcode"];
    [request setPostValue:objectType forKey:@"objtype"];
    [SVProgressHUD show];
    //发送同步网络请求
    [request startAsynchronous];
}
//初始化标签视图
- (void)initLabelView
{
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, currentScreenFrame.size.height-20-5-30-LABELVIEWHEIGHT-40, currentScreenFrame.size.width,LABELVIEWHEIGHT)];
    labelView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:labelView];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(90, 2, 10, 10)];
    redView.backgroundColor = [UIColor redColor];
    [labelView addSubview:redView];
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(90, 17, 10, 10)];
    greenView.backgroundColor = [UIColor greenColor];
    [labelView addSubview:greenView];
    UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(90, 32, 10, 10)];
    orangeView.backgroundColor = [UIColor orangeColor];
    [labelView addSubview:orangeView];
    
    UILabel *redLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 2, 150, 10)];
    redLabel.text = @"红色代表有隐患工程";
    redLabel.backgroundColor = [UIColor clearColor];
    redLabel.textColor = [UIColor whiteColor];
    redLabel.font = [UIFont systemFontOfSize:10];
    [labelView addSubview:redLabel];
    
    UILabel *greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 17, 150, 10)];
    greenLabel.text = @"绿色代表已巡查工程";
    greenLabel.backgroundColor = [UIColor clearColor];
    greenLabel.textColor = [UIColor whiteColor];
    greenLabel.font = [UIFont systemFontOfSize:10];
    [labelView addSubview:greenLabel];
    
    UILabel *orangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 32, 150, 10)];
    orangeLabel.text = @"橙色代表未巡查工程";
    orangeLabel.backgroundColor = [UIColor clearColor];
    orangeLabel.textColor = [UIColor whiteColor];
    orangeLabel.font = [UIFont systemFontOfSize:10];
    [labelView addSubview:orangeLabel];}

//初始化日历视图
- (void)initCalendarView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake((currentScreenFrame.size.width-150)/2, 0, 150, TITLVIEWHEIGHT)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.userInteractionEnabled = YES;
    
    UIView *titleBgView = [[UIView alloc] initWithFrame:CGRectMake((titleView.frame.size.width - 100)/2, 0, 100, TITLVIEWHEIGHT)];
    titleBgView.clipsToBounds = YES;
    [titleView addSubview:titleBgView];
    //创建时间标签
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleBgView.frame.size.width, TITLVIEWHEIGHT)];
    dateLabel.text = [NSString stringWithFormat:@"%ld年 %.2ld月",localYear,localMonth];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont systemFontOfSize:13];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [titleBgView addSubview:dateLabel];
    
    //创建两个月份的按钮
    NSArray *changeMonthBtnName = @[@"left",@"right"];
    for (int i=0; i<changeMonthBtnName.count; i++) {
        UIButton *LRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [LRBtn setImage:[UIImage imageNamed:[changeMonthBtnName objectAtIndex:i]] forState:UIControlStateNormal];
        if (i == 0) {
            LRBtn.frame = CGRectMake(0, (titleView.frame.size.height-24)/2, 24, 24);
        }
        if (i == 1) {
            LRBtn.frame = CGRectMake(titleView.frame.size.width-24, (titleView.frame.size.height-24)/2, 24, 24);
        }
        
        LRBtn.tag = 100+i;
        LRBtn.backgroundColor = [UIColor clearColor];
        [LRBtn addTarget:self action:@selector(selectMonth:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:LRBtn];
    }
    [self.view addSubview:titleView];
    
    count = 0;
    
    calendarBgView = [[UIView alloc] initWithFrame:CGRectMake(20, titleView.frame.origin.y+5+TITLVIEWHEIGHT, (currentScreenFrame.size.width-40), (currentScreenFrame.size.height-20-44-44-TITLVIEWHEIGHT-LABELVIEWHEIGHT))];
    calendarBgView.backgroundColor = [UIColor clearColor];
    calendarBgView.layer.masksToBounds = YES;
    calendarBgView.layer.borderWidth = 1.0;
    calendarBgView.layer.borderColor = [[UIColor clearColor] CGColor];
    [self.view addSubview:calendarBgView];
    
    NSArray *weekArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    for (int i=0; i<weekArray.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((calendarBgView.frame.size.width/7) *i, 0, calendarBgView.frame.size.width/7, calendarBgView.frame.size.height/7)];
        view.tag = 10001;
        view.backgroundColor = [UIColor clearColor];
        view.layer.masksToBounds = YES;
        view.layer.borderColor = [[UIColor whiteColor] CGColor];
        view.layer.borderWidth = 1.0;
        
        UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 21, 48, 21)];
        weekLabel.backgroundColor = [UIColor clearColor];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.textColor = [UIColor whiteColor];
        weekLabel.text = [weekArray objectAtIndex:i];
        weekLabel.font = [UIFont systemFontOfSize:12];
        [view addSubview:weekLabel];
        [calendarBgView addSubview:view];
    }
}

- (void)getCurrentScreenFrame
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    currentScreenFrame = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] intValue] > 7.0) {
        currentScreenFrame.size.height -=22;
        currentScreenFrame.origin.y = 22;
    }
}

//选择上一个月或者下一个月
- (void)selectMonth:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
        {
            localMonth -=1;
            if (localMonth<1) {
                localMonth = 12;
                localYear -=1;
            }
        }
            break;
            
        case 101:
        {
            localMonth +=1;
            if (localMonth > 12) {
                localMonth = 1;
                localYear +=1;
            }
        }
            break;
        default:
            break;
    }
    
    count = 0;
    nextDaysCount = 0;
    lastdaysCount = 0;
    dateLabel.text = [NSString stringWithFormat:@"%ld年 %.2ld月",localYear,localMonth];
    if (localMonth==1||localMonth==3||localMonth==5||localMonth==7||localMonth==8||localMonth==10||localMonth==12) {
        currentMonthDays = 31;
    }else if (localMonth == 2)
    {
        if ((localYear%4 ==0 && localYear%100 !=0)||localYear%400 == 0 ) {
            currentMonthDays = 29;
        }else{
            currentMonthDays = 28;
        }
    }else{
        currentMonthDays = 30;
    }
    
    isSelected = YES;
        //调用服务
    [self getWebServiceData:[NSString stringWithFormat:@"%d",selectedObjectType] Year:[NSString stringWithFormat:@"%ld",localYear] Month:[NSString stringWithFormat:@"%ld",localMonth]];
}
//画日历
- (void)drawCalendar
{
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [currentCalendar setFirstWeekday:1]; //设置每周的第一天是从周一开始算起
    [currentCalendar setMinimumDaysInFirstWeek:7]; //设置每周有7天
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:[SHAREAPP offSetTime]]];//更细时差
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *firstDayInAMonth = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d%.2d01",localYear,localMonth]]; //每月1号字符串
    NSRange dateRange = [currentCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:firstDayInAMonth]; // 时间range(该月的天数)
    NSInteger weekday = [currentCalendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:firstDayInAMonth]; //每月1号是周几
    
    //开始画日历
    NSInteger weekSum = 6;//一共有6行
    NSInteger btnWidth = calendarBgView.frame.size.width/7;
    NSInteger btnHeight = calendarBgView.frame.size.height/7;
    count = 0;
    //开始按行循环
    for (int i = 0; i < weekSum; i++)
    {
        for (int j=0; j<7; j++)
        {
            CGRect calendarBtnFrame = CGRectMake(btnWidth*j, btnHeight*(i+1), btnWidth, btnHeight);
            if (i == 0) { //第一行
                if (j< weekday-1) { //显示上个月遗留的天数
                    lastdaysCount +=1;
                    
                    UIView *tempView = [[UIView alloc] initWithFrame:calendarBtnFrame];
                    tempView.userInteractionEnabled = YES;
                    tempView.layer.masksToBounds = YES;
                    tempView.layer.borderColor = [[UIColor whiteColor] CGColor];
                    tempView.layer.borderWidth = 1.0;
                    
                    UILabel *temLabel = [[UILabel alloc] initWithFrame:CGRectMake((calendarBtnFrame.size.width-27)/2, (calendarBtnFrame.size.height)/2, 27, 21)];
                    temLabel.backgroundColor = [UIColor clearColor];
                    NSInteger month = localMonth;
                    NSInteger year = localYear;
                    if (month<2) {
                        month = 12;
                        year -= 1;
                    }
                    NSInteger days = [SHAREAPP daysOfAMonth:year month:(month-1)]-weekday+lastdaysCount+1;
                    temLabel.text = [NSString stringWithFormat:@"%ld",days];
                    temLabel.textAlignment = NSTextAlignmentCenter;
                    temLabel.textColor = [UIColor grayColor];
                    temLabel.font = [UIFont systemFontOfSize:10];
                    temLabel.tag = 88;
                    [tempView addSubview:temLabel];
                    [calendarBgView addSubview:tempView];
                    continue;
                }
            }
            
            if (count >= dateRange.length) {
                nextDaysCount +=1; //显示下个月遗留的天数
                
                UIView *temp = [[UIView alloc] initWithFrame:calendarBtnFrame];
                temp.userInteractionEnabled = YES;
                temp.layer.masksToBounds = YES;
                temp.layer.borderColor = [[UIColor whiteColor] CGColor];
                temp.layer.borderWidth = 1.0;
                
                UILabel *temLabel = [[UILabel alloc] initWithFrame:CGRectMake((calendarBtnFrame.size.width-27)/2, (calendarBtnFrame.size.height)/2, 27, 21)];
                temLabel.backgroundColor = [UIColor clearColor];
                temLabel.text = [NSString stringWithFormat:@"%ld",nextDaysCount];
                temLabel.textAlignment = NSTextAlignmentCenter;
                temLabel.textColor = [UIColor grayColor];
                temLabel.tag = 88;
                temLabel.font = [UIFont systemFontOfSize:10];
                [temp addSubview:temLabel];
                [calendarBgView addSubview:temp];
                continue;
            }
            
            //画本月日历
            count++;
            UIView *tempView = [[UIView alloc] initWithFrame:calendarBtnFrame];
            tempView.tag = (localMonth*100 + 100)*100+88;
            tempView.userInteractionEnabled = YES;
            tempView.layer.masksToBounds = YES;
            tempView.layer.borderColor = [[UIColor whiteColor] CGColor];
            tempView.layer.borderWidth = 1.0;
            [calendarBgView addSubview:tempView];
            //标签视图
            UIView *lableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, calendarBtnFrame.size.width, (calendarBtnFrame.size.height)/2)];
            lableView.backgroundColor = [UIColor clearColor];
            [tempView addSubview:lableView];
            //显示巡查情况
            if (historyArray.count != 0 && count < historyArray.count +1) {
                HistoryObject *object = [historyArray objectAtIndex:count-1];
                if ([object.nopatrolCount intValue] != 0) {
                    UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(10, 2, 6, 6)];
                    orangeView.backgroundColor = [UIColor orangeColor];
                    [lableView addSubview:orangeView];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 2, 15, 6)];
                    label.backgroundColor = [UIColor clearColor];
                    label.textColor = [UIColor whiteColor];
                    label.font = [UIFont systemFontOfSize:7];
                    label.text = object.nopatrolCount;
                    [lableView addSubview:label];
                }
                if ([object.patrolCount intValue] != 0) {
                    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 6, 6)];
                    greenView.backgroundColor = [UIColor greenColor];
                    [lableView addSubview:greenView];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 10, 15, 6)];
                    label.backgroundColor = [UIColor clearColor];
                    label.textColor = [UIColor whiteColor];
                    label.font = [UIFont systemFontOfSize:7];
                    label.text = object.patrolCount;
                    [lableView addSubview:label];
                }
                if ([object.eventCount intValue] != 0) {
                    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(10, 18, 6, 6)];
                    redView.backgroundColor = [UIColor redColor];
                    [lableView addSubview:redView];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 18, 15, 6)];
                    label.backgroundColor = [UIColor clearColor];
                    label.textColor = [UIColor whiteColor];
                    label.font = [UIFont systemFontOfSize:7];
                    label.text = object.eventCount;
                    [lableView addSubview:label];
                }
            }
           
            //创建日期label
            UILabel *temLabel = [[UILabel alloc] initWithFrame:CGRectMake((calendarBtnFrame.size.width-27)/2, (calendarBtnFrame.size.height)/2, 27, 21)];
            temLabel.text = [NSString stringWithFormat:@"%ld",count];
            temLabel.backgroundColor = [UIColor clearColor];
            temLabel.textAlignment = NSTextAlignmentCenter;
            temLabel.textColor = [UIColor whiteColor];
            temLabel.font = [UIFont systemFontOfSize:10];
            temLabel.userInteractionEnabled = YES;
            [tempView addSubview:temLabel];
            //创建button
            UIButton *ttBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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

- (void)removeCalenBtnFromCalenView
{
    for (UIView *obj in calendarBgView.subviews) {
        if ([obj isKindOfClass:[UIView class]] && obj.tag !=10001) {
             [obj removeFromSuperview];
        }
    }
}

#pragma mark - privated Action
//单机时间日期
- (void)btnPress:(id)sender
{
    NSLog(@"单机了时间");
    
}

//选择水库类型
- (void)selectedObjTypeAction:(id)sender
{
    NSMutableArray *nameArray = [NSMutableArray arrayWithCapacity:modal.reserviorArray.count];
    for (int i=0; i<modal.reserviorArray.count; i++) {
        Reservior *reservior = [modal.reserviorArray objectAtIndex:i];
        [nameArray addObject:reservior.typeName];
    }
    if (dropDown == nil) {
        imgView.image = [UIImage imageNamed:@"up"];
        CGFloat f = 30*nameArray.count;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :nameArray];
        [self.view addSubview:dropDown];
        dropDown.delegate = self;
    }else{
        imgView.image = [UIImage imageNamed:@"down"];
        [dropDown hideDropDown:sender];
        dropDown.delegate = self;
        [self rel];
    }
}

#pragma mark - NIDropDownDelegate action
- (void) niDropDownDelegateMethod: (int) sender
{
    imgView.image = [UIImage imageNamed:@"down"];
    [self rel];
    isSelected = YES;
    Reservior *reservior = [modal.reserviorArray objectAtIndex:sender];
    selectedObjectType = reservior.objectType;
    [self getWebServiceData:[NSString stringWithFormat:@"%d",selectedObjectType] Year:[NSString stringWithFormat:@"%d",localYear] Month:[NSString stringWithFormat:@"%ld",localMonth]];
}

-(void)rel{
    dropDown = nil;
}
#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    if (request.responseStatusCode == 200) {
        NSString *string = [request responseString];
        NSString *jsonString = [[string substringFromIndex:1] substringToIndex:[string substringFromIndex:1].length - 1];
        NSString *resultString = [jsonString stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        NSData *jsondata = [resultString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray * jsonArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableLeaves error:nil];
        
        if (historyArray.count != 0) {
            [historyArray removeAllObjects];
        }
        historyArray = [NSMutableArray arrayWithCapacity:jsonArray.count];
        for (int i =0; i<jsonArray.count; i++) {
            HistoryObject *object = [[HistoryObject alloc] init];
            NSDictionary *objectDic = [jsonArray objectAtIndex:i];
            object.allCount = [objectDic objectForKey:@"allcount"];
            object.patrolCount = [objectDic objectForKey:@"patrol"];
            object.nopatrolCount = [objectDic objectForKey:@"nopatrol"];
            object.eventCount = [objectDic objectForKey:@"eventcount"];
            [historyArray addObject:object];
        }
        if (isFirst) {
            [self initCalendarView];
            [self drawCalendar];
            isFirst = NO;
        }
        if (isSelected) {
            [self removeCalenBtnFromCalenView];
            [self drawCalendar];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithError:@"更新失败"];
}
#pragma mark - UIBarButtonitemAction
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
