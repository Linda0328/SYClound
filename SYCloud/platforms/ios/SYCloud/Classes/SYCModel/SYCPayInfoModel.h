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
@end
