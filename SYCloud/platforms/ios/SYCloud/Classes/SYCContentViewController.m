//
//  SYCContentViewController.m
//  SYCloud
//
//  Created by 文清 on 2017/3/20.
//
//

#import "SYCContentViewController.h"
#import "HexColor.h"
#import "SYCNavTitleModel.h"
#import "MJExtension.h"
#import "SYCOptionModel.h"
#import "SYCEventModel.h"
#import "SYCEventButton.h"
#import "UILabel+SYCNavigationTitle.h"
#import "SYCSystem.h"
#import "SYScanViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "SYCGroupModel.h"
#import "SYOpenWLANTableViewController.h"
#import "UIImage+SYColorExtension.h"
#import "SYCPasswordViewController.h"
#import "SYCPresentationController.h"
#import "SYCPayOrderInfoViewController.h"
#import "SYCPopoverGroupViewController.h"
#import "SYCHttpReqTool.h"
#import "SYCRequestLoadingViewController.h"
#import "MBProgressHUD.h"
#import "SYCLoadViewController.h"
#import "SYCShareModel.h"
#import "SYCShareAppViewController.h"
#import "WXApiManager.h"
#import "QQManager.h"
#import "SYCShareVersionInfo.h"
#import "SYCScanPictureViewController.h"
#import "SYCScanImagesViewController.h"
#import "SYCNewLoadViewController.h"
//static float const tableWidth = 130.0f;
static NSString *const searchBarCilck = @"click";
static NSString *const searchBarChange = @"change";
static NSString *const searchBarSubmit = @"submit";
static void *eventBarItem = @"eventBarItem";
@interface SYCContentViewController ()<UISearchBarDelegate,UIViewControllerTransitioningDelegate,UIAdaptivePresentationControllerDelegate,UIPopoverPresentationControllerDelegate>
@property (nonatomic,strong)SYCNavTitleModel *titleModel;
@property (nonatomic,strong)NSMutableArray *optionURLArr;
@property (nonatomic,strong)NSMutableArray *groupArr;
@property (nonatomic,strong)dispatch_source_t timer;
@property (nonatomic,assign)CGRect presentedRect;
@property (nonatomic,strong)NSArray *guidenceImages;
@property (nonatomic,assign)NSInteger currentGuidenceImageIndex;
@property (nonatomic,strong)SYCPopoverGroupViewController *popOverVC;
@end

@implementation SYCContentViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isHiddenNavigationBar) {
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.navigationBar.hidden = YES;
    }else{
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.hidden = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentGuidenceImageIndex = 1;
    if (_isFirst&&[SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].paymentSDKID]) {
        __weak __typeof(self)weakSelf = self;
        __block UIView *payloadingView = [self payLoading];
        __block SYCPayOrderInfoViewController *payOrderVC = [[SYCPayOrderInfoViewController alloc]init];
        payOrderVC.prePayID = [SYCShareVersionInfo sharedVersion].paymentSDKID;
        [SYCHttpReqTool requestPayPluginInfoWithPrepareID:[SYCShareVersionInfo sharedVersion].paymentSDKID completion:^(NSString *resultCode, NSMutableDictionary *result) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf dealWithPayOrderInfoResultCode:resultCode result:result paymentType:payMentTypeSDK loadingView:payloadingView payOrderVC:payOrderVC payCode:[SYCShareVersionInfo sharedVersion].paymentSDKID];
        }];
    }
    _presentedRect = CGRectZero;
    _optionURLArr = [NSMutableArray arrayWithCapacity:20];
    __weak __typeof(self)weakSelf = self;
    self.pushBlock = ^(NSString *contentUrl,BOOL isBackToLast,BOOL reload,SYCNavigationBarModel *navModel){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        SYCContentViewController *viewC =[[SYCContentViewController alloc]init];
        [viewC setNavigationBar:navModel];
        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
        viewC.view.frame = rect;
        viewC.isBackToLast = isBackToLast;
        MainViewController *pushM = [[MainViewController alloc]init];
        //处理中文字符
        NSString *url=[navModel.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        pushM.startPage = url;
        viewC.CurrentChildVC = pushM;
        pushM.enableReload = reload;
        pushM.isChild = YES;
        pushM.isRoot = NO;
        pushM.lastViewController = strongSelf.CurrentChildVC;
        pushM.view.frame = rect;
        [viewC addChildViewController:pushM];
        [viewC.view addSubview:pushM.view];
        [pushM didMoveToParentViewController:viewC];
        strongSelf.hidesBottomBarWhenPushed = YES;
        strongSelf.navigationController.navigationBar.translucent = NO;
        strongSelf.navigationController.navigationBar.hidden = NO;
        [strongSelf.navigationController pushViewController:viewC animated:YES];
        
        if (strongSelf.CurrentChildVC.isRoot) {
            strongSelf.hidesBottomBarWhenPushed = NO;
        }
        
    };
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(PushScanVC:) name:scanNotify object:nil];
    [center addObserver:self selector:@selector(popVC:) name:popNotify object:nil];
    [center addObserver:self selector:@selector(passwordSetting:) name:passwordNotify object:nil];
    [center addObserver:self selector:@selector(PayImmedately:) name:PayImmedateNotify object:nil];
    [center addObserver:self selector:@selector(shareApp:) name:shareNotify object:nil];
    [center addObserver:self selector:@selector(ShowPhotos:) name:showPhotoNotify object:nil];
    [center addObserver:self selector:@selector(LoadAgain:) name:LoadAgainNotify object:nil];
    [center addObserver:self selector:@selector(guidence:) name:guidenceNotify object:nil];
}

