//
//  SYCPresentationController.m
//  SYCloud
//
//  Created by 文清 on 2017/4/21.
//
//

#import "SYCPresentationController.h"
#import "SYCBlurEffectSdapter.h"
@interface SYCPresentationController()
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIVisualEffectView *blurBackgroundView;
@property (nonatomic, strong) SYCBlurEffectSdapter *blurEffectAdapter;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@property (nonatomic, strong) UIViewPropertyAnimator *propertyAnimator;
#endif
@end
@implementation SYCPresentationController

#pragma mark - Getters

- (UIView *)dimmingView {
    if (!_dimmingView) {
        _dimmingView = [[UIView alloc] initWithFrame:self.containerView.frame];
    }
    return _dimmingView;
}
#pragma mark ---blur or backgroudcolor
- (void)setBackgroundColor:(UIColor * __nullable)backgroundColor {
    _backgroundColor = backgroundColor;
    self.dimmingView.backgroundColor = _backgroundColor;
}
-(void)setBackgroundAlpha:(float)backgroundAlpha{
    _backgroundAlpha = backgroundAlpha;
    self.dimmingView.alpha = backgroundAlpha;
}
- (void)setBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle {
    if (_blurEffectStyle != blurEffectStyle) {
        _blurEffectStyle = blurEffectStyle;
        if (self.shouldApplyBackgroundBlurEffect) {
            SYCBlurEffectSdapter *blurEffect = self.blurEffectAdapter;
            if (blurEffectStyle != blurEffect.blurEffectStyle) {
                [self setupBackgroundBlurView];
            }
        }
    }
}

- (void)setupBackgroundBlurView {
    [self.blurBackgroundView removeFromSuperview];
    self.blurBackgroundView = nil;
    
    if (self.shouldApplyBackgroundBlurEffect) {
        
        self.blurEffectAdapter = [SYCBlurEffectSdapter effectWithStyle:self.blurEffectStyle];
        UIVisualEffect *visualEffect = self.blurEffectAdapter.blurEffect;
        self.blurBackgroundView = [[UIVisualEffectView alloc] initWithEffect:visualEffect];
        
        self.blurBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.blurBackgroundView.frame = self.dimmingView.bounds;
        self.blurBackgroundView.translatesAutoresizingMaskIntoConstraints = YES;
        self.blurBackgroundView.userInteractionEnabled = NO;
        
        self.dimmingView.backgroundColor = [UIColor clearColor];
        [self.dimmingView addSubview:self.blurBackgroundView];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        if ([UIViewPropertyAnimator class]) {
            self.propertyAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:1.0 curve:UIViewAnimationCurveLinear animations:^{
                self.blurBackgroundView.effect = nil;
            }];
        }
#endif
    } else {
        self.dimmingView.backgroundColor = self.backgroundColor;
    }
}




#pragma mark - SuperClass Override

- (void)presentationTransitionWillBegin {
    
    [self setupBackgroundBlurView];
    
    self.dimmingView.frame = self.containerView.bounds;
   
    [self.containerView addSubview:self.dimmingView];
    
    // this is some kind of bug :<, if we will delete this line, then inside custom animator
    // we need to set finalFrameForViewController to targetView
    [super presentationTransitionWillBegin];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    [super presentationTransitionDidEnd:completed];
    
    if (!completed) {
        [self.dimmingView removeFromSuperview];
    }
   
}

- (void)dismissalTransitionWillBegin {
    
    [super dismissalTransitionWillBegin];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    
    if (completed) {
        [self.dimmingView removeFromSuperview];
    }
    [super dismissalTransitionDidEnd:completed];
}


- (BOOL)shouldPresentInFullscreen {
    return YES;
}

- (BOOL)shouldRemovePresentersView {
    return NO;
}
-(CGRect)frameOfPresentedViewInContainerView{
    //presentview frame
    self.presentedView.frame = _contentViewRect;
    return self.presentedView.frame;
}
@end
