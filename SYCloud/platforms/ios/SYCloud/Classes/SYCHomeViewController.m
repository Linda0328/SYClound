//
//  SYCHomeViewController.m
//  SYCloud
//
//  Created by 文清 on 2018/5/9.
//

#import "SYCHomeViewController.h"
#import "SYCSystem.h"
@interface SYCHomeViewController ()

@end

@implementation SYCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if([[[UIDevice currentDevice]systemVersion ] floatValue]>=7)
    {
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGRect rect = [UIScreen mainScreen].bounds;
        if (self.isHiddenNavBar) {
            rect.size.height = height - (isIphoneX?69:49);
        }else{
            rect.size.height = height - (isIphoneX?82:56);
        }
        //        if (self.isBack) {
        //            if (self.isHiddenNavBar) {
        //                rect.size.height = height - (isIphoneX?69:49);
        //            }else{
        //                rect.size.height = height - (isIphoneX?82:113);
        //            }
        //        }
        self.webView.frame = rect;
        self.view.frame = rect;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