-(void)PushScanVC:(NSNotification*)notify{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您未允许app访问相机，无法进入扫一扫，前往设置-隐私-相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >=8) {
                NSString *urlStr = [NSString stringWithFormat:@"prefs:root=%@",bundleID];
                NSURL *url =[NSURL URLWithString:urlStr];
                if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }
            if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                    [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL        success) {
                    }];
                }
            }
        
        }];
        
        [alertC addAction:cancelAction];
        [alertC addAction:confirmAction];
        [self presentViewController:alertC animated:YES completion:nil];
        return;
    }
    
    MainViewController *main = (MainViewController*)notify.object;
    if (![main isEqual:_CurrentChildVC]) {
        return;
    }
    SYScanViewController *scan = [[SYScanViewController alloc]init];
    scan.lastMain = _CurrentChildVC;
    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:scan animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
-(void)popVC:(NSNotification*)notify{
    
    MainViewController *main = (MainViewController*)notify.object;
    if (![main isEqual:_CurrentChildVC]) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)passwordSetting:(NSNotification*)notify{
    
    SYCPassWordModel *payModel = (SYCPassWordModel*)notify.object;
    MainViewController *main = (MainViewController*)[notify.userInfo objectForKey:mainKey];
    if (![main isEqual:_CurrentChildVC]) {
        return;
    }
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    _presentedRect = CGRectMake(0, 2*screenSize.height/5, screenSize.width,  3*screenSize.height/5);
    __weak __typeof(self)weakSelf = self;
    [SYCHttpReqTool PswSetOrNot:^(NSString *resultCode, BOOL resetPsw) {
        if ([resultCode isEqualToString:resultCodeSuccess]) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (resetPsw) {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您未设置支付密码，请设置您的支付密码并完成提交" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                     [strongSelf showPasswordInput:payModel needResetPsw:resetPsw];
                }];
                [alertC addAction:action];
                dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf presentViewController:alertC animated:YES completion:nil];
                });
            }else{
                 [strongSelf showPasswordInput:payModel needResetPsw:resetPsw];
            }
        }
       
    }];
    
}
-(void)showPasswordInput:(SYCPassWordModel*)payModel needResetPsw:(BOOL)resetPsw{
    SYCPasswordViewController *passwVC = [[SYCPasswordViewController alloc]init];
    passwVC.pswModel = payModel;
    passwVC.showAmount = YES;
    passwVC.isTranslate = YES;
    passwVC.needSetPassword = resetPsw;
    passwVC.presentingMainVC = self.CurrentChildVC;
    dispatch_async(dispatch_get_main_queue(), ^{
        passwVC.modalPresentationStyle = UIModalPresentationCustom;
        passwVC.transitioningDelegate = self;
        [self presentViewController:passwVC animated:YES completion:nil];
    });

}
-(void)PayImmedately:(NSNotification*)notify{
    
    MainViewController *main = (MainViewController*)[notify.userInfo objectForKey:mainKey];
    if (![main isEqual:_CurrentChildVC]) {
        return;
    }
    __weak __typeof(self)weakSelf = self;
    __block UIView *payloadingView = [self payLoading];
    NSString *payMentType = [notify.userInfo objectForKey:PreOrderPay];
    __block SYCPayOrderInfoViewController *payOrderVC = [[SYCPayOrderInfoViewController alloc]init];
    if ([payMentType isEqualToString:payMentTypeImme]) {
        SYCPayInfoModel *payModel = (SYCPayInfoModel*)notify.object;
        payOrderVC.payInfoModel = payModel;
        [SYCHttpReqTool payImmediatelyInfoWithpayAmount:payModel.amount completion:^(NSString *resultCode, NSMutableDictionary *result) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf dealWithPayOrderInfoResultCode:resultCode result:result paymentType:payMentType loadingView:payloadingView payOrderVC:payOrderVC payCode:payModel];
        }];
    }else if([payMentType isEqualToString:payMentTypeScan]){
        NSString *qrcode = (NSString*)notify.object;
        payOrderVC.qrcode = qrcode;
        [SYCHttpReqTool payScanInfoWithQrcode:qrcode completion:^(NSString *resultCode, NSMutableDictionary *result) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf dealWithPayOrderInfoResultCode:resultCode result:result paymentType:payMentType loadingView:payloadingView payOrderVC:payOrderVC payCode:qrcode];
        }];
    }else if([payMentType isEqualToString:payMentTypeCode]){
        NSString *paycode = (NSString*)notify.object;
        payOrderVC.payCode = paycode;
        [SYCHttpReqTool payScanInfoWithPaycode:paycode completion:^(NSString *resultCode, NSMutableDictionary *result) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf dealWithPayOrderInfoResultCode:resultCode result:result paymentType:payMentType loadingView:payloadingView payOrderVC:payOrderVC payCode:paycode];
        }];
    }else if([payMentType isEqualToString:payMentTypeSDK]){
        NSString *prePayID = (NSString*)notify.object;
        payOrderVC.prePayID = prePayID;
        [SYCHttpReqTool requestPayPluginInfoWithPrepareID:prePayID completion:^(NSString *resultCode, NSMutableDictionary *result) {
            NSLog(@"-------result===%@",result[@"msg"]);
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf dealWithPayOrderInfoResultCode:resultCode result:result paymentType:payMentType loadingView:payloadingView payOrderVC:payOrderVC payCode:prePayID];
        }];

    }
    
}
-(void)shareApp:(NSNotification*)notify{
    MainViewController *main = (MainViewController*)[notify.userInfo objectForKey:mainKey];
    if (![main isEqual:_CurrentChildVC]) {
        return;
    }
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    _presentedRect = CGRectMake(0, screenSize.height-105*[SYCSystem PointCoefficient], screenSize.width, 105*[SYCSystem PointCoefficient]);
    SYCShareModel *shareM = (SYCShareModel*)notify.object;
    SYCShareAppViewController *shareVC = [[SYCShareAppViewController alloc]init];
    shareVC.shareModel = shareM;
    shareVC.modalPresentationStyle = UIModalPresentationCustom;
    shareVC.transitioningDelegate = self;
    [self presentViewController:shareVC animated:YES completion:nil];
}
-(void)ShowPhotos:(NSNotification*)notify{
    MainViewController *main = (MainViewController*)notify.object;
    if (![main isEqual:_CurrentChildVC]) {
        return;
    }
    NSArray *imgs = [notify.userInfo objectForKey:photoArrkey];
    NSInteger index =[[notify.userInfo objectForKey:defaultPhotoIndexKey]integerValue];
    _presentedRect = [[UIScreen mainScreen]bounds];
    SYCScanImagesViewController *pic = [[SYCScanImagesViewController alloc]init];
    pic.imgs = imgs ;
    pic.index = index;
    pic.modalPresentationStyle = UIModalPresentationCustom;
    pic.transitioningDelegate = self;
    [self presentViewController:pic animated:YES completion:nil];
}
-(void)LoadAgain:(NSNotification*)notify{
    MainViewController *main = (MainViewController*)notify.object;
    if (![main isEqual:_CurrentChildVC]) {
        return;
    }
    SYCNewLoadViewController *loadVC = [[SYCNewLoadViewController alloc]init];
    loadVC.isLoadAgain = YES;
    [self presentViewController:loadVC animated:YES completion:nil];
}
-(void)guidence:(NSNotification*)notify{
    MainViewController *main = (MainViewController*)notify.object;
    if (![main isEqual:_CurrentChildVC]) {
        return;
    }
    _guidenceImages = [notify.userInfo objectForKey:GuidenceImagesKey];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    imageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ChangedImages:)];
    NSString *imageName = [SYCSystem guidenceImageName:[_guidenceImages objectAtIndex:_currentGuidenceImageIndex-1]];
    [imageV setImage:[UIImage imageNamed:imageName]];
    [imageV addGestureRecognizer:tap];
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:imageV];
}
-(void)ChangedImages:(UITapGestureRecognizer*)tap{
    _currentGuidenceImageIndex ++;
    UIImageView *imageV = (UIImageView *)tap.view;
    if (_currentGuidenceImageIndex > [_guidenceImages count]) {
        [imageV removeFromSuperview];
    }else{
        NSString *imageName = [SYCSystem guidenceImageName:[_guidenceImages objectAtIndex:_currentGuidenceImageIndex-1]];
        [imageV setImage:[UIImage imageNamed:imageName]];
    }
}
-(void)dealWithPayOrderInfoResultCode:(NSString*)resultCode result:(NSDictionary*)result paymentType:(NSString*)paymentType loadingView:(UIView*)payloadingView payOrderVC:(SYCPayOrderInfoViewController *)payOrderVC payCode:(id)payCode{
    __weak __typeof(self)weakSelf = self;
    if ([resultCode isEqualToString:resultCodeSuccess]&&[result[resultSuccessKey][@"code"] isEqualToString:@"000000"]) {
        CGSize screenSize = [[UIScreen mainScreen]bounds].size;
        _presentedRect = CGRectMake(0, 2*screenSize.height/5, screenSize.width,  3*screenSize.height/5);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            //停止动画
            dispatch_source_cancel(strongSelf.timer);
            payOrderVC.presentingMainVC = strongSelf.CurrentChildVC;
            payOrderVC.payMentType = paymentType;
            payOrderVC.requestResultDic = result[resultSuccessKey];
            payOrderVC.isPreOrderPay = [paymentType isEqualToString:payMentTypeImme]?NO:YES;
            dispatch_async(dispatch_get_main_queue(), ^{
            //2秒以后移除view
            [payloadingView removeFromSuperview];
            strongSelf.view.userInteractionEnabled = YES;
            payOrderVC.modalPresentationStyle = UIModalPresentationCustom;
            payOrderVC.transitioningDelegate = strongSelf;
            [strongSelf presentViewController:payOrderVC animated:YES completion:nil];});
        });
    }
    if ([resultCode isEqualToString:resultCodeSuccess]&&![result[resultSuccessKey][@"code"] isEqualToString:@"000000"]) {
        
        //停止动画
        dispatch_source_cancel(_timer);
        //主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
        //2秒以后移除view
        [payloadingView removeFromSuperview];
        self.view.userInteractionEnabled = YES;
        MBProgressHUD*HUD = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.label.text = result[@"msg"];
        [HUD showAnimated:YES];
        [HUD hideAnimated:YES afterDelay:1.5f];
            //用户非登录状态
        if([result[resultSuccessKey][@"code"] isEqualToString:@"300000"]){
//            SYCLoadViewController *load = [[SYCLoadViewController alloc]init];
//            load.mainVC = _CurrentChildVC;
//            if ([paymentType isEqualToString:payMentTypeSDK]) {
//                load.isFromSDK = YES;
//            }
//            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:load];
//            [self.navigationController presentViewController:nav animated:YES completion:nil];
            SYCNewLoadViewController *newLoad = [[SYCNewLoadViewController alloc]init];
            newLoad.payCode = payCode;
            newLoad.contentVC = self;
            newLoad.paymentType = paymentType;
            [self presentViewController:newLoad animated:YES completion:nil];
        }
        });
    }
    if (![resultCode isEqualToString:resultCodeSuccess]) {
        //停止动画
        dispatch_source_cancel(_timer);
        dispatch_async(dispatch_get_main_queue(), ^{
        //2秒以后移除view
        [payloadingView removeFromSuperview];
        self.view.userInteractionEnabled = YES;
        MBProgressHUD*HUD = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.label.text = @"请求失败，请检查网络";
        [HUD showAnimated:YES];
        [HUD hideAnimated:YES afterDelay:1.5f];
        });
    }

}
-(UIPresentationController*)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    SYCPresentationController *presentation = [[SYCPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    
//    presentation.blurEffectStyle = UIBlurEffectStyleLight;
//    presentation.shouldApplyBackgroundBlurEffect = YES;
    presentation.backgroundColor = [UIColor colorWithHexString:@"000000"];
    presentation.backgroundAlpha = 0.5;
    presentation.contentViewRect = _presentedRect;
    return presentation;
}

-(void)setNavigationBar:(SYCNavigationBarModel *)navBarModel{
    _isHiddenNavigationBar = NO;
//    UINavigationBar *bar = [UINavigationBar appearance];
//    UIImage *imageOrigin = [UIImage imageNamed:@"navBarBG"];
//    UIImage *image = [imageOrigin image:imageOrigin withColor:color];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    [bar setShadowImage:[[UIImage alloc]init]];
//    bar.barTintColor = [UIColor colorWithHexString:@"458DEF"];
    [SYCNavTitleModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    _titleModel = [SYCNavTitleModel mj_objectWithKeyValues:navBarModel.title];
    
    if ([_titleModel.type isEqualToString:titleType]) {
        UILabel *titleLab = [UILabel navTitle:[_titleModel.value objectForKey:_titleModel.type] TitleColor:[UIColor blackColor] titleFont:[UIFont systemFontOfSize:20]];
        self.navigationItem.titleView = titleLab;
        titleLab.tag = [_titleModel.ID integerValue];
    }else if ([_titleModel.type isEqualToString:imageType]){
        UIImage *titleImage = [UIImage imageNamed:_titleModel.value[_titleModel.type]];
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, titleImage.size.width, titleImage.size.height)];
        imageV.image = titleImage;
        self.navigationItem.titleView = imageV;
        imageV.tag = [_titleModel.ID integerValue];;
    }else if ([_titleModel.type isEqualToString:searchType]){
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        UISearchBar *searchB = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, width/2, 26)];
        NSString *title = _titleModel.value[_titleModel.type][@"title"];
        BOOL isFoucus = [_titleModel.value[_titleModel.type][@"isFocus"] boolValue];
        if (isFoucus) {
            [searchB becomeFirstResponder];
        }
        searchB.placeholder = title;
        searchB.delegate = self;
        UIImage *searchImage = [UIImage imageWithRect:searchB.bounds withColor:[UIColor clearColor]];
        searchB.backgroundImage = searchImage;
        self.navigationItem.titleView = searchB;
        searchB.tag = [_titleModel.ID integerValue];
    }else if ([_titleModel.type isEqualToString:optionType]){
//        _optionURLArr = [NSMutableArray array];
        NSMutableArray *titleArr = [NSMutableArray array];
        NSInteger select = 0;
        for (NSInteger i = 0; i < [_titleModel.value[_titleModel.type] count]; i++) {
            SYCOptionModel *model = [SYCOptionModel mj_objectWithKeyValues:_titleModel.value[_titleModel.type][i]];
//            [_optionURLArr addObject:model.url];
            if (model.select) {
                select = i;
            }
            [titleArr addObject:model.name];
        }
        UISegmentedControl *segMent = [[UISegmentedControl alloc]initWithItems:titleArr];
        segMent.selectedSegmentIndex = select;
        CGRect frameBase = CGRectMake(0, 0,self.view.bounds.size.width/2, 30);
        segMent.frame = frameBase;
        [segMent addTarget:self action:@selector(clickedSegmented:) forControlEvents:UIControlEventValueChanged];
        segMent.tag = [_titleModel.ID integerValue];
        self.navigationItem.titleView = segMent;
        self.navigationItem.titleView.tintColor = [UIColor whiteColor];
        
    }else if ([_titleModel.type isEqualToString:noneType]) {
        _isHiddenNavigationBar = YES;
        return;
    }
    if ([navBarModel.leftBtns count]>0) {
        NSMutableArray *leftItems = [NSMutableArray array];
        
        for (NSDictionary *dic in navBarModel.leftBtns){
            UIBarButtonItem *item = [self creatNavigationItemButtons:dic];
            [leftItems addObject:item];
        }
        UIBarButtonItem * negativeSpacer = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
        [leftItems addObject:negativeSpacer];
        self.navigationItem.leftBarButtonItems = leftItems;
    }
    if ([navBarModel.rightBtns count]>0) {
        NSMutableArray *rightItems = [NSMutableArray array];
        
        for (NSDictionary *dic in navBarModel.rightBtns) {
             UIBarButtonItem *item = [self creatNavigationItemButtons:dic];
            [rightItems addObject:item];
        }
        UIBarButtonItem * negativeSpacer = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
        [rightItems addObject:negativeSpacer];
        self.navigationItem.rightBarButtonItems = rightItems;
    }
}

