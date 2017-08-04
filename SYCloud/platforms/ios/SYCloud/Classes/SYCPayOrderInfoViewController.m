//
//  SYCPayOrderInfoViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/4/28.
//
//

#import "SYCPayOrderInfoViewController.h"
#import "SYCSystem.h"
#import "HexColor.h"
#import "SYCHttpReqTool.h"
#import "SYCShareVersionInfo.h"
#import "SYCPayTypeModel.h"
#import "SYCPayOrderInfoModel.h"
#import "MJExtension.h"
#import "SYCPasswordViewController.h"
#import "SYCPresentationController.h"
#import "SYCPaymentViewController.h"
#import "SYCPresentionAnimatedTransitioning.h"
static CGFloat infoCellHeight = 43;
static NSInteger infoCellNum = 2;
@interface SYCPayOrderInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate>
@property (nonatomic,strong)UILabel *moneyAmountLablel;
@property (nonatomic,strong)SYCPayOrderInfoModel *payOrderInfo;
@property (nonatomic,copy)NSString *defaultPayType;
@property (nonatomic,copy)NSString *desc;
@property (nonatomic,copy)NSString *assetNo;
@property (nonatomic,assign)SYCAssetType assetType;
@property (nonatomic,strong)UITableView *infoTable;
@property (nonatomic,strong)NSMutableArray *EnablePayment;
@property (nonatomic,strong)NSMutableArray *unEnablePayment;
@property (nonatomic,strong)NSIndexPath *selectedIndex;
@property (nonatomic,copy)NSString *amount;
@property (nonatomic,strong)UIButton *confirmBut;
@property (nonatomic,copy)NSString *couponID;
@property (nonatomic,copy)NSString *couponDesc;
@end

@implementation SYCPayOrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _EnablePayment = [NSMutableArray array];
    _unEnablePayment = [NSMutableArray array];
    _selectedIndex = [NSIndexPath indexPathForRow:1 inSection:0];
    if ([_payMentType isEqualToString:payMentTypeImme]) {
        [self getPayOrderInfo:_requestResultDic];
    }else if([_payMentType isEqualToString:payMentTypeScan]){
        [self getScanPayOrderInfo:_requestResultDic];
    }else if([_payMentType isEqualToString:payMentTypeCode]){
        [self getCodePayOrderInfo:_requestResultDic];
    }else if([_payMentType isEqualToString:payMentTypeSDK]){
        [self getSDKPayOrderInfo:_requestResultDic];
    }
   
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 45*[SYCSystem PointCoefficient])];
    [backBut setImage:[UIImage imageNamed:@"payInfoCancel"] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBut];
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 240*[SYCSystem PointCoefficient], 17.0*[SYCSystem PointCoefficient])];
    titleLable.numberOfLines = 1;
    titleLable.font = [UIFont systemFontOfSize:17.0*[SYCSystem PointCoefficient]];
    titleLable.textColor = [UIColor colorWithHexString:@"444444"];
    titleLable.center = CGPointMake(self.view.center.x, backBut.center.y);
    titleLable.text = @"确认付款";
    titleLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLable];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45*[SYCSystem PointCoefficient], width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    [self.view addSubview:lineView];
    
    _moneyAmountLablel = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lineView.frame)+15*[SYCSystem PointCoefficient], 200*[SYCSystem PointCoefficient], 27.5*[SYCSystem PointCoefficient])];
    _moneyAmountLablel.numberOfLines = 1;
    _moneyAmountLablel.font = [UIFont systemFontOfSize:27.5*[SYCSystem PointCoefficient]];
    _moneyAmountLablel.textColor = [UIColor colorWithHexString:@"3B7BCB"];
    _moneyAmountLablel.center = CGPointMake(self.view.center.x, lineView.center.y+42.5*[SYCSystem PointCoefficient]);
    _moneyAmountLablel.text = [NSString stringWithFormat:@"¥%.2f",[_amount floatValue]];
    _moneyAmountLablel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_moneyAmountLablel];
    
    _infoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_moneyAmountLablel.frame)+15*[SYCSystem PointCoefficient], self.view.frame.size.width,infoCellNum*infoCellHeight) style:UITableViewStylePlain];
    _infoTable.tableFooterView = [[UIView alloc]init];
    _infoTable.delegate = self;
    _infoTable.dataSource = self;
    _infoTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_infoTable];
   
