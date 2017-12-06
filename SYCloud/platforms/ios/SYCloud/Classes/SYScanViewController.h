//
//  SYScanViewController.h
//  SYMerchantsApp
//
//  Created by 文清 on 2016/10/29.
//
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
typedef void(^postAction) (NSString *);
@interface SYScanViewController : UIViewController
@property (nonatomic,assign)BOOL isFromRegister;
@property (nonatomic,strong)MainViewController *lastMain;
@property (nonatomic, copy) postAction block;
@end
