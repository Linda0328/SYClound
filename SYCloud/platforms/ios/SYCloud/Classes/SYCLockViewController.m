//
//  SYCLockViewController.m
//  SYCloud
//
//  Created by 文清 on 2018/5/22.
//

#import "SYCLockViewController.h"
#import "SYCPassWordView.h"
#import "HexColor.h"
#import "SYCShowPasswordView.h"
#import "Masonry.h"
#import "SYCSystem.h"
#import "UILabel+SYCNavigationTitle.h"
@interface SYCLockViewController ()
@property (nonatomic,strong)UILabel *noticeL;
@property (nonatomic,assign)BOOL firstDraw;
@property (nonatomic,copy)NSString *passWord;
@end

@implementation SYCLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _firstDraw = YES;
    NSMutableArray *leftItems = [NSMutableArray array];
    NSMutableArray *rightItems = [NSMutableArray array];
    UILabel *titleLab = [UILabel navTitle:@"设置手势密码" TitleColor:[UIColor blackColor] titleFont:[UIFont systemFontOfSize:20]];
    self.navigationItem.titleView = titleLab;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40*[SYCSystem PointCoefficient], 40*[SYCSystem PointCoefficient])];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToLast) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    [rightItems addObject:item];
    self.navigationItem.rightBarButtonItems = rightItems;
    UIBarButtonItem * negativeSpacer = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    [leftItems addObject:negativeSpacer];
    self.navigationItem.leftBarButtonItems = leftItems;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    SYCShowPasswordView *showPassV = [[SYCShowPasswordView alloc]init];
    showPassV.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [self.view addSubview:showPassV];
    [showPassV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20*[SYCSystem PointCoefficient]);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(80*[SYCSystem PointCoefficient]);
        make.height.mas_equalTo(80*[SYCSystem PointCoefficient]);
    }];
    _noticeL = [[UILabel alloc]init];
    [self.view addSubview:_noticeL];
    [_noticeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(showPassV.mas_bottom).mas_offset(20*[SYCSystem PointCoefficient]);
        make.centerX.equalTo(self.view);
//        make.width.mas_equalTo(self.view.bounds.size.width/2);
        make.height.mas_equalTo(15*[SYCSystem PointCoefficient]);
    }];
    _noticeL.text = @"绘制解锁图案";
    _noticeL.numberOfLines = 0;
    _noticeL.textAlignment = NSTextAlignmentCenter;
    _noticeL.font = [UIFont systemFontOfSize:15*[SYCSystem PointCoefficient]];
    _noticeL.textColor = [UIColor blackColor];
    
    UIImageView *imageV = [[UIImageView alloc]init];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_noticeL);
        make.width.mas_equalTo(15*[SYCSystem PointCoefficient]);
        make.height.mas_equalTo(15*[SYCSystem PointCoefficient]);
        make.right.mas_equalTo(_noticeL.mas_left).mas_offset(-5*[SYCSystem PointCoefficient]);
    }];
    [imageV setImage:[UIImage imageNamed:@"errLocktipsImage"]];
    imageV.hidden = YES;
    
    SYCPassWordView *myline = [[SYCPassWordView alloc]init];
    myline.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [self.view addSubview: myline];
    [myline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_noticeL.mas_bottom).mas_offset(60*[SYCSystem PointCoefficient]);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(292*[SYCSystem PointCoefficient]);
        make.height.mas_equalTo(292*[SYCSystem PointCoefficient]);
    }];
    [myline error:^{
         imageV.hidden = NO;
        if (_firstDraw) {
           _noticeL.text = @"密码太短，请至少链接4个点";
           _noticeL.textColor = [UIColor colorWithHexString:@"FF4D4D"];
        }else{
            _noticeL.text = @"与上次绘制不一致，请重试";
            _noticeL.textColor = [UIColor colorWithHexString:@"FF4D4D"];
        }
    }];
    [myline chuanZhi:^(NSString *str) {
        if (_firstDraw) {
            _noticeL.text = @"请再次绘制解锁图案";
            [showPassV showSelected:str];
            _passWord = str;
            _firstDraw = NO;
            myline.password = str;
        }else{
            if (![_passWord isEqualToString:str]) {
                imageV.hidden = NO;
                _noticeL.text = @"与上次绘制不一致，请重试";
                _noticeL.textColor = [UIColor colorWithHexString:@"FF4D4D"];
            }else{
                [showPassV showSelected:str];
                _noticeL.text = @"完成解锁图案设置";
                imageV.hidden = YES;
                _noticeL.textColor = [UIColor colorWithHexString:@"CFAF72"];
                [SYCSystem setGesturePassword:str];
                [SYCSystem setGestureLock];
                [SYCSystem setGestureCount:5];
                [self performSelector:@selector(backToRoot) withObject:nil afterDelay:1.0];
            }
        }
        
    }];
    
}
-(void)backToRoot{
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:index-2];
    [self.navigationController popToViewController:vc animated:YES];
}
-(void)backToLast{
    [self.navigationController popViewControllerAnimated:YES];
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
