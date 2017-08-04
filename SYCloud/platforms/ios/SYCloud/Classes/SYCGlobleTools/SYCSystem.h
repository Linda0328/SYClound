//
//  SYCSystem.h
//  SYCloud
//
//  Created by 文清 on 2017/3/11.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVViewController.h>
typedef NS_ENUM(NSInteger,getCaptchaType){
    getCaptchaRegister = 0,
    getCaptchaLoad ,
    getCaptchaModifyPassw ,
    getCaptchaModifyPayPassw ,
    getCaptchaModifyPhoneNum ,
};

extern NSString *const loadToken;
extern NSString *const memberInfo ;
extern NSString *const loginName ;

extern NSString *const popNotify;
extern NSString *const scanNotify;

extern NSString *const bundleID;
extern NSString *const WeiXinAppID;
extern NSString *const BDAppKay;
extern NSString * const QQAppID;
extern NSString * const QQAppkey;

extern NSString *const updateNotify;
extern NSString *const hideNotify;
extern NSString *const loadAppNotify;
extern NSString *const passwordNotify;
extern NSString *const groupRefreshNotify;
extern NSString *const groupEventKey;
extern NSString *const groupItemIDKey;

extern NSString *const AliPay;
extern NSString *const AliPayResult;
extern NSString *const WeixiPay;
extern NSString *const WeixiPayResult;
extern NSString *const AliPayScheme;
extern NSString *const AliPaySuccess;
extern NSString *const AliPayFail;

extern NSString *const PayPsw;
extern NSString *const PaypswSet;
extern NSString *const mainKey;
extern NSString *const PreOrderPay;
extern NSString *const PayResultCallback;
//四种支付类型
extern NSString *const payMentTypeCode;//二维码支付
extern NSString *const payMentTypeScan;//扫码
extern NSString *const payMentTypeImme;//面对面支付
extern NSString *const payMentTypeSDK;//生源支付SDK

extern NSString * const paySuccessNotify;
extern NSString * const PayImmedateNotify;
extern NSString * const payAndShowNotify;
extern NSString * const dismissPswNotify;
extern NSString * const selectPaymentNotify;

extern NSString * const payment_SuccessCode;
extern NSString * const payment_SuccessMessage;
extern NSString * const payment_FailCode;
extern NSString * const payment_FailMessage;
extern NSString * const payment_CancelCode;
extern NSString * const payment_CancelMessage;

//生源支付key
extern NSString * const SYCPayKEY;
extern NSString * const SYCPrepayIDkey;
extern NSString * const SYCThirdPartSchemeKey;
extern NSString * const SYCSystemType;

extern NSString *const PageVersionKey;

extern NSString *const paymentResultCodeKey;
extern NSString *const paymentDatakey;

extern NSString *const shareNotify;
@interface SYCSystem : NSObject
+(NSString*)baseURL;
+(NSString*)imagLoadURL;
+(NSString*)secondsForNow;
+(NSString*)sinagureForReq:(NSDictionary*)params;
+(NSString*)md5:(NSString*)input;
+(BOOL)judgeNSString:(NSString*)str;
+(NSURL*)appUrl:(CDVViewController*)CDV;
+(NSString *)loaclResourcePath;
+(NSMutableArray*)guiderImageS;
+(BOOL)connectedToNetwork;
+(NSString*)getNetworkType;

+(CGFloat)PointCoefficient;

+(CGFloat)deviceWidth;
+(CGFloat)deviceHeigth;

//分解url参数
+(NSDictionary *)dealWithURL:(NSString*)url;
@end
