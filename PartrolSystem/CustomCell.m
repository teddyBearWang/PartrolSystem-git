//
//  CustomCell.m
//  PartrolSystem
//
//*********************自定义UITableViewCell************************
//  Created by teddy on 14-4-23.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "CustomCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomCell ()

- (void)initSubViews;

@end

@implementation CustomCell
@synthesize subView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
  
    self.subView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 320-20, 460-20)];
    self.subView.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0f];
    self.subView.layer.cornerRadius = 6.0f;
    self.subView.layer.borderColor = [UIColor clearColor].CGColor;
    self.subView.layer.borderWidth = 1.0f;
    self.subView.clipsToBounds = YES;
    [self.contentView addSubview:self.subView];
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 5)];
    colorView.backgroundColor = [UIColor colorWithRed:184/255.0 green:125/255.0 blue:34/255.0 alpha:1.0f];
    [self.subView addSubview:colorView];
    
    self.reserviorImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.subView addSubview:self.reserviorImage];
    
    self.reserviorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.reserviorLabel.font = [UIFont systemFontOfSize:14];
    self.reserviorLabel.textColor = [UIColor whiteColor];
    self.reserviorLabel.backgroundColor = [UIColor clearColor];
    [self.subView addSubview:self.reserviorLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textColor = [UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1.0f];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    [self.subView addSubview:self.timeLabel];
    
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.locationLabel.font = [UIFont systemFontOfSize:13];
    self.locationLabel.backgroundColor = [UIColor clearColor];
    self.locationLabel.textColor = [UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1.0f];
    [self.subView addSubview:self.locationLabel];
    
    self.messageImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    //self.messageImage.layer.cornerRadius = 3.0f;
    [self.subView addSubview:self.messageImage];
    
    //布局设置button
    self.personButton = [ReserviorButton buttonWithType:UIButtonTypeCustom];
    self.personButton.backgroundColor = [UIColor clearColor];
    self.personButton.layer.borderWidth = 1.0f;
    self.personButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.personButton.layer.borderColor = [[UIColor clearColor] CGColor];
    self.personButton.titleLabel.textColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1.0f];
    self.personButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.personButton.frame = CGRectZero;
    [self.subView addSubview:self.personButton];
    
    self.positionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.positionLabel.backgroundColor = [UIColor clearColor];
    self.positionLabel.textColor = [UIColor whiteColor];
    [self.subView addSubview:self.positionLabel];
    
    self.dangerImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.dangerImage.layer.cornerRadius = 4.0f;
    self.dangerImage.layer.borderColor = [UIColor clearColor].CGColor;
    self.dangerImage.layer.borderWidth = 1.0f;
    self.dangerImage.clipsToBounds = YES;
    [self.subView addSubview:self.dangerImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.reserviorImage.frame = CGRectMake(10, 10, 50, 50);
    self.reserviorLabel.frame = CGRectMake(65, 10, 75, 20);
    self.timeLabel.frame = CGRectMake(140, 7, 140, 25);
    self.messageImage.frame = CGRectMake(300, 0, 20, 20);
    self.locationLabel.frame = CGRectMake(65, 40, 215, 20);
    self.personButton.frame = CGRectMake(0, 75, 80, 25);
    self.positionLabel.frame = CGRectMake(200, 75, 70, 30);
    self.dangerImage.frame = CGRectMake(20, 120, 260, 310);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    self.reserviorImage = nil,[self.reserviorImage release];
    self.reserviorLabel = nil,[self.reserviorLabel release];
    self.timeLabel = nil,[self.timeLabel release];
    self.messageImage = nil,[self.messageImage release];
    self.locationLabel = nil,[self.locationLabel release];
    [self.personButton release];
    self.positionLabel = nil,[self.positionLabel release];
    self.dangerImage = nil,[self.dangerImage release];
    [super dealloc];
}
@end
