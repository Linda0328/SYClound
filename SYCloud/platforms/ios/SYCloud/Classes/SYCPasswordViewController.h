//
//  SYCPasswordViewController.h
//  SYCloud
//
//  Created by 文清 on 2017/4/21.
//
//

#import <UIKit/UIKit.h>
#import "SYCPassWordModel.h"
#import "MainViewController.h"
#import "SYCPayOrderConfirmModel.h"
@interface SYCPasswordViewController : UIViewController
@property (nonatomic,strong)SYCPassWordModel *pswModel;
@property (nonatomic,assign)BOOL showAmount;
@property (nonatomic,strong)MainViewController *presentingMainVC;
@property (nonatomic,strong)SYCPayOrderConfirmModel *confirmPayModel;
@property (nonatomic,assign)BOOL isPreOrderPay;
@property (nonatomic,copy)NSString *paymentType;
@property (nonatomic,assign)BOOL needSetPassword;
@end
