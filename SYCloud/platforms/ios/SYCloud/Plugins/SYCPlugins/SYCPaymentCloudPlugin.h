//
//  SYCPaymentCloudPlugin.h
//  SYCloud
//
//  Created by 文清 on 2017/4/10.
//
//

#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

@interface SYCPaymentCloudPlugin : CDVPlugin
-(void)paymentCode:(CDVInvokedUrlCommand *)command;
-(void)paymentScan:(CDVInvokedUrlCommand *)command;
-(void)paymentImmed:(CDVInvokedUrlCommand *)command;
-(void)paymentPwd:(CDVInvokedUrlCommand *)command;
@end
