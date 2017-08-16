//
//  SYCScanImageViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/8/16.
//
//

#import "SYCScanImageViewController.h"

@interface SYCScanImageViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIImageView *imgView;
@end

@implementation SYCScanImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    UIScrollView *bgView = [[UIScrollView alloc] init];
    
    bgView.frame = [UIScreen mainScreen].bounds;
    
    bgView.backgroundColor = [UIColor blackColor];
    UIImage *image = [UIImage imageNamed:@"global_bottom_menu_myNormal"];
    _imgView = [[UIImageView alloc] initWithImage:image];
    
    [_imgView setContentMode:UIViewContentModeScaleAspectFit];
    
    [bgView addSubview:_imgView];
    
    // 设置_imgView的位置大小
    
    CGRect frame ;
    
    frame.size.width = bgView.frame.size.width;
    
    frame.size.height =frame.size.width*(image.size.height/image.size.width);
    
    _imgView.frame = frame;
    
    _imgView.center=bgView.center;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
    
    // 设置WindowLevel与状态栏平级，起到隐藏状态栏的效果
    
    [[[UIApplication sharedApplication] keyWindow] setWindowLevel:UIWindowLevelStatusBar];
    
    //最大放大比例
    
    bgView.maximumZoomScale = 2.0;
    
    bgView.contentSize=_imgView.frame.size;
    
    bgView.delegate = self;
    
    //隐藏滚动条
    
    bgView.showsVerticalScrollIndicator = NO;
    
    bgView.showsHorizontalScrollIndicator = NO;
}
//代理方法

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView

{
    
    return _imgView;
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView

{
    
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
    [_imgView setCenter:CGPointMake(xcenter, ycenter)];
    
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
