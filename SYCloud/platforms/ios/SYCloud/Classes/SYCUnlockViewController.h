//
//  SYCUnlockViewController.h
//  SYCloud
//
//  Created by 文清 on 2018/5/30.
//

#import <UIKit/UIKit.h>
typedef void(^matchBlock)(void);
@interface SYCUnlockViewController : UIViewController
@property (nonatomic,copy) matchBlock matchB;
@end
