//
//  SYCBlindYTKViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/5/5.
//
//

#import "SYCBlindYTKViewController.h"
#import "SYCSystem.h"
#import "HexColor.h"
@interface SYCBlindYTKViewController ()

@end

@implementation SYCBlindYTKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 45*[SYCSystem PointCoefficient])];
    [backBut setImage:[UIImage imageNamed:@"pay_back"] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBut];
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 240*[SYCSystem PointCoefficient], 17.0*[SYCSystem PointCoefficient])];
    titleLable.numberOfLines = 1;
    titleLable.font = [UIFont systemFontOfSize:17.0*[SYCSystem PointCoefficient]];
    titleLable.textColor = [UIColor colorWithHexString:@"444444"];
    titleLable.center = CGPointMake(self.view.center.x, backBut.center.y);
    titleLable.text = @"绑定生源一卡通";
    titleLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLable];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45*[SYCSystem PointCoefficient], width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    [self.view addSubview:lineView];
    
    UITextField *YKTtextF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, width, 45*[SYCSystem PointCoefficient])];
    YKTtextF.center = CGPointMake(self.view.center.x, lineView.center.y+22.5*[SYCSystem PointCoefficient]);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 15)];
    label.textColor = [UIColor colorWithHexString:@"444444"];
    label.text = @"储值卡号：";
    label.textAlignment = NSTextAlignmentLeft;
    YKTtextF.leftView = label;
    [self.view addSubview:YKTtextF];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(YKTtextF.frame), width, 1)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    [self.view addSubview:lineView1];
    
    UITextField *YZMtextF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, width - 140, 45*[SYCSystem PointCoefficient])];
    YZMtextF.center = CGPointMake(self.view.center.x, lineView1.center.y+22.5*[SYCSystem PointCoefficient]);
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 15)];
    label1.textColor = [UIColor colorWithHexString:@"444444"];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.text = @"验证码：";
    YZMtextF.leftView = label;
    [self.view addSubview:YZMtextF];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(YZMtextF.frame)+10, 5, 100, CGRectGetHeight(YZMtextF.frame)-10)];
    button.backgroundColor =  [UIColor colorWithHexString:@"3B7BCB"];
    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getYZM:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(YZMtextF.frame), width, 1)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    [self.view addSubview:lineView2];

}
-(void)dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)getYZM:(id)sender{

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
