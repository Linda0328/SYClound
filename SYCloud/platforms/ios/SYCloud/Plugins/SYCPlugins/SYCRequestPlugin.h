//
//  SYCRequestPlugin.h
//  SYCloud
//
//  Created by 文清 on 2017/4/26.
//
//

#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>
extern NSString * const GETRequest;
extern NSString * const POSTRequest;

@interface SYCRequestPlugin : CDVPlugin
-(void)ajax:(CDVInvokedUrlCommand *)command;
-(void)safeAjax:(CDVInvokedUrlCommand *)command;

@end
