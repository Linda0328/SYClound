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
@interface SYCUnlockViewController ()

@end

@implementation SYCUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    __block NSInteger count = 5;
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
    noticeL.text = @"请绘制手势密码";
    noticeL.numberOfLines = 0;
    noticeL.textAlignment = NSTextAlignmentCenter;
    noticeL.font = [UIFont systemFontOfSize:15*[SYCSystem PointCoefficient]];
    noticeL.textColor = [UIColor blackColor];
    
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
        noticeL.text = [NSString stringWithFormat:@"密码错误，还可以在输入%@次",[NSNumber numberWithInteger:count]];
        noticeL.textColor = [UIColor colorWithHexString:@"FF4D4D"];
    }];
    [myline chuanZhi:^(NSString *str) {
        if ([str isEqualToString:[SYCSystem getGesturePassword]]) {
            if (self.matchB) {
                self.matchB();
            }
        }else{
            count --;
            noticeL.text = [NSString stringWithFormat:@"密码错误，还可以在输入%@次",[NSNumber numberWithInteger:count]];
            noticeL.textColor = [UIColor colorWithHexString:@"FF4D4D"];
        }
    }];
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(myline.mas_bottom).mas_offset(80*[SYCSystem PointCoefficient]);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(20*[SYCSystem PointCoefficient]);
        make.width.mas_equalTo(120*[SYCSystem PointCoefficient]);
    }];
    [button setTitle:@"忘记手势？" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"CFAF72"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
}
-(void)forgetPassword{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"忘记手势，需要重新登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil
                             ];
    [alertC addAction:action];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       [SYCSystem setGesturePassword:@""];
       SYCNewLoadViewController *newLoad = [[SYCNewLoadViewController alloc]init];
        [self presentViewController:newLoad animated:YES completion:nil];
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
