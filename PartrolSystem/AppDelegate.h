//
//  AppDelegate.h
//  PartrolSystem
//
//  Created by teddy on 14-3-17.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SHAREAPP ((AppDelegate*)([[UIApplication sharedApplication]delegate]))

@interface AppDelegate : UIResponder <UIApplicationDelegate>



@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) NSInteger remYear;
@property (assign, nonatomic) NSInteger remMonth;
@property (assign, nonatomic) NSInteger remDay;
@property (assign, nonatomic) NSInteger offSetTime;

- (void)refreshNowTimeDate;
-(NSInteger)daysOfAMonth:(NSInteger)nowtimeYear month:(NSInteger)nowtimeMonth;
@end
