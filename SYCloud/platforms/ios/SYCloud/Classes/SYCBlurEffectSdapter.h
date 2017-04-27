//
//  SYCBlurEffectSdapter.h
//  SYCloud
//
//  Created by 文清 on 2017/4/21.
//
//
@import UIKit;
#import <Foundation/Foundation.h>

@interface SYCBlurEffectSdapter : NSObject
@property (nonatomic, readonly) UIBlurEffect *blurEffect;
@property (nonatomic, readonly) UIBlurEffectStyle blurEffectStyle;

+ (instancetype)effectWithStyle:(UIBlurEffectStyle)style;
@end
