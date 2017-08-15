//
//  SYCPhotoPlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/8/2.
//
//

#import "SYCPhotoPlugin.h"
#import "MainViewController.h"
#import "SYCSystem.h"
@implementation SYCPhotoPlugin
-(void)show:(CDVInvokedUrlCommand *)command{
    MainViewController *main = (MainViewController*)self.viewController;
    NSArray *imgs = [command.arguments firstObject];
    NSNumber *index = [command.arguments objectAtIndex:1];
    [[NSNotificationCenter defaultCenter]postNotificationName:showPhotoNotify object:main userInfo:@{photoArrkey:imgs,defaultPhotoIndexKey:index}];
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"photo"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        
    }];
}
@end
