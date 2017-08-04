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
static NSString *kLinkTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
@interface SYCShareAppViewController ()
@property (nonatomic,strong)MBProgressHUD *HUD;
@end

@implementation SYCShareAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *shareArr = @[@"QQ",@"QQ空间",@"微信",@"朋友圈"];
    CGFloat width = [[UIScreen mainScreen]bounds].size.width;
    CGFloat gap = 20.0f;
    CGFloat buttonWidth = (width-(shareArr.count+1)*gap)/4;
    for (NSInteger i = 0;i < [shareArr count];i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(gap+i*buttonWidth, gap, buttonWidth, 60)];
        [button setTitle:[shareArr objectAtIndex:i] forState:UIControlStateNormal];
        
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
