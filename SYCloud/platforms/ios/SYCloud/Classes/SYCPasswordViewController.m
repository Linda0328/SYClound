//
//  SYCPasswordViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/4/21.
//
//

#import "SYCPasswordViewController.h"
#import "HexColor.h"
#import "SYCSystem.h"
#import "SYCHttpReqTool.h"
#import "MBProgressHUD.h"
#import "SYCPaymentLoadingHUD.h"
#import "SYCPaymentSuccessHUD.h"
#import "SYCPaymentFailHUD.h"
#import "SYCShareVersionInfo.h"
#import "SYCContentViewController.h"
static const CGFloat passWDotRadius = 5;
static const NSInteger passWNum = 6;

@interface SYCPasswordViewController ()<UITextFieldDelegate>
@property (nonnull,strong)NSMutableArray *dotArr;
@property (nonatomic,strong)UILabel *titleLable;
@property (nonatomic,assign)BOOL isSetTwice;
@property (nonatomic,copy)NSString *firstPsw;
@property (nonatomic,strong)UIImageView *payResultIMG;
@property (nonatomic,strong)UILabel *resultMSGL;
@property (nonatomic,strong)NSMutableArray *lineArr;
@property (nonatomic,strong)NSDictionary *payResultDic;
@property (nonatomic,strong)UITextField *textF;
@end

@implementation SYCPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _firstPsw = [[NSString alloc]init];
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 45*[SYCSystem PointCoefficient])];
    [backBut setImage:[UIImage imageNamed:@"pay_back"] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBut];
    _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 240*[SYCSystem PointCoefficient], 17.0*[SYCSystem PointCoefficient])];
    _titleLable.numberOfLines = 1;
    _titleLable.font = [UIFont systemFontOfSize:17.0*[SYCSystem PointCoefficient]];
    _titleLable.textColor = [UIColor colorWithHexString:@"444444"];
    _titleLable.center = CGPointMake(self.view.center.x, backBut.center.y);
    _titleLable.text = _needSetPassword?@"请设置您的支付密码":@"请输入支付密码";
    _titleLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLable];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45*[SYCSystem PointCoefficient], width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    [self.view addSubview:lineView];
    if (_showAmount) {
        UILabel *lable0 = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lineView.frame)+19*[SYCSystem PointCoefficient], 200*[SYCSystem PointCoefficient], 17*[SYCSystem PointCoefficient])];
        lable0.numberOfLines = 1;
        lable0.font = [UIFont systemFontOfSize:17.0*[SYCSystem PointCoefficient]];
        lable0.textColor = [UIColor colorWithHexString:@"444444"];
        lable0.center = CGPointMake(self.view.center.x, lineView.center.y+27.5*[SYCSystem PointCoefficient]);
        lable0.text = _pswModel.title;
        lable0.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lable0];
    }
//    CGFloat isPhone5Gap = [[UIScreen mainScreen] bounds].size.height < 569?-15:15;
    CGFloat gap = 15.0f;
    _textF = [[UITextField alloc]initWithFrame:CGRectMake(40*[SYCSystem PointCoefficient], CGRectGetMaxY(_titleLable.frame)+2*19*[SYCSystem PointCoefficient]+17*[SYCSystem PointCoefficient]+gap*[SYCSystem PointCoefficient], width-80*[SYCSystem PointCoefficient],45*[SYCSystem PointCoefficient])];
    _textF.delegate = self;
    _textF.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
    _textF.layer.borderWidth = 1;
    _textF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textF.keyboardType = UIKeyboardTypeNumberPad;
    [_textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _textF.backgroundColor = [UIColor whiteColor];
    //输入的文字颜色为白色
    _textF.textColor = [UIColor whiteColor];
    //输入框光标的颜色为白色
    _textF.tintColor = [UIColor whiteColor];
    [self.view addSubview:_textF];
    [_textF becomeFirstResponder];
    [self averagePassWTextF:_textF];
    
    UIImage *paySuccess = [UIImage imageNamed:@"paySuccess"];
    _payResultIMG = [[UIImageView alloc]initWithImage:paySuccess];
    _payResultIMG.frame = CGRectMake(0, 0, paySuccess.size.width, paySuccess.size.height);
    _payResultIMG.center = CGPointMake(self.view.center.x, 4*self.view.center.y/5);
    [self.view addSubview:_payResultIMG];
    _payResultIMG.hidden = YES;
    
    _resultMSGL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.view.frame)-10, 15*[SYCSystem PointCoefficient])];
    _resultMSGL.numberOfLines = 0;
//    _resultMSGL.lineBreakMode = NSLineBreakByCharWrapping;
    _resultMSGL.font = [UIFont systemFontOfSize:13.0*[SYCSystem PointCoefficient]];
    _resultMSGL.textColor = [UIColor colorWithHexString:@"444444"];
    _resultMSGL.center = CGPointMake(self.view.center.x, _payResultIMG.center.y);
    _resultMSGL.text = @"支付成功！";
    _resultMSGL.textAlignment = NSTextAlignmentCenter;
    _resultMSGL.hidden = YES;
    [self.view addSubview:_resultMSGL];
    _confirmPayModel.token = [SYCShareVersionInfo sharedVersion].token;

    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"变化%@", string);
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= passWNum) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        NSLog(@"输入的字符个数大于6，忽略输入");
        return NO;
    } else {
        return YES;
    }
}

