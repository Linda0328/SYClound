//
//  SYCPaymentViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/5/2.
//
//

#import "SYCPaymentViewController.h"
#import "HexColor.h"
#import "SYCSystem.h"
#import "SYCPayTypeModel.h"
#import "SYCPresentationController.h"
#import "SYCBlindYTKViewController.h"
#import "SYCHttpReqTool.h"
#import "SYCPayOrderInfoModel.h"
#import "MJExtension.h"
//static CGFloat infoCellHeight = 43;
NSString *const selectIndex = @"selectedIndex";
@interface SYCPaymentViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate>
@property (nonatomic,strong)UITableView *paymentTable;
@property (nonatomic,assign)BOOL isRefresh;
@property (nonatomic,strong)SYCPayTypeModel *model;
@end

@implementation SYCPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"----%ld",(long)_selectedCellIndex.row);
    
    _isRefresh = NO;
    // Do any additional setup after loading the view.
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 45*[SYCSystem PointCoefficient])];
    [backBut setImage:[UIImage imageNamed:@"pay_back"] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBut];
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 240*[SYCSystem PointCoefficient], 17.0*[SYCSystem PointCoefficient])];
    titleLable.numberOfLines = 1;
    titleLable.font = [UIFont systemFontOfSize:17.0*[SYCSystem PointCoefficient]];
    titleLable.textColor = [UIColor colorWithHexString:@"444444"];
    titleLable.center = CGPointMake(self.view.center.x, 22.5);
    titleLable.text = @"选择支付方式";
    titleLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLable];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45*[SYCSystem PointCoefficient],screenSize.width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    [self.view addSubview:lineView];
    
    _paymentTable = [[UITableView alloc]initWithFrame:CGRectMake(0,45, self.view.frame.size.width, 3*screenSize.height/5-45) style:UITableViewStylePlain];
    _paymentTable.tableFooterView = [[UIView alloc]init];
    _paymentTable.delegate = self;
    _paymentTable.dataSource = self;
    _paymentTable.showsVerticalScrollIndicator = NO;
    _paymentTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_paymentTable];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(dismiss:) name:refreshPaymentNotify object:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1+[_unEnnalepaymentArr count]+[_EnnalepaymentArr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*[SYCSystem PointCoefficient];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.detailTextLabel.text = nil;
    cell.textLabel.font = [UIFont systemFontOfSize:15*[SYCSystem PointCoefficient]];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"444444"];
    NSString *imageStr = nil;
    if (indexPath.row < [_EnnalepaymentArr count]) {
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"paymentselected"]];
        SYCPayTypeModel *model = [_EnnalepaymentArr objectAtIndex:indexPath.row];
        if (model.assetType == 0) {
            imageStr = model.isEnabled?@"consumeImg":@"consumeImgDisable";
        }else if (model.assetType == 1) {
            imageStr = model.isEnabled?@"LCTImg":@"LCTImgDisable";
        }else if (model.assetType == 2){
            imageStr = model.isEnabled?@"YKTimg":@"YKTimgDisable";
        }
        if (_selectedCellIndex.row == indexPath.row) {
            cell.accessoryView.hidden = NO;
            _model = model;
        }else{
           cell.accessoryView.hidden = YES;
        }
        if (!model.isEnabled) {
            cell.textLabel.textColor = [UIColor colorWithHexString:@"dddddd"];
            cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"dddddd"];
            cell.detailTextLabel.text = model.tips;
        }
        cell.textLabel.text = model.assetName;
    }else{
        if (indexPath.row == [_EnnalepaymentArr count] ) {
            imageStr = @"addYKT";
            cell.textLabel.text = @"绑定生源一卡通";
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            if ([_unEnnalepaymentArr count]>0) {
                NSInteger cout = indexPath.row - [_EnnalepaymentArr count] - 1;
                SYCPayTypeModel *model = [_unEnnalepaymentArr objectAtIndex:cout];
                if (model.assetType == 0) {
                    imageStr = model.isEnabled?@"consumeImg":@"consumeImgDisable";
                }else if (model.assetType == 1) {
                    imageStr = model.isEnabled?@"LCTImg":@"LCTImgDisable";
                }else if (model.assetType == 2){
                    imageStr = model.isEnabled?@"YKTimg":@"YKTimgDisable";
                }
                if (!model.isEnabled) {
                    cell.textLabel.textColor = [UIColor colorWithHexString:@"dddddd"];
                    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"dddddd"];
                    cell.detailTextLabel.text = model.tips;
                }
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = model.assetName;
            }
           
        }
    }
    [cell.imageView setImage:[UIImage imageNamed:imageStr]];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < [_EnnalepaymentArr count]) {
        SYCPayTypeModel *model = [_EnnalepaymentArr objectAtIndex:indexPath.row];
        if (!model.isEnabled) {
            return;
        }
        if(_selectedCellIndex !=indexPath){
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryView.hidden = NO;
            UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:_selectedCellIndex];
            selectedCell.accessoryView.hidden = YES;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:selectPaymentNotify object:model userInfo:@{selectIndex : indexPath}];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (indexPath.row == [_EnnalepaymentArr count]){
        SYCBlindYTKViewController *SYCBlind = [[SYCBlindYTKViewController alloc]init];
        SYCBlind.modalPresentationStyle = UIModalPresentationCustom;
        SYCBlind.transitioningDelegate = self;
        [self presentViewController:SYCBlind animated:YES completion:nil];
    }
}
-(void)dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIPresentationController*)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    SYCPresentationController *presentation = [[SYCPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    presentation.backgroundColor = [UIColor colorWithHexString:@"000000"];
    presentation.backgroundAlpha = 0.1;
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
