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
#import "SYCSystem.h"
@implementation SYCScanPlugin
-(void)getCode:(CDVInvokedUrlCommand *)command{
    MainViewController *mainVC = (MainViewController*)self.viewController;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:scanNotify object:mainVC];
    [self.commandDelegate runInBackground:^{
        [SYCShareVersionInfo sharedVersion].scanPluginID = command.callbackId;
    }];
}

@end
