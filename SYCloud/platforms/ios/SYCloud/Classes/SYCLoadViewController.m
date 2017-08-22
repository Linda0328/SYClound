//
//  SYCLoadViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/7/18.
//
//

#import "SYCLoadViewController.h"
#import "HexColor.h"
#import "UIImage+SYColorExtension.h"
#import "UILabel+SYCNavigationTitle.h"
#import "SYCustomTextField.h"
#import "SYCHttpReqTool.h"
#import "SYCSystem.h"
#import "MBProgressHUD.h"
#import "SYCShareVersionInfo.h"
@interface SYCLoadViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)SYCustomTextField *phoneTextF;
@property (nonatomic,strong)SYCustomTextField *passWordTextF;
@property (nonatomic,strong)SYCustomTextField *verificationCodeTextF;
@property (nonatomic,strong)UIImageView *leftV;
@property (nonatomic,strong)UIImageView *leftV1;
@property (nonatomic,strong)UIButton*getVerficationB;
@property (nonatomic,assign)BOOL isVerfication;
@property (nonatomic,assign)BOOL isEditing;
@property (nonatomic,strong)MBProgressHUD *HUD;
@end

@implementation SYCLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isVerfication = NO;
    _isEditing = NO;
    self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"f5f5f5"];
    CGFloat width = [[UIScreen mainScreen]bounds].size.width;
    UIColor *color = [UIColor colorWithHexString:@"458DEF"];
    UINavigationBar *bar = [UINavigationBar appearance];
    UIImage *imageOrigin = [UIImage imageNamed:@"navBarBG"];
    UIImage *image = [imageOrigin image:imageOrigin withColor:color];
    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[[UIImage alloc]init]];
    UILabel *titleLab = [UILabel navTitle:@"登录" TitleColor:[UIColor colorWithHexString:@"ffffff"] titleFont:[UIFont systemFontOfSize:20]];
    self.navigationItem.titleView = titleLab;
   
    //保持原图，否则图片颜色为蓝色
    UIImage *backImage = [[UIImage imageNamed:@"head_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    UIBarButtonItem * negativeSpacer = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = @[backbutton,negativeSpacer];
    
    
    _phoneTextF = [[SYCustomTextField alloc]initWithFrame:CGRectMake(16, 22, width-32, 52)];
    UIImage *leftImage = [UIImage imageNamed:@"loadAccountNormal"];
    _leftV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, leftImage.size.width, leftImage.size.height)];
    [_leftV setImage:leftImage];
    _phoneTextF.leftView = _leftV;
    _phoneTextF.leftViewMode = UITextFieldViewModeAlways;
    _phoneTextF.placeholder = @"手机号码/闪购手机号码";
    _phoneTextF.font = [UIFont systemFontOfSize:15.0];
    _phoneTextF.textColor = [UIColor colorWithHexString:@"999999"];
    _phoneTextF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextF.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
    _phoneTextF.layer.borderWidth = 0.5;
    _phoneTextF.layer.cornerRadius = 5.0f;
    _phoneTextF.delegate = self;
    [self.view addSubview:_phoneTextF];
    
