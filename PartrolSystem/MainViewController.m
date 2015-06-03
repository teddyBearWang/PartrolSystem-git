//
//  MainViewController.m
//  PartrolSystem
//
//*******************登陆界面************************
//  Created by teddy on 14-3-17.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "ReserviorViewController.h"
#import "MainViewController.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ReserviorModal.h"
#import "Reservior.h"
#import "UserModal.h"
#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>


@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.titleLabel.text = @"水利巡查移动端";
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:26];
    self.backImageView.image = [UIImage imageNamed:@"login_bg"];
    
    self.loginID.placeholder = @"区号";
    self.loginID.delegate = self;
    //设置UITextField.Placeholder的颜色
    [self.loginID setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.loginID.background = [UIImage imageNamed:@"img_et_bg"];
    self.loginID.backgroundColor = [UIColor clearColor];
    self.loginID.textColor = [UIColor whiteColor];
    self.loginID.layer.cornerRadius = 6.0f;
    self.loginID.layer.borderWidth = 1.0f;
    
    CGRect rect = self.loginID.frame;
    rect.size.height = 50;
    self.loginID.frame = rect;
    self.loginID.font = [UIFont systemFontOfSize:18];
    self.loginID.layer.borderColor = [UIColor clearColor].CGColor;
    self.loginID.leftViewMode = UITextFieldViewModeAlways;

    CGRect rect1 = self.loginPsw.frame;
    rect1.size.height = 50;
    self.loginPsw.frame = rect1;
    self.loginPsw.font = [UIFont systemFontOfSize:18];
    self.loginPsw.background = [UIImage imageNamed:@"img_et_bg"];
    self.loginPsw.backgroundColor = [UIColor clearColor];
    self.loginPsw.textColor = [UIColor whiteColor];
    self.loginPsw.delegate = self;
    self.loginPsw.layer.borderColor = [UIColor clearColor].CGColor;
    self.loginPsw.layer.cornerRadius = 6.0f;
    self.loginPsw.layer.borderWidth = 1.0f;
    self.loginPsw.placeholder = @"密码";
    [self.loginPsw setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.loginPsw.secureTextEntry = YES;
    self.loginPsw.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *loginIDImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    loginIDImage.image = [UIImage imageNamed:@"img_user"];
    UIImageView *loginPswImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    loginPswImage.image = [UIImage imageNamed:@"img_password"];
    self.loginID.leftView = loginIDImage;
    self.loginPsw.leftView = loginPswImage;
    
    //取出本地的登陆数据
    NSArray *loginArray = [self readNSUserDefault];
    if (loginArray.count != 0) {
        self.loginID.text = [loginArray objectAtIndex:0];
        if (loginArray.count > 1) {
            self.loginPsw.text = [loginArray objectAtIndex:1];
        }
    }
    [self.loginButon setBackgroundImage:[UIImage imageNamed:@"btn_login"] forState:UIControlStateNormal];
    [self.loginButon setBackgroundImage:[UIImage imageNamed:@"btn_login_click"] forState:UIControlStateHighlighted];
    [self.loginButon setTitle:@"登  录" forState:UIControlStateNormal];
    [self.loginButon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.loginButon setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if (!_isMoved) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        // self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -100);
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y-100);
        [UIView commitAnimations];
        _isMoved = YES;
    }
}

- (void)changeAction1:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
   // self.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y+100);
    _isMoved = NO;
    [UIView commitAnimations];
    
}
#pragma private Method -
//本地同步
- (void)saveNSUserDefault:(NSString *)name passWord:(NSString *)psw
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:name forKey:@"loginName"];
    [user setObject:psw forKey:@"loginPsw"];
    //同步
    [user synchronize];
}

//本地存取
- (NSArray *)readNSUserDefault
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *loginName = [user objectForKey:@"loginName"];
    NSString *loginPsw = [user objectForKey:@"loginPsw"];
    NSArray *array = [NSArray arrayWithObjects:loginName,loginPsw, nil];
    return array;
}

#pragma mark - click Action
- (NSString *)getLvl:(NSString *)sender
{
    if (sender.length > 3 && sender.length < 6) {
        return @"3";
    }else if (sender.length == 6){
        return @"4";
    }else if (sender.length > 6 && sender.length < 10){
        return @"5";
    }else{
        return @"2";
    }
}

//  click loginButton action
- (IBAction)loginAction:(id)sender
{
    //将账号和密码保存在本地
    [self saveNSUserDefault:self.loginID.text passWord:self.loginPsw.text];
    
    if (self.loginID.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"区号不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
        return;
    }
    
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
     ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"getTypeNum" forKey:@"t"];
    [request setPostValue:self.loginID.text forKey:@"type"];
    [request setPostValue:self.loginPsw.text forKey:@"psd"];
    [request setPostValue:@"iPhone" forKey:@"system"];
    [request setPostValue:[self getLvl:self.loginID.text] forKey:@"lvl"];
    [request setDelegate:self];
 
    [SVProgressHUD showWithStatus:@"登陆中..."];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //发送一个同步请求
        [request startSynchronous];
    });
}

#pragma mark - ASIHTTPRequestDelegate method
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithSuccess:@"登陆成功"];
    ReserviorModal *reserviorModal = [ReserviorModal sharedReserviorModal];
    reserviorModal.reserviorArray = [NSMutableArray array];
    if (request.responseStatusCode == 200) {
        //保存登陆成功的用户名和密码
        UserModal *userModal = [UserModal sharedUserModal];
        userModal.loginName = self.loginID.text;
        userModal.loginPassWord = self.loginPsw.text;
        
        NSString *responseString = [request responseString];
        NSString *jsonString = [responseString substringFromIndex:1];
        NSString *jsonString1 = [jsonString substringToIndex:[jsonString length]-1];
        NSString *string = [jsonString1 stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
        //Json数据的解析
        NSArray *array = (NSArray *)[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
       for (int i = 0; i<array.count; i++) {
            Reservior *reservior = [[Reservior alloc] init];
            NSDictionary *reserviorDic = (NSDictionary *)[array objectAtIndex:i];
            reservior.typeName = [reserviorDic objectForKey:@"TYPENAME"];
            reservior.adcdName = [reserviorDic objectForKey:@"ADCDNAME"];
            reservior.objectType = [[reserviorDic objectForKey:@"OBJTYPE"] intValue];
            reservior.uncheckNum = [[reserviorDic objectForKey:@"unchecknum"] intValue];
            [reserviorModal.reserviorArray addObject:reservior];
        }
            ReserviorViewController *reserviorCtrl = [[ReserviorViewController alloc] init];
            [self.navigationController pushViewController:reserviorCtrl animated:YES];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"错误信息：%@",error.localizedDescription);
    [SVProgressHUD dismissWithError:error.localizedDescription];
}

- (IBAction)tapBackgroundAction:(id)sender
{
    if (_isMoved) {
        [self changeAction1:nil];
    }
    
    [self.loginID resignFirstResponder];
    [self.loginPsw resignFirstResponder];
}
@end
