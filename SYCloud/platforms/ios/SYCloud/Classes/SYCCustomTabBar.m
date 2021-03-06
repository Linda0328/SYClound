//
//  SYCCustomTabBar.m
//  SYCloud
//
//  Created by 文清 on 2017/11/10.
//

#import "SYCCustomTabBar.h"
#import "HexColor.h"
#import "SYCArcView.h"
#import "SYCSystem.h"
#define SINGLE_LINE_WIDTH  1/[UIScreen mainScreen].scale
#define SINGLE_LINE_ADJUST_OFFSET (1/[UIScreen mainScreen].scale)/2
@interface SYCCustomTabBar()

@property (nonatomic,strong) SYCArcView *view; //半圆View

@property(assign,nonatomic)int index;//UITabBar子view的索引
@end
@implementation SYCCustomTabBar


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
////     Drawing code
//    //中间的按钮宽度是UItabBar的高度，其他按钮的宽度就是，(self.width-self.height)/4.0
//    CGFloat buttonW = (self.bounds.size.width-self.bounds.size.height)/3.0;
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextSetLineWidth(context, SINGLE_LINE_WIDTH);
//    CGContextBeginPath(context);
//    CGFloat lineMargin =0;
//
//    //1PX线，像素偏移
//    CGFloat pixelAdjustOffset = 0;
//    if (((int)(1 * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
//        pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
//    }
//    CGFloat yPos = lineMargin - pixelAdjustOffset;
//
//    //第一段线
//    CGContextMoveToPoint(context, 0, yPos);
//    CGContextAddLineToPoint(context, buttonW*2+SINGLE_LINE_WIDTH*2, yPos);
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextStrokePath(context);
//
//    //第二段线
//    CGContextMoveToPoint(context, buttonW*2+self.bounds.size.height-SINGLE_LINE_WIDTH*2, yPos);
//    CGContextAddLineToPoint(context, self.bounds.size.width, yPos);
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextStrokePath(context);
//
////    CGFloat width = [UIScreen mainScreen].bounds.size.width;
////    CGRect rect = CGRectMake(0, (width-55*[SYCSystem PointCoefficient]),55*[SYCSystem PointCoefficient], 1);
////    UIGraphicsBeginImageContext(rect.size);
////    CGContextRef context = UIGraphicsGetCurrentContext();
////    CGContextSetFillColorWithColor(context,[UIColor colorWithHexString:@"dddddd"].CGColor);
////    CGContextFillRect(context, rect);
////    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
////    [self setShadowImage:img];
////    [self setBackgroundImage:[[UIImage alloc]init]];
//}
//
////自定义半圆View的懒加载
//-(UIView *)view{
//    if(!_view){
//        CGFloat buttonW = (self.bounds.size.width-self.bounds.size.height)/3.0;
//        SYCArcView *view = [[SYCArcView alloc]initWithFrame:CGRectMake(buttonW*2, -self.bounds.size.height*0.5f, self.bounds.size.height, self.bounds.size.height)];
//        view.backgroundColor=[UIColor whiteColor];
//        view.layer.masksToBounds=YES;
//        view.layer.cornerRadius=self.bounds.size.height*0.5f;
//        _view = view;
//        [self addSubview:_view];
//    }
//    return _view;
//
//}
#pragma mark - Override Methods
- (void)setFrame:(CGRect)frame
{
    //IPhoneX tababr上移 高度83
    if (self.superview &&CGRectGetMaxY(self.superview.bounds) !=CGRectGetMaxY(frame)) {
        frame.origin.y = CGRectGetHeight(self.superview.bounds) -CGRectGetHeight(frame);
        self.barStyle = UIBarStyleDefault;
    }
    [super setFrame:frame];
}

#pragma mark - Initial Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.translucent =false;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
@end
