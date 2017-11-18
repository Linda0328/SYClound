//
//  SYCLoadTextField.m
//  SYCloud
//
//  Created by 文清 on 2017/11/16.
//

#import "SYCLoadTextField.h"

@implementation SYCLoadTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
////重设 leftview x
//-(CGRect)leftViewRectForBounds:(CGRect)bounds{
//    CGRect iconRect = [super leftViewRectForBounds:bounds];
//    iconRect.origin.x +=16;
//    return iconRect;
//}
//UItextfield 文字与输入框的距离
-(CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds,16.0 , 0);
}
//控制文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds,16.0, 0);
}
//重写此方法,修改placeholder颜色
-(void)drawPlaceholderInRect:(CGRect)rect{
    CGSize palcaholderSize = [self.placeholder sizeWithAttributes:@{NSFontAttributeName:self.font}];
    [self.placeholder drawInRect:CGRectMake(0, (rect.size.height - palcaholderSize.height)/2, rect.size.width, rect.size.height) withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:self.font}];
}
@end
