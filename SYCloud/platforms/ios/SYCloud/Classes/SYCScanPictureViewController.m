//
//  SYCScanPictureViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/8/11.
//
//

#import "SYCScanPictureViewController.h"
#import "SYCImgCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "HexColor.h"
static CGFloat MaxScale = 3.0;
static CGFloat MinScale = 1.0;
@interface SYCScanPictureViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UIPageControl *pageC;
@property (nonatomic,strong)UICollectionView *collectionView;

@end

@implementation SYCScanPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(screenSize.width, screenSize.height/2);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, screenSize.height/4, screenSize.width, screenSize.height/2) collectionViewLayout:layout];
    _collectionView.scrollsToTop = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.pagingEnabled = YES;//滑动分页效果
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
//    _collectionView.maximumZoomScale = 3;
//    _collectionView.minimumZoomScale = 1;
//    [_collectionView setZoomScale:1 animated:NO];
    [_collectionView registerClass:[SYCImgCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([SYCImgCollectionViewCell class])];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [self.view addSubview:_collectionView];
    
    _pageC = [[UIPageControl alloc]initWithFrame:CGRectMake(60, screenSize.height-60, screenSize.width-120, 40)];
    _pageC.numberOfPages = [_imgs count];
    _pageC.currentPage = _index;
    _pageC.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"45bdef"];
    [self.view addSubview:_pageC];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissVC:)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    
}
-(void)dismissVC:(UITapGestureRecognizer*)tap{
//    CGPoint point = [tap locationInView:self.view];
//    if (!CGRectContainsPoint(_collectionView.frame,point)) {
        [self dismissViewControllerAnimated:YES completion:nil];
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_imgs count];
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SYCImgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SYCImgCollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    [cell.imageV setImageWithURL:[NSURL URLWithString:[_imgs objectAtIndex:indexPath.row]]
                        placeholderImage:nil];
    cell.imageV.userInteractionEnabled = YES;
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(Pinch:)];
    [cell.imageV addGestureRecognizer:pinch];
    return cell;
}
#pragma mark ---
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_collectionView]) {
        NSInteger page = scrollView.contentOffset.x/scrollView.frame.size.width;
        self.pageC.currentPage = page;
    }
}
////告诉Scrollview缩放哪个子控件
//-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    SYCImgCollectionViewCell *cell = (SYCImgCollectionViewCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.pageC.currentPage inSection:0]];
//    return cell.imageV;
//}
////等比放大，让放大的图片保持在scrollview的中央
//-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    SYCImgCollectionViewCell *cell = (SYCImgCollectionViewCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.pageC.currentPage inSection:0]];
//    CGFloat offsetX = (_collectionView.bounds.size.width > _collectionView.contentSize.width)?(_collectionView.bounds.size.width - _collectionView.contentSize.width) *0.5 : 0.0;
//    CGFloat offsetY = (_collectionView.bounds.size.height > _collectionView.contentSize.height)?
//    (_collectionView.bounds.size.height - _collectionView.contentSize.height) *0.5 : 0.0;
//    cell.imageV.center =CGPointMake(_collectionView.contentSize.width *0.5 + offsetX,_collectionView.contentSize.height *0.5 + offsetY);
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
