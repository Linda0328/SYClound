//
//  SYCAuthPlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/12/1.
//

#import "SYCAuthPlugin.h"
#import "SYCSystem.h"
#import "MainViewController.h"
#import "SYCShareVersionInfo.h"
#import "AppDelegate.h"
@implementation SYCAuthPlugin
-(void)login:(CDVInvokedUrlCommand *)command{
    MainViewController *main = (MainViewController*)self.viewController;
    [SYCShareVersionInfo sharedVersion].token = nil;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@""forKey:loadToken];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appdelegate.isUploadRegId = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:LoadAgainNotify object:main userInfo:nil];
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"load"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}
@end