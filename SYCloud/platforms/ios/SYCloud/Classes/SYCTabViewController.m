//
//  SYCTabViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/3/20.
//
//

#import "SYCTabViewController.h"
#import "MainViewController.h"
#import "SYCContentViewController.h"
#import "SYCNavigationBarModel.h"
#import "SYCTabBarItemModel.h"
#import "HexColor.h"
#import "SYCCustomTabBar.h"
#import "SYCSystem.h"


#define standOutHeight 16.0f*[SYCSystem PointCoefficient] // 中间突出部分的高度
#define ScreenW  CGRectGetWidth([UIScreen mainScreen].bounds)
#define ScreenH CGRectGetHeight([UIScreen mainScreen].bounds)
@implementation SYCTabViewController
-(void)InitTabBarWithtabbarItems:(NSArray*)tabbarItems navigationBars:(NSArray*)navigationBars{
    [self setDelegate:self];
    NSMutableArray *controllers = [NSMutableArray array];
    for (NSInteger i = 0; i < [tabbarItems count]; i++) {
        SYCTabBarItemModel *tabModel = [tabbarItems objectAtIndex:i];
        SYCNavigationBarModel *navBarModel = [navigationBars objectAtIndex:i];
        SYCContentViewController *viewC =[[SYCContentViewController alloc]init];
        if (i == 0) {
            self.firstViewC = viewC;
            viewC.isFirst = YES;
        }
        [viewC setNavigationBar:navBarModel];
        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-113);
        viewC.view.frame =rect;
        MainViewController *mainViewC = [[MainViewController alloc]init];
        mainViewC.isChild = YES;
        mainViewC.isRoot = YES;
        mainViewC.enableReload = YES;
        mainViewC.startPage = navBarModel.url;
        mainViewC.isHiddenNavBar = viewC.isHiddenNavigationBar;
        mainViewC.view.frame = rect;
        [viewC.view addSubview:mainViewC.view];
        [viewC addChildViewController:mainViewC];
        [mainViewC didMoveToParentViewController:viewC];
        viewC.CurrentChildVC = mainViewC;
        UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:viewC];
        if (viewC.isHiddenNavigationBar) {
            navC.navigationBar.translucent = YES;
            navC.navigationBar.hidden = YES;
        }else{
            navC.navigationBar.translucent = NO;
            navC.navigationBar.hidden = NO;
        }
        UITabBarItem *tabItem = [self tabBarItemWithModle:tabModel titleColor:nil];
        navC.tabBarItem = tabItem;
        [controllers addObject:navC];
    }
    self.viewControllers = controllers;
    self.tabBarController.tabBar.translucent = NO;
    
    UIView *bgView = [[UIView alloc]initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.delegate = self;
//    SYCCustomTabBar *customTabbar = [[SYCCustomTabBar alloc]init];
//    //利用KVC替换默认的Tabbar
//    [self setValue:customTabbar forKey:@"tabBar"];
    [self.tabBar setShadowImage:[[UIImage alloc]init]];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    [self.tabBar insertSubview:[self drawTabbarBgImageView] atIndex:0];
    self.tabBar.opaque = YES;
}
// 画背景的方法，返回 Tabbar的背景
- (UIImageView *)drawTabbarBgImageView
{
//    NSLog(@"tabBarHeight：  %f" , tabBarHeight);// 设备tabBar高度 一般49
    CGFloat tabBarHeight = self.tabBar.bounds.size.height;
    CGFloat radius = 32*[SYCSystem PointCoefficient];// 圆半径
    CGFloat allFloat= (pow(radius, 2)-pow((radius-standOutHeight), 2));// standOutHeight 突出高度 12
    CGFloat ww = sqrtf(allFloat);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -standOutHeight,ScreenW , tabBarHeight +standOutHeight)];// ScreenW设备的宽
    //    imageView.backgroundColor = [UIColor redColor];
    CGSize size = imageView.frame.size;
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(size.width/2 - ww, standOutHeight)];
    NSLog(@"ww: %f", ww);
    NSLog(@"ww11: %f", 0.5*((radius-ww)/radius));
    CGFloat angleH = 0.5*((radius-standOutHeight)/radius);
    NSLog(@"angleH：%f", angleH);
    CGFloat startAngle = (1+angleH)*((float)M_PI); // 开始弧度
    CGFloat endAngle = (2-angleH)*((float)M_PI);//结束弧度
    // 开始画弧：CGPointMake：弧的圆心  radius：弧半径 startAngle：开始弧度 endAngle：介绍弧度 clockwise：YES为顺时针，No为逆时针
    [path addArcWithCenter:CGPointMake((size.width)/2, radius) radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    // 开始画弧以外的部分
    [path addLineToPoint:CGPointMake(size.width/2+ww, standOutHeight)];
    [path addLineToPoint:CGPointMake(size.width, standOutHeight)];
    [path addLineToPoint:CGPointMake(size.width,size.height)];
    [path addLineToPoint:CGPointMake(0,size.height)];
    [path addLineToPoint:CGPointMake(0,standOutHeight)];
    [path addLineToPoint:CGPointMake(size.width/2-ww, standOutHeight)];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;// 整个背景的颜色
    layer.strokeColor = [UIColor colorWithWhite:0.765 alpha:1.000].CGColor;//边框线条的颜色
    layer.lineWidth = 0.5;//边框线条的宽
    // 在要画背景的view上 addSublayer:
    [imageView.layer addSublayer:layer];
    return imageView;
}

-(UITabBarItem *)tabBarItemWithModle:(SYCTabBarItemModel*)tabModel titleColor:(UIColor*)titleColor{
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:tabModel.name image:[self renderImageWithName:[tabModel.ico stringByAppendingString:@"Normal"]] selectedImage:[self renderImageWithName:[tabModel.ico stringByAppendingString:@"Selected"]]];
    tabBarItem.tag = [tabModel.ID integerValue];
    //改变tabBar字体颜色
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    //    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    return tabBarItem;
    
}
-(void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated{
    [super setViewControllers:viewControllers animated:animated];
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController * obj, NSUInteger idx, BOOL *stop) {
        obj.title = nil;
            if (idx == 1) {
                obj.tabBarItem.imageInsets = UIEdgeInsetsMake(-7.5*[SYCSystem PointCoefficient] , 0, 7.5*[SYCSystem PointCoefficient], 0);
            } else {
                obj.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            }
    }];
}
- (UIImage*)renderImageWithName:(NSString*)imageName {
    UIImage * image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

@end
