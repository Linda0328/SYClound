/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  SYCloud
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "SYCHttpReqTool.h"
#import "SYCMainModel.h"
#import "MJExtension.h"
#import "SYCEventModel.h"
#import "SYCNavTitleModel.h"
#import "SYCTabBarItemModel.h"
#import "SYCNavigationBarModel.h"
#import "SYCMainPageModel.h"
#import "SYCShareVersionInfo.h"
#import "NSString+Helper.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "XZMCoreNewFeatureVC.h"
#import "SYCSystem.h"
#import "SYReachableNotViewController.h"
#import "MBProgressHUD.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import "SYCUUID.h"
#import <AlipaySDK/AlipaySDK.h>
#import "SYCLoadViewController.h"
#import "SYCCacheURLProtocol.h"
#import "SYCCache.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "MiPushSDK.h"
#import "SYCPushMessageViewController.h"
#import "SYCNewLoadViewController.h"
#import "SYCNewGuiderViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "QQManager.h"
#import "SYCUnlockViewController.h"
@interface AppDelegate()<MiPushSDKDelegate,UNUserNotificationCenterDelegate>{
    BMKMapManager *_mapManager;
}
@property (nonatomic,strong)Reachability *hostReach;
@property (nonatomic,strong)NSDictionary *userInfo;
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    //使用百度地图必须先启动BaiduManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BDAppKay generalDelegate:nil];
    if (!ret) {
        NSLog(@"BaiduMap manager start failed");
    }
    [[UINavigationBar appearance] setTranslucent:NO];
    [UITabBar appearance].translucent = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [self.hostReach startNotifier];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    self.window.autoresizesSubviews = YES;
    //注册微信支付
    [WXApi registerApp:WeiXinAppID];
    //拦截http请求
    [NSURLProtocol registerClass:[SYCCacheURLProtocol class]];
    //手机QQ权限注册
    [[TencentOAuth alloc]initWithAppId:QQAppID andDelegate:[QQManager sharedManager]];
    //小米推送
    [MiPushSDK registerMiPush:self type:0 connect:YES];
    