//    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(_infoTable.frame)+6, width, 0.5)];
//    lineView1.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
//    [self.view addSubview:lineView1];
    
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    _confirmBut = [[UIButton alloc]initWithFrame:CGRectMake(16*[SYCSystem PointCoefficient], 3*screenSize.height/5-16*[SYCSystem PointCoefficient]-50*[SYCSystem PointCoefficient], self.view.frame.size.width-32*[SYCSystem PointCoefficient], 50*[SYCSystem PointCoefficient])];
    _confirmBut.backgroundColor = [UIColor colorWithHexString:@"3B7BCB"];
    [_confirmBut setTitle:@"立即付款" forState:UIControlStateNormal];
    [_confirmBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBut addTarget:self action:@selector(PayImmedately:) forControlEvents:UIControlEventTouchUpInside];
    if ([SYCSystem judgeNSString:_defaultPayType]) {
        _confirmBut.enabled = YES;
    }else{
        _confirmBut.enabled = NO;
        _confirmBut.backgroundColor = [UIColor colorWithHexString:@"999999"];
    }
    _confirmBut.layer.masksToBounds = YES;
    _confirmBut.layer.cornerRadius = 10.0f;
    [self.view addSubview:_confirmBut];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(pswPayResult:) name:dismissPswNotify object:nil];
    [center addObserver:self selector:@selector(selectPayment:) name:selectPaymentNotify object:nil];
}
-(void)getPayOrderInfo:(NSDictionary*)dic{
    _desc = _payInfoModel.desc;
    _amount = _payInfoModel.payAmount;
    [self dealDataToModel:dic];
}
-(void)getScanPayOrderInfo:(NSDictionary*)dic{
    
    _desc = dic[@"result"][@"payment_info"][@"orderDesc"];
    _amount = dic[@"result"][@"payment_info"][@"payAmount"];
    [self dealDataToModel:dic];
}
-(void)getCodePayOrderInfo:(NSDictionary*)dic{
   
    _desc = dic[@"result"][@"payment_info"][@"orderDesc"];
    _amount = dic[@"result"][@"payment_info"][@"payAmount"];
    [self dealDataToModel:dic];
}
-(void)getSDKPayOrderInfo:(NSDictionary*)dic{
    _desc = dic[@"result"][@"payment_info"][@"orderDesc"];
    _amount = dic[@"result"][@"payment_info"][@"payAmount"];
    [self dealDataToModel:dic];
}
-(void)dealDataToModel:(NSDictionary*)dic{
    NSDictionary *data = dic[@"result"][@"payment_info"];
    [SYCPayOrderInfoModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"payTypes":@"SYCPayTypeModel"};
    }];
    _payOrderInfo = [SYCPayOrderInfoModel mj_objectWithKeyValues:data];
    
    for (SYCPayTypeModel *model in _payOrderInfo.payTypes) {
        if (model.defaultPay) {
            _defaultPayType = model.assetName;
            _assetType = model.assetType;
            _assetNo = model.assetNo;
            [_EnablePayment addObject:model];
        }
        
    }
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
    [_infoTable reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    for (SYCPayTypeModel *model in _payOrderInfo.payTypes) {
        if (model.isEnabled) {
            if (!model.defaultPay) {
                [_EnablePayment addObject:model];
            }
        }else{
            [_unEnablePayment addObject:model];
        }
    }
}
-(void)PayImmedately:(id)sender{
    SYCPasswordViewController *passwVC = [[SYCPasswordViewController alloc]init];
    passwVC.modalPresentationStyle = UIModalPresentationCustom;
    passwVC.transitioningDelegate = self;
    passwVC.presentingMainVC = _presentingMainVC;
    SYCPayOrderConfirmModel *confirmPayModel = [[SYCPayOrderConfirmModel alloc]init];
    confirmPayModel.assetType = [NSString stringWithFormat:@"%ld",(long)_assetType];
    confirmPayModel.assetNo = _assetNo;
    passwVC.needSetPassword = _payOrderInfo.resetPayPassword;
    if (_isPreOrderPay) {
        confirmPayModel.partner = _payOrderInfo.partner;
        confirmPayModel.prepayId = _payOrderInfo.orderNo;
    }else{
        confirmPayModel.merchantId = _payInfoModel.merchantID;
        confirmPayModel.payAmount =  _isPreOrderPay?_amount:_payInfoModel.payAmount;
        confirmPayModel.orderSubject = _desc;
        confirmPayModel.exclAmount = _payInfoModel.exclAmount;
    }
    confirmPayModel.couponId = _couponID;
    passwVC.confirmPayModel = confirmPayModel;
    passwVC.isPreOrderPay = _isPreOrderPay;
    passwVC.paymentType = _payMentType;
    passwVC.needSetPassword = _payOrderInfo.resetPayPassword;
    [self presentViewController:passwVC animated:YES completion:nil];
}

