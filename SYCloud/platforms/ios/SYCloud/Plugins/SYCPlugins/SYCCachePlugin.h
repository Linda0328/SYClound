//
//  SYCCachePlugin.h
//  SYCloud
//
//  Created by 文清 on 2017/3/16.
//
//

#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>
@interface SYCCachePlugin : CDVPlugin
-(void)get:(CDVInvokedUrlCommand*)command;
-(void)set:(CDVInvokedUrlCommand*)command;
@end
