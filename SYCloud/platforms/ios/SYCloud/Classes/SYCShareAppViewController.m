//
//  SYCShareViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/8/4.
//
//

#import "SYCShareAppViewController.h"
#import "WXApiRequestHandler.h"
#import "MBProgressHUD.h"
#import "SYCSystem.h"
#import "HexColor.h"
#import "UIButton+TitleImageCenter.h"
static NSString *kLinkTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
@interface SYCShareAppViewController ()
@property (nonatomic,strong)MBProgressHUD *HUD;
@end

@implementation SYCShareAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Dismiss) name:dismissShareNotify object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *shareArr = @[@"微信",@"朋友圈",@"QQ",@"QQ空间"];
    NSArray *shareImgs = @[@"wx",@"pyq",@"qq",@"qqZone"];
    CGFloat width = [[UIScreen mainScreen]bounds].size.width;
    CGFloat gapRight = 17.0f*[SYCSystem PointCoefficient];
    CGFloat gapUp = 23.0*[SYCSystem PointCoefficient];
    CGFloat buttonWidth = 54*[SYCSystem PointCoefficient];
    CGFloat gap = (width-2*gapRight-shareArr.count*buttonWidth)/(shareArr.count-1);
    for (NSInteger i = 0;i < [shareArr count];i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(gapRight+i*(buttonWidth+gap), gapUp, buttonWidth, 59*[SYCSystem PointCoefficient])];
        [button setImage:[UIImage imageNamed:shareImgs[i]] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"888890"] forState:UIControlStateNormal];
        [button setTitle:[shareArr objectAtIndex:i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//        //设置文字偏移：向下偏移图片高度+向左偏移图片的宽度
//        [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.frame.size.height+5,-button.imageView.frame.size.width, 0, 0)];
//        //设置图片偏移:向上偏移文字的高度+向右偏移文字的宽度
//        [button setImageEdgeInsets:UIEdgeInsetsMake(-button.titleLabel.frame.size.height-5, 0, 0, -button.titleLabel.frame.size.width)];
        [button verticalImageAndTitle:10.0f];
        [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    _HUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_HUD];
    [_HUD hideAnimated:YES];
}
-(void)action:(UIButton*)sender{
    NSString *title = [sender currentTitle];
    __block UIImage *thumbImg = nil;
    //并发队列使用全局并发队列，异步执行任务
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        thumbImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_shareModel.pic]]];
    });
    
    _HUD.label.text = @"请求微信失败";
    BOOL isShared = YES;
    if ([title isEqualToString:@"微信"]) {
        isShared = [WXApiRequestHandler sendLinkURL:_shareModel.url TagName:kLinkTagName Title:_shareModel.title Description:_shareModel.describe ThumbImage:thumbImg InScene:WXSceneSession];
        
    }
    if ([title isEqualToString:@"朋友圈"]) {
        isShared = [WXApiRequestHandler sendLinkURL:_shareModel.url TagName:kLinkTagName Title:_shareModel.title Description:_shareModel.describe ThumbImage:thumbImg InScene:WXSceneTimeline];

    }
    if ([title isEqualToString:@"QQ"]) {
        
    }
    if ([title isEqualToString:@"QQ空间"]) {
        
    }
    if(!isShared){
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:1.5f];
    }
}
-(void)Dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
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
