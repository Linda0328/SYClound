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
extern NSString * const resultCodeSuccess;
@interface SYCHttpReqTool : NSObject
+(NSDictionary*)VersionInfo;
+(NSDictionary*)MainData;
+(NSMutableDictionary*)commonParam;
+(void)PswSetOrNot:(void (^)(NSString *resultCode,BOOL resetPsw))completionHandler;
+(void)PswSet:(NSString*)psw completion:(void (^)(NSString *resultCode,BOOL resetPsw))completionHandler;
+(void)PayPswResponseUrl:(NSString*)url pswParam:(NSString*)pswParam password:(NSString*)password parmaDic:(NSDictionary*)paramDic completion:(void (^)(NSString *resultCode,BOOL success,NSString *msg,NSDictionary *successDic))completionHandler;
+(void)ajaxResponseUrl:(NSString*)url requestType:(NSString*)type isSignature:(BOOL)ISsignature parmaDic:(NSDictionary*)params completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler;
//面对面支付请求用户支付方式
+(void)payImmediatelyInfoWithpayAmount:(NSString*)amount completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler;
+(void)payScanInfoWithQrcode:(NSString*)qrcode completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler;
+(void)payScanInfoWithPaycode:(NSString*)payCode completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler;
+(void)payImmediatelyConfirm:(SYCPayOrderConfirmModel*)payConfirm prePayOrder:(BOOL)isPreOrder completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler;
+(void)getCaptchaforblindYKTwithCardNo:(NSString*)cardNo completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler;
+(void)blindYKTwithCardNo:(NSString*)cardNo captcha:(NSString*)captcha prior:(NSString*)prior completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler;
//获取到支付订单信息
+(void)requestPayPluginInfoWithPrepareID:(NSString*)prepareId completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler;
//获取验证码
+(void)getVerficationCodeWithMobile:(NSString*)phoneNum forUseCode:(NSString*)code fromTerminal:(NSString*)terminal completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler;
//手机密码登录
+(void)loadWithMobile:(NSString*)phoneNum password:(NSString*)password regID:(NSString*)regId fromTerminal:(NSString*)systemType completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler;
//手机验证码登录
+(void)loadWithMobile:(NSString*)phoneNum verficationCode:(NSString*)code regID:(NSString*)regId fromTerminal:(NSString*)systemType completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler;
@end