//    _passWordTextF = [[SYCustomTextField alloc]initWithFrame:CGRectInset(_phoneTextF.frame, 0, _phoneTextF.frame.size.height)];
    _passWordTextF = [[SYCustomTextField alloc]initWithFrame:CGRectMake(16, 74, width-32, 52)];
    UIImage *leftImage1 = [UIImage imageNamed:@"loadPassWNormal"];
    _leftV1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, leftImage.size.width, leftImage.size.height)];
    [_leftV1 setImage:leftImage1];
    _passWordTextF.leftView = _leftV1;
    _passWordTextF.leftViewMode = UITextFieldViewModeAlways;
    _passWordTextF.placeholder = @"请输入密码";
    //暗文输入
    
    _passWordTextF.font = [UIFont systemFontOfSize:15.0];
    _passWordTextF.textColor = [UIColor colorWithHexString:@"999999"];
    _passWordTextF.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
    _passWordTextF.layer.borderWidth = 0.5;
    _passWordTextF.layer.cornerRadius = 5.0f;
    _passWordTextF.delegate = self;
    [self.view addSubview:_passWordTextF];
    _getVerficationB = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_passWordTextF.frame)-105-11, 10, 105, 33)];
    [_getVerficationB setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerficationB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _getVerficationB.backgroundColor = [UIColor colorWithHexString:@"458DEF"];
    [_getVerficationB addTarget:self action:@selector(getVerfication:) forControlEvents:UIControlEventTouchUpInside];
    _getVerficationB.layer.cornerRadius = 3.0f;
    _getVerficationB.layer.masksToBounds = YES;
    [_passWordTextF addSubview:_getVerficationB];
    _getVerficationB.hidden = YES;
    
    UIButton *VerficationButt = [[UIButton alloc]initWithFrame:CGRectMake(width-116, 152, 100, 30)];
    [VerficationButt setTitle:@"验证码登录" forState:UIControlStateNormal];
    [VerficationButt setTitleColor:[UIColor colorWithHexString:@"458DEF"] forState:UIControlStateNormal];
    [VerficationButt addTarget:self action:@selector(ExchangeWayForloading:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:VerficationButt];
    
    UIButton *loadButt = [[UIButton alloc]initWithFrame:CGRectMake(16, 207, width-32, 51)];
    [loadButt setTitle:@"登录" forState:UIControlStateNormal];
    [loadButt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loadButt addTarget:self action:@selector(loading:) forControlEvents:UIControlEventTouchUpInside];
    loadButt.backgroundColor = [UIColor colorWithHexString:@"458DEF"];
    loadButt.layer.cornerRadius = 5.0f;
    loadButt.layer.masksToBounds = YES;
    [self.view addSubview:loadButt];
    _HUD = [[MBProgressHUD alloc]initWithView:self.view];
    _HUD.mode = MBProgressHUDModeText;
    [self.view addSubview:_HUD];
    [_HUD hideAnimated:YES];
}
-(void)backClick{
    if (!_isFromSDK) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"退出登录，将取消支付" preferredStyle:UIAlertControllerStyleAlert];
    //UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        NSMutableDictionary *payCallback = [NSMutableDictionary dictionary];
        [payCallback setObject:payment_CancelCode forKey:@"resultCode"];
        [payCallback setObject:payment_CancelMessage forKey:@"resultContent"];
        
        NSDictionary *resultDic = @{PayResultCallback:payCallback,
                                    PreOrderPay:payMentTypeSDK
                                    };
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:payAndShowNotify object:_mainVC userInfo:resultDic];
        }];
    }]];
    //UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"不退出" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)getVerfication:(UIButton*)button{
    
    if ([SYCSystem isMobilePhoneOrtelePhone:_phoneTextF.text]) {
        __weak __typeof(self)weakSelf = self;
        [SYCHttpReqTool getVerficationCodeWithMobile:_phoneTextF.text forUseCode:[NSString stringWithFormat:@"%@",@(getCaptchaLoad)] fromTerminal:SYCSystemType completion:^(NSString *resultCode, NSMutableDictionary *result) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSLog(@"------%@",result);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([resultCode isEqualToString:resultCodeSuccess]) {
                    NSDictionary *resultDic = [result objectForKey:resultSuccessKey];
                    if ([[resultDic objectForKey:@"code"]isEqualToString:@"000000"]) {
                        [self Countdown];
                        strongSelf.HUD.label.text = @"请注意查收验证码";
                    }else{
                        strongSelf.HUD.label.text = [resultDic objectForKey:@"msg"];
                    }
                }else{
                    strongSelf.HUD.label.text = @"获取验证码失败";
                }
                [strongSelf.HUD showAnimated:YES];
                [strongSelf.HUD hideAnimated:YES afterDelay:2.0f];
            });
            
        }];
    }else{
        _HUD.label.text = @"请输入正确的手机号码";
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:2.0f];
    }
   
}
-(void)ExchangeWayForloading:(UIButton*)button{
    if ([button.currentTitle isEqualToString:@"验证码登录"]) {
        _passWordTextF.secureTextEntry = NO;
        _getVerficationB.hidden = NO;
        [button setTitle:@"密码登录" forState:UIControlStateNormal];
        [_leftV1 setImage:_isEditing?[UIImage imageNamed:@"loadVerficationInput"]:[UIImage imageNamed:@"loadVerficationNormal"]];
        _passWordTextF.placeholder = @"验证码";
        _isVerfication = YES;
    }else{
        _passWordTextF.secureTextEntry = YES;
        _getVerficationB.hidden = YES;
        [button setTitle:@"验证码登录" forState:UIControlStateNormal];
        [_leftV1 setImage:_isEditing?[UIImage imageNamed:@"loadPassWInput"]:[UIImage imageNamed:@"loadPassWNormal"]];
        _passWordTextF.placeholder = @"密码";
        _isVerfication = NO;
    }
    _passWordTextF.leftView = _leftV1;
}
-(void)loading:(UIButton*)butt{
    
    if (![SYCSystem isMobilePhoneOrtelePhone:_phoneTextF.text]) {
        _HUD.label.text = @"请输入正确的手机号码";
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:2.0f];
        return;
    }
    
    if (![SYCSystem judgeNSString:_passWordTextF.text]) {
        _HUD.label.text = _isVerfication?@"请输入验证码":@"请输入密码";
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:2.0f];
        return;
    }
    __weak __typeof(self)weakSelf = self;
    if (_isVerfication) {
        [SYCHttpReqTool loadWithMobile:_phoneTextF.text verficationCode:_passWordTextF.text regID:[SYCShareVersionInfo sharedVersion].regId fromTerminal:SYCSystemType completion:^(NSString *resultCode, NSMutableDictionary *result) {
            NSLog(@"------%@",result);
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([resultCode isEqualToString:resultCodeSuccess]) {
                    NSDictionary *resultDic = [result objectForKey:resultSuccessKey];
                    if ([[resultDic objectForKey:@"code"]isEqualToString:@"000000"]) {
                       
                        NSString *token = [[resultDic objectForKey:@"result"] objectForKey:@"token"];
                        NSString *nickName = [[resultDic objectForKey:@"result"] objectForKey:@"nickName"];
                        NSString *portraitPath = [[resultDic objectForKey:@"result"] objectForKey:@"portraitPath"];
                        [SYCShareVersionInfo sharedVersion].token = token;
                        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                        [def setObject:token forKey:loadToken];
                        [def setObject:[nickName stringByAppendingFormat:@"|%@",portraitPath] forKey:memberInfo];
                        [def setObject:_phoneTextF.text forKey:loginName];
                        [def synchronize];
                        strongSelf.HUD.label.text = @"登录成功";
                        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                        [center postNotificationName:loadAppNotify object:nil];
                        [strongSelf dismissViewControllerAnimated:YES completion:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:PayImmedateNotify object:[SYCShareVersionInfo sharedVersion].paymentSDKID userInfo:@{mainKey:strongSelf.mainVC,PreOrderPay:payMentTypeSDK}];
                        }];
                    }else{
                        strongSelf.HUD.label.text = [resultDic objectForKey:@"msg"];
                    }
                }else{
                    strongSelf.HUD.label.text = @"登录失败";
                }
                [strongSelf.HUD showAnimated:YES];
                [strongSelf.HUD hideAnimated:YES afterDelay:2.0f];
            });

        }];
    }else{
        [SYCHttpReqTool loadWithMobile:_phoneTextF.text password:_passWordTextF.text regID:[SYCShareVersionInfo sharedVersion].regId fromTerminal:SYCSystemType completion:^(NSString *resultCode, NSMutableDictionary *result) {
            NSLog(@"------%@",result);
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([resultCode isEqualToString:resultCodeSuccess]) {
                    NSDictionary *resultDic = [result objectForKey:resultSuccessKey];
                    if ([[resultDic objectForKey:@"code"]isEqualToString:@"000000"]) {
                        NSString *token = [[resultDic objectForKey:@"result"] objectForKey:@"token"];
                        NSString *nickName = [[resultDic objectForKey:@"result"] objectForKey:@"nickName"];
                        NSString *portraitPath = [[resultDic objectForKey:@"result"] objectForKey:@"portraitPath"];
                        [SYCShareVersionInfo sharedVersion].token = token;
                        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                        [def setObject:token forKey:loadToken];
                        [def setObject:[nickName stringByAppendingFormat:@"|%@",portraitPath] forKey:memberInfo];
                        [def setObject:_phoneTextF.text forKey:loginName];
                        [def synchronize];
                        strongSelf.HUD.label.text = @"登录成功";
                        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                        [center postNotificationName:loadAppNotify object:nil];
                        [strongSelf dismissViewControllerAnimated:YES completion:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:PayImmedateNotify object:[SYCShareVersionInfo sharedVersion].paymentSDKID userInfo:@{mainKey:strongSelf.mainVC,PreOrderPay:payMentTypeSDK}];
                        }];
                    }else{
                        strongSelf.HUD.label.text = [resultDic objectForKey:@"msg"];
                    }
                }else{
                    strongSelf.HUD.label.text = @"登录失败";
                }
                [strongSelf.HUD showAnimated:YES];
                [strongSelf.HUD hideAnimated:YES afterDelay:2.0f];
            });

        }];
    }
}
-(void) Countdown{
    __block int timeout = 120; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [_getVerficationB setTitle:@"获取验证码" forState:UIControlStateNormal];
                _getVerficationB.userInteractionEnabled = YES;
                _getVerficationB.backgroundColor = [UIColor colorWithHexString:@"3B7BCB"];
            });
            
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%.2ds",timeout];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                NSLog(@"____%@",strTime);
                
                [_getVerficationB setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                
                _getVerficationB.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
                
                _getVerficationB.userInteractionEnabled = NO;
                
            });
            
            timeout--;
            
        }
        
    });
    dispatch_resume(_timer);

}
#pragma mark ---textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:_phoneTextF]) {
         _isEditing = NO;
        [_leftV setImage:[UIImage imageNamed:@"loadAccountInput"]];
        _phoneTextF.leftView = _leftV;
    }
    if ([textField isEqual:_passWordTextF]) {
         _isEditing = YES;
        [_leftV1 setImage:_isVerfication?[UIImage imageNamed:@"loadVerficationInput"]:[UIImage imageNamed:@"loadPassWInput"]];
        _passWordTextF.leftView = _leftV1;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:_passWordTextF]&&textField.text.length > 11) {
        return NO;
    }
    return YES;
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
