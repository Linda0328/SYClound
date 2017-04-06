//
//  UIImage+SYColorExtension.m
//  iShopping
//
//  Created by 文清 on 16/9/14.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "UIImage+SYColorExtension.h"
#import "HexColor.h"
@implementation UIImage (SYColorExtension)
// 画背景
- (UIImage *)image:(UIImage *)image withColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextFillRect(context, rect);
    
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+ (UIImage*) createImageWithColor: (UIColor*) color rect:(CGRect)rect
{
//    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+ (UIImage *)imageWithRect:(CGRect )rectOrigin withColor:(UIColor *)color
{
    UIImage *image = [[UIImage alloc]init];
    UIGraphicsBeginImageContextWithOptions(rectOrigin.size, NO, 3);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawInRect:rectOrigin];
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextFillRect(context, rectOrigin);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
// 合成图片
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContext(image1.size);
    
    // Draw image2  哪个图片在最下面先画谁，在这里有先后顺序
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

// 画带有边框的圆，在画这个图片的时候用到了，也写出来吧，但是边框设的为零，
- (UIImage *)circleImageName:(NSString *)path borderWith:(double)border colorWith:(UIColor *)color
{
    UIImage *img=[UIImage imageNamed:path];
    UIGraphicsBeginImageContext(img.size );
    
    CGContextRef ctr =UIGraphicsGetCurrentContext();
    
    double radius=img.size.height>img.size.width?(img.size.width/2):(img.size.height/2);
    
    radius/=2;
    
    double centerx=img.size.width/2;
    double centery=img.size.height/2;
    
    [color set];
    //   CGContextSetLineWidth(ctr, border);
    CGContextAddArc(ctr, centerx, centery, radius+border,0, M_PI_2*4,YES);
    CGContextFillPath(ctr);
    
    CGContextAddArc(ctr, centerx, centery, radius,0, M_PI_2*4,YES);
    CGContextClip(ctr);
    
    [img drawInRect:CGRectMake(0,0, img.size.width, img.size.height)];
    
    UIImage *newImg=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImg;
    
}
//图片内容随主题颜色改变，其他背景透明
- (UIImage *)imageContentWithColor:(UIColor *)color {
    if (!color) {
        return nil;
    }
    
    UIImage *newImage = nil;
    
    CGRect imageRect = (CGRect){CGPointZero,self.size};
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -(imageRect.size.height));
    
    CGContextClipToMask(context, imageRect, self.CGImage);//选中选区 获取不透明区域路径
    CGContextSetFillColorWithColor(context, color.CGColor);//设置颜色
    CGContextFillRect(context, imageRect);//绘制
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();//提取图片
    
    UIGraphicsEndImageContext();
    return newImage;
}

//对图片尺寸进行压缩--
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
+(UIImage*)drawLineByImageView:(UIImageView *)imageView{
    UIGraphicsBeginImageContext(imageView.frame.size);//开始画线
    [imageView.image drawInRect:CGRectMake(0, 0, CGRectGetWidth(imageView.frame), CGRectGetHeight(imageView.frame))];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    //虚线长度为5 高度是1
    CGFloat lengths[] = {5,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    //设置颜色
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithHexString:@"ffffff"].CGColor);
    CGContextSetLineDash(line, 0, lengths, 2);//画虚线
    CGContextMoveToPoint(line, 0.0, 2.0);//开始画线
    CGContextAddLineToPoint(line, CGRectGetWidth(imageView.frame), 2.0);
    CGContextStrokePath(line);
    return UIGraphicsGetImageFromCurrentImageContext();

}
@end
