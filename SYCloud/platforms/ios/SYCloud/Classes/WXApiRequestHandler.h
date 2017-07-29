//
//  WXApiRequestHandler.h
//  SYCloud
//
//  Created by 文清 on 2017/7/29.
//
//

#import <Foundation/Foundation.h>
#import "WXApiObject.h"
#import "WXApi.h"
@interface WXApiRequestHandler : NSObject
+(BOOL)sendRequestForPay:(NSDictionary*)data;
@end
