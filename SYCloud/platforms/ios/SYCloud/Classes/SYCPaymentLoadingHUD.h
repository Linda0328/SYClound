//
//  SYCPaymentLoadingHUD.h
//  SYCloud
//
//  Created by 文清 on 2017/4/27.
//
//

#import <UIKit/UIKit.h>

@interface SYCPaymentLoadingHUD : UIView
-(void)start;

-(void)hide;

+(SYCPaymentLoadingHUD*)showIn:(UIView*)view;

+(SYCPaymentLoadingHUD*)hideIn:(UIView*)view;
@end
