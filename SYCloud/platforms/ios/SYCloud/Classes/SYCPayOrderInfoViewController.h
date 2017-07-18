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
@property (nonatomic,copy)NSString *qrcode;
@property (nonatomic,copy)NSString *payCode;
@property (nonatomic,copy)NSString *prePayID;
@property (nonatomic,assign)BOOL isPreOrderPay;
@property (nonatomic,copy)NSString *payMentType;
@property (nonatomic,strong)NSDictionary *requestResultDic;
@end
