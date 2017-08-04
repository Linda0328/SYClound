//
//  WXApiRequestHandler.m
//  SYCloud
//
//  Created by 文清 on 2017/7/29.
//
//

#import "WXApiRequestHandler.h"
#import "WXMediaMessage+messageConstruct.h"
#import "SendMessageToWXReq+requestWithTextOrMediaMessage.h"
@implementation WXApiRequestHandler
+(BOOL)sendRequestForPay:(NSDictionary*)data{
    PayReq *req = [[PayReq alloc]init];
    req.partnerId = data[@"partnerid"];
    req.prepayId = data[@"prepayid"];
    req.nonceStr = data[@"noncestr"];
    req.timeStamp = [data[@"timestamp"] intValue];
    req.package = data[@"package"];
    req.sign = data[@"sign"];
    return [WXApi sendReq:req];
}
+ (BOOL)sendLinkURL:(NSString *)urlString
            TagName:(NSString *)tagName
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(UIImage *)thumbImage
            InScene:(enum WXScene)scene{
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
                                                   Description:description
                                                        Object:ext
                                                    MessageExt:nil
                                                 MessageAction:nil
                                                    ThumbImage:thumbImage
                                                      MediaTag:tagName];
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    return [WXApi sendReq:req];

}
@end
