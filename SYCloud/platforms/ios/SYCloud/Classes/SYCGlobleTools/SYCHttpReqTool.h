//
//  SYCHttpReqTool.h
//  SYCloud
//
//  Created by 文清 on 2017/3/13.
//
//

#import <Foundation/Foundation.h>
#import "SYCPayOrderConfirmModel.h"
extern NSString * const SYCIndexJson;
extern NSString * const SYCIndexVersion;
extern NSString * const resultRequestErrorKey;
extern NSString * const resultJsonErrorKey;
extern NSString * const resultSuccessKey;
extern NSString * const resultCodeKey;
extern NSString * const resultCodeRequestError;
extern NSString * const resultCodeJsonError;
@interface SYCHttpReqTool : NSObject
+(NSDictionary*)VersionInfo;
+(NSDictionary*)MainData;
+(NSMutableDictionary*)commonParam;
+(BOOL)PswSetOrNot;
+(BOOL)PswSet;
+(NSDictionary*)PayPswResponseUrl:(NSString*)url pswParam:(NSString*)pswParam parmaDic:(NSDictionary*)paramDic;
+(NSDictionary*)ajaxResponseUrl:(NSString*)url requestType:(NSString*)type isSignature:(BOOL)ISsignature parmaDic:(NSMutableDictionary*)params;
//面对面支付请求用户支付方式
+(NSDictionary*)payImmediatelyInfoWithpayAmount:(NSString*)amount;
+(NSDictionary*)payScanInfoWithQrcode:(NSString*)qrcode;
+(NSDictionary*)payScanInfoWithPaycode:(NSString*)payCode;
+(NSDictionary*)payImmediatelyConfirm:(SYCPayOrderConfirmModel*)payConfirm prePayOrder:(BOOL)isPreOrder;
+(NSDictionary*)getCaptchaforblindYKTwithCardNo:(NSString*)cardNo;
+(NSDictionary*)blindYKTwithCardNo:(NSString*)cardNo captcha:(NSString*)captcha;
@end
