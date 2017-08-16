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
@interface SYCScanImagesViewController ()<UIScrollViewDelegate>

@end

@implementation SYCScanImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    for (NSInteger i = 0; i < [_imgs count]; i++) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width*i;
        frame.origin.y = 0;
        MRZoomScrollView *scrollV = [[MRZoomScrollView alloc]initWithFrame:frame];
        [scrollV.imageView setImageWithURL:[NSURL URLWithString:[_imgs objectAtIndex:i]]
                          placeholderImage:nil];
        [scrollView addSubview:scrollV];
    }
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
