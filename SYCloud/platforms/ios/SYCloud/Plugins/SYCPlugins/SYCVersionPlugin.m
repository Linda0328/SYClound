//
//  SYCVersionPlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/3/17.
//
//

#import "SYCVersionPlugin.h"
#import "MainViewController.h"
#import "SYCShareVersionInfo.h"
#import "SYCSystem.h"
@implementation SYCVersionPlugin
-(void)getInfo:(CDVInvokedUrlCommand*)command{
    
    NSDictionary *verDic = [self getVersionInfo];
    [self.commandDelegate runInBackground:^{
        
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:verDic];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
    
}
-(NSMutableDictionary*)getVersionInfo{
    
    SYCShareVersionInfo *shareVerInfo = [SYCShareVersionInfo sharedVersion];
    
    NSMutableDictionary *verDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:shareVerInfo.pageVersion,@"pageVersion",shareVerInfo.appVersion,@"appVersion",shareVerInfo.appVersionName,@"appVersionName",nil];
    
    [verDic setObject:shareVerInfo.remoteUrl forKey:@"remoteUrl"];
    [verDic setObject:shareVerInfo.imageUrl forKey:@"imageUrl"];
//    [verDic setObject:[SYGlobleConst judgeNSString:shareVerInfo.token]?shareVerInfo.token:@"" forKey:@"token"];
//    [verDic setObject:shareVerInfo.lastAppVersion forKey:@"lastAppVersion"];
//    [verDic setObject:shareVerInfo.lastVersionName forKey:@"lastVersionName"];
    [verDic setObject:@(shareVerInfo.needUpdate) forKey:@"needUpdate"];
    [verDic setObject:@(shareVerInfo.needPush) forKey:@"needPush"];
    [verDic setObject:shareVerInfo.systemType forKey:@"systemType"];
    [verDic setObject:shareVerInfo.regId forKey:@"regId"];
    return verDic;
}
-(void)setToken:(CDVInvokedUrlCommand*)command{
    NSString *comeback = [command.arguments firstObject];
//    if (![SYCSystem judgeNSString:comeback]) {
//        return;
//    }
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:comeback forKey:loadToken];
    [def synchronize];
    [SYCShareVersionInfo sharedVersion].token = comeback;
    MainViewController *main = (MainViewController*)self.viewController;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center postNotificationName:loadAppNotify object:main];
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:comeback];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}
-(void)setNeedPush:(CDVInvokedUrlCommand*)command{
    NSString *comeback = [command.arguments firstObject];
    [self.commandDelegate runInBackground:^{
        [SYCShareVersionInfo sharedVersion].needPush = [comeback boolValue];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:comeback];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

@end
