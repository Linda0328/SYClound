//
//  SYCNewGuiderViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/11/30.
//

#import "SYCNewGuiderViewController.h"
#import "Masonry.h"
#import "SYCSystem.h"
#import "HexColor.h"
#import "SYCNewLoadViewController.h"
#import "SYCRegisterViewController.h"
static NSString *versionKey = @"versionKey";
@interface SYCNewGuiderViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIPageControl *pageC;
@end

@implementation SYCNewGuiderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *bgImage = isIphoneX?[UIImage imageNamed:@"ydBG1125"]:[UIImage imageNamed:@"GuiderBg"];
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    self.view.layer.contents = (__bridge id _Nullable)(bgImage.CGImage);
    CGFloat ScreenHeight = [UIScreen mainScreen].bounds.size.height;
    NSArray *images = [SYCSystem NewGuiderImageS];
    UIScrollView *imageScrollV = [[UIScrollView alloc]init];
    [self.view addSubview:imageScrollV];
    CGFloat top = 38*[SYCSystem PointCoefficient];
    CGFloat left = 32*[SYCSystem PointCoefficient];
    CGFloat bottom = 145*[SYCSystem PointCoefficient];
    CGFloat width = [UIScreen mainScreen].bounds.size.width-2*left;
//    CGFloat heigth =  ScreenHeight-bottom;
    [imageScrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-left);
        make.bottom.mas_equalTo(-bottom);
    }];
    imageScrollV.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    imageScrollV.pagingEnabled = YES;
    imageScrollV.showsVerticalScrollIndicator = NO;
    imageScrollV.showsHorizontalScrollIndicator = NO;
    imageScrollV.delegate = self;
    imageScrollV.contentSize = CGSizeMake(images.count*width, CGRectGetWidth(imageScrollV.frame));
    for (NSInteger i = 0 ; i < images.count;i++) {
        UIImageView *imageV = [[UIImageView alloc]init];
        [imageScrollV addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(i*width);
            make.height.equalTo(imageScrollV);
            make.width.equalTo(imageScrollV);
        }];
        [imageV setImage:[UIImage imageNamed:[images objectAtIndex:i]]];
    }
    
    CGFloat pHeight = 8*[SYCSystem PointCoefficient];
    CGFloat pGap = 10*[SYCSystem PointCoefficient];
    _pageC = [[UIPageControl alloc]init];
    [self.view addSubview:_pageC];
    [_pageC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScreenHeight-bottom+pHeight+pGap);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(pHeight);
    }];
    _pageC.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"CFAF72"];
    _pageC.numberOfPages = [images count];
    _pageC.currentPage = 0;
    
    CGFloat gap = 20*[SYCSystem PointCoefficient];
    CGFloat Bleft = 40*[SYCSystem PointCoefficient];
    CGFloat Bwidth = 132*[SYCSystem PointCoefficient];
    CGFloat Bheight = 44*[SYCSystem PointCoefficient];
    UIButton *registerBut = [[UIButton alloc]init];
    [self.view addSubview:registerBut];
    [registerBut  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScreenHeight-bottom+pHeight+pGap+gap);
        make.left.mas_equalTo(Bleft);
        make.width.mas_equalTo(Bwidth);
        make.height.mas_equalTo(Bheight);
    }];
    [registerBut setTitle:@"在线申请" forState:UIControlStateNormal];
    [registerBut setTitleColor:[UIColor colorWithHexString:@"CFAF72"] forState:UIControlStateNormal];
    registerBut.layer.borderColor = [UIColor colorWithHexString:@"CFAF72"].CGColor;
    registerBut.layer.borderWidth = 1.0;
    registerBut.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    registerBut.layer.cornerRadius = 5.0*[SYCSystem PointCoefficient];
    [registerBut addTarget:self action:@selector(GotoRegister) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *LoadBut = [[UIButton alloc]init];
    [self.view addSubview:LoadBut];
    [LoadBut  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScreenHeight-bottom+pHeight+pGap+gap);
        make.right.mas_equalTo(-Bleft);
        make.width.mas_equalTo(Bwidth);
        make.height.mas_equalTo(Bheight);
    }];
    [LoadBut setTitle:@"立即登录" forState:UIControlStateNormal];
    LoadBut.backgroundColor = [UIColor colorWithHexString:@"CFAF72"];
    [LoadBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    LoadBut.layer.cornerRadius = 5.0*[SYCSystem PointCoefficient];
    [LoadBut addTarget:self action:@selector(gotoLoad) forControlEvents:UIControlEventTouchUpInside];
}
-(void)GotoRegister{
    SYCRegisterViewController *registerVC = [[SYCRegisterViewController alloc]init];
    registerVC.isFromGuider = YES;
    [self presentViewController:registerVC animated:YES completion:nil];
}
-(void)gotoLoad{
    SYCNewLoadViewController *loadVC = [[SYCNewLoadViewController alloc]init];
    [self presentViewController:loadVC animated:YES completion:nil];
}
// 是否应该显示版本新特性页面
+ (BOOL)canShowNewGuider{
    
    //系统直接读取的版本号
    NSString *versionValueStringForSystemNow=[[NSBundle mainBundle].infoDictionary valueForKey:(NSString *)kCFBundleVersionKey];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    //读取本地版本号
    NSString *versionLocal = [userDef objectForKey:versionKey];
    
    if(versionLocal!=nil && [versionValueStringForSystemNow isEqualToString:versionLocal]){//说明有本地版本记录，且和当前系统版本一致
        
        return NO;
        
    }else{ // 无本地版本记录或本地版本记录与当前系统版本不一致
        //保存
        [userDef setObject:versionValueStringForSystemNow forKey:versionKey];
        [userDef synchronize];
        return YES;
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger page = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageC.currentPage = page;
    
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
