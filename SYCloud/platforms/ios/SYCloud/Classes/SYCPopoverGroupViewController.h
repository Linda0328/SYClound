//
//  SYCPopoverGroupViewController.h
//  SYCloud
//
//  Created by 文清 on 2017/5/5.
//
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
extern float const cellHeight;
@interface SYCPopoverGroupViewController : UIViewController
@property (nonatomic,strong)NSMutableArray *groupArr;
@property (nonatomic,copy)NSString *actionEvent;
@property (nonatomic,strong)MainViewController *PresentingVC;
@end
