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
static CGFloat infoCellHeight = 43;
static NSInteger infoCellNum = 2;
@interface SYCPayOrderInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate>
@property (nonatomic,strong)UILabel *moneyAmountLablel;
@property (nonatomic,strong)SYCPayOrderInfoModel *payOrderInfo;
@property (nonatomic,copy)NSString *defaultPayType;
@property (nonatomic,copy)NSString *assetNo;
@property (nonatomic,assign)SYCAssetType assetType;
@property (nonatomic,strong)UITableView *infoTable;
@property (nonatomic,strong)NSMutableArray *EnablePayment;
@property (nonatomic,strong)NSMutableArray *unEnablePayment;
@end

@implementation SYCPayOrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _EnablePayment = [NSMutableArray array];
    _unEnablePayment = [NSMutableArray array];
    [self getPayOrderInfo];
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
    _moneyAmountLablel.text = [NSString stringWithFormat:@"%.2f",[_payInfoModel.amount floatValue]];
    _moneyAmountLablel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_moneyAmountLablel];
    
    _infoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_moneyAmountLablel.frame)+15*[SYCSystem PointCoefficient], self.view.frame.size.width,infoCellNum*infoCellHeight) style:UITableViewStylePlain];
    _infoTable.tableFooterView = [[UIView alloc]init];
    _infoTable.delegate = self;
    _infoTable.dataSource = self;
    _infoTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_infoTable];
   
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(_infoTable.frame)+6, width, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    [self.view addSubview:lineView1];
    
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    UIButton *confirmBut = [[UIButton alloc]initWithFrame:CGRectMake(16*[SYCSystem PointCoefficient], 3*screenSize.height/5-16*[SYCSystem PointCoefficient]-50*[SYCSystem PointCoefficient], self.view.frame.size.width-32*[SYCSystem PointCoefficient], 50*[SYCSystem PointCoefficient])];
    confirmBut.backgroundColor = [UIColor colorWithHexString:@"3B7BCB"];
    [confirmBut setTitle:@"立即付款" forState:UIControlStateNormal];
    [confirmBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBut addTarget:self action:@selector(PayImmedately:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBut];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(pswPayResult:) name:dismissPswNotify object:nil];
    [center addObserver:self selector:@selector(selectPayment:) name:selectPaymentNotify object:nil];
}
-(void)getPayOrderInfo{
    NSDictionary *dic = [SYCHttpReqTool payImmediatelyInfo:[SYCShareVersionInfo sharedVersion].token payAmount:_payInfoModel.amount];
    NSDictionary *data = dic[@"result"][@"payment_info"];
    [SYCPayOrderInfoModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"payTypes":@"SYCPayTypeModel"};
    }];
    _payOrderInfo = [SYCPayOrderInfoModel mj_objectWithKeyValues:data];
    
    for (SYCPayTypeModel *model in _payOrderInfo.payTypes) {
        if (model.defaultPay) {
            _defaultPayType = model.assetName;
            _assetType = model.assetType;
            _assetNo = model.assetName;
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
//    passwVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    passwVC.transitioningDelegate = self;
    passwVC.presentingMainVC = _presentingMainVC;
    SYCPayOrderConfirmModel *confirmPayModel = [[SYCPayOrderConfirmModel alloc]init];
    confirmPayModel.assetType = [NSString stringWithFormat:@"%ld",_assetType];
    confirmPayModel.assetNo = _assetNo;
    if (_isPreOrderPay) {
        
    }else{
        confirmPayModel.payAmount =  _moneyAmountLablel.text;
        confirmPayModel.orderSubject = _payInfoModel.desc;
        confirmPayModel.merchantId = _payInfoModel.merchantID;
    }
    passwVC.confirmPayModel = confirmPayModel;
    passwVC.isPreOrderPay = _isPreOrderPay;
    [self presentViewController:passwVC animated:YES completion:nil];
}

-(void)dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)pswPayResult:(NSNotification*)notify{
    [self dismissViewControllerAnimated:YES completion:^{
         [[NSNotificationCenter defaultCenter]postNotificationName:payAndShowNotify object:notify.object userInfo:notify.userInfo];
    }];
    
}
-(void)selectPayment:(NSNotification*)notify{
    SYCPayTypeModel *model = (SYCPayTypeModel *)notify.object;
    _assetNo = model.asserNo;
    _assetType = model.assetType;
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
    cell.textLabel.textColor = [UIColor colorWithHexString:@"444444"];
//    cell.detailTextLabel.font = [UIFont systemFontOfSize:19*[SYCSystem PointCoefficient]];
//    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"999999"];
    if (indexPath.row == 0) {
        NSString *text = @"付款商家：";
        cell.textLabel.text = [text stringByAppendingString:_payInfoModel.desc];
    
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cell.textLabel.text];
        [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17*[SYCSystem PointCoefficient]],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]} range:[cell.textLabel.text rangeOfString:_payInfoModel.desc]];
        cell.textLabel.attributedText = str;
    }else if (indexPath.row == 1){
        NSString *text =@"付款方式：";
        cell.textLabel.text = [text stringByAppendingString:_defaultPayType];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cell.textLabel.text];
        [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17*[SYCSystem PointCoefficient]],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]} range:[cell.textLabel.text rangeOfString:_defaultPayType]];
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
        paymentVC.unEnnalepaymentArr = _unEnablePayment;
        paymentVC.EnnalepaymentArr = _EnablePayment;
        paymentVC.modalPresentationStyle = UIModalPresentationCustom;
        paymentVC.transitioningDelegate = self;
        [self presentViewController:paymentVC animated:YES completion:nil];
    }
}
-(UIPresentationController*)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    SYCPresentationController *presentation = [[SYCPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    presentation.backgroundColor = [UIColor colorWithHexString:@"000000"];
    presentation.backgroundAlpha = 0.5;
    presentation.contentViewRect = CGRectMake(0, 2*screenSize.height/5, screenSize.width,  3*screenSize.height/5);
    return presentation;
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
