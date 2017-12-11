//
//  SYCResultPlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/4/6.
//
//

#import "SYCResultPlugin.h"
#import "MainViewController.h"
#import "SYCShareVersionInfo.h"
#import "SYCSystem.h"
@implementation SYCResultPlugin
-(void)reload:(CDVInvokedUrlCommand *)command{
    MainViewController *main = (MainViewController*)self.viewController;
    BOOL isfinish = [[command.arguments firstObject] boolValue];
    if (isfinish) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:popNotify object:main];
    }
    if (main.lastViewController.reloadB) {
        main.lastViewController.reloadB(nil);
    }
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"reload"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}
-(void)finish:(CDVInvokedUrlCommand *)command{
    MainViewController *main = (MainViewController*)self.viewController;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:popNotify object:main];
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"finish"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}
-(void)exec:(CDVInvokedUrlCommand *)command{
    NSString *function = [command.arguments firstObject];
    NSDictionary *data = [command.arguments objectAtIndex:1];
    BOOL isfinish = [[command.arguments objectAtIndex:2] boolValue];
    MainViewController *main = (MainViewController*)self.viewController;
    if (isfinish) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:popNotify object:main];
    }
    if(main.lastViewController.execB){
        main.lastViewController.execB(function,data);
    }
    [self.commandDelegate runInBackground:^{
        [SYCShareVersionInfo sharedVersion].listenPluginID = command.callbackId;
    }];
}
-(void)refresh:(CDVInvokedUrlCommand *)command{
    BOOL isfinish = [[command.arguments firstObject] boolValue];
    MainViewController *main = (MainViewController*)self.viewController;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:loadAppNotify object:main];
    if(isfinish){
        [center postNotificationName:popNotify object:main];
    }
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"refresh"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        
    }];
}
@end
