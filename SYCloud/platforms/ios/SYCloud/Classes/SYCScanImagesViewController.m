//
//  SYCScanImagesViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/8/16.
//
//

#import "SYCScanImagesViewController.h"
#import "MRZoomScrollView.h"
#import "UIImageView+AFNetworking.h"
#import "HexColor.h"
#import "SYCSystem.h"
@interface SYCScanImagesViewController ()<UIScrollViewDelegate,MRZoomScrollViewDelegate>
@property (nonatomic,strong)UIPageControl *pageC;

@end

@implementation SYCScanImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat pageHeight = 60*[SYCSystem PointCoefficient];
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [scrollView setContentSize:CGSizeMake([_imgs count]*screenSize.width, screenSize.height)];
    [scrollView setBackgroundColor:[UIColor blackColor]];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.userInteractionEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    CGRect frame = scrollView.bounds;
    for (NSInteger i = 0; i < [_imgs count]; i++) {
        frame.origin.x = frame.size.width*i;
        frame.origin.y = 0;
        MRZoomScrollView *scrollV = [[MRZoomScrollView alloc]initWithFrame:frame];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center = CGPointMake(screenSize.width/2, screenSize.height/2);
        [scrollV addSubview:indicator];
        [indicator startAnimating];
        NSURL *imgURL = [NSURL URLWithString:[_imgs objectAtIndex:i]];
        NSURLRequest *request = [NSURLRequest requestWithURL:imgURL];
//        [UIImage imageNamed:@"merchantDefaultImage"]
        __weak __typeof(scrollV.imageView)weakImg = scrollV.imageView;
        
        [scrollV.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            CGFloat point = image.size.height/image.size.width;
            CGFloat sPoint = (screenSize.height-2*pageHeight)/screenSize.width;
            __strong __typeof(weakImg)strongImg = weakImg;
            CGRect frame = strongImg.frame;
            CGFloat height = screenSize.height-2*pageHeight;
            CGFloat width = screenSize.width;
            if (point>sPoint) {
                width = height*point>width?width:height*point;
            }else{
                height = width*point>height?height:width*point;
            }
            frame.size = CGSizeMake(width, height);
            strongImg.frame = frame;
            strongImg.center = CGPointMake(screenSize.width/2, screenSize.height/2);
            [strongImg setImage:image];
            [indicator stopAnimating];
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            [indicator stopAnimating];
        }];
        [scrollView addSubview:scrollV];
        scrollV.customDelegate = self;
    }
    [scrollView setContentOffset:CGPointMake(_index*screenSize.width, 0)];
    _pageC = [[UIPageControl alloc]initWithFrame:CGRectMake(pageHeight, screenSize.height-pageHeight, screenSize.width-2*pageHeight, pageHeight-20*[SYCSystem PointCoefficient])];
    _pageC.numberOfPages = [_imgs count];
    _pageC.currentPage = _index;
    _pageC.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"45bdef"];
    [self.view addSubview:_pageC];
}
-(void)dismissScanPicture{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ---
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
