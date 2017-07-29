//
//  SYCWXPayRequestModel.h
//  SYCloud
//
//  Created by 文清 on 2017/7/29.
//
//

#import <Foundation/Foundation.h>

@interface SYCWXPayRequestModel : NSObject
@property (nonatomic,copy)NSString *requestCharset;
@property (nonatomic,copy)NSString *requestMethod;
@property (nonatomic,strong)NSDictionary *requestParams;
@property (nonatomic,copy)NSString *requestUrl;
@end
