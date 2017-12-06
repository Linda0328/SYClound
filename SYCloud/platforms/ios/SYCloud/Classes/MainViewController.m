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
//  MainViewController.h
//  SYCloud
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "MainViewController.h"
#import "SYCSystem.h"
#import "SYCShareVersionInfo.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "SYScanViewController.h"
#import "SYCEventButton.h"
#import "SYCNavTitleModel.h"
#import "SYIntroduceWLANView.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <AlipaySDK/AlipaySDK.h>
#import "NSObject+JsonExchange.h"
#import "SYCWXPayModel.h"
#import "MJExtension.h"
#import "WXApiRequestHandler.h"
#import "SYCWXPayRequestModel.h"
#import "WXApiManager.h"
#import "QQManager.h"
#import "SYCHttpReqTool.h"
#import "NSObject+MJKeyValue.h"
@interface MainViewController()<UIAlertViewDelegate,BMKLocationServiceDelegate,WXApiManagerDelegate,QQManagerDelegate>{
    BMKLocationService *_locationService;
}
@property (nonatomic,strong)MBProgressHUD *HUD;
@property (nonatomic,assign)BOOL isAliPay;
@property (nonatomic,assign)BOOL isWexinPay;
@property (nonatomic,strong)SYCNavTitleModel *titleModel;
//@property (nonatomic,strong)NSMutableArray *optionURLArr;
@property(nonatomic,strong)SYIntroduceWLANView *introductV;
@property(nonatomic,assign)NSInteger locationTime;
@end
@implementation MainViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    // View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
    // you can do so here.

    [super viewWillAppear:animated];
    if ([SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].scanResult]) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[SYCShareVersionInfo sharedVersion].scanResult];
        [self.commandDelegate sendPluginResult:result callbackId:[SYCShareVersionInfo sharedVersion].scanPluginID];
        [SYCShareVersionInfo sharedVersion].scanResult = nil;
        [SYCShareVersionInfo sharedVersion].scanPluginID = nil;
    }
    
    
     AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (appdelegate.isLogin&&!appdelegate.isUploadRegId&&[SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].regId]) {
        [SYCHttpReqTool uploadRegId:[SYCShareVersionInfo sharedVersion].regId withToken:[SYCShareVersionInfo sharedVersion].token completion:^(NSString *resultCode, NSMutableDictionary *result) {
            if ([resultCode isEqualToString:resultCodeSuccess]) {
                appdelegate.isUploadRegId = YES;
            }
        }];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    _locationTime = 0;
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    _locationService = [[BMKLocationService alloc]init];
    _locationService.delegate = self;
    //启动locationService
    [_locationService startUserLocationService];
    __weak __typeof(self)weakSelf = self;
    if (_enableReload) {
        MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf LoadURL:strongSelf.startPage];
            [strongSelf.webView.scrollView.mj_header endRefreshing];
        }];
        gifHeader.stateLabel.text = @"正在刷新...";
        self.webView.scrollView.mj_header = gifHeader;
    }
    _HUD = [[MBProgressHUD alloc]initWithView:self.view];
    _HUD.mode = MBProgressHUDModeText;
    _HUD.label.font = [UIFont systemFontOfSize:14*[SYCSystem PointCoefficient]];
    [self.view addSubview:_HUD];
    
    self.reloadB = ^(NSString *url){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf LoadURL:url];
    };
    
    self.showB = ^(NSString *msg,double time){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.HUD.label.text = msg;
        if (time == 0) {
            time = 10.0f;
        }
        [strongSelf.HUD showAnimated:YES];
        [strongSelf.HUD hideAnimated:YES afterDelay:time];
    };
    self.execB = ^(NSString *function,NSDictionary *data){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSError *error = nil;
        NSData *jsdata = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
        NSString *dataS = [[NSString alloc]initWithData:jsdata encoding:NSUTF8StringEncoding];
        dataS = [dataS stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *js = [function stringByAppendingFormat:@"(%@)",dataS];
        //        NSString *js = @"app.page.product.list.updatePulocationCallback()";
        [strongSelf.commandDelegate evalJs:js];
        
    };
    // Do any additional setup after loading the view from its nib.
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(hideProgress:) name:hideNotify object:nil];
    [center addObserver:self selector:@selector(updateApp:) name:updateNotify object:nil];
    [center addObserver:self selector:@selector(ReloadAppState:) name:loadAppNotify object:nil];
    [center addObserver:self selector:@selector(GroupRefresh:) name:groupRefreshNotify object:nil];
    
    [center addObserver:self selector:@selector(paySuccess:) name:paySuccessNotify object:nil];
    [center addObserver:self selector:@selector(paymentImmedatelyReback:) name:payAndShowNotify object:nil];
    [center addObserver:self selector:@selector(AlyPay:) name:AliPay object:nil];
    [center addObserver:self selector:@selector(AlyPayResult:) name:AliPayResult object:nil];
    [center addObserver:self selector:@selector(WeixiPay:) name:WeixiPay object:nil];
    [center addObserver:self selector:@selector(WeixiPayResult:) name: WeixiPayResult object:nil];
   
    //开始加载
    [center addObserver:self selector:@selector(onloadNotification:) name:CDVPluginResetNotification object:nil];
    //加载完成
    [center addObserver:self selector:@selector(loadedNotification:) name:CDVPageDidLoadNotification object:nil];
    [WXApiManager sharedManager].delegate = self;
    [QQManager sharedManager].delegate = self;
}
-(void)viewWillLayoutSubviews{
    if([[[UIDevice currentDevice]systemVersion ] floatValue]>=7)
    {
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGRect rect = [UIScreen mainScreen].bounds;
        
        if (_isRoot) {
            if (_isHiddenNavBar) {
                rect.size.height = height - 49;
            }else{
               rect.size.height = height -113;
            }
        }else{
            if (!_isHiddenNavBar) {
                 rect.size.height = height - 64;
            }
        }
        self.view.frame = rect;
        self.webView.frame = rect;
    }
    
}
-(void)LoadURL:(NSString*)url{
    self.wwwFolderName = @"www";
    if ([SYCSystem judgeNSString:url]) {
        self.startPage = url;
    }
    NSURL *appURL = [SYCSystem appUrl:self];
    NSURLRequest* appReq = [NSURLRequest requestWithURL:appURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    if (self.webViewEngine) {
        [self.webViewEngine loadRequest:appReq];
    }
}
-(void)hideProgress:(NSNotification*)notify{
    MainViewController *main = (MainViewController*)notify.object;
    if (![main isEqual:self]) {
        return;
    }
    if (!_HUD.isHidden) {
        [_HUD hideAnimated:YES];
    }
}
-(void)updateApp:(NSNotification*)notify{
    if (![SYCShareVersionInfo sharedVersion].needUpdate) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"已是最新版本" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"AppsStore有最新版本哦，要去更新吗" delegate:self cancelButtonTitle:@"不去" otherButtonTitles:@"更新", nil];
        [alert show];
    }
}

