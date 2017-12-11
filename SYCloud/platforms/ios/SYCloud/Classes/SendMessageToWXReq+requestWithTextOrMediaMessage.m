//
//  SendMessageToWXReq+requestWithTextOrMediaMessage.m
//  SYCloud
//
//  Created by 文清 on 2017/8/4.
//
//

#import "SendMessageToWXReq+requestWithTextOrMediaMessage.h"

@implementation SendMessageToWXReq (requestWithTextOrMediaMessage)
+ (SendMessageToWXReq *)requestWithText:(NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = bText;
    req.scene = scene;
    if (bText)
        req.text = text;
    else
        req.message = message;
    return req;
}

@end