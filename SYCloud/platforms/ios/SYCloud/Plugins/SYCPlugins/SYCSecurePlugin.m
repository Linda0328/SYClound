
//
//  SYCSecurePlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/3/17.
//
//

#import "SYCSecurePlugin.h"
#import "SYCSystem.h"
@implementation SYCSecurePlugin
-(void)sign:(CDVInvokedUrlCommand *)command{
    NSDictionary *comeback = [command.arguments firstObject];
    NSString *secureStr = [SYCSystem sinagureForReq:comeback];
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:secureStr];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];

}
@end