-(void)ReloadAppState:(NSNotification*)notify{
    
    MainViewController *main = (MainViewController*)notify.object;
    if ([main isEqual:self]) {
        return;
    }
    [self LoadURL:self.startPage];
}
-(void)GroupRefresh:(NSNotification*)notify{
    MainViewController *main = (MainViewController*)notify.object;
    if (![main isEqual:self]) {
        return;
    }
    NSString *event = notify.userInfo[groupEventKey];
    NSString *itemID = notify.userInfo[groupItemIDKey];
    if ([event hasPrefix:@"javascript:"]) {
        NSString *newEvent = [event stringByReplacingOccurrencesOfString:@"javascript:" withString:@""];
        NSString *js = [newEvent stringByAppendingFormat:@"('%@')",itemID];
        [self.commandDelegate evalJs:js];
    }
}
-(void)paySuccess:(NSNotification*)notify{
    NSDictionary *payResult = notify.userInfo;
    MainViewController *main = (MainViewController*)notify.object;
    if (![main isEqual:self]) {
        return;
    }
    NSString *jsonStr = [payResult ex_JSONString];
    NSLog(@"---------payplugin------%@",[SYCShareVersionInfo sharedVersion].paymentID);
    if ([SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].paymentID]) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsonStr];
        [self.commandDelegate sendPluginResult:result callbackId:[SYCShareVersionInfo sharedVersion].paymentID];
        [SYCShareVersionInfo sharedVersion].paymentID = nil;
    }

}
-(void)paymentImmedatelyReback:(NSNotification*)notify{
    NSDictionary *payResult = notify.userInfo;
    MainViewController *main = (MainViewController*)notify.object;
    if (![main isEqual:self]) {
        return;
    }
    NSDictionary *resultDic = payResult[PayResultCallback];
    NSLog(@"--------%@",resultDic);
    NSString *jsonStr = [resultDic ex_JSONString];
    NSString *type = payResult[PreOrderPay];
    if ([SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].paymentImmedatelyID]&&[type isEqualToString:payMentTypeImme]) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsonStr];
        [self.commandDelegate sendPluginResult:result callbackId:[SYCShareVersionInfo sharedVersion].paymentImmedatelyID];
        [SYCShareVersionInfo sharedVersion].paymentImmedatelyID = nil;
    }
    if ([SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].paymentScanID]&&[type isEqualToString:payMentTypeScan]) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsonStr];
        [self.commandDelegate sendPluginResult:result callbackId:[SYCShareVersionInfo sharedVersion].paymentScanID];
        [SYCShareVersionInfo sharedVersion].paymentScanID = nil;
    }
    if ([SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].paymentCodeID]&&[type isEqualToString:payMentTypeCode]) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsonStr];
        [self.commandDelegate sendPluginResult:result callbackId:[SYCShareVersionInfo sharedVersion].paymentCodeID];
        [SYCShareVersionInfo sharedVersion].paymentCodeID = nil;
    }
    if ([SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].paymentSDKID]&&[type isEqualToString:payMentTypeSDK]) {
        UIApplication *app = [UIApplication sharedApplication];
        NSString *urlS = [[SYCShareVersionInfo sharedVersion].thirdPartScheme stringByAppendingString:@"://back"];
        for (NSString *key in [resultDic allKeys]) {
            if ([key isEqualToString:@"resultContent"]) {
                continue;
            }
            urlS = [urlS stringByAppendingFormat:@"&%@=%@",key,[resultDic objectForKey:key]];
        }
        NSURL *url = [NSURL URLWithString:urlS];
        if([app canOpenURL:url]){
            if ([[UIDevice currentDevice].systemVersion doubleValue]>=10.0) {
                [app openURL:url options:@{} completionHandler:nil];
            }else{
                [app openURL:url];
            }
        }
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:finishSDKPay forKey:SDKIDkey];
        [def synchronize];
        [SYCShareVersionInfo sharedVersion].paymentSDKID = nil;
        [SYCShareVersionInfo sharedVersion].thirdPartScheme = nil;
    }

}
-(void)AlyPay:(NSNotification*)notify{
    MainViewController *main = (MainViewController*)notify.object;
    if (![main isEqual:self]) {
        return;
    }else{
        _isAliPay = YES;
    }
    [[AlipaySDK defaultService] payOrder:[SYCShareVersionInfo sharedVersion].aliPayModel.requestParams fromScheme:AliPayScheme callback:^(NSDictionary *resultDic) {
        [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay:"]];

        NSString *resultContent = resultDic[@"memo"];
        NSString *resultStatus = resultDic[@"resultStatus"];
        if ([resultStatus isEqualToString:@"6001"]&&![SYCSystem judgeNSString:resultContent]) {
            resultContent = @"支付取消！";
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:AliPaySuccess forKey:@"resultCode"];
        if (![resultStatus isEqualToString:@"9000"]) {
            [dic setObject:AliPayFail forKey:@"resultCode"];
        }
        [dic setObject:resultContent forKey:@"resultContent"];
        [dic setObject:[SYCShareVersionInfo sharedVersion].aliPayModel.orderDesc forKey:@"orderDesc"];
        [dic setObject:[SYCShareVersionInfo sharedVersion].aliPayModel.orderSn forKey:@"orderSn"];
        [dic setObject:[SYCShareVersionInfo sharedVersion].aliPayModel.orderAmount forKey:@"orderAmount"];
        NSString *jsonS = [dic ex_JSONString];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsonS];
        [self.commandDelegate sendPluginResult:result callbackId:[SYCShareVersionInfo sharedVersion].aliPayPluginID];
        [SYCShareVersionInfo sharedVersion].aliPayModel = nil;
        [SYCShareVersionInfo sharedVersion].aliPayPluginID = nil;
    }];
}
-(void)AlyPayResult:(NSNotification*)notify{
    if (!_isAliPay) {
        return;
    }
    NSMutableDictionary *dic = (NSMutableDictionary*)notify.object;
    [dic setObject:[SYCShareVersionInfo sharedVersion].aliPayModel.orderDesc forKey:@"orderDesc"];
    [dic setObject:[SYCShareVersionInfo sharedVersion].aliPayModel.orderSn forKey:@"orderSn"];
    [dic setObject:[SYCShareVersionInfo sharedVersion].aliPayModel.orderAmount forKey:@"orderAmount"];
    NSString *jsonS = [dic ex_JSONString];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsonS];
    [self.commandDelegate sendPluginResult:result callbackId:[SYCShareVersionInfo sharedVersion].aliPayPluginID];
    [SYCShareVersionInfo sharedVersion].aliPayModel = nil;
    [SYCShareVersionInfo sharedVersion].aliPayPluginID = nil;
    _isAliPay = NO;
}
-(void)WeixiPay:(NSNotification*)notify{
    MainViewController *main = (MainViewController*)notify.object;
    if (![main isEqual:self]) {
        return;
    }else{
        _isWexinPay = YES;
    }
    if ([WXApi isWXAppInstalled]) {
         SYCWXPayRequestModel *requestM = [SYCWXPayRequestModel mj_objectWithKeyValues:[SYCShareVersionInfo sharedVersion].wxPayModel.paymentParameters];
          if (requestM.requestParams) {
              if(![WXApiRequestHandler sendRequestForPay:requestM.requestParams]){
                  _HUD.label.text = @"请求微信失败";
              }
          }
    }else{
        _HUD.label.text = @"请安装微信";
    }
    [_HUD showAnimated:YES];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5* NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [_HUD hideAnimated:YES];
    });
}
-(void) WeixiPayResult:(NSNotification*)notify{
    if (!_isWexinPay) {
        return;
    }
    NSMutableDictionary *dic = (NSMutableDictionary*)notify.object;
    [dic setObject:[SYCShareVersionInfo sharedVersion].wxPayModel.orderDesc forKey:@"orderDesc"];
    [dic setObject:[SYCShareVersionInfo sharedVersion].wxPayModel.orderSn forKey:@"orderSn"];
    [dic setObject:[SYCShareVersionInfo sharedVersion].wxPayModel.orderAmount forKey:@"orderAmount"];
    NSString *jsonS = [dic ex_JSONString];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsonS];
    [self.commandDelegate sendPluginResult:result callbackId:[SYCShareVersionInfo sharedVersion].wxPayPluginID];
    [SYCShareVersionInfo sharedVersion].wxPayModel = nil;
    [SYCShareVersionInfo sharedVersion].wxPayPluginID = nil;
    _isWexinPay = NO;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //        NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/"];
        //        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    }
    
}
#pragma mark --- 百度地图定位坐标更新
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    CLLocation *location = userLocation.location;
//    CLLocationCoordinate2D coordiante = userLocation.location.coordinate;
    NSLog(@"user location lat = %f,long = %f",location.coordinate.latitude,location.coordinate.latitude);
    NSTimeInterval time = 0.0;
    if (_locationTime > 0){
        time = 60.0;
    }
    
    if (_locationTime%60 == 0) {
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time* NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            NSLog(@"location error :%ld",_locationTime);
            //保留小数点后六位
            NSString *mLatitude = [NSString stringWithFormat:@"%.6f",location.coordinate.latitude];
            NSString *mLongitude = [NSString stringWithFormat:@"%.6f",location.coordinate.longitude];
            [SYCShareVersionInfo sharedVersion].mLatitude = mLatitude;
            [SYCShareVersionInfo sharedVersion].mLongitude = mLongitude;
            CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
            [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                if (placemarks.count>0) {
                    CLPlacemark *placeMark = [placemarks firstObject];
                    NSString *city = placeMark.locality;
                    if (![SYCSystem judgeNSString:city]) {
                        city = @"无法定位当前城市";
                    }
                    [SYCShareVersionInfo sharedVersion].mCity = city;//城市
                    [SYCShareVersionInfo sharedVersion].mDistrict = placeMark.subLocality;//地区
                    [SYCShareVersionInfo sharedVersion].mStreet = placeMark.thoroughfare;//街道
                    [SYCShareVersionInfo sharedVersion].mAddrStr = placeMark.subThoroughfare;//地址信息
                    NSLog(@"user location mCity = %@,mDistrict = %@,mStreet = %@,mAddrStr = %@",city,placeMark.subLocality,placeMark.thoroughfare,placeMark.subThoroughfare);
                    //            [SYCShareVersionInfo sharedVersion].mAddrStr = placeMark.name;
                }else if (!error&&placemarks.count == 0){
                    NSLog(@"No location and error return");
                }else{
                    NSLog(@"location error :%@",error);
                }
                
            }];
            
        });

    }
    _locationTime++;
        //    [_locationService stopUserLocationService];
}
- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response{
    NSString *text = @"分享失败";
    BOOL shareSuccess = NO;
    if (response.errCode == WXSuccess) {
        text = @"分享成功";
        shareSuccess = YES;
    }
    if (response.errCode == WXErrCodeUserCancel){
        text = @"取消分享";
    }
    [SYCShareVersionInfo sharedVersion].shareResult = @{@"shareResult":@(shareSuccess),
                                                        @"shareForm":[SYCShareVersionInfo sharedVersion].sharePlatform
                                                        };
    _HUD.label.text = text;
    [_HUD showAnimated:YES];
    [_HUD hideAnimated:YES afterDelay:1.50f];
    if ([SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].sharePluginID]) {
//        NSString *jsonStr = [[SYCShareVersionInfo sharedVersion].shareResult ex_JSONString];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:[SYCShareVersionInfo sharedVersion].shareResult];
        [self.commandDelegate sendPluginResult:result callbackId:[SYCShareVersionInfo sharedVersion].sharePluginID];
        [SYCShareVersionInfo sharedVersion].shareResult = nil;
        [SYCShareVersionInfo sharedVersion].sharePluginID = nil;
    }
}
-(void)managerDidRecvQQMessageResponse:(SendMessageToQQResp *)response{
    
    NSString *text = @"分享失败";
    BOOL shareSuccess = NO;
    if ([[response result]isEqualToString:@"0"]) {
        text = @"分享成功";
        shareSuccess = YES;
    }
    if([[response result]isEqualToString:@"-4"]) {
        text = @"取消分享";
    }
    [SYCShareVersionInfo sharedVersion].shareResult = @{@"shareResult":@(shareSuccess),
                                                        @"shareForm":[SYCShareVersionInfo sharedVersion].sharePlatform
                                                        };
    _HUD.label.text = text;
    [_HUD showAnimated:YES];
    [_HUD hideAnimated:YES afterDelay:1.50f];
    
    if ([SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].sharePluginID]) {
        //        NSString *jsonStr = [[SYCShareVersionInfo sharedVersion].shareResult ex_JSONString];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:[SYCShareVersionInfo sharedVersion].shareResult];
        [self.commandDelegate sendPluginResult:result callbackId:[SYCShareVersionInfo sharedVersion].sharePluginID];
        [SYCShareVersionInfo sharedVersion].shareResult = nil;
        [SYCShareVersionInfo sharedVersion].sharePluginID = nil;
    }
}

