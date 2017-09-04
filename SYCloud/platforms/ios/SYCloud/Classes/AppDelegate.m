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
#import "SYCTabViewController.h"
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
#import "QQManager.h"
#import "MiPushSDK.h"
#import "SYCPushMessageViewController.h"
@interface AppDelegate()<MiPushSDKDelegate,UNUserNotificationCenterDelegate>{
    BMKMapManager *_mapManager;
}
@property (nonatomic,strong)Reachability *hostReach;
@property (nonatomic,strong)SYCTabViewController *tabVC ;
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
    //    self.viewController = [[MainViewController alloc] init];
    //    return [super application:application didFinishLaunchingWithOptions:launchOptions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    __weak __typeof(self)weakSelf = self;
    self.hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [self.hostReach startNotifier];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    self.window.autoresizesSubviews = YES;
    //小米推送
    [MiPushSDK registerMiPush:self];
    //注册微信支付
    [WXApi registerApp:WeiXinAppID];
    //手机QQ权限注册
    [[TencentOAuth alloc]initWithAppId:QQAppID andDelegate:[QQManager sharedManager]];
    BOOL canShow = [XZMCoreNewFeatureVC canShowNewFeature];
    [NSURLProtocol registerClass:[SYCCacheURLProtocol class]];
    if(canShow){ // 初始化新特性界面
        self.window.rootViewController = [XZMCoreNewFeatureVC newFeatureVCWithImageNames:[SYCSystem guiderImageS] enterBlock:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.isReachable) {
                [strongSelf setRootViewController];
            }else{
                SYReachableNotViewController *rec = [[SYReachableNotViewController alloc]init];
                rec.refreshB = ^(){
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    if (strongSelf.isReachable) {
                        [strongSelf setRootViewController];
                    }else{
                        MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:strongSelf.window];
                        [self.window addSubview:HUD];
                        HUD.label.text = @"无网络连接，无法加载数据";
                        [HUD showAnimated:YES ];
                        [HUD hideAnimated:YES afterDelay:1.5f];
                    }
                };
                UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:rec];
                strongSelf.window.rootViewController = navC;
            }
        } configuration:^(UIButton *enterButton) { // 配置进入按钮
            [enterButton setTitle:@"立即进入" forState:UIControlStateNormal];
            [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            enterButton.layer.masksToBounds = YES;
            enterButton.layer.cornerRadius = 10;
            enterButton.layer.borderWidth = 1;
            enterButton.layer.borderColor = [UIColor whiteColor].CGColor;
            enterButton.bounds = CGRectMake(0, 0, 100, 40);
            enterButton.center = CGPointMake(KScreenW * 0.8, KScreenH* 0.08);
        }];
    }else{
        if ([SYCSystem connectedToNetwork]) {
            [self setRootViewController];
        }else{
            SYReachableNotViewController *rec = [[SYReachableNotViewController alloc]init];
            rec.refreshB = ^(){
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (strongSelf.isReachable) {
                    [strongSelf setRootViewController];
                }else{
                    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:strongSelf.window];
                    [self.window addSubview:HUD];
                    HUD.label.text = @"无网络连接，无法加载数据";
                    [HUD showAnimated:YES ];
                    [HUD hideAnimated:YES afterDelay:1.5f];
                }
            };
            UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:rec];
            self.window.rootViewController = navC;
        }

    }
    [self.window makeKeyAndVisible];
    //通过推送窗口启动程序
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo){
        [self dealWithPushMessage:userInfo];
    }
    return YES;
}
-(void)setRootViewController{
    NSDictionary *versionResult = [SYCHttpReqTool VersionInfo];
    if (![[versionResult objectForKey:resultCodeKey]isEqualToString:resultCodeSuccess]) {
        [self ShowException];
        return;
    }
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
            [self.window addSubview:HUD];
            HUD.label.text = @"加载数据异常";
            [HUD showAnimated:YES ];
            [HUD hideAnimated:YES afterDelay:1.5f];
        }
    };
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:rec];
    self.window.rootViewController = navC;
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    //上次支付订单未完成，新的支付订单又来了
    UIViewController *vc = _tabVC.firstViewC;
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:SDKIDkey]isEqualToString:finishSDKPay]) {
        while (vc.presentedViewController) {
            [vc dismissViewControllerAnimated:YES completion:nil];
            vc = vc.presentedViewController;
        }
    }
    NSString *comesURl = url.absoluteString;
   
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
        NSString *resultContent = resultDic[@"memo"];
        NSString *resultStatus = resultDic[@"resultStatus"];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:AliPaySuccess forKey:paymentResultCodeKey];
        if (![resultStatus isEqualToString:@"9000"]) {
            [dic setObject:AliPayFail forKey:paymentResultCodeKey];
        }
        [dic setObject:resultContent forKey:@"resultContent"];
        [[NSNotificationCenter defaultCenter]postNotificationName:AliPayResult object:dic];

    }];
   
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
            [[NSNotificationCenter defaultCenter] postNotificationName:PayImmedateNotify object:[SYCShareVersionInfo sharedVersion].paymentSDKID userInfo:@{mainKey:_tabVC.firstViewC.CurrentChildVC,PreOrderPay:payMentTypeSDK}];
        }else{
            SYCLoadViewController *load = [[SYCLoadViewController alloc]init];
            load.mainVC = _tabVC.firstViewC.CurrentChildVC;
            load.isFromSDK = YES;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:load];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
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
    UIViewController *vc = _tabVC.firstViewC;
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:SDKIDkey]isEqualToString:finishSDKPay]) {
        while (vc.presentedViewController) {
            [vc dismissViewControllerAnimated:YES completion:nil];
            vc = vc.presentedViewController;
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
            [[NSNotificationCenter defaultCenter] postNotificationName:PayImmedateNotify object:[SYCShareVersionInfo sharedVersion].paymentSDKID userInfo:@{mainKey:_tabVC.firstViewC.CurrentChildVC,PreOrderPay:payMentTypeSDK}];
        }else{
            SYCLoadViewController *load = [[SYCLoadViewController alloc]init];
            load.mainVC = _tabVC.firstViewC.CurrentChildVC;
            load.isFromSDK = YES;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:load];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
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
    //注册APNS失败
}
//应用在前台
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"新消息" message:[[userInfo objectForKey:@"aps"]objectForKey:@"alert"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"忽视" style:UIAlertActionStyleCancel handler:nil
                                     ];
            [alertC addAction:action];
            UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dealWithPushMessage:userInfo];
            }];
            [alertC addAction:action0];
            [self.window.rootViewController presentViewController:alertC animated:YES completion:nil];
       });
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self dealWithPushMessage:userInfo];
        });
    }
    
}
// iOS10新加入的回调方法
// 应用在前台收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"新消息" message:[[userInfo objectForKey:@"aps"]objectForKey:@"alert"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"忽视" style:UIAlertActionStyleCancel handler:nil
                                     ];
            [alertC addAction:action];
            UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dealWithPushMessage:userInfo];
            }];
            [alertC addAction:action0];
            [self.window.rootViewController presentViewController:alertC animated:YES completion:nil];
            
        });
       
    }
    
}

