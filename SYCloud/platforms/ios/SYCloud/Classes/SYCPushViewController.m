//
//  SYCPushViewController.m
//  SYCloud
//
//  Created by 文清 on 2018/5/9.
//

#import "SYCPushViewController.h"
#import "SYCSystem.h"
@interface SYCPushViewController ()

@end

@implementation SYCPushViewController

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
        if (!self.isPush) {
            rect.size.height = height - (isIphoneX?49:32);
        }
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
