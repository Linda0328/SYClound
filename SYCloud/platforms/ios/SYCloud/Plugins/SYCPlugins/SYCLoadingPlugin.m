//
//  SYCLoadingPlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/3/17.
//
//

#import "SYCLoadingPlugin.h"
#import "MainViewController.h"
@implementation SYCLoadingPlugin
-(void)show:(CDVInvokedUrlCommand *)command{
    NSString *msg = [command.arguments firstObject];
    NSString *time = [command.arguments objectAtIndex:1];
    double time0 = [time doubleValue];
    MainViewController *mainVC = (MainViewController*)self.viewController;
//    if (mainVC.showB) {
//        mainVC.showB(msg,time0);
//    }
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}
-(void)hide:(CDVInvokedUrlCommand *)command{
    MainViewController *mainVC = (MainViewController*)self.viewController;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center postNotificationName:hideNotify object:mainVC];
    
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"hide"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}
-(void)update:(CDVInvokedUrlCommand *)command{
    MainViewController *mainVC = (MainViewController*)self.viewController;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center postNotificationName:updateNotify object:mainVC];
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"update"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
    
}

@end
