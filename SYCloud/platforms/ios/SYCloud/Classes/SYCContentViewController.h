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
@interface SYCContentViewController : UIViewController
@property (nonatomic,strong)MainViewController *CurrentChildVC;

-(void)setNavigationBar:(SYCNavigationBarModel *)navBarModel;
@end
