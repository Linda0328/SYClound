//
//  SYCTabViewController.h
//  SYCloud
//
//  Created by 文清 on 2017/3/20.
//
//

#import <UIKit/UIKit.h>
#import "SYCContentViewController.h"
@interface SYCTabViewController : UITabBarController<UITabBarControllerDelegate>
@property (nonatomic,strong)SYCContentViewController *firstViewC;
-(void)InitTabBarWithtabbarItems:(NSArray*)tabbarItems navigationBars:(NSArray*)navigationBars;
@end
