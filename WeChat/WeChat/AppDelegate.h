//
//  AppDelegate.h
//  WeChat
//
//  Created by J on 16/5/30.
//  Copyright © 2016年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure//登录失败
}XMPPResultType;

typedef void(^XMPPResultBlock)(XMPPResultType type);//xmpp请求结果的block

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  用户登录
 */
- (void)xmppUserLogin:(XMPPResultBlock)resutlBlock;

@end

