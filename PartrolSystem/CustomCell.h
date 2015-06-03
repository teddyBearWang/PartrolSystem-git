//
//  CustomCell.h
//  PartrolSystem
//
//  Created by teddy on 14-4-23.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReserviorButton.h"


#define CELLHEIGHT  self.contentView.frame.size.height
#define CELLWIDTH  self.contentView.frame.size.width

@interface CustomCell : UITableViewCell

{
    
    UIView *_subView; //子视图
    
    UIImageView *_reserviorImage; //水库图片
    UILabel *_reserviorLabel;     // 水库名称
    UILabel *_locationLabel;          // 水库地址
    UIImageView *_messageImage;   //新消息图片
    UILabel *_timeLabel;          //时间
    ReserviorButton *_personButton;      //巡查员名字
    UILabel *_positionLabel;      //位置
    UIImageView *_dangerImage;    //隐患图片
    
}
@property (nonatomic, strong) UIImageView *reserviorImage;
@property (nonatomic, strong) UILabel *reserviorLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIImageView *messageImage;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) ReserviorButton *personButton;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UIImageView *dangerImage;
@property (nonatomic, strong) UIView *subView;
@end
