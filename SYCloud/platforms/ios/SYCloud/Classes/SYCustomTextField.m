//
//  SYCustomTextField.m
//  SYCloud
//
//  Created by 文清 on 2017/7/19.
//
//

#import "SYCustomTextField.h"

@implementation SYCustomTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//重设 leftview x
-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x +=11;
    return iconRect;
}
//UItextfield 文字与输入框的距离
-(CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 45.0, 0);
}
//控制文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 45.0, 0);
}
@end