/**
 *  重置显示的点
 */
- (void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    for (UIView *dotView in self.dotArr) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.dotArr objectAtIndex:i]).hidden = NO;
    }
    if (textField.text.length == passWNum) {
        NSLog(@"输入完毕");
        [textField resignFirstResponder];
        if (!_needSetPassword) {
            [SYCPaymentLoadingHUD showIn:self.view];
        }
        __block SYCPasswordViewController *weakSelf = self;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0* NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [weakSelf finishEditing:textField];
        });
    }
}
-(void)finishEditing:(UITextField*)textField{
   
    if (_isSetTwice) {
        if ([_firstPsw isEqualToString:textField.text]) {
            NSString *md5Psw = [SYCSystem md5:textField.text];
            __weak __typeof(self)weakSelf = self;
            [SYCHttpReqTool PswSet:md5Psw completion:^(NSString *resultCode, BOOL resetPsw) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if ([resultCode isEqualToString:resultCodeSuccess]) {
                    
                    if(resetPsw){
                        [strongSelf completePay:textField];
                    }else{
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strongSelf.presentationController.containerView animated:YES];
                        hud.label.text = @"支付密码设置失败";
                        [hud showAnimated:YES];
                        [hud hideAnimated:YES afterDelay:3.0];
                    }

                }
            }];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.presentationController.containerView animated:YES];
            hud.label.text = @"两次输入密码不一致";
            textField.text = nil;
            for (UIView *dotView in self.dotArr) {
                dotView.hidden = YES;
            }
            [textField becomeFirstResponder];
            [hud showAnimated:YES];
            [hud hideAnimated:YES afterDelay:2.0];
        }
    }
    if (_needSetPassword&&!_isSetTwice) {
        _firstPsw = textField.text;
        _isSetTwice = YES;
        [textField becomeFirstResponder];
        _titleLable.text = @"请再次输入您的支付密码";
        for (int i = 0; i < textField.text.length; i++) {
            ((UIView *)[self.dotArr objectAtIndex:i]).hidden = YES;
        }
        textField.text = nil;
    }
    if (!_needSetPassword) {
        [self completePay:textField];
    }
}
-(void)completePay:(UITextField*)textField {
    textField.hidden = YES;
    for (UIView *dotView in self.dotArr) {
        dotView.hidden = YES;
    }
    for (UIView *dotView in self.lineArr) {
        dotView.hidden = YES;
    }
    if (_isTranslate) {
        [self readyToPay:textField];
    }else{
        _confirmPayModel.payPassword = [SYCSystem md5:textField.text];
        [self readyToConfirmPay:textField];
    }

    

}
/**
 * /禁止可被粘贴复制
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}
-(void)dismiss:(id)sender{
    [_textF resignFirstResponder];
    if (_isSetTwice) {
        _titleLable.text = @"请设置您的支付密码";
        _isSetTwice = NO;
    }else{
       [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
-(void)averagePassWTextF:(UITextField*)textF{
    CGFloat equalwidth = CGRectGetWidth(textF.frame)/passWNum;
    CGFloat height = CGRectGetHeight(textF.frame);
    self.lineArr = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0 ; i < passWNum -1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(textF.frame) + (i + 1) * equalwidth, CGRectGetMinY(textF.frame), 1,height)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
        [self.view addSubview:lineView];
        [self.lineArr addObject:lineView];
    }
    self.dotArr = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < passWNum; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(textF.frame) + (equalwidth-2*passWDotRadius) / 2 + i * equalwidth, CGRectGetMinY(textF.frame) + (height - 2*passWDotRadius)/ 2, 2*passWDotRadius, 2*passWDotRadius)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = passWDotRadius;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self.view addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotArr addObject:dotView];
    }
}
-(void)readyToConfirmPay:(UITextField*)textF{
    
    _titleLable.text = @"支付结果";
    __weak __typeof(self)weakSelf = self;
    [SYCHttpReqTool payImmediatelyConfirm:_confirmPayModel prePayOrder:_isPreOrderPay completion:^(NSString *resultCode, NSMutableDictionary *result) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([resultCode isEqualToString:resultCodeSuccess]) {
            if ([[result[resultSuccessKey] objectForKey:@"code"]isEqualToString:@"000000"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                [SYCPaymentLoadingHUD hideIn:self.view];
                strongSelf.resultMSGL.text = @"支付成功！";
                strongSelf.resultMSGL.hidden = NO;
                [SYCPaymentSuccessHUD showIn:self.view];
                });
                __block SYCPasswordViewController *weakSelf = self;
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5* NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [weakSelf hideAndDismissAllPresented:result[resultSuccessKey]];
                });
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                [SYCPaymentLoadingHUD hideIn:self.view];
                _resultMSGL.text = [result[resultSuccessKey] objectForKey:@"msg"];
                _resultMSGL.hidden = NO;
                [SYCPaymentFailHUD showIn:self.view];
                });
                __block SYCPasswordViewController *weakSelf = self;
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2* NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [weakSelf passwordUncorrect:textF];
                });
            }

        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SYCPaymentLoadingHUD hideIn:self.view];
                _resultMSGL.text = [SYCSystem connectedToNetwork]?@"请求超时，支付失败":@"网络不给力";
                _resultMSGL.hidden = NO;
                [SYCPaymentFailHUD showIn:self.view];
            });
            __block SYCPasswordViewController *weakSelf = self;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2* NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [weakSelf passwordUncorrect:textF];
            });
        }
       
    }];
    
}
-(void)readyToPay:(UITextField*)textF{
    NSString *md5Psw = [SYCSystem md5:textF.text];
    _titleLable.text = @"支付结果";
    __weak __typeof(self)weakSelf = self;
    [SYCHttpReqTool PayPswResponseUrl:_pswModel.url pswParam:_pswModel.psw password:md5Psw parmaDic:_pswModel.param completion:^(NSString *resultCode, BOOL success, NSString *msg, NSDictionary *successDic) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([resultCode isEqualToString:resultCodeSuccess]) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SYCPaymentLoadingHUD hideIn:strongSelf.view];
                    strongSelf.resultMSGL.text = @"成功！";
                    strongSelf.resultMSGL.hidden = NO;
                    [SYCPaymentSuccessHUD showIn:strongSelf.view];
                });
                __block SYCPasswordViewController *weakSelf = self;
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5* NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [weakSelf hideAndDismiss:successDic];
                });

            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SYCPaymentLoadingHUD hideIn:strongSelf.view];
                    strongSelf.resultMSGL.text = msg;
                    strongSelf.resultMSGL.hidden = NO;
                    [SYCPaymentFailHUD showIn:strongSelf.view];
                });
                __block SYCPasswordViewController *weakSelf = self;
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0* NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [weakSelf passwordUncorrect:textF];
                });

            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SYCPaymentLoadingHUD hideIn:strongSelf.view];
                strongSelf.resultMSGL.text = [SYCSystem connectedToNetwork]?@"请求超时，支付失败":@"网络不给力";
                strongSelf.resultMSGL.hidden = NO;
                [SYCPaymentFailHUD showIn:strongSelf.view];
            });
            __block SYCPasswordViewController *weakSelf = self;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0* NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [weakSelf passwordUncorrect:textF];
            });
            
        }
    }];
    
    
}
-(void)passwordUncorrect:(UITextField*)textF{
    [SYCPaymentFailHUD hideIn:self.view];
    textF.hidden = NO;
    textF.text = nil;
    for (UIView *dotView in self.lineArr) {
        dotView.hidden = NO;
    }
    _resultMSGL.hidden = YES;
    _titleLable.text = @"请输入支付密码";
    [textF becomeFirstResponder];
}
-(void)hideAndDismiss:(NSDictionary*)successDic{
    
    [SYCPaymentSuccessHUD hideIn:self.view];
    __weak __typeof(self)weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
       [[NSNotificationCenter defaultCenter]postNotificationName:paySuccessNotify object:strongSelf.presentingMainVC userInfo:successDic];
    }];
    
}
-(void)hideAndDismissAllPresented:(NSDictionary*)dic{
    [SYCPaymentSuccessHUD hideIn:self.view];
//    [SYCPaymentFailHUD hideIn:self.view];
    NSMutableDictionary *payCallback = [NSMutableDictionary dictionary];
    NSString *code = nil;
    NSString *message = nil;
    if ([dic[@"code"] isEqualToString:@"000000"]) {
        code = payment_SuccessCode;
        message = payment_SuccessMessage;
        [payCallback setObject:dic[@"result"][@"tradeNo"] forKey:@"tradeNo"];
    }else{
        code = payment_FailCode;
        message = payment_CancelMessage;
    }
    [payCallback setObject:code forKey:@"resultCode"];
    [payCallback setObject:message forKey:@"resultContent"];
    if (!_isPreOrderPay) {
        [payCallback setObject:_confirmPayModel.payAmount forKey:@"orderAmount"];
         [payCallback setObject:_confirmPayModel.orderSubject forKey:@"orderDesc"];
    }
    [payCallback setObject:_confirmPayModel.assetType forKey:@"paymentMethod"];
    [payCallback setObject:_confirmPayModel.assetNo forKey:@"assetNo"];
    NSDictionary *resultDic = @{PayResultCallback:payCallback,
                                PreOrderPay:_paymentType
    };
    [self dismissViewControllerAnimated:YES completion:^{
        __block SYCPasswordViewController *weakSelf = self;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
             [[NSNotificationCenter defaultCenter]postNotificationName:dismissPswNotify object:weakSelf.presentingMainVC userInfo:resultDic];
        });
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
