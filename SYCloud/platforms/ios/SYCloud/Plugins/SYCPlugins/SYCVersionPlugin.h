//
//  SYCVersionPlugin.h
//  SYCloud
//
//  Created by 文清 on 2017/3/17.
//
//

#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

@interface SYCVersionPlugin : CDVPlugin
-(void)getInfo:(CDVInvokedUrlCommand*)command;
-(void)setToken:(CDVInvokedUrlCommand*)command;
-(void)setNeedPush:(CDVInvokedUrlCommand*)command;
@end
