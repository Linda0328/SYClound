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
extern NSString * const bundleID;
extern NSString * const BDAppKay;
extern NSString *const updateNotify;
extern NSString *const hideNotify;
extern NSString *const loadAppNotify;
@interface SYCSystem : NSObject
+(NSString*)baseURL;
+(NSString*)imagLoadURL;
+(NSString*)secondsForNow;
//+(NSString*)sinagureForReq;
+(BOOL)judgeNSString:(NSString*)str;
+(NSURL*)appUrl:(CDVViewController*)CDV;
@end
