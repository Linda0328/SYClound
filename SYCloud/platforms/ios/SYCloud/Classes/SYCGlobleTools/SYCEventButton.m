//
//  SYCEventButton.m
//  SYCloud
//
//  Created by 文清 on 2017/3/20.
//
//

#import "SYCEventButton.h"
#import "HexColor.h"
#import "SYCSystem.h"
static CGFloat font = 17.0f;
@implementation SYCEventButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setModel:(SYCEventModel *)model{
    _model = model;
    self.tag = [model.ID integerValue];
    if ([SYCSystem judgeNSString:model.name]&&![SYCSystem judgeNSString:model.ico]) {
        
        CGSize size = [model.name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}];
        self.frame = CGRectMake(0, 0, size.width, size.height);
        self.titleLabel.font = [UIFont systemFontOfSize:font];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitle:model.name forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if (![SYCSystem judgeNSString:model.name]&&[SYCSystem judgeNSString:model.ico]) {
        UIImage *image = [UIImage imageNamed:model.ico];
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        self.frame = CGRectMake(0, 0, width, height);
        [self setImage:image forState:UIControlStateNormal];
    }
//    if ([SYCSystem judgeNSString:model.name]&&![SYCSystem judgeNSString:model.ico]) {
//        
//    }
}
@end
