//
//  UILabel+SYCFitWidthLable.m
//  SYCloud
//
//  Created by 文清 on 2017/11/16.
//

#import "UILabel+SYCFitWidthLable.h"

@implementation UILabel (SYCFitWidthLable)
+(UILabel*)SingleLineCustomText:(NSString*)text Font:(UIFont*)font Color:(UIColor*)textColor{
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    size.width = size.width>[UIScreen mainScreen].bounds.size.width?[UIScreen mainScreen].bounds.size.width:size.width;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    label.numberOfLines = 0;
    label.textColor = textColor;
    label.text = text;
    return label;
}
@end
