//
//  SYCRequestPlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/4/26.
//
//

#import "SYCRequestPlugin.h"
#import "SYCHttpReqTool.h"
#import "SYCSystem.h"
static NSString * const NETWORK_ERROR_CODE = @"1000";
static NSString * const REQUEST_FAILURE_ERROR_CODE = @"2000";
static NSString * const PARSE_ERROR_CODE = @"3000";
static NSString * const OTHER_ERROR_CODE = @"9000";
static NSString * const NETWORK_ERROR_MSG = @"网络异常，当前无可用网络";
static NSString * const REQUEST_FAILURE_ERROR_MSG = @"请求服务接口响应异常";
static NSString * const PARSE_ERROR_MSG = @"请求参数解析异常";
static NSString * const OTHER_ERROR_MSG = @"其他错误码";
@implementation SYCRequestPlugin
-(void)ajax:(CDVInvokedUrlCommand *)command{
    __block BOOL connect = NO;
    __block NSString *Code = NETWORK_ERROR_CODE;
    __block NSString *Msg = NETWORK_ERROR_MSG;
    NSString *url= [command.arguments firstObject];
    NSString *type = [command.arguments objectAtIndex:0];
    NSMutableDictionary *params = [command.arguments objectAtIndex:1];
    if (![SYCSystem judgeNSString:url] || ![SYCSystem judgeNSString:type]) {
        Code = PARSE_ERROR_CODE;
        Msg = PARSE_ERROR_MSG;
    }else if(![type isEqualToString:GETRequest]&&![type isEqualToString:POSTRequest]){
        Code = PARSE_ERROR_CODE;
        Msg = PARSE_ERROR_MSG;
    }
    __weak __typeof(self)weakSelf = self;
    __block NSDictionary *successDic = nil;
    if([SYCSystem connectedToNetwork]){
        [SYCHttpReqTool newAjaxResponseUrl:url requestType:type isSignature:NO parmaDic:params completion:^(NSString *resultCode, NSMutableDictionary *result) {
             __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([resultCode isEqualToString:resultRequestErrorKey]) {
                connect = NO;
                Code = REQUEST_FAILURE_ERROR_CODE;
                Msg = REQUEST_FAILURE_ERROR_MSG;
            }
            if ([resultCode isEqualToString:resultJsonErrorKey]) {
                connect = NO;
                Code = OTHER_ERROR_CODE;
                Msg = OTHER_ERROR_MSG;
            }
            if ([resultCode isEqualToString:resultCodeSuccess]) {
                connect = YES;
                successDic = [result objectForKey:resultSuccessKey];
            }
            NSDictionary *errDic = @{@"code":Code,
                                     @"message":Msg};
            [strongSelf.commandDelegate runInBackground:^{
                CDVPluginResult *result = nil;
                if (connect) {
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:successDic];
                }else{
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errDic];
                }
                [strongSelf.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            }];
        }];
        
    }
    
}
-(void)safeAjax:(CDVInvokedUrlCommand *)command{
    __block BOOL connect = NO;
    __block NSString *Code = NETWORK_ERROR_CODE;
    __block NSString *Msg = NETWORK_ERROR_MSG;
    NSString *url= [command.arguments firstObject];
    NSString *type = [command.arguments objectAtIndex:1];
    NSMutableDictionary *params = [command.arguments objectAtIndex:2];
    NSLog(@"safeAjax------%@---",url);
    if (![SYCSystem judgeNSString:url] || ![SYCSystem judgeNSString:type]) {
        Code = PARSE_ERROR_CODE;
        Msg = PARSE_ERROR_MSG;
    }else if(![type isEqualToString:GETRequest]&&![type isEqualToString:POSTRequest]){
        Code = PARSE_ERROR_CODE;
        Msg = PARSE_ERROR_MSG;
    }
    __weak __typeof(self)weakSelf = self;
    __block NSDictionary *successDic = nil;
    if([SYCSystem connectedToNetwork]){
        
        [SYCHttpReqTool newAjaxResponseUrl:url requestType:type isSignature:YES parmaDic:params completion:^(NSString *resultCode, NSMutableDictionary *result) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([resultCode isEqualToString:resultCodeRequestError]) {
                connect = NO;
                Code = REQUEST_FAILURE_ERROR_CODE;
                Msg = REQUEST_FAILURE_ERROR_MSG;
            }
            if ([resultCode isEqualToString:resultCodeJsonError]) {
                connect = NO;
                Code = OTHER_ERROR_CODE;
                Msg = OTHER_ERROR_MSG;
            }
            if ([resultCode isEqualToString:resultCodeSuccess]) {
                connect = YES;
                successDic = [result objectForKey:resultSuccessKey];
            }
            NSDictionary *errDic = @{@"code":Code,
                                     @"message":Msg};
            [strongSelf.commandDelegate runInBackground:^{
                CDVPluginResult *result = nil;
                if (connect) {
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:successDic];
                }else{
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errDic];
                }
                [strongSelf.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            }];

        }];
        
    }
   
}
@end
