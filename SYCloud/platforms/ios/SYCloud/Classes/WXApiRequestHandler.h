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
+ (BOOL)sendLinkURL:(NSString *)urlString
            TagName:(NSString *)tagName
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(UIImage *)thumbImage
            InScene:(enum WXScene)scene;
+(BOOL)sendImage:(NSString*)image InScene:(enum WXScene)scene;
@end
