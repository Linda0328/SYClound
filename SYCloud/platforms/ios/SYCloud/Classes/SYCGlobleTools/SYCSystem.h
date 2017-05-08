//
//  SYCSystem.h
//  SYCloud
//
//  Created by 文清 on 2017/3/11.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVViewController.h>
extern NSString *const loadToken;
extern NSString *const popNotify;
extern NSString *const scanNotify;
extern NSString *const bundleID;
extern NSString *const BDAppKay;
extern NSString *const updateNotify;
extern NSString *const hideNotify;
extern NSString *const loadAppNotify;
extern NSString *const passwordNotify;
extern NSString *const groupRefreshNotify;
extern NSString *const groupEventKey;
extern NSString *const groupItemIDKey;

extern NSString *const AliPay;
extern NSString *const AliPayScheme;
extern NSString *const AliPaySuccess;
extern NSString *const AliPayFail;

extern NSString *const PayPsw;
extern NSString *const PaypswSet;
extern NSString *const mainKey;
extern NSString *const PreOrderPay;
extern NSString *const PayResultCallback;
extern NSString *const payMentTypeCode;
extern NSString *const payMentTypeScan;
extern NSString *const payMentTypeImme;

extern NSString *const paySuccessNotify;
extern NSString *const PayImmedateNotify;
extern NSString *const payAndShowNotify;
extern NSString *const dismissPswNotify;
extern NSString *const selectPaymentNotify;

extern NSString *const payment_SuccessCode;
extern NSString *const payment_SuccessMessage;
extern NSString *const payment_FailCode;
extern NSString *const payment_FailMessage;
extern NSString *const payment_CancelCode;
extern NSString *const payment_CancelMessage;
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
@end
