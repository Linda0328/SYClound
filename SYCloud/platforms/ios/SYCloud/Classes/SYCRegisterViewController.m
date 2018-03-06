//
//  SYCRegisterViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/11/17.
//

#import "SYCRegisterViewController.h"
#import "HexColor.h"
#import "UILabel+SYCFitWidthLable.h"
#import "SYCLoadTextField.h"
#import "SYCSystem.h"
#import "Masonry.h"
#import "SYCHttpReqTool.h"
#import "MBProgressHUD.h"
#import "SYCShareVersionInfo.h"
#import "AppDelegate.h"
#import "SYScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SYCNewLoadViewController.h"
@interface SYCRegisterViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)SYCLoadTextField *acountTextF;
@property (nonatomic,strong)SYCLoadTextField *passWTextF;
@property (nonatomic,strong)SYCLoadTextField *verficationTextF;
@property (nonatomic,strong)SYCLoadTextField *recommendTextF;
@property (nonatomic,strong)UIButton *getVerficationB;
@property (nonatomic,strong)MBProgressHUD *HUD;
@end

@implementation SYCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *bgImage = isIphoneX?[UIImage imageNamed:@"loginBG1125@3x"]:[UIImage imageNamed:@"newLoadBg"];
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    self.view.layer.contents = (__bridge id _Nullable)(bgImage.CGImage);
    
    UIFont *lableFont = [UIFont systemFontOfSize:15.0*[SYCSystem PointCoefficient]];
    UIColor *textColor = [UIColor colorWithHexString:@"ffffff"];
//    UILabel *leftLabel = [UILabel SingleLineCustomText:@"手机号码  " Font:lableFont Color:textColor];
    _acountTextF = [[SYCLoadTextField alloc]init];
    [self.view addSubview:_acountTextF];
    CGFloat left = 30*[SYCSystem PointCoefficient];
    CGFloat height = 48*[SYCSystem PointCoefficient];
    CGFloat gap = 120*[SYCSystem PointCoefficient];
    [_acountTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-left);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(height);
        make.top.mas_equalTo(self.view).offset(gap);
    }];
    _acountTextF.layer.masksToBounds = YES;
    _acountTextF.layer.cornerRadius = height/2;
    _acountTextF.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    _acountTextF.textColor = textColor;
    _acountTextF.font = lableFont;
//    _acountTextF.leftView = leftLabel;
//    _acountTextF.leftViewMode = UITextFieldViewModeAlways;
    _acountTextF.placeholder = @"手机号码/闪购手机号码";
    _acountTextF.keyboardType = UIKeyboardTypeNumberPad;
    //输入框光标的颜色为白色
    _acountTextF.tintColor = [UIColor whiteColor];
    _acountTextF.delegate = self;
    
   
//    UILabel *leftLabel0 = [UILabel SingleLineCustomText:@"密码  " Font:lableFont Color:textColor];
    CGFloat gapM = 26*[SYCSystem PointCoefficient];
    _passWTextF = [[SYCLoadTextField alloc]init];
    [self.view addSubview:_passWTextF];
    [_passWTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-left);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(height);
        make.top.mas_equalTo(_acountTextF.mas_bottom).offset(gapM);
    }];
    _passWTextF.layer.masksToBounds = YES;
    _passWTextF.layer.cornerRadius = height/2;
    _passWTextF.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    _passWTextF.textColor = textColor;
    
    _passWTextF.font = lableFont;
//    _passWTextF.leftView = leftLabel0;
//    _passWTextF.leftViewMode = UITextFieldViewModeAlways;
    _passWTextF.placeholder = @"密码";
    _passWTextF.secureTextEntry = YES;
    //输入框光标的颜色为白色
    _passWTextF.tintColor = [UIColor whiteColor];
    _passWTextF.delegate = self;
    
//    UILabel *leftLabelV = [UILabel SingleLineCustomText:@"验证码  " Font:lableFont Color:textColor];
    _verficationTextF = [[SYCLoadTextField alloc]init];
    [self.view addSubview:_verficationTextF];
    [_verficationTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-left);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(height);
        make.top.mas_equalTo(_passWTextF.mas_bottom).offset(gapM);
    }];
    _verficationTextF.layer.masksToBounds = YES;
    _verficationTextF.layer.cornerRadius = height/2;
    _verficationTextF.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    _verficationTextF.textColor = textColor;
    _verficationTextF.font = lableFont;
