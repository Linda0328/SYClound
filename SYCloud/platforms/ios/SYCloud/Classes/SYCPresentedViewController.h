//
//  SYCPresentedViewController.h
//  SYCloud
//
//  Created by 文清 on 2017/4/21.
//
//

#import <UIKit/UIKit.h>
#import "SYCPresentationController.h"
@interface SYCPresentedViewController : UIViewController<UIViewControllerTransitioningDelegate>
@property (nonatomic,readonly,strong,nullable)UIViewController *contentViewController;
@property (nonatomic,readonly,nullable)SYCPresentationController *presentationController;
@end
