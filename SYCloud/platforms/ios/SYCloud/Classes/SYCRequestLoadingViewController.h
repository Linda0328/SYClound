//
//  SYCRequestLoadingViewController.h
//  SYCloud
//
//  Created by 文清 on 2017/5/8.
//
//

#import <UIKit/UIKit.h>
typedef void (^pushPayOrderBlock)();
extern NSString *const requestResultErrorNotify;
extern NSString *const requestResultSuccessNotify;
@interface SYCRequestLoadingViewController : UIViewController
@property (nonatomic,copy)pushPayOrderBlock pushBlock;
@end
