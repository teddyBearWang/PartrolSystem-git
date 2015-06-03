//
//  CountyViewController.h
//  PartrolSystem
//
//  Created by teddy on 14-3-28.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReserviorModal.h"
#import "ASIHTTPRequest.h"

@interface CountyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    UITableView *_tableView;
    ReserviorModal *_reserviorModal;
    UILabel *_countyName; //城市名字
    UILabel *_totalReservior; //总水库数量
    UILabel *_noPatrolLabel;//未巡查数量
    UILabel *_problemLabel;//有问题数量
    UILabel *_firstNameLabel;//第一负责人姓名
    UILabel *_secondNameLabel;//第二负责人姓名
    UIImageView *_bgView; //改变颜色的view
    
    UIButton *_firstNumLabel;//第一负责人号码
    UIButton *_secondNumLabel;//第二负责人号码
    UILabel *_firstNum;
    UILabel *_secondeNum;
    BOOL _isLoad;//表示正在加载网络数据
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ReserviorModal *reserviorModal;
@property (nonatomic, strong) UILabel *countyName;
@property (nonatomic, strong) UILabel *totalReservior;
@property (nonatomic, strong) UILabel *noPatrolLabel;
@property (nonatomic, strong) UILabel *problemLabel;
@property (nonatomic, strong) UILabel *firstNameLabel;
@property (nonatomic, strong) UILabel *secondNameLabel;
@property (nonatomic, strong) UIButton *firstNumLabel;
@property (nonatomic, strong) UIButton *secondNumLabel;
@property (nonatomic, strong) UILabel *firstNum;
@property (nonatomic, strong) UILabel *secondNum;
@property (nonatomic, strong) UIImageView *bgView;
@end
