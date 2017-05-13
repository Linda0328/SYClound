//
//  SYCPresentionAnimatedTransitioning.m
//  SYCloud
//
//  Created by 文清 on 2017/5/13.
//
//

#import "SYCPresentionAnimatedTransitioning.h"
#import "UIView+MJExtension.h"
const CGFloat duration = 1.0;
@implementation SYCPresentionAnimatedTransitioning
#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (self.presented) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        //        toView.layer.transform = CATransform3DMakeRotation(M_PI_2, 1, 1, 0);
        //        toView.y = -toView.height;
        toView.mj_x = 0;
        [UIView animateWithDuration:duration animations:^{
            //            toView.y = 0;
            
            toView.mj_x = toView.mj_w;
            //            toView.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        [UIView animateWithDuration:duration animations:^{
            UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
            //            fromView.y = -fromView.height;
            fromView.mj_x = -fromView.mj_w;
            //            fromView.layer.transform = CATransform3DMakeRotation(M_PI_2, 1, 1, 0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
