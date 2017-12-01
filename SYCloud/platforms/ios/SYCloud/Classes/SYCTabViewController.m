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
    bgView.backgroundColor = [UIColor colorWithHexString:@"F9F9F9"];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.delegate = self;
//    SYCCustomTabBar *customTabbar = [[SYCCustomTabBar alloc]init];
//    //利用KVC替换默认的Tabbar
//    [self setValue:customTabbar forKey:@"tabBar"];
}

-(UITabBarItem *)tabBarItemWithModle:(SYCTabBarItemModel*)tabModel titleColor:(UIColor*)titleColor{
    
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:tabModel.name image:[self renderImageWithName:[tabModel.ico stringByAppendingString:@"Normal"]] selectedImage:[self renderImageWithName:[tabModel.ico stringByAppendingString:@"Selected"]]];
    tabBarItem.tag = [tabModel.ID integerValue];
    //改变tabBar字体颜色
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    //    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    return tabBarItem;
    
}
//-(void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated{
//    [super setViewControllers:viewControllers animated:animated];
//    [viewControllers enumerateObjectsUsingBlock:^(UIViewController * obj, NSUInteger idx, BOOL *stop) {
//        obj.title = nil;
//            if (idx == 1) {
//                obj.tabBarItem.imageInsets = UIEdgeInsetsMake(-6.5 , 0, 6.5, 0);
//            } else {
//                obj.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//        }
//    }];
//}
- (UIImage*)renderImageWithName:(NSString*)imageName {
    UIImage * image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

@end
