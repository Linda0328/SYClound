//
//  SYCPatternLockPlugin.h
//  SYCloud
//
//  Created by 文清 on 2017/8/2.
//
//

#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>
@interface SYCPatternLockPlugin : CDVPlugin
-(void)open:(CDVInvokedUrlCommand *)command;
-(void)close:(CDVInvokedUrlCommand*)command;
@end
