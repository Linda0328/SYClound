//
//  SYCPaymentViewController.h
//  SYCloud
//
//  Created by 文清 on 2017/5/2.
//
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,SYCAssetType){
    SYCAssetTypeConsumption = 1,
    SYCAssetTypeFinance,
    SYCAssetTypeYKT,
};
@interface SYCPaymentViewController : UIViewController
@property (nonatomic,strong)NSArray *EnnalepaymentArr;
@property (nonatomic,strong)NSArray *unEnnalepaymentArr;
@end
