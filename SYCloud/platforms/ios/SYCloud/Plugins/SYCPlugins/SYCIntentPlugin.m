//
//  SYCIntentPlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/3/17.
//
//

#import "SYCIntentPlugin.h"
#import "MainViewController.h"
#import "SYCContentViewController.h"
#import "SYCNavigationBarModel.h"
#import "MJExtension.h"
@implementation SYCIntentPlugin
-(void)open:(CDVInvokedUrlCommand *)command{
    
    NSString *loadUrl = [command.arguments firstObject];
    //重载URL
    MainViewController *mainVC = (MainViewController*)self.viewController;
    
    if (mainVC.reloadB) {
        mainVC.reloadB(loadUrl);
    }
    
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:loadUrl];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}
-(void)start:(CDVInvokedUrlCommand *)command{
    NSString *url = [command.arguments firstObject];
    BOOL isfinish = [[command.arguments objectAtIndex:1] boolValue];
    BOOL reload = [[command.arguments objectAtIndex:2] boolValue];
    NSDictionary *titleBar = [command.arguments objectAtIndex:3];
    
    //    NSDictionary *titleBarDic = [NSJSONSerialization JSONObjectWithData:[titleBar dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    SYCNavigationBarModel *model = [SYCNavigationBarModel mj_objectWithKeyValues:titleBar];
    model.url = url;
    MainViewController *mainVC = (MainViewController*)self.viewController;
   
    if (mainVC.isChild) {
        SYCContentViewController *navVC = (SYCContentViewController *)mainVC.parentViewController;
        if (navVC.pushBlock) {
            navVC.pushBlock(url,!isfinish,reload,model);
        }
    }
    [self.commandDelegate runInBackground:^{
        
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:url];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
    
}

@end
