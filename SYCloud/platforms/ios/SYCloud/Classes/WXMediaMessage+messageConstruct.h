//
//  WXMediaMessage+messageConstruct.h
//  SYCloud
//
//  Created by 文清 on 2017/8/4.
//
//

#import "WXApiObject.h"

@interface WXMediaMessage (messageConstruct)
+ (WXMediaMessage *)messageWithTitle:(NSString *)title
                         Description:(NSString *)description
                              Object:(id)mediaObject
                          MessageExt:(NSString *)messageExt
                       MessageAction:(NSString *)action
                          ThumbImage:(UIImage *)thumbImage
                            MediaTag:(NSString *)tagName;
@end
