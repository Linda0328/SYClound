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
@implementation SYCTabViewController
-(void)InitTabBarWithtabbarItems:(NSArray*)tabbarItems navigationBars:(NSArray*)navigationBars{
    
    NSMutableArray *controllers = [NSMutableArray array];
    for (NSInteger i = 0; i < [tabbarItems count]; i++) {
        SYCTabBarItemModel *tabModel = [tabbarItems objectAtIndex:i];
        SYCNavigationBarModel *navBarModel = [navigationBars objectAtIndex:i];
        SYCContentViewController *viewC =[[SYCContentViewController alloc]init];
        [viewC setNavigationBar:navBarModel];
        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-113);
        viewC.view.frame =rect;
        MainViewController *mainViewC = [[MainViewController alloc]init];
        mainViewC.isRoot = YES;
        mainViewC.startPage = navBarModel.url;
        mainViewC.view.frame = rect;
        [viewC.view addSubview:mainViewC.view];
        [viewC addChildViewController:mainViewC];
        [mainViewC didMoveToParentViewController:viewC];
        viewC.CurrentChildVC = mainViewC;
        mainViewC.isChild = YES;
        UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:viewC];
        navC.navigationBar.translucent = NO;
        navC.navigationBar.hidden = NO;
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
    //    self.tabBarController.tabBar.barTintColor = [UIColor colorWithHexString:@"F9F9F9"];
    //    self.tabBar.backgroundColor = [UIColor colorWithHexString:@"F9F9F9"];
}


-(UITabBarItem *)tabBarItemWithModle:(SYCTabBarItemModel*)tabModel titleColor:(UIColor*)titleColor{
    
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:tabModel.name image:[self renderImageWithName:[tabModel.ico stringByAppendingString:@"Normal"]] selectedImage:[self renderImageWithName:[tabModel.ico stringByAppendingString:@"Selected"]]];
    tabBarItem.tag = [tabModel.ID integerValue];
    //改变tabBar字体颜色
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"666666"],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    //    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    return tabBarItem;
    
}

- (UIImage*)renderImageWithName:(NSString*)imageName {
    UIImage * image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

@end
