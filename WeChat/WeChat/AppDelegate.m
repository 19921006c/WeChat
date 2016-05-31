//
//  AppDelegate.m
//  WeChat
//
//  Created by J on 16/5/30.
//  Copyright © 2016年 J. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
@interface AppDelegate (){
    XMPPStream *_xmppStream;
    XMPPResultBlock _resultBlock;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    return YES;
}

#pragma mark - 初始化 xmpp stream
- (void)setUpXMPPStream
{
    _xmppStream = [[XMPPStream alloc]init];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    
    //设置登录用户的JID
    XMPPJID *myJID = [XMPPJID jidWithUser:userName domain:@"joe.local" resource:@"iphone"];
    
    _xmppStream.myJID = myJID;
    
    //设置服务器域名
    _xmppStream.hostName = @"joe.local";//不仅可以是域名，还可以是IP地址
    
    //端口
    _xmppStream.hostPort = 5222;//默认就是5222
    
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}
#pragma mark - 连接到服务器
- (void)connectToHost
{
    if (_xmppStream == nil) {
        [self setUpXMPPStream];
    }
    NSError *error = nil;
    
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]){
        NSLog(@"%@",error);
    };
    
    
}

- (void)sendPwdToHost
{
    NSError *error = nil;
    
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    
    [_xmppStream authenticateWithPassword:password error:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }
}

#pragma mark - XMPP stream delegate

#pragma mark - 链接成功与主机
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"与主机连接成功");
    //主机连接成功后
    [self sendPwdToHost];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"与主机断开连接 = %@",error);
}

#pragma mark - 授权成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"授权成功");
    
    [self sendOnLineToHost];
    
    //此方法实在子线程被调用的，所以要在主线程刷新ui
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        self.window.rootViewController = storyboard.instantiateInitialViewController;
        
    });
    
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    //判断block有没有值，回调控制器
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
    NSLog(@"授权失败 = %@",error);
}

#pragma mark - 授权成功后发送在线消息

- (void)sendOnLineToHost
{
    XMPPPresence *presence = [XMPPPresence presence];
    
    NSLog(@"%@",presence);
    
    [_xmppStream sendElement:presence];
    
}

#pragma mark - 注销

- (void)logOut
{
    //1.发送离线消息
    XMPPPresence *offLine = [XMPPPresence presenceWithType:@"unavailable"];
    
    [_xmppStream sendElement:offLine];
    
    //2.与服务器断开连接
    
    [_xmppStream disconnect];
    
    NSLog(@"与主机断开连接");
}

- (void)xmppUserLogin:(XMPPResultBlock)resutlBlock
{
    //先把block存起来
    _resultBlock = resutlBlock;
    
    [self connectToHost];
}
@end
