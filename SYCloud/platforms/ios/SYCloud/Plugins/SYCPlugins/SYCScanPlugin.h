//
//  SYCScanPlugin.h
//  SYCloud
//
//  Created by 文清 on 2017/3/17.
//
//

#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

@interface SYCScanPlugin : CDVPlugin
-(void)getCode:(CDVInvokedUrlCommand *)command;
@end
