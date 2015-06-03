//
//  AppDelegate.m
//  PartrolSystem
//
//  Created by teddy on 14-3-17.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
//#import <GoogleMaps/GoogleMaps.h>

@implementation AppDelegate

@synthesize remDay = _remDay;
@synthesize remMonth = _remMonth;
@synthesize remYear = _remYear;
@synthesize offSetTime = _offSetTime;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //获取现在的时间
    [self refreshNowTimeDate];
    self.offSetTime = 8 * 60 * 60;//与格林尼治时间的偏移量
    
    MainViewController *mainCtrl = [[MainViewController alloc] init];
    UINavigationController *navigationCtrl = [[UINavigationController alloc] initWithRootViewController:mainCtrl];
    //修改默认navigationControl.title的颜色
    [navigationCtrl.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil]];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        //设置navigationBar的颜色
        navigationCtrl.navigationBar.translucent = NO; //bar的颜色不变成模糊
        navigationCtrl.navigationBar.barTintColor = [UIColor colorWithRed:29/255.0 green:37/255.0 blue:42/255.0 alpha:1.0f];
    }else{
        navigationCtrl.navigationBar.tintColor = [UIColor colorWithRed:29/255.0 green:37/255.0 blue:42/255.0 alpha:1.0f];
    }
    self.window.rootViewController = navigationCtrl;
    return YES;
}

- (void)refreshNowTimeDate
{
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    NSInteger unitFlag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateCom = [currentCalendar components:unitFlag fromDate:currentDate];
    self.remYear = [dateCom year];
    self.remMonth = [dateCom month];
    self.remDay = [dateCom day];
}

-(NSInteger)daysOfAMonth:(NSInteger)nowtimeYear month:(NSInteger)nowtimeMonth
{
    if (nowtimeMonth < 1) {
        nowtimeMonth = 12;
        nowtimeYear -=1;
    }
    
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [currentCalendar setFirstWeekday:0]; //设置每周从周几开始
    [currentCalendar setMinimumDaysInFirstWeek:7]; //设置每周最少的天数
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置时区
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:[SHAREAPP offSetTime]]];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *firstDayInAMonth = [[NSDate alloc] init];
    //每月一号的时间
    firstDayInAMonth = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld%.2ld01",(long)[SHAREAPP remYear],(long)[SHAREAPP remMonth]]];
    NSRange dateRange = [currentCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:firstDayInAMonth]; //时间range(每月的天数)
    return dateRange.length;
}

//禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
