//
//  SYCWXPayModel.h
//  SYCloud
//
//  Created by 文清 on 2017/7/29.
//
//

#import <Foundation/Foundation.h>

@interface SYCWXPayModel : NSObject
@property (nonatomic,copy)NSString *orderAmount;
@property (nonatomic,copy)NSString *orderDesc;
@property (nonatomic,copy)NSString *orderSn;
@property (nonatomic,strong)NSDictionary *paymentParameters;
@end
