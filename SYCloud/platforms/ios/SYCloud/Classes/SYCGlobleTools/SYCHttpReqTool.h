//
//  SYCHttpReqTool.h
//  SYCloud
//
//  Created by 文清 on 2017/3/13.
//
//

#import <Foundation/Foundation.h>
extern NSString * const SYCIndexJson;
extern NSString * const SYCIndexVersion;
@interface SYCHttpReqTool : NSObject
+(NSDictionary*)VersionInfo;
+(NSDictionary*)MainData;
+(NSMutableDictionary*)commonParam;
+(BOOL)PswSetOrNot;
+(BOOL)PswSet;
+(NSDictionary*)PayPswResponseUrl:(NSString*)url pswParam:(NSString*)pswParam parmaDic:(NSDictionary*)paramDic;
+(NSDictionary*)ajaxResponseUrl:(NSString*)url requestType:(NSString*)type isSignature:(BOOL)ISsignature parmaDic:(NSMutableDictionary*)params;
@end
