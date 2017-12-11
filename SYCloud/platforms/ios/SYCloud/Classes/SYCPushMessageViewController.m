//
//  SYCPushMessageViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/8/16.
//
//

#import "SYCPushMessageViewController.h"
#import "HexColor.h"
#import "UIImage+SYColorExtension.h"
#import "UILabel+SYCNavigationTitle.h"
@interface SYCPushMessageViewController ()

@end

@implementation SYCPushMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *color = [UIColor colorWithHexString:@"458DEF"];
//    UINavigationBar *bar = [UINavigationBar appearance];
//    UIImage *imageOrigin = [UIImage imageNamed:@"navBarBG"];
//    UIImage *image = [imageOrigin image:imageOrigin withColor:color];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    [bar setShadowImage:[[UIImage alloc]init]];
    
    UILabel *titleLab = [UILabel navTitle:_navTitle TitleColor:[UIColor colorWithHexString:@"ffffff"] titleFont:[UIFont systemFontOfSize:20]];
    self.navigationItem.titleView = titleLab;
    NSMutableArray *leftItems = [NSMutableArray array];
    UIImage *backImg = [UIImage imageNamed:@"head_back"];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, backImg.size.width, backImg.size.height)];
    [backButton setImage:backImg forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(DismissPushMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [leftItems addObject:backItem];
    UIBarButtonItem * negativeSpacer = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    [leftItems addObject:negativeSpacer];
    self.navigationItem.leftBarButtonItems = leftItems;
}
-(void)DismissPushMessage{
    [self dismissViewControllerAnimated:YES completion:nil];
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
