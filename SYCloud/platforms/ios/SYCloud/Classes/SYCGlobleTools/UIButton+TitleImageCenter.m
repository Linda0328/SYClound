//
//  UIButton+TitleImageCenter.m
//  SYCloud
//
//  Created by 文清 on 2017/8/9.
//
//

#import "UIButton+TitleImageCenter.h"

@implementation UIButton (TitleImageCenter)
- (void)verticalImageAndTitle:(CGFloat)spacing
{
    //要保证Button的宽度一定要大于等于图片的宽
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}
@end
