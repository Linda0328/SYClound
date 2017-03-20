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
    NSArray *eventArr = [command.arguments firstObject];
    NSString *key = [eventArr firstObject];
    NSDictionary *val = [eventArr objectAtIndex:1];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [self.commandDelegate runInBackground:^{
        [userDef setObject:val forKey:key];
        [userDef synchronize];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];

}
-(void)get:(CDVInvokedUrlCommand*)command{
    NSArray *eventArr = [command.arguments firstObject];
    NSString *key = [eventArr firstObject];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [self.commandDelegate runInBackground:^{
        NSDictionary *val = [userDef objectForKey:key];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:val];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];

}
@end
