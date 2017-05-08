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
#import "SYCPayOrderInfoViewController.h"
#import "SYCPayInfoModel.h"

@implementation SYCPaymentCloudPlugin
//付款码支付
-(void)paymentCode:(CDVInvokedUrlCommand *)command{
    NSLog(@"----------%@",command.arguments);
    MainViewController *main = (MainViewController*)self.viewController;
    NSString *paycode = [command.arguments firstObject];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:PayImmedateNotify object:paycode userInfo:@{mainKey:main,PreOrderPay:payMentTypeCode}];
    [self.commandDelegate runInBackground:^{
        [SYCShareVersionInfo sharedVersion].paymentCodeID = command.callbackId;
    }];
}
//扫码支付
-(void)paymentScan:(CDVInvokedUrlCommand *)command{
    NSLog(@"----------%@",command.arguments);
    MainViewController *main = (MainViewController*)self.viewController;
    NSString *qrcode = [command.arguments firstObject];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:PayImmedateNotify object:qrcode userInfo:@{mainKey:main,PreOrderPay:payMentTypeScan}];
    [self.commandDelegate runInBackground:^{
        [SYCShareVersionInfo sharedVersion].paymentScanID = command.callbackId;
    }];
}
//面对面支付
-(void)paymentImmed:(CDVInvokedUrlCommand *)command{
//    __weak __typeof(self)weakSelf = self;
    MainViewController *main = (MainViewController*)self.viewController;
    SYCPayInfoModel *payModel = [[SYCPayInfoModel alloc]init];
    payModel.merchantID = [command.arguments firstObject];
    payModel.amount = [command.arguments objectAtIndex:1];
    payModel.desc = [command.arguments objectAtIndex:2];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:PayImmedateNotify object:payModel userInfo:@{mainKey:main,PreOrderPay:payMentTypeImme}];
    [self.commandDelegate runInBackground:^{
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"----------%@",command.arguments);
        
        [SYCShareVersionInfo sharedVersion].paymentImmedatelyID = command.callbackId;
    }];
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
       
        [SYCShareVersionInfo sharedVersion].paymentID = command.callbackId;
    }];
}
@end