//    _verficationTextF.leftView = leftLabelV;
//    _verficationTextF.leftViewMode = UITextFieldViewModeAlways;
    _verficationTextF.placeholder = @"验证码";
    _verficationTextF.keyboardType = UIKeyboardTypeNumberPad;
    //输入框光标的颜色为白色
    _verficationTextF.tintColor = [UIColor whiteColor];
    _verficationTextF.delegate = self;
    
    UIFont *font0 = [UIFont systemFontOfSize:12*[SYCSystem PointCoefficient]];
    NSString *Verfication = @"获取验证码";
    CGSize sizeV = [Verfication sizeWithAttributes:@{NSFontAttributeName:font0}];
    _getVerficationB = [[UIButton alloc]init];
    [_verficationTextF addSubview:_getVerficationB];
    CGFloat bHeight = 27.0*[SYCSystem PointCoefficient];
    CGFloat verLeft = 16.0*[SYCSystem PointCoefficient];
    [_getVerficationB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_verficationTextF);
        make.height.mas_equalTo(bHeight);
        make.width.mas_equalTo(sizeV.width+20);
        make.right.mas_equalTo(-verLeft);
    }];
    [_getVerficationB setTitle:Verfication forState:UIControlStateNormal];
    [_getVerficationB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _getVerficationB.backgroundColor = [UIColor colorWithHexString:@"c59d5f"];
    _getVerficationB.titleLabel.font = font0;
    [_getVerficationB addTarget:self action:@selector(getVerfication:) forControlEvents:UIControlEventTouchUpInside];
    _getVerficationB.layer.cornerRadius = bHeight/2;
    _getVerficationB.layer.masksToBounds = YES;
    
//    UILabel *leftLabelR = [UILabel SingleLineCustomText:@"推荐人  " Font:lableFont Color:textColor];
    _recommendTextF = [[SYCLoadTextField alloc]init];
    [self.view addSubview:_recommendTextF];
    [_recommendTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-left);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(height);
        make.top.mas_equalTo(_verficationTextF.mas_bottom).offset(gapM);
    }];
    _recommendTextF.layer.masksToBounds = YES;
    _recommendTextF.layer.cornerRadius = height/2;
    _recommendTextF.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    _recommendTextF.textColor = textColor;
    _recommendTextF.font = lableFont;
    _recommendTextF.placeholder = @"推荐人";
    _recommendTextF.keyboardType = UIKeyboardTypeNumberPad;
    //输入框光标的颜色为白色
    _recommendTextF.tintColor = [UIColor whiteColor];
    _recommendTextF.delegate = self;
    
    UIButton *scanB = [[UIButton alloc]init];
    [_recommendTextF addSubview:scanB];
    CGFloat sHeight = 24.0*[SYCSystem PointCoefficient];
    [scanB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_recommendTextF);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(height);
        make.right.mas_equalTo(-sHeight/2);
    }];
    
    [scanB setImage:[UIImage imageNamed:@"RecommendScan"] forState:UIControlStateNormal];
    [scanB addTarget:self action:@selector(scanRecommend:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *laodButton = [[UIButton alloc]init];
    [self.view addSubview:laodButton];
    [laodButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-left);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(height);
        make.top.mas_equalTo(_recommendTextF.mas_bottom).offset(gapM);
    }];
    laodButton.layer.masksToBounds = YES;
    laodButton.layer.cornerRadius = height/2;
    [laodButton setBackgroundColor:[UIColor colorWithHexString:@"c59d5f"]];
    [laodButton setTitle:@"注册" forState:UIControlStateNormal];
    [laodButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    laodButton.titleLabel.font = [UIFont systemFontOfSize:20*[SYCSystem PointCoefficient]];
    [laodButton addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
    
    UIFont *fontLoad = [UIFont systemFontOfSize:15.0*[SYCSystem PointCoefficient]];
    CGFloat gap1 = 34.0*[SYCSystem PointCoefficient];
    NSString *loadL = @"已有账号，去登录";
    CGSize sizeL = [loadL sizeWithAttributes:@{NSFontAttributeName:fontLoad}];
    UIButton *gotBacklaod = [[UIButton alloc]init];
    [self.view addSubview:gotBacklaod];
    [gotBacklaod mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(sizeL.width+20);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(sizeL.height+20);
        make.top.mas_equalTo(laodButton.mas_bottom).offset(gap1);
    }];
    [gotBacklaod setTitle:loadL forState:UIControlStateNormal];
    [gotBacklaod setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    gotBacklaod.titleLabel.font = fontLoad;
    [gotBacklaod addTarget:self action:@selector(gobackLoad) forControlEvents:UIControlEventTouchUpInside];
    
    _HUD = [[MBProgressHUD alloc]initWithView:self.view];
    _HUD.mode = MBProgressHUDModeText;
    _HUD.label.font = [UIFont systemFontOfSize:14*[SYCSystem PointCoefficient]];
    [self.view addSubview:_HUD];
    [_HUD hideAnimated:YES];
}
-(void)getVerfication:(UIButton*)button{
    if ([SYCSystem isMobilePhoneOrtelePhone:_acountTextF.text]) {
        __weak __typeof(self)weakSelf = self;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"正在发送验证码";
        [SYCHttpReqTool newGetVerficationCodeWithMobile:_acountTextF.text forUseCode:[NSString stringWithFormat:@"%@",@(getCaptchaRegister)] fromTerminal:SYCSystemType completion:^(NSString *resultCode, NSMutableDictionary *result) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                 [hud hideAnimated:YES];
                if ([resultCode isEqualToString:resultCodeSuccess]) {
                    NSDictionary *resultDic = [result objectForKey:resultSuccessKey];
                    if ([[resultDic objectForKey:@"code"]isEqualToString:@"000000"]) {
                        [self Countdown];
                        strongSelf.HUD.label.text = @"请注意查收验证码";
                    }else{
                        strongSelf.HUD.label.text = [resultDic objectForKey:@"msg"];
                    }
                }else{
                    strongSelf.HUD.label.text = @"请求超时，请检查网络";
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
    [_passWTextF resignFirstResponder];
    [_verficationTextF resignFirstResponder];
    [_recommendTextF resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:_acountTextF]&&textField.text.length>10) {
        textField.text = [textField.text substringToIndex:10];
    }
    if ([textField isEqual:_passWTextF]&&textField.text.length>20) {
        textField.text = [textField.text substringToIndex:20];
    }
    return YES;
}
-(void)scanRecommend:(UIButton*)button{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您未允许app访问相机，无法进入扫一扫，前往设置-隐私-相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >=8) {
                NSString *urlStr = [NSString stringWithFormat:@"prefs:root=%@",bundleID];
                NSURL *url =[NSURL URLWithString:urlStr];
                if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }
            if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                    [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL        success) {
                    }];
                }
            }
            
        }];
        
        [alertC addAction:cancelAction];
        [alertC addAction:confirmAction];
        [self presentViewController:alertC animated:YES completion:nil];
        return;
    }
    SYScanViewController *scanVC = [[SYScanViewController alloc]init];
    scanVC.isFromRegister = YES;
    scanVC.block = ^(NSString *scanResult){
        _recommendTextF.text = scanResult;
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:scanVC];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)gotoRegister{
    [_acountTextF resignFirstResponder];
    [_passWTextF resignFirstResponder];
    [_recommendTextF resignFirstResponder];
    
    if (![SYCSystem isMobilePhoneOrtelePhone:_acountTextF.text]) {
        _HUD.label.text = @"请输入正确的手机号码";
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:2.0f];
        return;
    }
    if (![SYCSystem judgeNSString:_passWTextF.text]) {
        _HUD.label.text = @"请输入密码";
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:2.0f];
        return;
    }else{
        BOOL isRight = YES;
        NSRange range = [_passWTextF.text rangeOfString:@" "];
        if (range.location != NSNotFound) {
            isRight = NO;
        }
        if (_passWTextF.text.length < 6||_passWTextF.text.length > 20) {
            isRight = NO;
        }
        if (!isRight) {
            _HUD.label.text = @"不能包含特殊字符，长度在6-20字符之间";
            [_HUD showAnimated:YES];
            [_HUD hideAnimated:YES afterDelay:2.0f];
            return;
        }
    }
    if (![SYCSystem judgeNSString:_verficationTextF.text]) {
        _HUD.label.text = @"请输入验证码";
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:2.0f];
        return;
    }
     __weak __typeof(self)weakSelf = self;
    [SYCHttpReqTool registerWithMobile:_acountTextF.text password:_passWTextF.text verficationCode:_verficationTextF.text regID:[SYCShareVersionInfo sharedVersion].regId fromTerminal:SYCSystemType QRCode:_recommendTextF.text completion:^(NSString *resultCode, NSMutableDictionary *result) {
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
                    strongSelf.HUD.label.text = @"注册成功";
                    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                    [center postNotificationName:loadAppNotify object:nil];
                    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                    if ([SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].regId]) {
                        appdelegate.isUploadRegId = YES;
                    }
                    [appdelegate setTabController];
//                    [strongSelf dismissViewControllerAnimated:YES completion:^{
//                        [appdelegate setTabController];
//                    }];
                    
                }else{
                    strongSelf.HUD.label.text = [resultDic objectForKey:@"msg"];
                }
            }else{
                strongSelf.HUD.label.text = @"注册失败";
            }
            [strongSelf.HUD showAnimated:YES];
            [strongSelf.HUD hideAnimated:YES afterDelay:2.0f];
        });
    }];
}
-(void)gobackLoad{
    if(_isFromGuider){
        SYCNewLoadViewController *load = [[SYCNewLoadViewController alloc]init];
        [self presentViewController:load animated:YES completion:nil];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_acountTextF resignFirstResponder];
    [_passWTextF resignFirstResponder];
    [_recommendTextF resignFirstResponder];
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
