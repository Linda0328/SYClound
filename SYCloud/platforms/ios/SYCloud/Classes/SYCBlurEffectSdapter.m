//
//  SYCBlurEffectSdapter.m
//  SYCloud
//
//  Created by 文清 on 2017/4/21.
//
//

#import "SYCBlurEffectSdapter.h"
#import <objc/runtime.h>

@interface SYCBlurEffectSdapter ()
@property (nonatomic, strong) UIBlurEffect *blurEffect;
@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle;
@end
@implementation SYCBlurEffectSdapter
+ (instancetype)effectWithStyle:(UIBlurEffectStyle)style {
    SYCBlurEffectSdapter *result = [[[self class] alloc] init];
    result.blurEffect = [UIBlurEffect effectWithStyle:style];
    result.blurEffectStyle = style;
    return result;
}
@end