//- (void)didFailToLocateUserWithError:(NSError *)error{
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0* NSEC_PER_SEC));
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        if (error) {
//            NSLog(@"baiduMap located failed for error = %@",[error description]);
//            [SYCShareVersionInfo sharedVersion].locationError = [error description];
//        }
//    });
//}


////网络变化
//-(void)reachabilityChanged:(NSNotification*)notify{
//    
//    AppDelegate *appD = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//    if (!appD.isReachable) {
//        
//        if ([[self.view subviews]containsObject:_introductV]) {
//            _introductV.hidden = NO;
//        }else{
//            _introductV = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SYIntroduceWLANView class]) owner:nil options:nil] firstObject];
//            //            CGRect introRect = CGRectMake(0, CGRectGetMaxY(_navBarBackgroundView.frame), CGRectGetWidth(self.view.frame), 48);
//            CGRect rect = _introductV.frame;
//            rect.origin.y = 64;
//            rect.size.width = CGRectGetWidth(self.view.frame);
//            _introductV.frame = rect;
//            _introductV.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showOpenWLAN:)];
//            [_introductV addGestureRecognizer:tap];
//            [self.view addSubview:_introductV];
//        }
//        
//    }else{
//        _introductV.hidden = YES;
//    }
//    
//}
//-(void)showOpenWLAN:(UITapGestureRecognizer*)tap{
//    
//    if (_unReachableB) {
//        _unReachableB();
//    }    
//}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.hidesBottomBarWhenPushed) {
        self.hidesBottomBarWhenPushed = YES;
    }
}

-(void)onloadNotification:(NSNotification*)notify{
    NSLog(@"-------开始等加载啦-----");
}
-(void)loadedNotification:(NSNotification*)notify{
    NSLog(@"-------加载结束啦-----");
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/* Comment out the block below to over-ride */

/*
- (UIWebView*) newCordovaViewWithFrame:(CGRect)bounds
{
    return[super newCordovaViewWithFrame:bounds];
}

- (NSUInteger)supportedInterfaceOrientations 
{
    return [super supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (BOOL)shouldAutorotate 
{
    return [super shouldAutorotate];
}
*/

@end

@implementation MainCommandDelegate

/* To override the methods, uncomment the line in the init function(s)
   in MainViewController.m
 */

#pragma mark CDVCommandDelegate implementation

- (id)getCommandInstance:(NSString*)className
{
    return [super getCommandInstance:className];
}

- (NSString*)pathForResource:(NSString*)resourcepath
{
    return [super pathForResource:resourcepath];
}

@end

@implementation MainCommandQueue

/* To override, uncomment the line in the init function(s)
   in MainViewController.m
 */
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

@end
