//
//  ReserviorViewController.h
//  PartrolSystem
//
//  Created by teddy on 14-3-18.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "UserModal.h"

@class ReserviorModal;
@interface ReserviorViewController : UIViewController<ASIHTTPRequestDelegate>
{
    NSArray *_imageArray;
    ReserviorModal *_reserviorModal;
    UserModal *_userModal;
    BOOL _isload;
    
}

@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) ReserviorModal *reserviorModal;
@property (strong, nonatomic) UserModal *userModal;
@end
