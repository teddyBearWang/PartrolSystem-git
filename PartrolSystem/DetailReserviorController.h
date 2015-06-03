//
//  DetailReserviorController.h
//  PartrolSystem
//
//  Created by teddy on 14-3-20.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReserviorModal.h"
#import "ASIHTTPRequest.h"

@interface DetailReserviorController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    UITableView *_tableView;
    UIImageView *_imgView;
    UILabel *_nameLabel;
    UILabel *_adcdLabel;
    UILabel *_patrolStatusLabel;
    //dataSource array
    NSMutableArray *_dataArray;
    ReserviorModal *_reserviorModal;
    NSArray *_itemArray; //segmentCtrl的item数组
    
    BOOL _loading;// 正在加载中
    NSString *_passCode;//传入下级的水库编号
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *adcdLabel;
@property (nonatomic, strong) UILabel *patrolStatusLabel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) ReserviorModal *reserviorModal;

@end
