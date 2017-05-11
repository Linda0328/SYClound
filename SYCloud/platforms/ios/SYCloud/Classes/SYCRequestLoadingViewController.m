//
//  SYCRequestLoadingViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/5/8.
//
//

#import "SYCRequestLoadingViewController.h"
#import "HexColor.h"
NSString *const requestResultErrorNotify = @"requestResultError";
NSString *const requestResultSuccessNotify = @"requestResultSuccess";
@interface SYCRequestLoadingViewController ()
@property (nonatomic,strong)UILabel *noticeL;
@end

@implementation SYCRequestLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"000000"];
    self.view.alpha = 0.3;
    _noticeL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    _noticeL.center = self.view.center;
    _noticeL.textAlignment = NSTextAlignmentCenter;
    _noticeL.font = [UIFont systemFontOfSize:20.0f];
    _noticeL.textColor = [UIColor whiteColor];
    _noticeL.text = @"支付中...";
    [self.view addSubview:_noticeL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showResponseSuccess:) name:requestResultSuccessNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showResponseError:) name:requestResultErrorNotify object:nil];
}
-(void)showResponseError:(NSNotification*)notify{
    NSString *notice = (NSString*)notify.object;
    _noticeL.text = notice;
    __block SYCRequestLoadingViewController *weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0* NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    });
}
-(void)showResponseSuccess:(NSNotification*)notify{
    __block SYCRequestLoadingViewController *weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.pushBlock) {
            weakSelf.pushBlock();
        }
    }];
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
