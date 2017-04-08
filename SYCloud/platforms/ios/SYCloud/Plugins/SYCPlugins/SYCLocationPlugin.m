//
//  SYCLoactionPlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/3/17.
//
//

#import "SYCLocationPlugin.h"
#import <CoreLocation/CoreLocation.h>
#import "SYCShareVersionInfo.h"
#import "SYCSystem.h"
#import "NSObject+JsonExchange.h"
@implementation SYCLocationPlugin
-(void)position:(CDVInvokedUrlCommand *)command{
//    NSString *success = [command.arguments firstObject];
//    NSString *fail = [command.arguments objectAtIndex:1];
    NSDictionary *locationDic = @{@"mLatitute":[SYCShareVersionInfo sharedVersion].mLatitude,
                                  @"mLongtitude":[SYCShareVersionInfo sharedVersion].mLongtitude};
    NSString *jsonStr = [locationDic JSONString];
    [self.commandDelegate runInBackground:^{
        if ([SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].locationError]) {
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[SYCShareVersionInfo sharedVersion].locationError];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }else{
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsonStr];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];

        }
        
    }];
}
@end
