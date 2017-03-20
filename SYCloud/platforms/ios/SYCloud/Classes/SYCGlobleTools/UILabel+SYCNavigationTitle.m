//
//  UILabel+SYCNavigationTitle.m
//  SYCloud
//
//  Created by 文清 on 2017/3/20.
//
//

#import "UILabel+SYCNavigationTitle.h"

@implementation UILabel (SYCNavigationTitle)
+(UILabel*)navTitle:(NSString*)title TitleColor:(UIColor*)color titleFont:(UIFont*)font{
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 0)];
    titleLab.text = title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = font;
    titleLab.textColor = color;
    titleLab.numberOfLines = 0;
    [titleLab sizeToFit];
    return titleLab;
}
@end
