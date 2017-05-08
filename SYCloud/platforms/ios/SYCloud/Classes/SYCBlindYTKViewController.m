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
#import "SYCHttpReqTool.h"
#import "SYCShareVersionInfo.h"
#import "MBProgressHUD.h"
NSString *const refreshPaymentNotify = @"refreshPayment";
@interface SYCBlindYTKViewController ()
@property (nonatomic,strong)UITextField *YKTtextF;
@property (nonatomic,strong)UITextField *YZMtextF;
@property (nonatomic,strong)MBProgressHUD *HUD;
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
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50*[SYCSystem PointCoefficient], width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    [self.view addSubview:lineView];
    
    _YKTtextF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, width, 50*[SYCSystem PointCoefficient])];
    _YKTtextF.center = CGPointMake(self.view.center.x, lineView.center.y+25*[SYCSystem PointCoefficient]);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 15)];
    label.textColor = [UIColor colorWithHexString:@"444444"];
    label.text = @"储值卡号：";
    label.font = [UIFont systemFontOfSize:15.0*[SYCSystem PointCoefficient]];
    label.textAlignment = NSTextAlignmentRight;
    _YKTtextF.leftView = label;
    _YKTtextF.leftViewMode = UITextFieldViewModeAlways;
    _YKTtextF.placeholder = @"请输入一卡通卡号";
    _YKTtextF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _YKTtextF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_YKTtextF];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_YKTtextF.frame), width, 1)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    [self.view addSubview:lineView1];
    
    _YZMtextF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, width - 130, 50*[SYCSystem PointCoefficient])];
    _YZMtextF.center = CGPointMake(self.view.center.x-65, lineView1.center.y+25*[SYCSystem PointCoefficient]);
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 15)];
    label1.textColor = [UIColor colorWithHexString:@"444444"];
    label1.textAlignment = NSTextAlignmentRight;
    label1.text = @"验证码：";
    label1.font = [UIFont systemFontOfSize:15.0*[SYCSystem PointCoefficient]];
    _YZMtextF.leftViewMode = UITextFieldViewModeAlways;
    _YZMtextF.leftView = label1;
    _YZMtextF.placeholder = @"请输入验证码";
    _YZMtextF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _YZMtextF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_YZMtextF];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_YZMtextF.frame)+10, CGRectGetMaxY(lineView1.frame)+10, 110, CGRectGetHeight(_YZMtextF.frame)-20)];
    button.backgroundColor =  [UIColor colorWithHexString:@"3B7BCB"];
    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 6.0f;
    [button addTarget:self action:@selector(getYZM:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_YZMtextF.frame), width, 1)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    [self.view addSubview:lineView2];

    
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    UIButton *confirmBut = [[UIButton alloc]initWithFrame:CGRectMake(16*[SYCSystem PointCoefficient], 3*screenSize.height/5-16*[SYCSystem PointCoefficient]-50*[SYCSystem PointCoefficient], self.view.frame.size.width-32*[SYCSystem PointCoefficient], 50*[SYCSystem PointCoefficient])];
    confirmBut.backgroundColor = [UIColor colorWithHexString:@"3B7BCB"];
    [confirmBut setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBut addTarget:self action:@selector(BlindConfirm:) forControlEvents:UIControlEventTouchUpInside];
    confirmBut.layer.masksToBounds = YES;
    confirmBut.layer.cornerRadius = 10.0f;
    [self.view addSubview:confirmBut];
    
    _HUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_HUD];
    
}
-(void)dismiss:(id)sender{
    [_YKTtextF resignFirstResponder];
    [_YZMtextF resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)getYZM:(id)sender{
    UIButton *butt = (UIButton*)sender;
    __block int timeout = 120; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [butt setTitle:@"发送验证码" forState:UIControlStateNormal];
                butt.userInteractionEnabled = YES;
                butt.backgroundColor = [UIColor colorWithHexString:@"3B7BCB"];
            });
            
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%.2ds",timeout];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                NSLog(@"____%@",strTime);
                
                [butt setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                
                butt.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
                
                butt.userInteractionEnabled = NO;
                
            });
            
            timeout--;
            
        }
        
    });
    dispatch_resume(_timer);
    [_YKTtextF resignFirstResponder];
    
    if ([SYCSystem judgeNSString:_YKTtextF.text]) {
        NSDictionary *captchaDic = [SYCHttpReqTool getCaptchaforblindYKTwithCardNo:_YKTtextF.text];
        NSLog(@"------%@--",captchaDic);
        if ([captchaDic[@"code"] isEqualToString:@"000000"] ) {
            _HUD.label.text = @"发送验证码成功，请注意查收短信";
        }else{
            _HUD.label.text = captchaDic[@"msg"];
        }
    }else{
        _HUD.label.text = @"请输入一卡通卡号";
    }
    [_HUD showAnimated:YES];
    [_HUD hideAnimated:YES afterDelay:2.0f];
   
}
-(void)BlindConfirm:(id)sender{
    BOOL isRight = YES;
    if (![SYCSystem judgeNSString:_YKTtextF.text]){
        isRight = NO;
        _HUD.label.text = @"请输入一卡通卡号";
    }else if(![SYCSystem judgeNSString:_YKTtextF.text]){
        isRight = NO;
        _HUD.label.text = @"请输入验证码";
    }
    if (isRight) {
        NSDictionary *blindResulrDic = [SYCHttpReqTool blindYKTwithCardNo:_YKTtextF.text captcha:_YZMtextF.text];
        NSLog(@"------%@--",blindResulrDic);
        if ([blindResulrDic[@"code"] isEqualToString:@"000000"] ) {
            _HUD.label.text = @"绑定成功！";
        }else{
            _HUD.label.text = blindResulrDic[@"msg"];
        }
    }
    [_HUD showAnimated:YES];
    [_HUD hideAnimated:YES afterDelay:2.0f];
    [self dismissViewControllerAnimated:YES completion:^{
          NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
          [center postNotificationName:refreshPaymentNotify object:nil];
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_YKTtextF resignFirstResponder];
    [_YZMtextF resignFirstResponder];
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