-(void)dismiss:(id)sender{
    NSMutableDictionary *payCallback = [NSMutableDictionary dictionary];
    [payCallback setObject:payment_CancelCode forKey:@"resultCode"];
    [payCallback setObject:payment_CancelMessage forKey:@"resultContent"];
    [payCallback setObject:[NSString stringWithFormat:@"%ld",(long)_assetType] forKey:@"paymentMethod"];
    if ([SYCSystem judgeNSString:_assetNo]) {
        [payCallback setObject:_assetNo forKey:@"asserNo"];
    }
    NSDictionary *resultDic = @{PayResultCallback:payCallback,
                                PreOrderPay:_payMentType
                                };
    [self dismissViewControllerAnimated:YES completion:^{
         [[NSNotificationCenter defaultCenter]postNotificationName:payAndShowNotify object:_presentingMainVC userInfo:resultDic];
    }];
}
-(void)pswPayResult:(NSNotification*)notify{
    [self dismissViewControllerAnimated:YES completion:^{
         [[NSNotificationCenter defaultCenter]postNotificationName:payAndShowNotify object:notify.object userInfo:notify.userInfo];
    }];
    
}
-(void)selectPayment:(NSNotification*)notify{
    SYCPayTypeModel *model = (SYCPayTypeModel *)notify.object;
    _assetNo = model.assetNo;
    _assetType = model.assetType;
    _defaultPayType = model.assetName;
    _selectedIndex = [notify.userInfo objectForKey:selectIndex];
    if (!_confirmBut.enabled) {
        _confirmBut.backgroundColor = [UIColor colorWithHexString:@"3B7BCB"];
        _confirmBut.enabled = YES;
    }
    
    [_infoTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return infoCellNum;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return infoCellHeight*[SYCSystem PointCoefficient];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15*[SYCSystem PointCoefficient]];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"999999"];
//    cell.detailTextLabel.font = [UIFont systemFontOfSize:19*[SYCSystem PointCoefficient]];
//    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"999999"];
    if (indexPath.row == 0) {
        NSString *text = @"付款商家：";
        if ([SYCSystem judgeNSString:_desc]) {
            cell.textLabel.text = [text stringByAppendingString:_desc];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cell.textLabel.text];
            [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17*[SYCSystem PointCoefficient]],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"444444"]} range:[cell.textLabel.text rangeOfString:_desc]];
            cell.textLabel.attributedText = str;
        }else{
            cell.textLabel.text = text;
        }
    }else if (indexPath.row == 1){
        NSString *text =@"付款方式：";
        if (![SYCSystem judgeNSString:_defaultPayType]) {
           _defaultPayType = @"选择支付方式";
        }
        cell.textLabel.text = [text stringByAppendingString:_defaultPayType];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cell.textLabel.text];
        [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17*[SYCSystem PointCoefficient]],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"444444"]} range:[cell.textLabel.text rangeOfString:_defaultPayType]];
        cell.textLabel.attributedText = str;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 16*[SYCSystem PointCoefficient], 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        SYCPaymentViewController *paymentVC = [[SYCPaymentViewController alloc]init];
        
        if ([_payMentType isEqualToString:payMentTypeImme]) {
            paymentVC.payAmount = _payInfoModel.amount;
        }else if([_payMentType isEqualToString:payMentTypeScan]){
            paymentVC.qrCode = _qrcode;
        }else if([_payMentType isEqualToString:payMentTypeCode]){
            paymentVC.payCode = _payCode;
        }
        paymentVC.unEnnalepaymentArr = _unEnablePayment;
        paymentVC.EnnalepaymentArr = _EnablePayment;
        paymentVC.paymentType = _payMentType;
        paymentVC.modalPresentationStyle = UIModalPresentationCustom;
        paymentVC.transitioningDelegate = self;
        paymentVC.selectedCellIndex = _selectedIndex;
        [self presentViewController:paymentVC animated:YES completion:nil];
    }
}
-(UIPresentationController*)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    SYCPresentationController *presentation = [[SYCPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    presentation.backgroundColor = [UIColor colorWithHexString:@"000000"];
    presentation.backgroundAlpha = 0.1;
    presentation.contentViewRect = CGRectMake(0, 2*screenSize.height/5, screenSize.width,  3*screenSize.height/5);
    return presentation;
}
///*
// * 由返回的对象控制Presented时的动画；
// */
//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    SYCPresentionAnimatedTransitioning *anim = [[SYCPresentionAnimatedTransitioning alloc] init];
//    anim.presented = YES;
//    return anim;
//}
//
///*
// * 由返回的控制器控制dismissed时的动画；
// */
//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    SYCPresentionAnimatedTransitioning *anim = [[SYCPresentionAnimatedTransitioning alloc] init];
//    anim.presented = NO;
//    return anim;
//}
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
