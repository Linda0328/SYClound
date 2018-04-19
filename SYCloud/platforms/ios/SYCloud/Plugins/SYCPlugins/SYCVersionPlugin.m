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
    [verDic setObject:SYCVersionCode forKey:versionCode];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *token = [def objectForKey:loadToken];
    [verDic setObject:[SYCSystem judgeNSString:token]?token:@"" forKey:@"token"];
    [verDic setObject:shareVerInfo.lastAppVersion forKey:@"lastAppVersion"];
    [verDic setObject:shareVerInfo.lastAppVersionName forKey:@"lastVersionName"];
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    shareVerInfo.needPush = (settings.types!=UIUserNotificationTypeNone)?YES:NO;
    [verDic setObject:@(shareVerInfo.needUpdate) forKey:@"needUpdate"];
    [verDic setObject:@(shareVerInfo.needPush) forKey:@"needPush"];
    [verDic setObject:shareVerInfo.systemType forKey:@"systemType"];
    [verDic setObject:[SYCSystem judgeNSString:shareVerInfo.regId]?shareVerInfo.regId :@""forKey:@"regId"];
    [verDic setObject:@(shareVerInfo.formal) forKey:@"formal"];
    [verDic setObject:shareVerInfo.localPath forKey:@"localPath"];
    [verDic setObject:@"" forKey:@"imei"];
    return verDic;
}
-(void)setToken:(CDVInvokedUrlCommand*)command{
    NSString *comeback = [command.arguments firstObject];
    if (![SYCSystem judgeNSString:comeback]) {
        return;
    }
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:comeback forKey:loadToken];
    [def synchronize];
    [SYCShareVersionInfo sharedVersion].token = comeback;

    [self.commandDelegate runInBackground:^{
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:comeback];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}
-(void)setNeedPush:(CDVInvokedUrlCommand*)command{
    NSString *comeback = [command.arguments firstObject];
    MainViewController *main = (MainViewController*)self.viewController;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:loadAppNotify object:main];
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:comeback];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

@end
