//
//  SYCLoadingPlugin.h
//  SYCloud
//
//  Created by 文清 on 2017/3/17.
//
//

#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

@interface SYCLoadingPlugin : CDVPlugin
-(void)show:(CDVInvokedUrlCommand *)command;
-(void)hide:(CDVInvokedUrlCommand *)command;
-(void)update:(CDVInvokedUrlCommand *)command;

@end
