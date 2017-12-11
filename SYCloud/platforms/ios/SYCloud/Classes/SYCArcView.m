//
//  SYCArcView.m
//  SYCloud
//
//  Created by 文清 on 2017/12/1.
//

#import "SYCArcView.h"
#import "HexColor.h"
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)
@implementation SYCArcView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"efefef"].CGColor);
    
    
    CGContextSetLineWidth(context, SINGLE_LINE_WIDTH);
    CGContextBeginPath(context);
    CGFloat lineMargin =self.bounds.size.width*0.5f;
    
    //1px线，偏移像素点
    CGFloat pixelAdjustOffset = 0;
    if (((int)(1 * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
    }
    
    CGFloat yPos = self.bounds.size.width*0.5f - pixelAdjustOffset;
    
    CGFloat xPos = self.bounds.size.width*0.5f - pixelAdjustOffset;
    
    CGContextAddArc(context, xPos, yPos, self.bounds.size.width*0.5f, M_PI, 0, 0);
    
    CGContextStrokePath(context);
}


@end
