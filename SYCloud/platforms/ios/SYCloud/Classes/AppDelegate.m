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
@interface AppDelegate(){
    BMKMapManager *_mapManager;
}
@property (nonatomic,strong)Reachability *hostReach;

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
    
   
    BOOL canShow = [XZMCoreNewFeatureVC canShowNewFeature];
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
    
    return YES;
}
-(void)setRootViewController{
    [SYCHttpReqTool VersionInfo];
    NSDictionary *dic = nil;
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSString *indexV = [userdef objectForKey:SYCIndexVersion];
    if ([indexV isEqualToString:[SYCShareVersionInfo sharedVersion].indexVersion]) {
//        // 读取本地缓存首页数据
//        NSString *jsonPath = [NSString appendJsonFilePathToDocument:SYCIndexJson];
//        // Json数据
//        NSData *indexData =[NSData dataWithContentsOfFile:jsonPath];
//        dic = [NSJSONSerialization JSONObjectWithData:[indexData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
        dic = [userdef objectForKey:SYCIndexJson];
    }else{
        [userdef setObject:[SYCShareVersionInfo sharedVersion].indexVersion forKey:SYCIndexVersion];
        NSDictionary *result = [SYCHttpReqTool MainData];
        dic = result[resultSuccessKey];
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
    SYCTabViewController *tabVC = [[SYCTabViewController alloc]init];
    [tabVC InitTabBarWithtabbarItems:mainPageModel.bottomBtns navigationBars:mainModel.bottomBarConfig];
    self.window.rootViewController = tabVC;
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

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
         NSLog(@"----result---%@",resultDic);
        NSString *resultContent = resultDic[@"memo"];
        NSString *resultStatus = resultDic[@"resultStatus"];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:AliPaySuccess forKey:@"resultCode"];
        if (![resultStatus isEqualToString:@"9000"]) {
            [dic setObject:AliPayFail forKey:@"resultCode"];
        }
        [dic setObject:resultContent forKey:resultContent];
        [[NSNotificationCenter defaultCenter]postNotificationName:AliPayResult object:dic];

    }];
    

    
    return YES;
}
//ios9之后废弃该方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
    }];
    
    //短信
    
    return YES;
}
@end
