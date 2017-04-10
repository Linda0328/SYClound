//
//  SYCPaymentPlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/3/17.
//
//

#import "SYCPaymentPlugin.h"
#import "SYCAliPayModel.h"
#import "MJExtension.h"
#import "SYCShareVersionInfo.h"
#import "MainViewController.h"
#import "SYCSystem.h"
@implementation SYCPaymentPlugin
-(void)alipay:(CDVInvokedUrlCommand *)command{
    NSDictionary *msg = [command.arguments firstObject];
    SYCAliPayModel *aliModel = [SYCAliPayModel mj_objectWithKeyValues:msg];
    [SYCShareVersionInfo sharedVersion].aliPayModel = aliModel;
    MainViewController *mainVC = (MainViewController*)self.viewController;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:AliPay object:mainVC];
    [self.commandDelegate runInBackground:^{
        [SYCShareVersionInfo sharedVersion].aliPayPluginID = command.callbackId;
        
    }];
}
-(void)wxpay:(CDVInvokedUrlCommand *)command{
}

@end
