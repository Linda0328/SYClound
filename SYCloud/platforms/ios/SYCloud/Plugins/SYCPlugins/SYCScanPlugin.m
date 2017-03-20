//
//  SYCScanPlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/3/17.
//
//

#import "SYCScanPlugin.h"
#import "MainViewController.h"
#import "SYCShareVersionInfo.h"
@implementation SYCScanPlugin
-(void)getCode:(CDVInvokedUrlCommand *)command{
    MainViewController *mainVC = (MainViewController*)self.viewController;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center postNotificationName:scanNotify object:mainVC];
    [self.commandDelegate runInBackground:^{
        //        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[SYShareVersionInfo sharedVersion].scanResult];
        //        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
//        [SYCShareVersionInfo sharedVersion].scanPluginID = command.callbackId;
    }];
}

@end
