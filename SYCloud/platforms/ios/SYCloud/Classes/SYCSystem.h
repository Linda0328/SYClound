//
//  SYCSystem.h
//  SYCloud
//
//  Created by 文清 on 2017/3/11.
//
//

#import <Foundation/Foundation.h>

extern NSString *const loadToken;

@interface SYCSystem : NSObject
+(NSString*)baseURL;
+(NSString*)secondsForNow;
+(NSString*)sinagureForReq;
@end
