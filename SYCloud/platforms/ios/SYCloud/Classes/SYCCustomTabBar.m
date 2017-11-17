//
//  SYCCustomTabBar.m
//  SYCloud
//
//  Created by 文清 on 2017/11/10.
//

#import "SYCCustomTabBar.h"
#import "HexColor.h"
#define SINGLE_LINE_WIDTH  1/[UIScreen mainScreen].scale
#define SINGLE_LINE_ADJUST_OFFSET (1/[UIScreen mainScreen].scale)/2

@implementation SYCCustomTabBar


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
//     Drawing code
    //中间的按钮宽度是UItabBar的高度，其他按钮的宽度就是，(self.width-self.height)/4.0
    CGFloat buttonW = (self.bounds.size.width-self.bounds.size.height)/4.0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"DDDDDD"].CGColor);
    CGContextSetLineWidth(context, SINGLE_LINE_WIDTH);
    CGContextBeginPath(context);
    CGFloat lineMargin =0;
    
    //1PX线，像素偏移
    CGFloat pixelAdjustOffset = 0;
    if (((int)(1 * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
    }
    CGFloat yPos = lineMargin - pixelAdjustOffset;
    
    //第一段线
    CGContextMoveToPoint(context, 0, yPos);
    CGContextAddLineToPoint(context, buttonW*2+SINGLE_LINE_WIDTH*2, yPos);
    CGContextStrokePath(context);
        
    //第二段线
    CGContextMoveToPoint(context, buttonW*2+self.bounds.size.height-SINGLE_LINE_WIDTH*2, yPos);
    CGContextAddLineToPoint(context, self.bounds.size.width, yPos);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"DDDDDD"].CGColor);
    CGContextStrokePath(context);
}


@end
