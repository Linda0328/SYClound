//
//  SYCGuidencePlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/12/1.
//

#import "SYCGuidencePlugin.h"
#import "MainViewController.h"
#import "SYCSystem.h"

@implementation SYCGuidencePlugin
-(void)show:(CDVInvokedUrlCommand *)command{
    MainViewController *main = (MainViewController*)self.viewController;
    NSArray *images = [command.arguments firstObject];
    [[NSNotificationCenter defaultCenter]postNotificationName:guidenceNotify object:main userInfo:@{GuidenceImagesKey:images}];
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"guidence"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}
@end
