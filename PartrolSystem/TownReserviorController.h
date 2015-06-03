//
//  TownReserviorController.h
//  PartrolSystem
//
//  Created by teddy on 14-3-19.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReserviorModal.h"
#import "ASIHTTPRequest.h"

@interface TownReserviorController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    UILabel *_townReserviorLabel; //乡镇名称
    UILabel *_totalReserviorLabel; //总水库
    UILabel *_noPartolReserviorLabel;//已巡查水库
    UILabel *_problemReserviorLabel;//有隐患水库
    UILabel *_firstHeadNameLabel;  // 第一负责人
    UILabel *_secondheadNameLabel; //第二负责人
    
    UIButton *_firstHeadNumber; //第一负责人号码
    UIButton *_secondHeadNumber; //第二负责人号码
    UIImageView *_bgView; //改变背景颜色的view
    
    UILabel *_firstName;
    UILabel *_secondName;
    UITableView *_tableView;
    ReserviorModal *_reserviorModal;
    BOOL _isLoading;
}

@property (nonatomic, strong) UILabel *townReserviorLabel;
@property (nonatomic, strong) UILabel *totalReserviorLabel;
@property (nonatomic, strong) UILabel *noPartolReserviorLabel;
@property (nonatomic, strong) UILabel *problemReserviorLabel;
@property (nonatomic, strong) UILabel *firstHeadNameLabel;
@property (nonatomic, strong) UILabel *secondheadNameLabel;
@property (nonatomic, strong) UIButton *firstHeadNumber;
@property (nonatomic, strong) UIButton *secondHeadNumber;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ReserviorModal *reserviorModal;
@property (nonatomic, strong) UILabel *firstName;
@property (nonatomic, strong) UILabel *secondName;
@property (nonatomic, strong) UIImageView *bgView;

@end
