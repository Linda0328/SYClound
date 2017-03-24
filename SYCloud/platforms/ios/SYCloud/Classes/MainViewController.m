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
@interface MainViewController()<UIAlertViewDelegate>
@property (nonatomic,strong)MBProgressHUD *HUD;

@property (nonatomic,strong)SYCNavTitleModel *titleModel;
@property (nonatomic,strong)NSMutableArray *optionURLArr;
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

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    __weak __typeof(self)weakSelf = self;
    
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf LoadURL:strongSelf.startPage];
        [strongSelf.webView.scrollView.mj_header endRefreshing];
    }];
    gifHeader.stateLabel.text = @"正在刷新...";
    self.webView.scrollView.mj_header = gifHeader;
    
    _HUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_HUD];
    
    self.reloadB = ^(NSString *url){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf LoadURL:url];
    };
    
    self.showB = ^(NSString *msg,double time){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.HUD.label.text = msg;
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
    
    //开始加载
    [center addObserver:self selector:@selector(onloadNotification:) name:CDVPluginResetNotification object:nil];
    //加载完成
    [center addObserver:self selector:@selector(loadedNotification:) name:CDVPageDidLoadNotification object:nil];

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
            rect.size.height = height - 64;
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
    [self.webViewEngine loadRequest:appReq];
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //        NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/"];
        //        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    }
    
}

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
