//
//  SYCPaymentFailHUD.h
//  SYCloud
//
//  Created by 文清 on 2017/4/27.
//
//

#import <UIKit/UIKit.h>

@interface SYCPaymentFailHUD : UIView<CAAnimationDelegate>
-(void)start;

-(void)hide;

+(SYCPaymentFailHUD*)showIn:(UIView*)view;

+(SYCPaymentFailHUD*)hideIn:(UIView*)view;
@end
