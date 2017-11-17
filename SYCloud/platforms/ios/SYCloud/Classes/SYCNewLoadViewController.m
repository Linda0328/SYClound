//
//  SYCNewLoadViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/11/8.
//

#import "SYCNewLoadViewController.h"
#import "SYCSystem.h"
#import "Masonry.h"
#import "SYCLoadTextField.h"
#import "UILabel+SYCFitWidthLable.h"
#import "HexColor.h"
#import "MBProgressHUD.h"
#import "SYCHttpReqTool.h"
#import "SYCShareVersionInfo.h"
#import "AppDelegate.h"
#import "SYCRegisterViewController.h"
@interface SYCNewLoadViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)SYCLoadTextField *acountTextF;
@property (nonatomic,strong)SYCLoadTextField *passWordTextF;
@property (nonatomic,strong)UIButton *phoneLoadBut;
@property (nonatomic,strong)UIButton*getVerficationB;
@property (nonatomic,strong)MBProgressHUD *HUD;
@property (nonatomic,assign)BOOL isVerfication;
@end

@implementation SYCNewLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *bgImage = [UIImage imageNamed:@"newLoadBg"];
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    self.view.layer.contents = (__bridge id _Nullable)(bgImage.CGImage);
    UIImage *logo = [UIImage imageNamed:@"loadLogo"];
    CGFloat width = 83*[SYCSystem PointCoefficient];
    CGFloat top = 120*[SYCSystem PointCoefficient];
    UIImageView *logoIMG = [[UIImageView alloc]init];
    [self.view addSubview:logoIMG];
    [logoIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width);
        make.top.mas_equalTo(top);
        make.centerX.equalTo(self.view);
    }];
    [logoIMG setImage:logo];
    
    UIFont *lableFont = [UIFont systemFontOfSize:15.0*[SYCSystem PointCoefficient]];
    UIColor *textColor = [UIColor colorWithHexString:@"ffffff"];
    UILabel *leftLabel = [UILabel SingleLineCustomText:@"手机号码  " Font:lableFont Color:textColor];
    _acountTextF = [[SYCLoadTextField alloc]init];
    [self.view addSubview:_acountTextF];
    CGFloat left = 30*[SYCSystem PointCoefficient];
    CGFloat height = 48*[SYCSystem PointCoefficient];
    CGFloat gap = 40*[SYCSystem PointCoefficient];
    [_acountTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-left);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(height);
        make.top.mas_equalTo(logoIMG.mas_bottom).offset(gap);
    }];
    _acountTextF.layer.masksToBounds = YES;
    _acountTextF.layer.cornerRadius = height/2;
    _acountTextF.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    _acountTextF.textColor = textColor;
    _acountTextF.font = lableFont;
    _acountTextF.leftView = leftLabel;
    //必须设置，否则默认不显示leftview
    _acountTextF.leftViewMode = UITextFieldViewModeAlways;
    _acountTextF.keyboardType = UIKeyboardTypeNumberPad;
    //输入框光标的颜色为白色
    _acountTextF.tintColor = [UIColor whiteColor];
    _acountTextF.delegate = self;
    
    UILabel *leftLabel0 = [UILabel SingleLineCustomText:@"密码  " Font:lableFont Color:textColor];
    _passWordTextF = [[SYCLoadTextField alloc]init];
    [self.view addSubview:_passWordTextF];
    CGFloat gap0 = 26*[SYCSystem PointCoefficient];
    [_passWordTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-left);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(height);
        make.top.mas_equalTo(_acountTextF.mas_bottom).offset(gap0);
    }];
    _passWordTextF.layer.masksToBounds = YES;
    _passWordTextF.layer.cornerRadius = height/2;
    _passWordTextF.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    _passWordTextF.textColor = textColor;
    _passWordTextF.font = lableFont;
    _passWordTextF.leftView = leftLabel0;
    //必须设置，否则默认不显示leftview
    _passWordTextF.leftViewMode = UITextFieldViewModeAlways;
    //输入框光标的颜色为白色
    _passWordTextF.tintColor = [UIColor whiteColor];
    _passWordTextF.secureTextEntry = YES;
    _passWordTextF.delegate = self;
    
    UIFont *font0 = [UIFont systemFontOfSize:12*[SYCSystem PointCoefficient]];
    NSString *Verfication = @"获取验证码";
    CGSize sizeV = [Verfication sizeWithAttributes:@{NSFontAttributeName:font0}];
    _getVerficationB = [[UIButton alloc]init];
    [_passWordTextF addSubview:_getVerficationB];
    CGFloat bHeight = 27.0*[SYCSystem PointCoefficient];
    CGFloat verLeft = 16.0*[SYCSystem PointCoefficient];
    [_getVerficationB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_passWordTextF);
        make.height.mas_equalTo(sizeV.height);
        make.width.mas_equalTo(sizeV.width);
        make.left.mas_equalTo(-verLeft);
    }];
    [_getVerficationB setTitle:Verfication forState:UIControlStateNormal];
    [_getVerficationB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _getVerficationB.backgroundColor = [UIColor colorWithHexString:@"c59d5f"];
    [_getVerficationB addTarget:self action:@selector(getVerfication:) forControlEvents:UIControlEventTouchUpInside];
    _getVerficationB.layer.cornerRadius = bHeight/2;
    _getVerficationB.layer.masksToBounds = YES;
    _getVerficationB.hidden = YES;
    _isVerfication = NO;
    
    UIButton *laodButton = [[UIButton alloc]init];
    [self.view addSubview:laodButton];
    [laodButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-left);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(height);
        make.top.mas_equalTo(_passWordTextF.mas_bottom).offset(gap0);
    }];
    laodButton.layer.masksToBounds = YES;
    laodButton.layer.cornerRadius = height/2;
    [laodButton setBackgroundColor:[UIColor colorWithHexString:@"c59d5f"]];
    [laodButton setTitle:@"登录" forState:UIControlStateNormal];
    [laodButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    laodButton.titleLabel.font = [UIFont systemFontOfSize:20*[SYCSystem PointCoefficient]];
    [laodButton addTarget:self action:@selector(gotoLoad) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat gap1 = 34.0*[SYCSystem PointCoefficient];
    NSString *phoneL = @"验证码登录";
    CGSize size = [phoneL sizeWithAttributes:@{NSFontAttributeName:font0}];
    _phoneLoadBut = [[UIButton alloc]init];
    [self.view addSubview:_phoneLoadBut];
    [_phoneLoadBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.height.mas_equalTo(size.height);
        make.width.mas_equalTo(size.width);
        make.top.mas_equalTo(laodButton.mas_bottom).offset(gap1);
    }];
    [_phoneLoadBut setTitle:phoneL forState:UIControlStateNormal];
    [_phoneLoadBut setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    _phoneLoadBut.titleLabel.font = font0;
    [_phoneLoadBut addTarget:self action:@selector(quickLoad) forControlEvents:UIControlEventTouchUpInside];
    
//    NSString *forgetPassw = @"|    忘记密码?";
//    CGSize size0 = [forgetPassw sizeWithAttributes:@{NSFontAttributeName:font0}];
//    UIButton *forgetPasswBut = [[UIButton alloc]init];
//    [self.view addSubview:forgetPasswBut];
//    [forgetPasswBut mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-left);
//        make.height.mas_equalTo(size0.height);
//        make.width.mas_equalTo(size0.width+20);
//        make.top.mas_equalTo(laodButton.mas_bottom).offset(gap1);
//    }];
//    [forgetPasswBut setTitle:forgetPassw forState:UIControlStateNormal];
//    [forgetPasswBut setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
//    forgetPasswBut.titleLabel.font = font0;
//    [forgetPasswBut addTarget:self action:@selector(gotoFindPassw) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *registerL = @"  注册";
    CGSize size1 = [registerL sizeWithAttributes:@{NSFontAttributeName:font0}];
    UIButton *registerBut = [[UIButton alloc]init];
    [self.view addSubview:registerBut];
    [registerBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-left);
        make.height.mas_equalTo(size1.height);
        make.width.mas_equalTo(size1.width);
        make.top.mas_equalTo(laodButton.mas_bottom).offset(gap1);
    }];
    [registerBut setTitle:registerL forState:UIControlStateNormal];
    [registerBut setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    registerBut.titleLabel.font = font0;
    [registerBut addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
    
    _HUD = [[MBProgressHUD alloc]initWithView:self.view];
    _HUD.mode = MBProgressHUDModeText;
    [self.view addSubview:_HUD];
    [_HUD hideAnimated:YES];
}
-(void)gotoLoad{

    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];;
    [appdelegate setTabController];
    if (![SYCSystem isMobilePhoneOrtelePhone:_acountTextF.text]) {
        _HUD.label.text = @"请输入正确的手机号码";
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:2.0f];
        return;
    }
    if (![SYCSystem judgeNSString:_passWordTextF.text]) {
        _HUD.label.text = @"请输入密码";
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:2.0f];
        return;
    }
    __weak __typeof(self)weakSelf = self;
    if (_isVerfication) {
        [SYCHttpReqTool loadWithMobile:_acountTextF.text verficationCode:_passWordTextF.text regID:[SYCShareVersionInfo sharedVersion].regId fromTerminal:SYCSystemType completion:^(NSString *resultCode, NSMutableDictionary *result) {
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
                        [def setObject:_acountTextF.text forKey:loginName];
                        [def synchronize];
                        strongSelf.HUD.label.text = @"登录成功";
                        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                        [center postNotificationName:loadAppNotify object:nil];
                        [strongSelf dismissViewControllerAnimated:YES completion:^{
                            if (_contentVC&&[SYCSystem judgeNSString:_paymentType]) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:PayImmedateNotify object:_payCode userInfo:@{mainKey:strongSelf.contentVC,PreOrderPay:_paymentType}];
                            }else{
                                AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];;
                                [appdelegate setTabController];
                            }
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
        return;
    }
    [SYCHttpReqTool loadWithMobile:_acountTextF.text password:_passWordTextF.text regID:[SYCShareVersionInfo sharedVersion].regId fromTerminal:SYCSystemType completion:^(NSString *resultCode, NSMutableDictionary *result) {
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
                    [def setObject:_acountTextF.text forKey:loginName];
                    [def synchronize];
                    strongSelf.HUD.label.text = @"登录成功";
                    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                    [center postNotificationName:loadAppNotify object:nil];
                    [strongSelf dismissViewControllerAnimated:YES completion:^{
                        if (_contentVC&&[SYCSystem judgeNSString:_paymentType]) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:PayImmedateNotify object:_payCode userInfo:@{mainKey:strongSelf.contentVC,PreOrderPay:_paymentType}];
                        }else{
                            AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];;
                            [appdelegate setTabController];
                        }
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
-(void)quickLoad{
    _isVerfication = !_isVerfication;
    [_phoneLoadBut setTitle:_isVerfication?@"密码登录":@"验证码登录" forState:UIControlStateNormal];
    UIFont *lableFont = [UIFont systemFontOfSize:15.0*[SYCSystem PointCoefficient]];
    UIColor *textColor = [UIColor colorWithHexString:@"ffffff"];
    UILabel *leftLabel = [UILabel SingleLineCustomText:_isVerfication?@"密码  ":@"验证码  " Font:lableFont Color:textColor];
    _passWordTextF.leftView = leftLabel;
    _getVerficationB.hidden = !_isVerfication;
}
//-(void)gotoFindPassw{
//
//}
-(void)gotoRegister{
    SYCRegisterViewController *registerVC = [[SYCRegisterViewController alloc]init];
    [self presentViewController:registerVC animated:YES completion:nil];
}
-(void)getVerfication:(UIButton*)button{
    
    if ([SYCSystem isMobilePhoneOrtelePhone:_acountTextF.text]) {
        __weak __typeof(self)weakSelf = self;
        [SYCHttpReqTool getVerficationCodeWithMobile:_acountTextF.text forUseCode:[NSString stringWithFormat:@"%@",@(getCaptchaLoad)] fromTerminal:SYCSystemType completion:^(NSString *resultCode, NSMutableDictionary *result) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
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
-(void) Countdown{
    __block int timeout = 60; //倒计时时间
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
                _getVerficationB.backgroundColor = [UIColor colorWithHexString:@"c59d5f"];
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_acountTextF resignFirstResponder];
    [_passWordTextF resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:_acountTextF]&&textField.text.length > 11) {
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
