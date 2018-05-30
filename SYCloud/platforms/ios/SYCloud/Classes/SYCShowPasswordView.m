//
//  SYCShowPasswordView.m
//  SYCloud
//
//  Created by 文清 on 2018/5/28.
//

#import "SYCShowPasswordView.h"
#import "SYCSystem.h"
#import "HexColor.h"
@implementation SYCShowPasswordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    if (self == [super init]) {
        [self createButton];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self createButton];
        
    }
    return self;
}
//创建button
- (void)createButton{
    //左侧距离
    float heightW = 30*[SYCSystem PointCoefficient];
    CGFloat butwidth = 20*[SYCSystem PointCoefficient];
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 100+j+3*i;
            button.frame = CGRectMake(heightW*j, i*heightW, butwidth, butwidth);
            button.layer.cornerRadius = 10*[SYCSystem PointCoefficient];
            [button setImage:[UIImage imageNamed:@"lockshowNormalImage"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"lockShowSelectedImage"] forState:UIControlStateSelected];
//            button.layer.borderColor = [UIColor whiteColor].CGColor;
//            button.layer.borderWidth = 3*[SYCSystem PointCoefficient];
            button.userInteractionEnabled = NO;
            [self addSubview:button];
        }
    }
}
-(void)showSelected:(NSString*)info{
    for (NSInteger i = 0; i < [info length]; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *tag = [info substringWithRange:range];
        for (UIButton *button in self.subviews) {
            if ((button.tag-100) == [tag integerValue]) {
//                button.backgroundColor = [UIColor colorWithHexString:@"CFAF72"];
                button.selected = YES;
                break;
            }
        }
    }
}
@end
