//
//  TownReservior.h
//  PartrolSystem
//***********************乡镇对象********************
//  Created by teddy on 14-3-19.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TownReservior : NSObject

@property (nonatomic, strong) NSString *adcd;   //编号
@property (nonatomic, strong) NSString *adcdName; //乡镇名称
@property (nonatomic, strong) NSString *lvlName; //等级编号
@property (nonatomic, strong) NSString *imgName; //图片名称
@property (nonatomic, strong) NSString *totalReserviorNum;//水库的总数量
@property (nonatomic, strong) NSString *noPartolReserviorNum;//未巡查过水库数量
@property (nonatomic, strong) NSString *problemReserviorNum;//有隐患的水库数量
@property (nonatomic, strong) NSString *firstHeadName;//第一负责人姓名
@property (nonatomic, strong) NSString *secondHeadName;//第二负责人姓名
@property (nonatomic, strong) NSString *firstHeadNumber;//第一负责人电话号码
@property (nonatomic, strong) NSString *secondHeadNumber;//第二负责人电话号码

@end
