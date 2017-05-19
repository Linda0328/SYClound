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
extern NSString *const selectIndex;
@interface SYCPaymentViewController : UIViewController
@property (nonatomic,strong)NSMutableArray *EnnalepaymentArr;
@property (nonatomic,strong)NSMutableArray *unEnnalepaymentArr;
@property (nonatomic,strong)NSIndexPath *selectedCellIndex;
@property (nonatomic,copy)NSString *paymentType;
@property (nonatomic,copy)NSString *payAmount;
@property (nonatomic,copy)NSString *payCode;
@property (nonatomic,copy)NSString *qrCode;
@end
