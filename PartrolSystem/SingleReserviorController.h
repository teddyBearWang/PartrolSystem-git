//
//  SingleReserviorController.h
//  PartrolSystem
// **********************单个水库的详细信息****************************
//  Created by teddy on 14-3-26.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"
#import "sys/utsname.h"
#import "AsyncDownloadFile.h"
#import <AVFoundation/AVFoundation.h>

@class ReserviorModal;
#define CALENCOLOR ([UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1.0])

@interface SingleReserviorController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,ASIHTTPRequestDelegate,AVAudioPlayerDelegate>
{
    ReserviorModal *_reserviorModal;
    UIView *_historyView;
    NSMutableArray *historyArray;
    UISegmentedControl *_segmentedCtrl;
    
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
    NSString *_todayTime;
    
    NSString *selecteDate;
    UIImageView *_imgView;
    NSMutableArray *dangerArray; //隐患数组
    
    BOOL _isDanger; //是否是获取隐患
    bool isShow;    //是否显示日历界面
    AVAudioPlayer *audioPlay;
    BOOL _isLoad; //表示正在加载网络数据中
    BOOL _isMonthChanged;//表示是否切换月份
    
}

@property (nonatomic, strong) ReserviorModal *reserviorModal;
@property (strong, nonatomic) UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (nonatomic, strong) NSString *codeNum;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *capactiyLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstNumButton;
@property (weak, nonatomic) IBOutlet UIButton *secondNumButtom;
@property  UIView *historyView;
@property (strong, nonatomic) UISegmentedControl *segmentedCtrl;

-(void)removeCalenBtnFromCalenView;
- (void)drawCalendar; //画日历
- (void)selfInitView;
- (void)getCurrentScreenFrame;
@end
