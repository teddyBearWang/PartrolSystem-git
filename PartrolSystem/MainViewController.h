//
//  MainViewController.h
//  PartrolSystem
//
//  Created by teddy on 14-3-17.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface MainViewController : UIViewController<ASIHTTPRequestDelegate,UITextFieldDelegate>
{
    BOOL _isMoved;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginButon;
@property (weak, nonatomic) IBOutlet UITextField *loginID;
@property (weak, nonatomic) IBOutlet UITextField *loginPsw;

- (IBAction)loginAction:(id)sender;
- (IBAction)tapBackgroundAction:(id)sender;

@end
