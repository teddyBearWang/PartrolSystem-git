//
//  HistoryViewController.h
//  PartrolSystem
//
//  Created by teddy on 14-4-11.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReserviorModal.h"
#import "AppDelegate.h"
#import "sys/utsname.h"
#import "NIDropDown.h"
#import "ASIHTTPRequest.h"
#import "UserModal.h"
#import "HistoryObject.h"

#define CALENCOLOR ([[UIColor alloc]initWithRed:0.98 green:0.98 blue:0.98 alpha:1])

@interface HistoryViewController : UIViewController<UINavigationControllerDelegate,NIDropDownDelegate,ASIHTTPRequestDelegate>
{
    NSInteger count; // 正常日期计数
    UIView *calendarBgView; //日历
    NSInteger nextDaysCount; //下月显本月日期计数 
    NSInteger lastdaysCount; //上月遗留本月日期计数
    
    NSInteger localYear; //记录当前查询时间
    NSInteger localMonth;
    NSInteger localDay;
    
    NSInteger currentMonthDays;
    NSInteger remBtnTag;
    UIButton *changeButton;
    CGRect currentScreenFrame;
    UILabel *dateLabel;
    
    NSString *selecteDate;
    
    NIDropDown *dropDown;
    ReserviorModal *modal; //单例对象
    UserModal *user;
    NSMutableArray *historyArray;
    int selectedObjectType;
    bool isFirst ;
    bool isSelected ;
    
    UIView *subView;
    UIImageView *imgView; // 显示小箭头的view

}
-(void)removeCalenBtnFromCalenView;
- (void)drawCalendar; //画日历
- (void)initCalendarView;
- (void)getCurrentScreenFrame;

- (void)rel;
@end
