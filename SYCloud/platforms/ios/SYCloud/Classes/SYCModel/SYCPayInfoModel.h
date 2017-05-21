//
//  SYCPayInfoModel.h
//  SYCloud
//
//  Created by 文清 on 2017/4/29.
//
//

#import <Foundation/Foundation.h>
//面对面支付插件传递数据模型
@interface SYCPayInfoModel : NSObject
@property (nonatomic,copy)NSString *merchantID;//商家ID
@property (nonatomic,copy)NSString *amount;//支付金额
@property (nonatomic,copy)NSString *desc;//支付描述
@property (nonatomic,copy)NSString *coupon;//支付优惠券ID
@property (nonatomic,copy)NSString *payAmount;//扣除优惠券金额之后实际支付金额
@end