-(UIBarButtonItem*)creatNavigationItemButtons:(NSDictionary*)dic{
    [SYCEventModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    SYCEventModel *itemM = [SYCEventModel mj_objectWithKeyValues:dic];
    SYCEventButton *eventB = [[SYCEventButton alloc]init];
    eventB.model = itemM;
    if ([itemM.type isEqualToString:groupType]) {
        _groupArr = [NSMutableArray arrayWithCapacity:20];
        [SYCGroupModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID":@"id"};
        }];
        for (NSDictionary *dic in itemM.group) {
            SYCGroupModel *model = [SYCGroupModel mj_objectWithKeyValues:dic];
            [_groupArr addObject:model];
        }
    }
    [eventB addTarget:self action:@selector(EventAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:eventB];
    objc_setAssociatedObject(eventB,eventBarItem,item,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return item;
}

#pragma mark --- segment
-(void)clickedSegmented:(UISegmentedControl*)segment{
    //segment的item 对应ID为控件ID后缀+1 根据ID绑定时间进行响应
    NSString *selectedID =[NSString stringWithFormat:@"%ld%ld",segment.tag,segment.selectedSegmentIndex+1];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *event = [userDef objectForKey:selectedID];
    
    if (![SYCSystem judgeNSString:event]) {
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:nil message:@"稍等片刻~~" delegate:self cancelButtonTitle:@"谢谢等待^_^" otherButtonTitles:nil, nil];
        [aler show];
        return;
    }
    
    if ([event hasPrefix:@"javascript:"]) {
        NSString *newEvent = [event stringByReplacingOccurrencesOfString:@"javascript:" withString:@""];
        if ([event hasSuffix:@";"]) {
            newEvent = [newEvent substringToIndex:[newEvent length]-1];
        }
        [self.CurrentChildVC.commandDelegate evalJs:[newEvent stringByAppendingString:@"()"]];
    }else{
        [self.CurrentChildVC LoadURL:event];
    }

}
-(void)EventAction:(SYCEventButton*)eventB{
    if ([eventB.model.type isEqualToString:backType]) {
        if (_isBackToLast) {
            if (_popOverVC) {
                [_popOverVC dismissViewControllerAnimated:YES completion:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
            if (index-2<0) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                return;
            }
            UIViewController *VC =[self.navigationController.viewControllers objectAtIndex:index-2];
            [self.navigationController popToViewController:VC animated:YES];
        }
        return;
    }
    if ([eventB.model.type isEqualToString:groupType]) {
       UIBarButtonItem *item = objc_getAssociatedObject(eventB, eventBarItem);
       _popOverVC = [[SYCPopoverGroupViewController alloc]init];
       _popOverVC.groupArr = _groupArr;
       _popOverVC.PresentingVC = self.CurrentChildVC;
       NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
       NSString *event = [userDef objectForKey:eventB.model.ID];
       _popOverVC.actionEvent = event;
       _popOverVC.modalPresentationStyle = UIModalPresentationPopover;
       UIPopoverPresentationController *popoverC = [_popOverVC popoverPresentationController];
       popoverC.barButtonItem = item;
       popoverC.delegate = self;
       popoverC.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.85];
       _popOverVC.preferredContentSize = CGSizeMake(105*[SYCSystem PointCoefficient], [_groupArr count]*cellHeight*[SYCSystem PointCoefficient]);
       [self presentViewController:_popOverVC animated:YES
                         completion:nil];
       return;
    }
    
    if (![SYCSystem judgeNSString:eventB.event]) {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *event = [userDef objectForKey:eventB.model.ID];
        eventB.event = event;
    }
    if (![SYCSystem judgeNSString:eventB.event]) {
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:nil message:@"稍等片刻~~" delegate:self cancelButtonTitle:@"谢谢等待^_^" otherButtonTitles:nil, nil];
        [aler show];
        return;
    }
    
    if ([eventB.event hasPrefix:@"javascript:"]) {
        NSString *newEvent = [eventB.event stringByReplacingOccurrencesOfString:@"javascript:" withString:@""];
        if ([eventB.event hasSuffix:@";"]) {
            newEvent = [newEvent substringToIndex:[newEvent length]-1];
        }
        [self.CurrentChildVC.commandDelegate evalJs:[newEvent stringByAppendingString:@"()"]];
    }else{
        [self.CurrentChildVC LoadURL:eventB.event];
    }
}
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    //默认是UIModalPresentationFullScreen，导致popover时候黑屏
    return UIModalPresentationNone;
}
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;   //no点击蒙版popover不消失， 默认yes,点击蒙层dismiss
}
//-(void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
//    [popoverPresentationController dismissalTransitionDidEnd:YES];
//}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSString *selectedID =[NSString stringWithFormat:@"%ld",searchBar.tag];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *event = [userDef objectForKey:selectedID];
    if ([event hasPrefix:@"javascript:"]) {
        NSString *newEvent = [event stringByReplacingOccurrencesOfString:@"javascript:" withString:@""];
        if ([event hasSuffix:@";"]) {
            newEvent = [newEvent substringToIndex:[newEvent length]-1];
        }
        NSString *parmas = [NSString stringWithFormat:@"('%@','%@')",searchBarCilck,searchBar.text];
        newEvent = [newEvent stringByAppendingString:parmas];
//        newEvent=[newEvent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self.CurrentChildVC.commandDelegate evalJs:newEvent];
    }
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
   
    [searchBar resignFirstResponder];
    return YES;
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([SYCSystem judgeNSString:searchBar.text]) {
        NSString *selectedID =[NSString stringWithFormat:@"%ld",searchBar.tag];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *event = [userDef objectForKey:selectedID];
        if ([event hasPrefix:@"javascript:"]) {
            NSString *newEvent = [event stringByReplacingOccurrencesOfString:@"javascript:" withString:@""];
            if ([event hasSuffix:@";"]) {
                newEvent = [newEvent substringToIndex:[newEvent length]-1];
            }
            NSString *parmas = [NSString stringWithFormat:@"('%@','%@')",searchBarChange,searchBar.text];
            newEvent = [newEvent stringByAppendingString:parmas];
//            newEvent=[newEvent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self.CurrentChildVC.commandDelegate evalJs:newEvent];
        }
    }
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *selectedID =[NSString stringWithFormat:@"%ld",searchBar.tag];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *event = [userDef objectForKey:selectedID];
    if ([event hasPrefix:@"javascript:"]) {
        NSString *newEvent = [event stringByReplacingOccurrencesOfString:@"javascript:" withString:@""];
        if ([event hasSuffix:@";"]) {
            newEvent = [newEvent substringToIndex:[newEvent length]-1];
        }
        NSString *parmas = [NSString stringWithFormat:@"('%@','%@')",searchBarSubmit,searchBar.text];
        newEvent = [newEvent stringByAppendingString:parmas];
        //处理中文字符
//        newEvent=[newEvent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [self.CurrentChildVC.commandDelegate evalJs:newEvent];
    }

}
-(UIView*)payLoading{
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    UIView *loadingV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80*[SYCSystem PointCoefficient], 80*[SYCSystem PointCoefficient])];
    loadingV.center = windows.center;
    loadingV.backgroundColor = [UIColor colorWithHexString:@"000000"];
    loadingV.alpha = 0.8;
    loadingV.layer.masksToBounds = YES;
    loadingV.layer.cornerRadius = 10.0;
    
    UIImage *pay_loading = [UIImage imageNamed:@"pay_loading"];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((loadingV.frame.size.width-pay_loading.size.width)/2, 10*[SYCSystem PointCoefficient], pay_loading.size.width, pay_loading.size.height)];
    [imageV setImage:pay_loading];
    [loadingV addSubview:imageV];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, windows.frame.size.width/5, loadingV.bounds.size.width, 20*[SYCSystem PointCoefficient])];
    lable.font = [UIFont systemFontOfSize:20*[SYCSystem PointCoefficient]];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    lable.text = @"生源支付";
    [loadingV addSubview:lable];
    lable.hidden = YES;
    self.view.userInteractionEnabled = NO;
    NSMutableArray *viewArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        CGFloat gap = 6;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(loadingV.frame)/2-6*[SYCSystem PointCoefficient]-gap+i*(gap+4*[SYCSystem PointCoefficient]), CGRectGetHeight(loadingV.frame)- 12, 4*[SYCSystem PointCoefficient], 4*[SYCSystem PointCoefficient])];
        [loadingV addSubview:view];
        view.tag = 1000+i;
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 2.0*[SYCSystem PointCoefficient];
        view.backgroundColor = [UIColor colorWithHexString:@"3B7BCB"];
        [loadingV addSubview:view];
        [viewArr addObject:view];
    }
    __block UIView *view = [loadingV viewWithTag:1000];
    view.backgroundColor = [UIColor whiteColor];
    __block NSInteger i = 0;
    //定时器开始执行的延时时间
    NSTimeInterval delayTime = 0.0f;
    //定时器间隔时间
    NSTimeInterval timeInterval = 0.3f;
    //创建子线程队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //使用之前创建的队列来创建计时器
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置延时执行时间，delayTime为要延时的秒数
    dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC));
    //设置计时器
    dispatch_source_set_timer(_timer, startDelayTime, timeInterval * NSEC_PER_SEC, 0.3 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        i ++;
        i = i%3;
        view = [loadingV viewWithTag:1000+i];
        //执行事件
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UIView *view in viewArr) {
                if ([view.backgroundColor isEqual:[UIColor whiteColor]]) {
                    view.backgroundColor = [UIColor colorWithHexString:@"3B7BCB"];
                }
            }
            view.backgroundColor = [UIColor whiteColor];
        });
    });
    // 启动计时器
    dispatch_resume(_timer);
    [windows addSubview:loadingV];
    return loadingV;
}
-(CALayer*)LayerAnimation{
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds          = CGRectMake(0, 0,  self.view.frame.size.width/3, self.view.frame.size.width/3);
    replicatorLayer.cornerRadius    = 10.0;
    replicatorLayer.position        = windows.center;
    replicatorLayer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2].CGColor;
    [self.view.layer addSublayer:replicatorLayer];
    CALayer *dotLayer        = [CALayer layer];
    dotLayer.bounds          = CGRectMake(0, 0, 15, 15);
    dotLayer.position        = CGPointMake(15, replicatorLayer.frame.size.height/2 );
    dotLayer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6].CGColor;
    dotLayer.cornerRadius    = 7.5;
    replicatorLayer.instanceCount = 3;
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(replicatorLayer.frame.size.width/3, 0, 0);
    [replicatorLayer addSublayer:dotLayer];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration    = 1.0;
    animation.fromValue   = @1;
    animation.toValue     = @0;
    animation.repeatCount = MAXFLOAT;
    [dotLayer addAnimation:animation forKey:nil];
    replicatorLayer.instanceDelay = 1.0/3;
    dotLayer.transform = CATransform3DMakeScale(0, 0, 0);
    return replicatorLayer;
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
