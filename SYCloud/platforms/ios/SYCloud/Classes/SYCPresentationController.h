//
//  SYCPresentationController.h
//  SYCloud
//
//  Created by 文清 on 2017/4/21.
//
//

#import <UIKit/UIKit.h>

@interface SYCPresentationController : UIPresentationController
/**
 *  The preferred size for the container’s content. (required)
 */
@property (nonatomic, assign) CGRect contentViewRect;


/*
 Apply background blur effect, this property need to be set before form sheet presentation
 By default, this is NO
 */
@property (nonatomic, assign) BOOL shouldApplyBackgroundBlurEffect;
/*
 The intensity of the blur effect. See UIBlurEffectStyle for valid options.
 By default, this is UIBlurEffectStyleLight
 */
//模糊效果类型
@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle;

/**
 The background color of the background view.
 By default, this is a black at with a 0.5 alpha component
 */
@property (nonatomic, strong, nullable) UIColor *backgroundColor;
/**
 The alpha of the background view.
 By default, this is a black at with a 0.5 alpha component
 */
@property (nonatomic, assign)float backgroundAlpha;
@end