//    CTCellularData *cellularData = [[CTCellularData alloc]init];
//    CTCellularDataRestrictedState state =  cellularData.restrictedState;
//    if (state == 0) {
//        //是否有权限 0 关闭 1 仅wifi 2 流量+wifi
//        NSString *message = [NSString stringWithFormat:@"您未打开生源闪购的网络访问权限，无法正常使用app，请前往设置"];
//        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            if ([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >=8) {
//                NSString *urlStr = [NSString stringWithFormat:@"prefs:root=%@",bundleID];
//                NSURL *url =[NSURL URLWithString:urlStr];
//                if( [[UIApplication sharedApplication]canOpenURL:url] ) {
//                    [[UIApplication sharedApplication]openURL:url];
//                }
//            }
//            if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max) {
//                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                if( [[UIApplication sharedApplication]canOpenURL:url] ) {
//                    [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL        success) {
//                    }];
//                }
//            }
//        }];
//        [alertC addAction:confirmAction];
//        [self.window.rootViewController presentViewController:alertC animated:YES completion:nil];
//    }
    if([[UIDevice currentDevice].systemVersion doubleValue]>= 10.0){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if (granted) {
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@",settings);
                }];
            }
        }];
        [MiPushSDK registerMiPush:self type:0 connect:YES];
        center.delegate = self;
    }else{
        [MiPushSDK registerMiPush:self type:0 connect:YES];
    }
    //进入app初始化5次输入手势密码
    [SYCSystem setGestureCount:5];
    BOOL canShow = [SYCNewGuiderViewController canShowNewGuider];
    if(canShow){ // 初始化新特性界面
        SYCNewGuiderViewController *newGuider = [[SYCNewGuiderViewController alloc]init];
        self.window.rootViewController = newGuider;
    }else{
       [self setRootViewController];
    }
    [self.window makeKeyAndVisible];
    BOOL show = YES;
    if ([SYCSystem judgeNSString:[SYCSystem getGesturePassword]]&&_isLogin) {
        show = NO;
    }
    
    //通过推送窗口启动程序
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo){
        self.userInfo = userInfo;
        [self dealWithPushMessage:userInfo show:show];
    }
    return YES;
}
-(void)applicationDidBecomeActive:(UIApplication *)application{
    if (_isLogin&&[SYCSystem judgeNSString:[SYCSystem getGesturePassword]]) {
        CGFloat intetval = [[NSUserDefaults standardUserDefaults]floatForKey:@"nowInterval"];
        NSDate *date = [NSDate date];
        NSTimeInterval time = [date timeIntervalSince1970]*1000;
        if (time-intetval>30*1000) {
            SYCUnlockViewController *unlockVC = [[SYCUnlockViewController alloc]init];
            unlockVC.matchB = ^{
                if (!self.window.rootViewController){
                    [self setTabController];
                }
                if (self.userInfo) {
                    [self dealWithPushMessage:self.userInfo show:YES];
                    self.userInfo = nil;
                }
            };
            if (self.window.rootViewController&&![self.window.rootViewController isKindOfClass:[SYCUnlockViewController class]]) {
                [self.window.rootViewController presentViewController:unlockVC animated:YES completion:nil];
            }
            if (!self.window.rootViewController) {
                self.window.rootViewController = unlockVC;
            }
            
        }
    }
    
}
-(void)applicationDidEnterBackground:(UIApplication *)application{
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970]*1000;
//    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    [[NSUserDefaults standardUserDefaults]setFloat:time forKey:@"nowInterval"];
}
-(void)setRootViewController{
    if (![SYCSystem connectedToNetwork]) {
        __weak __typeof(self)weakSelf = self;
        SYReachableNotViewController *rec = [[SYReachableNotViewController alloc]init];
        rec.refreshB = ^(){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.isReachable) {
                [strongSelf setRootViewController];
            }else{
                MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:strongSelf.window];
                HUD.label.font = [UIFont systemFontOfSize:14*[SYCSystem PointCoefficient]];
                [self.window addSubview:HUD];
                HUD.label.text = @"无网络连接，无法加载数据";
                [HUD showAnimated:YES ];
                [HUD hideAnimated:YES afterDelay:1.5f];
            }
        };
        UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:rec];
        self.window.rootViewController = navC;
        return;
    }
    NSDictionary *versionResult = [SYCHttpReqTool VersionInfo];
    _isLogin = [[[versionResult objectForKey:@"RequestSucsess"] objectForKey:@"isLogined"] boolValue];
    if (![[versionResult objectForKey:resultCodeKey]isEqualToString:resultCodeSuccess]) {
        [self ShowException];
        return;
    }
    if (!_isLogin) {
        self.window.rootViewController = [[SYCNewLoadViewController alloc]init];
    }else{
        if ([SYCSystem judgeNSString:[SYCSystem getGesturePassword]]) {
            SYCUnlockViewController *unlockVC = [[SYCUnlockViewController alloc]init];
            unlockVC.matchB = ^{
                [self setTabController];
            };
            if (self.window.rootViewController) {
                [self.window.rootViewController presentViewController:unlockVC animated:YES completion:nil];
            }else{
                self.window.rootViewController = unlockVC;
            }
        }else{
            [self setTabController];
        }
    }
}
-(void)setTabController{
    [SYCSystem imagLoadURL];
    //并发队列使用全局并发队列，异步执行任务
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SYCCache *cache = [[SYCCache alloc]init];
        [cache downLoadJSFileWithPageVersion:[SYCShareVersionInfo sharedVersion].pageVersion linkURL:[SYCShareVersionInfo sharedVersion].pagePackage];
    });
    NSDictionary *dic = nil;
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSString *indexV = [userdef objectForKey:SYCIndexVersion];
    if ([SYCSystem judgeNSString:indexV]&&[indexV isEqualToString:[SYCShareVersionInfo sharedVersion].indexVersion]) {
        // 读取本地缓存路径
        NSString *jsonPath = [SYCCache indexJsonPath];
        // Json数据
        NSData *indexData =[NSData dataWithContentsOfFile:jsonPath];
        NSError *error = nil;
        if (indexData) {
            dic = [NSJSONSerialization JSONObjectWithData:indexData options:NSJSONReadingAllowFragments error:&error];
        }
    }
    if (!dic) {
        NSDictionary *result = [SYCHttpReqTool MainData];
        if ([result[resultCodeKey]isEqualToString:resultCodeSuccess]) {
            dic = result[resultSuccessKey];
            NSString *jsonPath = [SYCCache indexJsonPath];
            NSString *dataStr = [dic mj_JSONString];
            NSData *data = [dataStr dataUsingEncoding:NSUnicodeStringEncoding];
            if ([data writeToFile:jsonPath atomically:YES]) {
                [userdef setObject:[SYCShareVersionInfo sharedVersion].indexVersion forKey:SYCIndexVersion];
            }
        }else{
            [self ShowException];
            return;
        }
    }
    [SYCNavTitleModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    [SYCTabBarItemModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    [SYCMainPageModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"leftBtns":@"SYCEventModel",
                 @"rightBtns":@"SYCEventModel",
                 @"bottomBtns":@"SYCTabBarItemModel",};
    }];
    [SYCMainModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"bottomBarConfig":@"SYCNavigationBarModel"};
    }];
    SYCMainModel *mainModel = [SYCMainModel mj_objectWithKeyValues:dic];
    SYCMainPageModel *mainPageModel = [SYCMainPageModel mj_objectWithKeyValues:mainModel.titleBarConfig];
    _tabVC = [[SYCTabViewController alloc]init];
    [_tabVC InitTabBarWithtabbarItems:mainPageModel.bottomBtns navigationBars:mainModel.bottomBarConfig];
    self.window.rootViewController = _tabVC;
    if ([SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].paymentSDKID]) {
         [[NSNotificationCenter defaultCenter] postNotificationName:PayImmedateNotify object:[SYCShareVersionInfo sharedVersion].paymentSDKID userInfo:@{mainKey:_tabVC.firstViewC.CurrentChildVC,PreOrderPay:payMentTypeSDK}];
    }
}
//网络变化
-(void)reachabilityChanged:(NSNotification*)notify{
    
    Reachability *currentReach = [notify object];
    //    NSParameterAssert([currentReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [currentReach currentReachabilityStatus];
    self.isReachable = YES;
    
    if (status == NotReachable) {
        self.isReachable = NO;
        return;
    }
    if (status == ReachableViaWiFi||status == ReachableViaWWAN) {
        self.isReachable = YES;
    }
    
}
-(void)ShowException{
    __weak __typeof(self)weakSelf = self;
    SYReachableNotViewController *rec = [[SYReachableNotViewController alloc]init];
    rec.titleName = @"异常";
    rec.notice = @"出现异常，敬请谅解！";
    rec.refreshB = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.isReachable) {
            [strongSelf setRootViewController];
        }else{
            MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:strongSelf.window];
            HUD.label.font = [UIFont systemFontOfSize:14*[SYCSystem PointCoefficient]];
            [self.window addSubview:HUD];
            HUD.label.text = @"加载数据异常";
            [HUD showAnimated:YES ];
            [HUD hideAnimated:YES afterDelay:1.5f];
        }
    };
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:rec];
    self.window.rootViewController = navC;
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    //上次支付订单未完成，新的支付订单又来了
    UINavigationController *navC = (UINavigationController*)[_tabVC selectedViewController];
    UIViewController *contentVC = [[navC viewControllers] lastObject];
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:SDKIDkey]isEqualToString:finishSDKPay]) {
        while (contentVC.presentedViewController) {
            [contentVC dismissViewControllerAnimated:YES completion:nil];
            contentVC = contentVC.presentedViewController;
        }
    }
    NSString *comesURl = url.absoluteString;
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
        NSString *resultContent = resultDic[@"memo"];
        NSString *resultStatus = resultDic[@"resultStatus"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:AliPaySuccess forKey:@"resultCode"];
        if (![resultStatus isEqualToString:@"9000"]) {
            [dic setObject:AliPayFail forKey:@"resultCode"];
        }
        [dic setObject:resultContent forKey:@"resultContent"];
        [[NSNotificationCenter defaultCenter]postNotificationName:AliPayResult object:dic];
    }];
    
    //短信
    if ([comesURl hasPrefix:SYCPayKEY]) {
        NSDictionary * dic = [SYCSystem dealWithURL:url.absoluteString];
        NSString *prePayID = [dic objectForKey:SYCPrepayIDkey];
        if ([SYCSystem judgeNSString:prePayID]) {
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:prePayID forKey:SDKIDkey];
            [def synchronize];
            [SYCShareVersionInfo sharedVersion].paymentSDKID = prePayID;
            [SYCShareVersionInfo sharedVersion].thirdPartScheme = [dic objectForKey:SYCThirdPartSchemeKey];
        }
        if ([self.window.rootViewController isKindOfClass:[SYCNewLoadViewController class]]) {
           
            SYCNewLoadViewController *newLoad = (SYCNewLoadViewController*)self.window.rootViewController;
            newLoad.paymentType = payMentTypeSDK;
            newLoad.payCode = prePayID;
            newLoad.isFromSDK = YES;
        }else{
            if ([SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].token]&&![[SYCShareVersionInfo sharedVersion].token isEqualToString:@"unauthorized"]) {
                UINavigationController *navC = (UINavigationController*)[_tabVC selectedViewController];
                SYCContentViewController *contentVC = (SYCContentViewController*)[[navC viewControllers] lastObject];
                [[NSNotificationCenter defaultCenter] postNotificationName:PayImmedateNotify object:[SYCShareVersionInfo sharedVersion].paymentSDKID userInfo:@{mainKey:contentVC.CurrentChildVC,PreOrderPay:payMentTypeSDK}];
            }else{
                UINavigationController *navC = (UINavigationController*)[_tabVC selectedViewController];
                SYCContentViewController *contentVC = (SYCContentViewController*)[[navC viewControllers] lastObject];
                if ([self.window.rootViewController isKindOfClass:[SYCTabViewController class]]) {
                    SYCNewLoadViewController *newLoad = [[SYCNewLoadViewController alloc]init];
                    newLoad.contentVC = contentVC ;
                    newLoad.paymentType = payMentTypeSDK;
                    newLoad.payCode = prePayID;
                    newLoad.isFromSDK = YES;
                    [navC presentViewController:newLoad animated:YES completion:nil];
                }
            }
        }
        
    }
    if ([comesURl hasPrefix:WeiXinAppID]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    
    if ([comesURl hasPrefix:[@"tencent" stringByAppendingString:QQAppID]])
    {
        return [QQApiInterface handleOpenURL:url delegate:[QQManager sharedManager]];;
    }
    return YES;
}
//ios9之后废弃该方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //上次支付订单未完成，新的支付订单又来了
    UINavigationController *navC = (UINavigationController*)[_tabVC selectedViewController];
    UIViewController *contentVC = [[navC viewControllers] lastObject];
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:SDKIDkey]isEqualToString:finishSDKPay]) {
        while (contentVC.presentedViewController) {
            [contentVC dismissViewControllerAnimated:YES completion:nil];
            contentVC = contentVC.presentedViewController;
        }
    }
    NSString *comesURl = url.absoluteString;
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSString *resultContent = resultDic[@"memo"];
        NSString *resultStatus = resultDic[@"resultStatus"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:AliPaySuccess forKey:@"resultCode"];
        if (![resultStatus isEqualToString:@"9000"]) {
            [dic setObject:AliPayFail forKey:@"resultCode"];
        }
        [dic setObject:resultContent forKey:@"resultContent"];
        [[NSNotificationCenter defaultCenter]postNotificationName:AliPayResult object:dic];
    }];
    
    //短信
    if ([comesURl hasPrefix:SYCPayKEY]) {
        NSDictionary * dic = [SYCSystem dealWithURL:url.absoluteString];
        NSString *prePayID = [dic objectForKey:SYCPrepayIDkey];
        if ([SYCSystem judgeNSString:prePayID]) {
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:prePayID forKey:SDKIDkey];
            [def synchronize];
            [SYCShareVersionInfo sharedVersion].paymentSDKID = prePayID;
            [SYCShareVersionInfo sharedVersion].thirdPartScheme = [dic objectForKey:SYCThirdPartSchemeKey];
        }
        if ([SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].token]&&![[SYCShareVersionInfo sharedVersion].token isEqualToString:@"unauthorized"]) {
            UINavigationController *navC = (UINavigationController*)[_tabVC selectedViewController];
            SYCContentViewController *contentVC = (SYCContentViewController*)[[navC viewControllers] lastObject];
            [[NSNotificationCenter defaultCenter] postNotificationName:PayImmedateNotify object:[SYCShareVersionInfo sharedVersion].paymentSDKID userInfo:@{mainKey:contentVC.CurrentChildVC,PreOrderPay:payMentTypeSDK}];
        }else{
            UINavigationController *navC = (UINavigationController*)[_tabVC selectedViewController];
            SYCContentViewController *contentVC = (SYCContentViewController*)[[navC viewControllers] lastObject];
            if ([self.window.rootViewController isKindOfClass:[SYCTabViewController class]]) {
                SYCNewLoadViewController *newLoad = [[SYCNewLoadViewController alloc]init];
                newLoad.contentVC = contentVC ;
                newLoad.paymentType = payMentTypeSDK;
                newLoad.payCode = prePayID;
                newLoad.isFromSDK = YES;
                [navC presentViewController:newLoad animated:YES completion:nil];
            }
        }
    }
    if ([comesURl hasPrefix:WeiXinAppID]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }

    if ([comesURl hasPrefix:[@"tencent" stringByAppendingString:QQAppID]])
    {
        return [QQApiInterface handleOpenURL:url delegate:[QQManager sharedManager]];;
    }
    return YES;
}
#pragma mark ---推送

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
    
}
//打开app推送信息数目归零
-(void)applicationWillResignActive:(UIApplication *)application{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    //注册APNS成功，注册deviceToken
    [MiPushSDK bindDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册APNS失败-------error-----%@",[error description]);
}
//应用在前台
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    _userInfo = userInfo;
    BOOL show = YES;
    CGFloat intetval = [[NSUserDefaults standardUserDefaults]floatForKey:@"nowInterval"];
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970]*1000;
    if (time-intetval>30*1000&&[SYCSystem judgeNSString:[SYCSystem getGesturePassword]]&&_isLogin) {
        show = NO;
    }
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"新消息" message:[[userInfo objectForKey:@"aps"]objectForKey:@"alert"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"忽视" style:UIAlertActionStyleCancel handler:nil
                                     ];
            [alertC addAction:action];
            UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dealWithPushMessage:userInfo show:show];
            }];
            [alertC addAction:action0];
            [self.window.rootViewController presentViewController:alertC animated:YES completion:nil];
       });
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self dealWithPushMessage:userInfo show:show];
        });
    }
    
}
// iOS10新加入的回调方法
// 应用在前台收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    _userInfo = userInfo;

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"新消息" message:[[userInfo objectForKey:@"aps"]objectForKey:@"alert"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"忽视" style:UIAlertActionStyleCancel handler:nil
                                     ];
            [alertC addAction:action];
            UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dealWithPushMessage:userInfo show:YES];
            }];
            [alertC addAction:action0];
            [self.window.rootViewController presentViewController:alertC animated:YES completion:nil];
            
        });
       
    }
    
}
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response withCompletionHandler:(nonnull void (^)(void))completionHandler{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    _userInfo = userInfo;
    BOOL show = YES;
    CGFloat intetval = [[NSUserDefaults standardUserDefaults]floatForKey:@"nowInterval"];
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970]*1000;
    if (time-intetval>30*1000&&[SYCSystem judgeNSString:[SYCSystem getGesturePassword]]&&_isLogin) {
        show = NO;
    }
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self dealWithPushMessage:userInfo show:show];
    }
}


