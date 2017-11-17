//
//  SYCContentViewController.h
//  SYCloud
//
//  Created by 文清 on 2017/3/20.
//
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "SYCNavigationBarModel.h"
typedef void(^pushViewControllerBlock)(NSString *contentUrl,BOOL isBackToLast,BOOL Reload,SYCNavigationBarModel *navModel);
@interface SYCContentViewController : UIViewController
@property (nonatomic,copy)pushViewControllerBlock pushBlock;
@property (nonatomic,strong)MainViewController *CurrentChildVC;
@property (nonatomic,assign)BOOL isHiddenNavigationBar;
@property (nonatomic,assign)BOOL isBackToLast;
@property (nonatomic,assign)BOOL isFirst;
-(void)setNavigationBar:(SYCNavigationBarModel *)navBarModel;
@end
