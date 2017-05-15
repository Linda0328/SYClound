//
//  SYCPayTypeModel.h
//  SYCloud
//
//  Created by 文清 on 2017/4/29.
//
//

#import <Foundation/Foundation.h>

@interface SYCPayTypeModel : NSObject
@property (nonatomic,copy) NSString *assetName;
@property (nonatomic,copy) NSString *assetNo;
@property (nonatomic,assign) NSInteger assetType;
@property (nonatomic,assign) BOOL defaultPay;
@property (nonatomic,assign) BOOL isEnabled;
@property (nonatomic,copy) NSString *tips;
@end