// 点击通知进入应用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self dealWithPushMessage:userInfo];
    }
}

#pragma mark --- MiPushSDKDelegate
-(void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data{
     NSLog(@"selector = %@,data = %@", selector,data);
   //请求成功，可在此获取regid
    if ([selector isEqualToString:@"registerApp"]) {
        // 获取regId
        NSLog(@"regid = %@", data[@"regid"]);
        [SYCShareVersionInfo sharedVersion].regId = data[@"regid"];
    }
}

-(void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data{
   //请求失败
}
-(void)dealWithPushMessage:(NSDictionary*)userInfo{
    NSString *title = [userInfo objectForKey:@"push_title"];
    NSString *type = [userInfo objectForKey:@"push_type"];
    NSString *url = [userInfo objectForKey:@"push_url"];
    if ([type isEqualToString:pushMessageTypePage]) {
        SYCPushMessageViewController *viewC =[[SYCPushMessageViewController alloc]init];
        viewC.navTitle = title;
        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-113);
        viewC.view.frame =rect;
        MainViewController *mainViewC = [[MainViewController alloc]init];
        mainViewC.startPage = url;
        mainViewC.view.frame = rect;
        [viewC.view addSubview:mainViewC.view];
        [viewC addChildViewController:mainViewC];
        [mainViewC didMoveToParentViewController:viewC];
        UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:viewC];
        [self.window.rootViewController presentViewController:navC animated:YES completion:nil];
    }
    
}
@end
