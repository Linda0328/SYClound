//
//  SYCUnlockViewController.m
//  SYCloud
//
//  Created by 文清 on 2018/5/30.
//

#import "SYCUnlockViewController.h"
#import "SYCPassWordView.h"
#import "HexColor.h"
#import "SYCShowPasswordView.h"
#import "Masonry.h"
#import "SYCSystem.h"
#import "SYCNewLoadViewController.h"
#import "MBProgressHUD.h"
#import "UILabel+SYCNavigationTitle.h"
#import "AppDelegate.h"
@interface SYCUnlockViewController ()

@end

@implementation SYCUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *leftItems = [NSMutableArray array];
    UILabel *titleLab = [UILabel navTitle:@"关闭手势密码" TitleColor:[UIColor blackColor] titleFont:[UIFont systemFontOfSize:20]];
    self.navigationItem.titleView = titleLab;
    UIImage *image = [UIImage imageNamed:@"ps_left_back"];
    UIButton *backbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width+20*[SYCSystem PointCoefficient], image.size.height+5*[SYCSystem PointCoefficient])];
    [backbutton setImage:image forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(backToLast) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backbutton];
    [leftItems addObject:item];
    UIBarButtonItem * negativeSpacer = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    [leftItems addObject:negativeSpacer];
    self.navigationItem.leftBarButtonItems = leftItems;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    __block NSInteger count = [SYCSystem getGestureCount];
    UIImageView *imageV = [[UIImageView alloc]init];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(88*[SYCSystem PointCoefficient]);
        make.height.mas_equalTo(88*[SYCSystem PointCoefficient]);
        make.top.mas_equalTo((30+(isIphoneX?46:0))*[SYCSystem PointCoefficient]);
    }];
    [imageV setImage:[UIImage imageNamed:@"lockPortraitImage"]];
    imageV.layer.cornerRadius = 44*[SYCSystem PointCoefficient];
    imageV.layer.masksToBounds = YES;
    
    UILabel *noticeL = [[UILabel alloc]init];
    [self.view addSubview:noticeL];
    [noticeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageV.mas_bottom).mas_offset(20*[SYCSystem PointCoefficient]);
        make.centerX.equalTo(self.view);
        //        make.width.mas_equalTo(self.view.bounds.size.width/2);
        make.height.mas_equalTo(15*[SYCSystem PointCoefficient]);
    }];
    if (count == 5) {
        noticeL.text = @"请绘制手势密码";
        noticeL.textColor = [UIColor blackColor];
    }else{
        noticeL.text = [NSString stringWithFormat:@"密码错误，还可以在输入%@次",[NSNumber numberWithInteger:count]];
        noticeL.textColor = [UIColor colorWithHexString:@"FF4D4D"];
    }
    noticeL.numberOfLines = 0;
    noticeL.textAlignment = NSTextAlignmentCenter;
    noticeL.font = [UIFont systemFontOfSize:15*[SYCSystem PointCoefficient]];
    
    SYCPassWordView *myline = [[SYCPassWordView alloc]init];
    myline.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [self.view addSubview: myline];
    [myline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noticeL.mas_bottom).mas_offset(50*[SYCSystem PointCoefficient]);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(292*[SYCSystem PointCoefficient]);
        make.height.mas_equalTo(292*[SYCSystem PointCoefficient]);
    }];
    [myline error:^{
        count --;
        [SYCSystem setGestureCount:count];
        if (count>0) {
            noticeL.text = [NSString stringWithFormat:@"密码错误，还可以在输入%@次",[NSNumber numberWithInteger:count]];
            noticeL.textColor = [UIColor colorWithHexString:@"FF4D4D"];
        }else{
            noticeL.text = [NSString stringWithFormat:@"密码错误，还可以在输入0次"];
            noticeL.textColor = [UIColor colorWithHexString:@"FF4D4D"];
            MBProgressHUD*HUD = [[MBProgressHUD alloc]initWithView:self.view];
            HUD.mode = MBProgressHUDModeText;
            HUD.label.font = [UIFont systemFontOfSize:14*[SYCSystem PointCoefficient]];
            HUD.label.text = @"绘制错误五次，重新登录";
            [self.view addSubview:HUD];
            [HUD showAnimated:YES];
            [HUD hideAnimated:YES afterDelay:1.5f];
            [SYCSystem setGesturePassword:@""];
            [SYCSystem setGestureUnlock];
            [self performSelector:@selector(gotoLoad) withObject:nil afterDelay:1.5f];
        }
    }];
    [myline chuanZhi:^(NSString *str) {
        if ([str isEqualToString:[SYCSystem getGesturePassword]]) {
            [SYCSystem setGestureCount:5];
            [self dismissViewControllerAnimated:YES completion:nil];
            if (self.matchB) {
                self.matchB();
            }
        }else{
            count --;
            [SYCSystem setGestureCount:count];
            if (count>0) {
                noticeL.text = [NSString stringWithFormat:@"密码错误，还可以在输入%@次",[NSNumber numberWithInteger:count]];
                noticeL.textColor = [UIColor colorWithHexString:@"FF4D4D"];
            }else{
                noticeL.text = [NSString stringWithFormat:@"密码错误，还可以在输入0次"];
                noticeL.textColor = [UIColor colorWithHexString:@"FF4D4D"];
                MBProgressHUD*HUD = [[MBProgressHUD alloc]initWithView:self.view];
                HUD.mode = MBProgressHUDModeText;
                HUD.label.font = [UIFont systemFontOfSize:14*[SYCSystem PointCoefficient]];
                HUD.label.text = @"绘制错误五次，重新登录";
                [self.view addSubview:HUD];
                [HUD showAnimated:YES];
                [HUD hideAnimated:YES afterDelay:1.5f];
                [SYCSystem setGesturePassword:@""];
                [SYCSystem setGestureUnlock];
                [self performSelector:@selector(gotoLoad) withObject:nil afterDelay:1.5f];
            }
        }
    }];
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(myline.mas_bottom).mas_offset(70*[SYCSystem PointCoefficient]);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(20*[SYCSystem PointCoefficient]);
        make.width.mas_equalTo(300*[SYCSystem PointCoefficient]);
    }];
    [button setTitle:@"忘记手势密码，重新登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"CFAF72"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
}
-(void)backToLast{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)gotoLoad{
    SYCNewLoadViewController *newLoad = [[SYCNewLoadViewController alloc]init];
    [self presentViewController:newLoad animated:YES completion:nil];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appdelegate.window.rootViewController = newLoad;
}
-(void)forgetPassword{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"忘记手势，需要重新登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil
                             ];
    [alertC addAction:action];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]setValue:@"unlock" forKey:@"isLocked"];
        [SYCSystem setGesturePassword:@""];
        [SYCSystem setGestureUnlock];
        [self gotoLoad];
    }];
    [alertC addAction:action0];
    [self presentViewController:alertC animated:YES completion:nil];
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
