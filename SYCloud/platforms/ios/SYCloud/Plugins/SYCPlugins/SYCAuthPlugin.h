//
//  SYCAuthPlugin.h
//  SYCloud
//
//  Created by 文清 on 2017/12/1.
//

#import <Cordova/CDVPlugin.h>
#import <UIKit/UIKit.h>
@interface SYCAuthPlugin : CDVPlugin
-(void)login:(CDVInvokedUrlCommand *)command;
@end
