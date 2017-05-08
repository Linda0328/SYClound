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
    BOOL connect = YES;
    NSString *Code = NETWORK_ERROR_CODE;
    NSString *Msg = NETWORK_ERROR_MSG;
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
    NSDictionary *successDic = nil;
    if([SYCSystem connectedToNetwork]){
        NSDictionary *requestDic = [SYCHttpReqTool ajaxResponseUrl:url requestType:type isSignature:NO parmaDic:params];
        if ([requestDic objectForKey:resultRequestError]) {
            connect = NO;
            Code = REQUEST_FAILURE_ERROR_CODE;
            Msg = REQUEST_FAILURE_ERROR_MSG;
        }
        if ([requestDic objectForKey:resultJsonError]) {
            connect = NO;
            Code = OTHER_ERROR_CODE;
            Msg = OTHER_ERROR_MSG;
        }
        if ([requestDic objectForKey:resultSuccess]) {
            successDic = [requestDic objectForKey:resultSuccess];
        }
    }else{
        connect = NO;
    }
    NSDictionary *errDic = @{@"code":Code,
                             @"message":Msg};
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *result = nil;
        if (connect) {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:successDic];
        }else{
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errDic];
        }
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
    
    
    
}
-(void)safeAjax:(CDVInvokedUrlCommand *)command{
    BOOL connect = YES;
    NSString *Code = NETWORK_ERROR_MSG;
    NSString *Msg = NETWORK_ERROR_MSG;
    NSString *url= [command.arguments firstObject];
    NSString *type = [command.arguments objectAtIndex:1];
    NSMutableDictionary *params = [command.arguments objectAtIndex:2];
    if (![SYCSystem judgeNSString:url] || ![SYCSystem judgeNSString:type]) {
        Code = PARSE_ERROR_CODE;
        Msg = PARSE_ERROR_MSG;
    }else if(![type isEqualToString:GETRequest]&&![type isEqualToString:POSTRequest]){
        Code = PARSE_ERROR_CODE;
        Msg = PARSE_ERROR_MSG;
    }
    NSDictionary *successDic = nil;
    if([SYCSystem connectedToNetwork]){
        NSDictionary *requestDic = [SYCHttpReqTool ajaxResponseUrl:url requestType:type isSignature:YES parmaDic:params];
        if ([requestDic objectForKey:resultRequestErrorKey]) {
            connect = NO;
            Code = REQUEST_FAILURE_ERROR_CODE;
            Msg = REQUEST_FAILURE_ERROR_MSG;
        }
        if ([requestDic objectForKey:resultJsonErrorKey]) {
            connect = NO;
            Code = OTHER_ERROR_CODE;
            Msg = OTHER_ERROR_MSG;
        }
        if ([requestDic objectForKey:resultSuccessKey]) {
            successDic = [requestDic objectForKey:resultSuccessKey];
        }
    }else{
        connect = NO;
    }
    NSDictionary *errDic = @{@"code":Code,
                             @"message":Msg};
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *result = nil;
        if (connect) {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:successDic];
        }else{
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errDic];
        }
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];

}
@end
