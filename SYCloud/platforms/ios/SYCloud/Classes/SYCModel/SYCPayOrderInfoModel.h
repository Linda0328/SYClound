//
//  SYCPayOrderInfoModel.h
//  SYCloud
//
//  Created by 文清 on 2017/4/29.
//
//

#import <Foundation/Foundation.h>

@interface SYCPayOrderInfoModel : NSObject
@property (nonatomic,copy) NSString *memberId;//会员编号
@property (nonatomic,copy) NSString *orderDesc;//预订单描述
@property (nonatomic,copy) NSString *orderNo;//预订单编号
@property (nonatomic,copy) NSString *partner;//商户号
@property (nonatomic,copy) NSString *payAmount;//支付金额
@property (nonatomic,strong) NSArray *payTypes;//支付方式
@property (nonatomic,assign)BOOL resetPayPassword;//是否需要设置支付密码
@property (nonatomic,copy) NSString *couponId;//优惠券ID
@property (nonatomic,copy) NSString *counponAmount;//优惠券金额
@end
