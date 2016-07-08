//
//  WCLoginViewController.m
//  WeChat
//
//  Created by J on 16/5/30.
//  Copyright © 2016年 J. All rights reserved.
//

#import "WCLoginViewController.h"
#import "AppDelegate.h"
@interface WCLoginViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingConstraint;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation WCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断当前设备的类型,改变两遍间距
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leadingConstraint.constant = 10;
        self.trailingConstraint.constant = 10;
    }
    
    [self.loginBtn setN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    NSLog(@"hellohellohello");
}
- (IBAction)loginBtnAction:(id)sender {
    
    NSString *userName = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:userName forKey:@"userName"];
    [defaults setObject:password forKey:@"password"];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    [app xmppUserLogin:^(XMPPResultType type) {
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                NSLog(@"登录成功");
                break;
            case XMPPResultTypeLoginFailure:
                NSLog(@"登录失败");
            default:
                break;
        }
    }];
}


@end
