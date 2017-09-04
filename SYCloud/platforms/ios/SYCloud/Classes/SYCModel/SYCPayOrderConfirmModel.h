//
//  SYCPayOrderConfirmModel.h
//  SYCloud
//
//  Created by 文清 on 2017/5/2.
//
//

#import <Foundation/Foundation.h>

@interface SYCPayOrderConfirmModel : NSObject
//确定订单必须的四个参数
@property (nonatomic,copy)NSString *assetType;//支付的资产类型（已定义好的枚举SYCAssetType）
@property (nonatomic,copy)NSString *assetNo; //支付资产编号，例如一卡通卡号
@property (nonatomic,copy)NSString *payPassword;//支付密码
@property (nonatomic,copy)NSString *token;//用户登录唯一标识
//预定支付（app支付，扫码支付，付款吗支付）需要下列两个参数
@property (nonatomic,copy)NSString *partner;
@property (nonatomic,copy)NSString *prepayId;
//面对面支付需要下列三个参数
@property (nonatomic,copy)NSString *merchantId;//商家编号
@property (nonatomic,copy)NSString *orderSubject;//订单描述
@property (nonatomic,copy)NSString *payAmount;//支付金额
@property (nonatomic,copy)NSString *couponId;//优惠券ID
@property (nonatomic,copy)NSString *exclAmount;
@property (nonatomic,copy)NSString *amount;
@end
