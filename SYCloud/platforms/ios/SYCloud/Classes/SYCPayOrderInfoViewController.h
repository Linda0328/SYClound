//
//  SYCPayOrderInfoViewController.h
//  SYCloud
//
//  Created by 文清 on 2017/4/28.
//
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "SYCPayInfoModel.h"
#import "SYCPaymentViewController.h"
#import "MainViewController.h"
@interface SYCPayOrderInfoViewController : UIViewController
@property (nonatomic,strong)SYCPayInfoModel *payInfoModel;
@property (nonatomic,strong)MainViewController *presentingMainVC;
@property (nonatomic,assign)BOOL isPreOrderPay;
@end
