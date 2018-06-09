//
//  SYCPatternLockPlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/8/2.
//
//

#import "SYCPatternLockPlugin.h"
#import "MainViewController.h"
#import "SYCSystem.h"
#import "SYCShareVersionInfo.h"
@implementation SYCPatternLockPlugin
-(void)close:(CDVInvokedUrlCommand*)command{
    MainViewController *main = (MainViewController*)self.viewController;
    [[NSNotificationCenter defaultCenter]postNotificationName:closeLockNotify object:main userInfo:nil];
    [self.commandDelegate runInBackground:^{
        [SYCShareVersionInfo sharedVersion].lockPluginID = command.callbackId;
//        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"photo"];
//        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}
-(void)open:(CDVInvokedUrlCommand *)command{
    MainViewController *main = (MainViewController*)self.viewController;
    [[NSNotificationCenter defaultCenter]postNotificationName:openLockNotify object:main userInfo:nil];
    [self.commandDelegate runInBackground:^{
        [SYCShareVersionInfo sharedVersion].lockPluginID = command.callbackId;
//        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"photo"];
//        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}
@end
