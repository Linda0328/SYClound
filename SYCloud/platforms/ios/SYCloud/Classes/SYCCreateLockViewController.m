//
//  SYCCreateLockViewController.m
//  SYCloud
//
//  Created by 文清 on 2018/5/22.
//

#import "SYCCreateLockViewController.h"
#import "Masonry.h"
#import "SYCSystem.h"
#import "HexColor.h"
#import "UILabel+SYCNavigationTitle.h"
#import "SYCLockViewController.h"
@interface SYCCreateLockViewController ()

@end

@implementation SYCCreateLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *leftItems = [NSMutableArray array];
    UILabel *titleLab = [UILabel navTitle:@"手势密码锁定" TitleColor:[UIColor blackColor] titleFont:[UIFont systemFontOfSize:20]];
    self.navigationItem.titleView = titleLab;
    UIImage *image = [UIImage imageNamed:@"ps_left_back"];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width+20*[SYCSystem PointCoefficient], image.size.height+5*[SYCSystem PointCoefficient])];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToLast) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    [leftItems addObject:item];
    UIBarButtonItem * negativeSpacer = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    [leftItems addObject:negativeSpacer];
    self.navigationItem.leftBarButtonItems = leftItems;
    
    UIImageView *imageV = [[UIImageView alloc]init];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55*[SYCSystem PointCoefficient]);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(116*[SYCSystem PointCoefficient]);
        make.height.mas_equalTo(236*[SYCSystem PointCoefficient]);
    }];
    [imageV setImage:[UIImage imageNamed:@"lockImage"]];
    UILabel *noticeLabel = [[UILabel alloc]init];
    [self.view addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageV.mas_bottom).mas_offset(26*[SYCSystem PointCoefficient]);
        make.centerX.equalTo(self.view);
        make.left.mas_equalTo(34*[SYCSystem PointCoefficient]);
        make.right.mas_equalTo(-34*[SYCSystem PointCoefficient]);
    }];
    noticeLabel.numberOfLines = 0;
    noticeLabel.font = [UIFont systemFontOfSize:15*[SYCSystem PointCoefficient]];
    noticeLabel.textColor = [UIColor blackColor];
    NSString *notice = @"你可以创建一个生源支付解锁图案，这样他人在使用你的手机时，将无法打开生源支付";
    noticeLabel.text = notice;
    
    UIButton *createButton = [[UIButton alloc]init];
    [self.view addSubview:createButton];
    [createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noticeLabel.mas_bottom).mas_offset(39*[SYCSystem PointCoefficient]);
        make.width.mas_equalTo(342*[SYCSystem PointCoefficient]);
        make.height.mas_equalTo(51*[SYCSystem PointCoefficient]);
        make.centerX.equalTo(self.view);
    }];
    [createButton addTarget:self action:@selector(CreatePasswordLock) forControlEvents:UIControlEventTouchUpInside];
    [createButton setBackgroundColor:[UIColor colorWithHexString:@"CFAF72"]];
    [createButton setTitle:@"创建手势密码" forState:UIControlStateNormal];
    [createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createButton.layer.cornerRadius = 5*[SYCSystem PointCoefficient];
}
-(void)backToLast{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)CreatePasswordLock{
    SYCLockViewController *lockVC = [[SYCLockViewController alloc]init];
    [self.navigationController pushViewController:lockVC animated:YES];
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
