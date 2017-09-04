//
//  SendMessageToWXReq+requestWithTextOrMediaMessage.h
//  SYCloud
//
//  Created by 文清 on 2017/8/4.
//
//

#import "WXApiObject.h"

@interface SendMessageToWXReq (requestWithTextOrMediaMessage)
+ (SendMessageToWXReq *)requestWithText:(NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene;
@end
