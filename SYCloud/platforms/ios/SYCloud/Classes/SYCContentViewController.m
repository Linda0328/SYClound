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
static float const tableWidth = 130.0f;
static NSString *const searchBarCilck = @"click";
static NSString *const searchBarChange = @"change";
static NSString *const searchBarSubmit = @"submit";
static void *eventBarItem = @"eventBarItem";
@interface SYCContentViewController ()<UISearchBarDelegate,UIViewControllerTransitioningDelegate,UIAdaptivePresentationControllerDelegate,UIPopoverPresentationControllerDelegate>
@property (nonatomic,strong)SYCNavTitleModel *titleModel;
@property (nonatomic,strong)NSMutableArray *optionURLArr;
@property (nonatomic,strong)NSMutableArray *groupArr;
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
//    self.CurrentChildVC.unReachableB = ^(){
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        SYOpenWLANTableViewController *openL = [[SYOpenWLANTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
//        [strongSelf.navigationController pushViewController:openL animated:YES];
//    };
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(PushScanVC:) name:scanNotify object:nil];
    [center addObserver:self selector:@selector(popVC:) name:popNotify object:nil];
    [center addObserver:self selector:@selector(passwordSetting:) name:passwordNotify object:nil];
    [center addObserver:self selector:@selector(PayImmedately:) name:PayImmedateNotify object:nil];
    
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
    SYCPasswordViewController *passwVC = [[SYCPasswordViewController alloc]init];
    passwVC.pswModel = payModel;
    passwVC.showAmount = YES;
    passwVC.presentingMainVC = _CurrentChildVC;
    passwVC.modalPresentationStyle = UIModalPresentationCustom;
    passwVC.transitioningDelegate = self;
    [self presentViewController:passwVC animated:YES completion:nil];
}

-(void)PayImmedately:(NSNotification*)notify{
    SYCPayInfoModel *payModel = (SYCPayInfoModel*)notify.object;
    MainViewController *main = (MainViewController*)[notify.userInfo objectForKey:mainKey];
    if (![main isEqual:_CurrentChildVC]) {
        return;
    }
    SYCPayOrderInfoViewController *payOrderVC = [[SYCPayOrderInfoViewController alloc]init];
    payOrderVC.payInfoModel = payModel;
    payOrderVC.presentingMainVC = _CurrentChildVC;
    payOrderVC.isPreOrderPay = [[notify.userInfo objectForKey:PreOrderPay] boolValue];
    payOrderVC.modalPresentationStyle = UIModalPresentationCustom;
    payOrderVC.transitioningDelegate = self;
    [self presentViewController:payOrderVC animated:YES completion:nil];
}
-(UIPresentationController*)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    SYCPresentationController *presentation = [[SYCPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
//    presentation.blurEffectStyle = UIBlurEffectStyleLight;
//    presentation.shouldApplyBackgroundBlurEffect = YES;
    presentation.backgroundColor = [UIColor colorWithHexString:@"000000"];
    presentation.backgroundAlpha = 0.5;
    presentation.contentViewRect = CGRectMake(0, 2*screenSize.height/5, screenSize.width,  3*screenSize.height/5);
    return presentation;
}
-(void)setNavigationBar:(SYCNavigationBarModel *)navBarModel{
    _isHiddenNavigationBar = NO;
    UIColor *color = [UIColor colorWithHexString:@"458DEF"];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"F9F9F9"];
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHexString:@"458DEF"];
    UINavigationBar *bar = [UINavigationBar appearance];
    UIImage *imageOrigin = [UIImage imageNamed:@"navBarBG"];
    UIImage *image = [imageOrigin image:imageOrigin withColor:color];
    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[[UIImage alloc]init]];
//    bar.barTintColor = [UIColor colorWithHexString:@"458DEF"];
    [SYCNavTitleModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    _titleModel = [SYCNavTitleModel mj_objectWithKeyValues:navBarModel.title];
    
    if ([_titleModel.type isEqualToString:titleType]) {
        UILabel *titleLab = [UILabel navTitle:[_titleModel.value objectForKey:_titleModel.type] TitleColor:[UIColor colorWithHexString:@"ffffff"] titleFont:[UIFont systemFontOfSize:20]];
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
        CGRect frame = segMent.frame;
        frame = CGRectMake(0, 0,self.view.bounds.size.width/2, 30);
        segMent.frame = frame;
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
//        if (_groupTable.hidden) {
//            _groupTable.hidden = NO;
//            UIWindow *window = [[UIApplication sharedApplication]keyWindow];
//            [window addSubview:_groupTable];
//        }else{
//            _groupTable.hidden = YES;
//        }
       UIBarButtonItem *item = objc_getAssociatedObject(eventB, eventBarItem);
       SYCPopoverGroupViewController *popOverVC = [[SYCPopoverGroupViewController alloc]init];
       popOverVC.groupArr = _groupArr;
       popOverVC.modalPresentationStyle = UIModalPresentationPopover;
       UIPopoverPresentationController *popoverC = [popOverVC popoverPresentationController];
       popoverC.barButtonItem = item;
       popoverC.delegate = self;
       popOverVC.preferredContentSize = CGSizeMake(100*[SYCSystem PointCoefficient], [_groupArr count]*cellHeight*[SYCSystem PointCoefficient]);
       [self presentViewController:popOverVC animated:YES
                         completion:nil];

       return;
    }
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *event = [userDef objectForKey:eventB.model.ID];
    eventB.event = event;
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
        [self.CurrentChildVC.commandDelegate evalJs:newEvent];
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
