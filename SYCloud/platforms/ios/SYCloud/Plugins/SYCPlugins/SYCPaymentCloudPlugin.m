//
//  SYCPaymentCloudPlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/4/10.
//
//

#import "SYCPaymentCloudPlugin.h"

#import "MJExtension.h"
#import "SYCSystem.h"
#import "SYCPassWordModel.h"
#import "MainViewController.h"
#import "SYCShareVersionInfo.h"
@implementation SYCPaymentCloudPlugin
//付款码支付
-(void)paymentCode:(CDVInvokedUrlCommand *)command{
   
}
//扫码支付
-(void)paymentScan:(CDVInvokedUrlCommand *)command{
    
}
//面对面支付
-(void)paymentImmed:(CDVInvokedUrlCommand *)command{
   
}
//设置密码
-(void)paymentPwd:(CDVInvokedUrlCommand *)command{
    NSLog(@"----------%@",command.arguments);
    MainViewController *main = (MainViewController*)self.viewController;
    SYCPassWordModel *payModel = [[SYCPassWordModel alloc]init];
    payModel.title = [command.arguments firstObject];
    payModel.url = [command.arguments objectAtIndex:1];
    payModel.psw = [command.arguments objectAtIndex:2];
    payModel.param = [command.arguments objectAtIndex:3];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:passwordNotify object:payModel userInfo:@{mainKey:main}];
    [self.commandDelegate runInBackground:^{
//        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"password"];
//        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        [SYCShareVersionInfo sharedVersion].paymentID = command.callbackId;
    }];
}
@end
