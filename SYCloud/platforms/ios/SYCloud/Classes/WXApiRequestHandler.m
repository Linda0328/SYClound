//
//  WXApiRequestHandler.m
//  SYCloud
//
//  Created by 文清 on 2017/7/29.
//
//

#import "WXApiRequestHandler.h"

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
@end
