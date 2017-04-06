//
//  SYCCachePlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/3/16.
//
//

#import "SYCCachePlugin.h"

@implementation SYCCachePlugin
-(void)set:(CDVInvokedUrlCommand*)command{
    NSString *key = [command.arguments firstObject];
    NSString *val = [command.arguments objectAtIndex:1];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [self.commandDelegate runInBackground:^{
        [userDef setObject:val forKey:key];
        [userDef synchronize];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];

}
-(void)get:(CDVInvokedUrlCommand*)command{
    NSString *key = [command.arguments firstObject];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [self.commandDelegate runInBackground:^{
        NSString *val = [userDef objectForKey:key];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:val];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];

}
@end
