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
@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    //    self.viewController = [[MainViewController alloc] init];
    //    return [super application:application didFinishLaunchingWithOptions:launchOptions];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    self.window.autoresizesSubviews = YES;
    [self setRootViewController];
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
        dic = [SYCHttpReqTool MainData];
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

@end
