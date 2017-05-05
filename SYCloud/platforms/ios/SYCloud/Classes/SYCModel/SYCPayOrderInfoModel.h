//
//  SYCPayOrderInfoModel.h
//  SYCloud
//
//  Created by 文清 on 2017/4/29.
//
//

#import <Foundation/Foundation.h>

@interface SYCPayOrderInfoModel : NSObject
@property (nonatomic,copy) NSString *memberId;
@property (nonatomic,copy) NSString *orderDesc;
@property (nonatomic,copy) NSString *orderNo;
@property (nonatomic,copy) NSString *partner;
@property (nonatomic,copy) NSString *payAmount;
@property (nonatomic,strong) NSArray *payTypes;
@property (nonatomic,assign)BOOL resetPayPassword;
@end
