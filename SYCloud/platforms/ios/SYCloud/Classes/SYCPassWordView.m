//
//  SYCPassWordView.m
//  SYCloud
//
//  Created by 文清 on 2018/5/22.
//

#import "SYCPassWordView.h"
#import "SYCSystem.h"
#import "HexColor.h"
@interface SYCPassWordView ()
//记录选中按钮
@property (nonatomic)NSMutableArray *selectArray;
//记录当前手势所在点，用来划线
@property (nonatomic)CGPoint currentPoint;
@property (nonatomic,strong)UIColor *lineColor;
@end
@implementation SYCPassWordView
//通过storyboard 或者 xib 文件创建的时候会调用这个方法
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ([super initWithCoder:aDecoder])
    {
        _selectArray = [[NSMutableArray alloc]init];
        [self createButton];
        self.lineColor = [UIColor colorWithHexString:@"CFAF72"];
    }
    return self;
}
-(instancetype)init{
    if (self == [super init]) {
        _selectArray = [[NSMutableArray alloc]init];
        [self createButton];
        self.lineColor = [UIColor colorWithHexString:@"CFAF72"];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        _selectArray = [[NSMutableArray alloc]init];
        [self createButton];
        self.lineColor = [UIColor colorWithHexString:@"CFAF72"];
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //获取绘图需要的上下文，他是专门用来保存绘画期间的数据的
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    if (self.selectArray.count == 0) {
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //设置填充颜色
//    [[UIColor blueColor] setFill];
    
    //设置描边颜色
//    [[UIColor redColor] setStroke];
    
    //设置线宽
    CGContextSetLineWidth(contextRef, 3*[SYCSystem PointCoefficient]);
    //线的样式
    path.lineJoinStyle= kCGLineCapButt;
    //设置颜色
    [self.lineColor set];
    //便利按钮  添加连线
    for (int i = 0; i < self.selectArray.count; i++) {
        UIButton *button = self.selectArray[i];
        if (i == 0) {
            //设置起点
            [path moveToPoint:button.center];
        }else{
            //添加连线
            [path addLineToPoint:button.center];
        }
    }
    //如果按钮不在当前点，就把当前触摸点作为当前点，可以使线随着拖动位置变化而变化
    [path addLineToPoint:_currentPoint];
    //把路径添加到上下文
    CGContextAddPath(contextRef, path.CGPath);
    //渲染
    CGContextStrokePath(contextRef);
}
//创建button
- (void)createButton{
    float heightW = 106*[SYCSystem PointCoefficient];
    CGFloat butwidth = 76*[SYCSystem PointCoefficient];
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 100+j+3*i;
            button.frame = CGRectMake(heightW*j, i*heightW, butwidth, butwidth);
            [button setImage:[UIImage imageNamed:@"lockNormalImage"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"lockSelectedImage"] forState:UIControlStateSelected];
            button.userInteractionEnabled = NO;
            [self addSubview:button];
        }
    }
}

//根据触摸点找到对应的button
- (UIButton*)buttonWithPoint:(CGPoint)point{
    for (UIButton *button in self.subviews) {
        //注意这个：CGRectContainsPoint(btn.frame, point) 如果point这个点包含在btn的frame范围内
        if (CGRectContainsPoint(button.frame, point))
        {
            return button;
        }
    }
    return nil;
}


//开始触摸
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //拿到触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //根据触摸点找到对应的button
    UIButton *button = [self buttonWithPoint:point];
    
    if (button && (button.selected == NO)) {
        button.selected = YES;
        //把这个button添加到数组中
        [self.selectArray addObject:button];
    }
    
}

//触摸移动过程中
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //拿到触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //根据触摸点找到对应的button
    UIButton *button = [self buttonWithPoint:point];
    
    if (button && (button.selected == NO)) {
        button.selected = YES;
        //把这个button添加到数组中
        [self.selectArray addObject:button];
    }else{
        _currentPoint = point;
    }
    //调用绘图方法
    [self setNeedsDisplay];
}

//触摸结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([_selectArray count]<4) {
        self.lineColor = [UIColor colorWithHexString:@"FF4D4D"];
        for (UIButton *button in _selectArray) {
            [button setImage:[UIImage imageNamed:@"lockwrongImage"] forState:UIControlStateSelected];
        }
        if (self.errBlock) {
            self.errBlock();
        }
        
    }else{
        self.lineColor = [UIColor colorWithHexString:@"CFAF72"];
        NSMutableString *path = [[NSMutableString alloc]init];
        for (UIButton *button in _selectArray) {
            [path appendFormat:@"%ld",button.tag - 100];
        }
        if (self.MyBlock) {
            self.MyBlock(path);
        }
    }
    [self setNeedsDisplay];
    [self performSelector:@selector(clearUI) withObject:nil afterDelay:1.5f];
}
-(void)clearUI{
    [_selectArray removeAllObjects];
    [self setNeedsDisplay];
    for (UIButton *button in self.subviews) {
        button.selected = NO;
        self.lineColor = [UIColor colorWithHexString:@"CFAF72"];
        [button setImage:[UIImage imageNamed:@"lockSelectedImage"] forState:UIControlStateSelected];
    }
}
- (void)chuanZhi:(NewBlock)block{
    self.MyBlock = block;
}

-(void)error:(wrongBlock)block{
    self.errBlock = block;
}
@end
