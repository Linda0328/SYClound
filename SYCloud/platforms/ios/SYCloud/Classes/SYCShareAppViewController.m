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
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "SYCShareVersionInfo.h"
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
    CGFloat buttonWidth = 60*[SYCSystem PointCoefficient];
    CGFloat gap = (width-2*gapRight-shareArr.count*buttonWidth)/(shareArr.count-1);
    for (NSInteger i = 0;i < [shareArr count];i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(gapRight+i*(buttonWidth+gap), gapUp, buttonWidth, 59*[SYCSystem PointCoefficient])];
        [button setImage:[UIImage imageNamed:shareImgs[i]] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"888890"] forState:UIControlStateNormal];
        [button setTitle:[shareArr objectAtIndex:i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button verticalImageAndTitle:10.0f];
        [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    _HUD = [[MBProgressHUD alloc]initWithView:[UIApplication sharedApplication].keyWindow];
    _HUD.mode = MBProgressHUDModeText;
    _HUD.label.font = [UIFont systemFontOfSize:14*[SYCSystem PointCoefficient]];
    [[UIApplication sharedApplication].keyWindow addSubview:_HUD];
    [_HUD hideAnimated:YES];
}
-(void)action:(UIButton*)sender{
    NSString *title = [sender currentTitle];
    if (![QQApiInterface isQQInstalled]&&([title isEqualToString:@"QQ"]||[title isEqualToString:@"QQ空间"])) {
        _HUD.label.text = @"请安装QQ";
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:1.5f];
        return;
    }
    if (![WXApi isWXAppInstalled]&&([title isEqualToString:@"微信"]||[title isEqualToString:@"朋友圈"])) {
        _HUD.label.text = @"请安装微信";
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:1.5f];
        return;
    }
   
    if (_shareModel) {
        [self shareWithShareModel:title];
    }
    if ([SYCSystem judgeNSString:_pic]) {
        [self shareWithImage:title];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)shareWithShareModel:(NSString*)title{
    __block UIImage *thumbImg = nil;
    __block NSData *imageData = nil;
    //并发队列使用全局并发队列，异步执行任务
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_shareModel.pic]];
        thumbImg = [UIImage imageWithData:imageData];
        //处理中文字符
        _shareModel.url = [_shareModel.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _HUD.label.text = @"请求微信失败";
        BOOL isShared = YES;
        if ([title isEqualToString:@"微信"]) {
            isShared = [WXApiRequestHandler sendLinkURL:_shareModel.url TagName:kLinkTagName Title:_shareModel.title Description:_shareModel.describe ThumbImage:thumbImg InScene:WXSceneSession];
            [SYCShareVersionInfo sharedVersion].sharePlatform = @"weixin";
        }
        if ([title isEqualToString:@"朋友圈"]) {
            isShared = [WXApiRequestHandler sendLinkURL:_shareModel.url TagName:kLinkTagName Title:_shareModel.title Description:_shareModel.describe ThumbImage:thumbImg InScene:WXSceneTimeline];
            [SYCShareVersionInfo sharedVersion].sharePlatform = @"wxpyq";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([title isEqualToString:@"QQ"]) {
                QQApiNewsObject *qqNews = [QQApiNewsObject objectWithURL:[NSURL URLWithString:_shareModel.url] title:_shareModel.title description:_shareModel.describe previewImageData:imageData];
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:qqNews];
                QQApiSendResultCode sent = [QQApiInterface sendReq:req];
                [self handleSentToQQresult:sent];
                [SYCShareVersionInfo sharedVersion].sharePlatform = @"qq";
            }
            if ([title isEqualToString:@"QQ空间"]) {
                QQApiNewsObject *qqNews = [QQApiNewsObject objectWithURL:[NSURL URLWithString:_shareModel.url] title:_shareModel.title description:_shareModel.describe previewImageData:imageData];
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:qqNews];
                QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
                [self handleSentToQQresult:sent];
                [SYCShareVersionInfo sharedVersion].sharePlatform = @"qzone";
            }
            if(!isShared){
                [_HUD showAnimated:YES];
                [_HUD hideAnimated:YES afterDelay:1.5f];
            }
        });
        
    });
}
-(void)shareWithImage:(NSString*)title{
     _HUD.label.text = @"请求微信失败";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //处理中文字符
        _shareModel.url = [_shareModel.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
       
        BOOL isShared = YES;
        if ([title isEqualToString:@"微信"]) {
            isShared = [WXApiRequestHandler sendImage:_pic InScene:WXSceneSession];
            [SYCShareVersionInfo sharedVersion].sharePlatform = @"weixin";
        }
        if ([title isEqualToString:@"朋友圈"]) {
            isShared = [WXApiRequestHandler sendImage:_pic InScene:WXSceneTimeline];
            [SYCShareVersionInfo sharedVersion].sharePlatform = @"wxpyq";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_pic]];
            if ([title isEqualToString:@"QQ"]) {
                QQApiImageObject *qqImage = [[QQApiImageObject alloc]initWithData:imageData previewImageData:imageData title:nil description:nil];
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:qqImage];
                QQApiSendResultCode sent = [QQApiInterface sendReq:req];
                [self handleSentToQQresult:sent];
                [SYCShareVersionInfo sharedVersion].sharePlatform = @"qq";
            }
            if ([title isEqualToString:@"QQ空间"]) {
                QQApiImageArrayForQZoneObject *qqImageZone = [[QQApiImageArrayForQZoneObject alloc]initWithImageArrayData:@[imageData] title:nil extMap:nil];
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:qqImageZone];
                QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
                [self handleSentToQQresult:sent];
                [SYCShareVersionInfo sharedVersion].sharePlatform = @"qzone";
            }
            if(!isShared){
                [_HUD showAnimated:YES];
                [_HUD hideAnimated:YES afterDelay:1.5f];
            }
            
        });
        
    });
}
-(void)handleSentToQQresult:(QQApiSendResultCode)code{
    NSLog(@"QQ分享错误码----%@",@(code));
    if (code == EQQAPIVERSIONNEEDUPDATE) {
//        当前QQ版本太低，需要更新至新版本才可以支持
        _HUD.label.text = @"当前QQ版本太低，需要更新至新版本才可以支持";
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:3.0f];
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
