//
//  SYCSharePlugin.h
//  SYCloud
//
//  Created by 文清 on 2017/8/2.
//
//

#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

@interface SYCSharePlugin : CDVPlugin
-(void)share:(CDVInvokedUrlCommand *)command;
-(void)image:(CDVInvokedUrlCommand *)command;
@end
