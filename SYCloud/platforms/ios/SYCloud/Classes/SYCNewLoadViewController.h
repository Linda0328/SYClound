//
//  SYCNewLoadViewController.h
//  SYCloud
//
//  Created by 文清 on 2017/11/8.
//

#import <UIKit/UIKit.h>
#import "SYCContentViewController.h"
@interface SYCNewLoadViewController : UIViewController
@property (nonatomic,assign)BOOL isFromSDK;
@property (nonatomic,copy)NSString *paymentType;
@property (nonatomic,strong)SYCContentViewController *contentVC;
@property (nonatomic,assign)id payCode;
@property (nonatomic,assign)BOOL isLoadAgain;
@property (nonatomic,assign)BOOL forgetGesture;
@end
