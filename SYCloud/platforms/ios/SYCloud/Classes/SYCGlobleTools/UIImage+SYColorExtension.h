//
//  UIImage+SYColorExtension.h
//  iShopping
//
//  Created by 文清 on 16/9/14.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SYColorExtension)

+ (UIImage *)imageWithRect:(CGRect )rectOrigin withColor:(UIColor *)color;
/** 染背景色*/
- (UIImage *)image:(UIImage *)image withColor:(UIColor *)color;
/** 染内容*/
- (UIImage *)imageContentWithColor:(UIColor *)color ;
/** 拼接图片*/
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;
//对图片尺寸进行压缩--
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
//画虚线
+(UIImage*)drawLineByImageView:(UIImageView*)imageView;
@end
