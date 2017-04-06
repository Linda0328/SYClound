//
//  SYCResultPlugin.h
//  SYCloud
//
//  Created by 文清 on 2017/4/6.
//
//

#import <Cordova/CDVPlugin.h>

@interface SYCResultPlugin : CDVPlugin
-(void)reload:(CDVInvokedUrlCommand *)command;
-(void)finish:(CDVInvokedUrlCommand *)command;
-(void)exec:(CDVInvokedUrlCommand *)command;
@end
