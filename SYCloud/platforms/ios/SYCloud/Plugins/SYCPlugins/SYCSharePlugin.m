 //
//  SYCSharePlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/8/2.
//
//

#import "SYCSharePlugin.h"
#import "SYCShareModel.h"
#import "MainViewController.h"
#import "SYCShareVersionInfo.h"
#import "SYCSystem.h"
@implementation SYCSharePlugin
-(void)share:(CDVInvokedUrlCommand *)command{
    MainViewController *main = (MainViewController*)self.viewController;
    SYCShareModel *shareM = [[SYCShareModel alloc]init];
    shareM.title = [command.arguments firstObject];
    shareM.describe = [command.arguments objectAtIndex:1];
    shareM.pic = [command.arguments objectAtIndex:2];
    shareM.url = [command.arguments objectAtIndex:3];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:shareNotify object:shareM userInfo:@{mainKey:main}];
    [self.commandDelegate runInBackground:^{
        [SYCShareVersionInfo sharedVersion].sharePluginID = command.callbackId;
    }];
}
-(void)image:(CDVInvokedUrlCommand *)command{
     MainViewController *main = (MainViewController*)self.viewController;
     NSString *pic = [command.arguments firstObject];
     NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
     [center postNotificationName:shareIMGNotify object:pic userInfo:@{mainKey:main}];
     [self.commandDelegate runInBackground:^{
         [SYCShareVersionInfo sharedVersion].sharePluginID = command.callbackId;
     }];
}
@end
