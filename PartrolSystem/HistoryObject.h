//
//  HistoryObject.h
//  PartrolSystem
//
//  ******************巡查的历史记录，用于显示日历******************
//  Created by teddy on 14-4-3.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryObject : NSObject

@property (nonatomic, strong) NSString *sDateTime;
@property (nonatomic, strong) NSString *sKcontent;
@property (nonatomic, assign) NSInteger upLoadEvent;

@property (nonatomic, strong) NSString *allCount; //全部水库数量
@property (nonatomic, strong) NSString *patrolCount; //已经巡查水库数量
@property (nonatomic, strong) NSString *nopatrolCount; // 未巡查水库数量
@property (nonatomic, strong) NSString *eventCount; //有隐患水库数量

//隐患属性
@property (nonatomic, strong) NSString *skDate;
@property (nonatomic, strong) NSString *SkImg;
@property (nonatomic, strong) NSString *skRecode;

@end
