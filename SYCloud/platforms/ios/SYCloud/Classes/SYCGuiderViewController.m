//
//  SYCGuiderViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/11/18.
//

#import "SYCGuiderViewController.h"

@interface SYCGuiderViewController ()

@end

@implementation SYCGuiderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *bgImage = [UIImage imageNamed:@"GuiderBg"];
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    self.view.layer.contents = (__bridge id _Nullable)(bgImage.CGImage);
    
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
