//
//  SYCPaymentSuccessHUD.h
//  SYCloud
//
//  Created by 文清 on 2017/4/27.
//
//

#import <UIKit/UIKit.h>

@interface SYCPaymentSuccessHUD : UIView<CAAnimationDelegate>
-(void)start;

-(void)hide;

+(SYCPaymentSuccessHUD*)showIn:(UIView*)view;

+(SYCPaymentSuccessHUD*)hideIn:(UIView*)view;
@end
