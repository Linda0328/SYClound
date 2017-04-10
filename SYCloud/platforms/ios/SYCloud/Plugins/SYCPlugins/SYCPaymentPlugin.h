//
//  SYCPaymentPlugin.h
//  SYCloud
//
//  Created by 文清 on 2017/3/17.
//
//

#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

@interface SYCPaymentPlugin : CDVPlugin
-(void)alipay:(CDVInvokedUrlCommand *)command;
-(void)wxpay:(CDVInvokedUrlCommand *)command;

@end
