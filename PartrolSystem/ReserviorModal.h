//
//  ReserviorModal.h
//  PartrolSystem
//******************单例对象******************************
//  Created by teddy on 14-3-18.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReserviorModal : NSObject
@property (nonatomic, strong) NSMutableArray *reserviorArray; //水库水闸对象数组
@property (nonatomic, strong) NSMutableArray *townArray;    //乡镇数量数组
@property (nonatomic, strong) NSMutableArray *countyArray;  //县数量数组
@property (nonatomic, strong) NSMutableArray *cityArray;   //城市数量数组
@property (nonatomic, strong) NSMutableArray *totalReserviorArray; //全部水库数组
@property (nonatomic, strong) NSMutableArray *dateArray; //巡查记录数组
@property (nonatomic, strong) NSArray *singleArray;  //单个水库数组
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, strong) NSString *objType;   //选择水库类型
@property (nonatomic, strong) NSString *titleString;
+ (id)sharedReserviorModal;
@end
