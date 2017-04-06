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
static float const cellHeight = 32.0f;
static float const cellNum = 3;
static float const tableWidth = 130.0f;
static NSString *const searchBarCilck = @"click";
static NSString *const searchBarChange = @"change";
static NSString *const searchBarSubmit = @"submit";
@interface SYCContentViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)SYCNavTitleModel *titleModel;
@property (nonatomic,strong)NSMutableArray *optionURLArr;
@property (nonatomic,strong)NSMutableArray *groupArr;
@property (nonatomic,strong)UITableView *groupTable;
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
    self.pushBlock = ^(NSString *contentUrl,BOOL isBackToLast,SYCNavigationBarModel *navModel){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        SYCContentViewController *viewC =[[SYCContentViewController alloc]init];
        [viewC setNavigationBar:navModel];
        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
        viewC.view.frame = rect;
        viewC.isBackToLast = isBackToLast;
        MainViewController *pushM = [[MainViewController alloc]init];
        pushM.startPage = navModel.url;
        viewC.CurrentChildVC = pushM;
        pushM.view.frame = rect;
        [viewC addChildViewController:pushM];
        [viewC.view addSubview:pushM.view];
        [pushM didMoveToParentViewController:viewC];
        pushM.isChild = YES;
        pushM.isRoot = NO;
        pushM.lastViewController = strongSelf.CurrentChildVC;
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
}
-(void)viewWillDisappear:(BOOL)animated{
    if (!_groupTable.hidden) {
        _groupTable.hidden = YES;
    }
}
-(void)PushScanVC:(NSNotification*)notify{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        //        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未允许app访问相机，无法进进入扫一扫，前往打开权限？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
        //        [alertV show];
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
            
            //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];
        }];
        
        //        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleDefault handler:nil];
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
        [self createTable];
    }
    [eventB addTarget:self action:@selector(EventAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:eventB];
    return item;
}
-(void)createTable{
    
    _groupTable = [[UITableView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-tableWidth, 64, tableWidth, cellNum*cellHeight)];
    _groupTable.delegate = self;
    _groupTable.dataSource = self;
    _groupTable.hidden = YES;
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
        if (_groupTable.hidden) {
            _groupTable.hidden = NO;
            UIWindow *window = [[UIApplication sharedApplication]keyWindow];
            [window addSubview:_groupTable];
        }else{
            _groupTable.hidden = YES;
        }
       
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_groupArr count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    SYCGroupModel *model = _groupArr[indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:model.ico]];
    cell.textLabel.text = model.name;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"999999"];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}
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