#pragma mark --- MiPushSDKDelegate
-(void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data{
     NSLog(@"selector = %@,data = %@", selector,data);
   //请求成功，可在此获取regid
    if ([SYCSystem judgeNSString:data[@"regid"]]) {
        [[NSUserDefaults standardUserDefaults]setObject:data[@"regid"] forKey:SYCRegIDKey];
        [SYCShareVersionInfo sharedVersion].regId = data[@"regid"];
    }
}

-(void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data{
   //请求失败
    NSLog(@"小米推送请求失败------selector = %@,data = %@",selector,data);
}
-(void)dealWithPushMessage:(NSDictionary*)userInfo show:(BOOL)show{
    NSString *title = [userInfo objectForKey:@"push_title"];
    NSString *type = [userInfo objectForKey:@"push_type"];
    NSString *url = [userInfo objectForKey:@"push_url"];
    if ([type isEqualToString:pushMessageTypePage]&&show) {
        SYCPushMessageViewController *viewC =[[SYCPushMessageViewController alloc]init];
        viewC.navTitle = title;
        MainViewController *mainViewC = [[MainViewController alloc]init];
        //处理中文字符
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        mainViewC.startPage = url;
        mainViewC.isPush = YES;
        CGRect rect = [UIScreen mainScreen].bounds;
        rect.size.height -= isIphoneX?88:64;
        mainViewC.view.frame = rect;
        mainViewC.webView.frame = rect;
        [viewC.view addSubview:mainViewC.view];
        [viewC addChildViewController:mainViewC];
        [mainViewC didMoveToParentViewController:viewC];
        UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:viewC];
        [self.window.rootViewController presentViewController:navC animated:YES completion:nil];
    }
}
@end
