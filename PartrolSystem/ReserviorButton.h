//
//  ReserviorButton.h
//  PartrolSystem
//  Created by teddy on 14-3-19.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReserviorButton : UIButton
{
    int _selectNum;
    NSString *_buttonNumber;
    NSString *_clickdate; //点击的时间
    NSString *_imgString; //图片链接
    NSString *_audioString; //录音链接
}
@property (nonatomic) int selectNum;
@property (nonatomic, strong) NSString *buttonNumber;
@property (nonatomic, strong) NSString *clickDate;
@property (nonatomic, strong) NSString *imgString;
@property (nonatomic, strong) NSString *audioString;


@end
