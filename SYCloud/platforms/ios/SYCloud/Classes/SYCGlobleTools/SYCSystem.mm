//
//  SYCSystem.m
//  SYCloud
//
//  Created by 文清 on 2017/3/11.
//
//

#import "SYCSystem.h"
#import "SYCShareVersionInfo.h"
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Reachability.h"
static NSString * const SYCloudTestBaseURL = @"http://yun.test.shengyuan.cn:7360"; //测试服务器
static NSString * const SYCloudLocalBaseURLJW = @"http://172.16.0.143:7360"; //本地服务器
static NSString * const SYCloudLocalBaseURLTH = @"http://172.16.0.140:7360";
static NSString * const SYCloudLocalBaseURZP = @"http://192.168.0.100";
//static NSString * const SYCloudFormalBaseURL = @"http://yun.shengyuan.cn"; //正式服务器
static NSString * const SYCloudFormalBaseURL = @"http://www.yuanpay.xin"; //正式服务器
//static NSString * const SYCloudImageLoadBaseURL = @"http://yun.img.shengyuan.cn"; //正式服务器
static NSString * const SYCloudImageLoadBaseURL = @"http://www.yuanpay.xin"; //正式服务器

NSString * const WeiXinAppID = @"wxaa61de1143462250";
NSString * const bundleID = @"com.sycloud.SYCloud";
NSString * const BDAppKay = @"ixLnp9iaDmKMD49N1OVmAsEMpQznxZST";
NSString * const QQAppID = @"101414961";
NSString * const QQAppkey = @"b7954e6562b3067283f04b0166709aed";

NSString *const loadToken = @"LoadToken";
NSString *const memberInfo = @"memberInfo";
NSString *const loginName = @"loginName";

NSString *const resultExecNotify = @"resultExecNotify";
NSString *const popNotify = @"PushVCandReload";
NSString *const scanNotify = @"PushScanVC";
NSString *const updateNotify = @"updateOrNot";
NSString *const hideNotify = @"hideNotice";
NSString *const loadAppNotify = @"LoadApp";
NSString *const SecureSecrit = @"Sy-CloudPay-Android";
NSString *const passwordNotify = @"passwordNotify";

NSString *const groupRefreshNotify = @"groupRefresh";
NSString *const groupEventKey = @"groupEvent";
NSString *const groupItemIDKey = @"groupItemID";

NSString *const AliPay = @"AliPay";
NSString *const AliPayResult = @"AliPayResult";
NSString *const WeixiPay = @"WeixinPay";
NSString *const WeixiPayResult = @"WeixiPayResult";
NSString *const AliPayScheme = @"SYCloud";
NSString *const AliPaySuccess = @"0000";
NSString *const AliPayFail = @"7000";

//pay password
NSString *const PayPsw = @"passwordForPay";
NSString *const PaypswSet = @"passwordForPaySetOrNot";
NSString *const mainKey = @"mainVC";
NSString *const PreOrderPay = @"PayType";
NSString *const PayResultCallback = @"ResultCallback";
NSString *const payMentTypeCode = @"code";
NSString *const payMentTypeScan = @"scan";
NSString *const payMentTypeImme = @"immediately";
NSString *const payMentTypeSDK = @"SYCPaySDK";

NSString *const paySuccessNotify = @"paySuccess";

NSString *const PayImmedateNotify = @"PayImmedateNotify";
NSString *const LoadSuccessRemoveAuthNotify = @"LoadSuccessRemoveAuthNotify";
static CGFloat heightForSixSeries = 667;
static CGFloat heightForFivethSeries = 568;
NSString *const payAndShowNotify = @"showPayResult";
NSString *const dismissPswNotify = @"dismissPsw";
NSString *const selectPaymentNotify = @"selectPaymentNotify";
NSString *const refreshPaymentNotify = @"refreshPayment";
NSString *const payment_SuccessCode = @"0000";
NSString *const payment_SuccessMessage = @"支付成功";
NSString *const payment_FailCode = @"1000";
NSString *const payment_FailMessage = @"支付失败";
NSString *const payment_CancelCode = @"2000";
NSString *const payment_CancelMessage = @"支付取消";

NSString *const SYCPayKEY = @"SYCPay";//生源支付key
NSString *const SYCPrepayIDkey = @"prepayId";
NSString *const SYCThirdPartSchemeKey = @"scheme";
NSString * const SYCSystemType = @"1";

NSString *const PageVersionKey = @"pageVersion";

NSString *const paymentResultCodeKey = @"resultCode";
NSString *const paymentDatakey = @"paymentmodelkey";

NSString *const shareNotify = @"shareNotify";
NSString *const shareIMGNotify = @"shareIMG";
NSString *const dismissShareNotify = @"dismissShare";
NSString *const closeLockNotify = @"closeLock";
NSString *const openLockNotify = @"openLock";
NSString *const showPhotoNotify = @"showPhoto";
NSString *const LoadAgainNotify = @"loadAgain";
NSString *const guidenceNotify = @"guidence";
NSString *const photoArrkey = @"photoArr";
NSString *const defaultPhotoIndexKey = @"defaultPhotoIndex";
NSString *const SDKIDkey = @"SDKID";
NSString *const finishSDKPay = @"finishSDKPay";
//push message type
NSString *const pushMessageTypePage = @"page";
NSString *const pushNotify = @"pushNotify";
NSString *const SYCVersionCode = @"1.0.5";
NSString *const versionCode = @"versionCode";
NSString *const GuidenceImagesKey = @"GuidenceImages";
NSString *const SYCRegIDKey = @"RegIDKey";

NSString *const SYCGesturePassword = @"GesturePassword";
@implementation SYCSystem
+(NSString*)baseURL{
    NSString *baseURL = nil;
    #ifdef DEBUG
//     baseURL = SYCloudLocalBaseURLJW;
//      baseURL = SYCloudLocalBaseURLTH;
//    baseURL = SYCloudLocalBaseURZP;
      baseURL = SYCloudTestBaseURL;
      [SYCShareVersionInfo sharedVersion].formal = NO;
    #else
      baseURL = SYCloudFormalBaseURL;
      [SYCShareVersionInfo sharedVersion].formal = YES;
    #endif
    [SYCShareVersionInfo sharedVersion].remoteUrl = baseURL;
    return baseURL;
}
+(NSString*)imagLoadURL{
    NSString *imagLoadURL = SYCloudImageLoadBaseURL;
    [SYCShareVersionInfo sharedVersion].imageUrl = imagLoadURL;
    return imagLoadURL;
}
+(NSString*)secondsForNow{
    NSDate *nowDate = [NSDate date];
    NSTimeInterval seconds = [nowDate timeIntervalSince1970];
    NSString *time = [NSString stringWithFormat:@"%f",seconds];
    return time;
}
+(NSString*)sinagureForReq:(NSDictionary*)params{
    NSMutableDictionary *paramWithRandomNo = nil;
    NSString *paramStr = nil;
    if (params) {
        paramWithRandomNo = [NSMutableDictionary dictionaryWithDictionary:params];
        NSArray *allKey = [paramWithRandomNo allKeys];
        //数组升序排列
        allKey = [allKey sortedArrayUsingSelector:@selector(compare:)];
        for (NSInteger i = 0; i < [allKey count]; i++) {
            NSString *parm = [NSString stringWithFormat:@"%@",[paramWithRandomNo objectForKey:allKey[i]]];
            //解码UTF-8,反编码显示中文
            parm = [parm stringByRemovingPercentEncoding];
            if (i == 0) {
                paramStr = [NSString stringWithFormat:@"%@%@",allKey[i],parm];
            }else{
                paramStr = [paramStr stringByAppendingFormat:@"%@%@",allKey[i],parm];
            }
            
        }
        
    }
    paramStr = [paramStr stringByAppendingString:SecureSecrit];
    //处理特殊字符
//    paramStr = [paramStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *signature = [SYCSystem md5:paramStr];
    return signature;
}
+(NSString*)md5:(NSString*)input{
    if (![SYCSystem judgeNSString:input ]) {
        return nil;
    }
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",digest[i]];
    }
    return output;
}

+(BOOL)judgeNSString:(NSString*)str{
    if (![str isKindOfClass:[NSString class]]) {
        str = [NSString stringWithFormat:@"%@",str];
    }
    if (!str) {
        return NO;
    }
    
    if ([str isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([[NSNull null] isEqual:str]) {
        return NO;
    }
    if (str.length == 0) {
        return NO;
    }
    if ([@"(null)" isEqualToString:str]) {
        return NO;
    }
    if ([@"<null>" isEqualToString:str]) {
        return NO;
    }
    return YES;
}
+(NSURL*)appUrl:(CDVViewController*)CDV
{
    NSURL* appURL = nil;
    
    if ([CDV.startPage rangeOfString:@"://"].location != NSNotFound) {
        appURL = [NSURL URLWithString:CDV.startPage];
    } else if ([CDV.wwwFolderName rangeOfString:@"://"].location != NSNotFound) {
        appURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", CDV.wwwFolderName, CDV.startPage]];
    } else if([CDV.wwwFolderName hasSuffix:@".bundle"]){
        // www folder is actually a bundle
        NSBundle* bundle = [NSBundle bundleWithPath:CDV.wwwFolderName];
        appURL = [bundle URLForResource:CDV.startPage withExtension:nil];
    } else if([CDV.wwwFolderName hasSuffix:@".framework"]){
        // www folder is actually a framework
        NSBundle* bundle = [NSBundle bundleWithPath:CDV.wwwFolderName];
        appURL = [bundle URLForResource:CDV.startPage withExtension:nil];
    } else {
        // CB-3005 strip parameters from start page to check if page exists in resources
        NSURL* startURL = [NSURL URLWithString:CDV.startPage];
        NSString* startFilePath = [CDV.commandDelegate pathForResource:[startURL path]];
        
        if (startFilePath == nil) {
            appURL = nil;
        } else {
            appURL = [NSURL fileURLWithPath:startFilePath];
            // CB-3005 Add on the query params or fragment.
            NSString* startPageNoParentDirs = CDV.startPage;
            NSRange r = [startPageNoParentDirs rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?#"] options:0];
            if (r.location != NSNotFound) {
                NSString* queryAndOrFragment = [CDV.startPage substringFromIndex:r.location];
                appURL = [NSURL URLWithString:queryAndOrFragment relativeToURL:appURL];
            }
        }
    }
    
    return appURL;
}
+(NSString *)loaclResourcePath{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *resPath = [mainBundle resourcePath];
//    NSString *jsPath = [resPath stringByAppendingString:docName];
    NSString *hasFex = @"file://";
    NSString *jsPath = [hasFex stringByAppendingString:resPath];
    NSLog(@"jspath----------%@",jsPath);
    return  jsPath;
}
+(CGFloat)deviceWidth{
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    return width;
}
+(CGFloat)deviceHeigth{
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
    return height;
}
+(NSString*)guidenceImageName:(NSString*)iName{
    
    CGFloat width = [SYCSystem deviceWidth];
    if ([SYCSystem deviceWidth]>375) {
        width = 540;
    }else if([SYCSystem deviceWidth]>320){
        width = 375;
    }else{
        width = 320;
    }
    NSString *imageName = [NSString stringWithFormat:@"%@_%.f",iName,width];
    return imageName;
}
+(NSMutableArray*)NewGuiderImageS{
    NSMutableArray *arr = [NSMutableArray array];
    CGFloat width = [SYCSystem deviceWidth];
    if ([SYCSystem deviceWidth]>375) {
        width = 540;
    }else if([SYCSystem deviceWidth]>320){
        width = 375;
    }else{
        width = 320;
    }
    NSString *wh = [NSString stringWithFormat:@"yd%.f_",width];
    for (NSInteger i = 1 ; i<6; i++) {
        NSString *newWH = [wh stringByAppendingFormat:@"%zd.png",i];
        [arr addObject:newWH];
    }
    return arr;
}
+(NSMutableArray*)guiderImageS{
    NSMutableArray *arr = [NSMutableArray array];
    //    NSString *wh = [NSString stringWithFormat:@"%.0fx%.0f-",2*[SYGlobleConst deviceWidth],2*[SYGlobleConst deviceHeigth]];
    NSString *wh = @"640x960-";
    if ([SYCSystem deviceWidth]>375) {
        wh = @"1080x1920-";
    }else if ([SYCSystem deviceWidth]>320) {
        wh = @"750x1334-";
    }else{
        if ([SYCSystem deviceHeigth]>480) {
            wh = @"640x1136-";
        }
        
    }
    for (NSInteger i = 1 ; i<4; i++) {
        NSString *newWH = [wh stringByAppendingFormat:@"%zd.png",i];
        [arr addObject:newWH];
    }
    return arr;
}
+(BOOL)connectedToNetwork{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieverFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieverFlags) {
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}
+ (NSString *)getNetType
{
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSString *net = @"当前无网路连接";
    if ( ReachableViaWiFi ==internetStatus) {
        net = @"WIFI";
    }
    if ( ReachableViaWWAN ==internetStatus) {
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        NSString *currentStatus = info.currentRadioAccessTechnology;
        
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
            net = @"GPRS";
        }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
            net = @"2.75G EDGE";
        }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
            net = @"3G";
        }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
            net = @"3.5G HSDPA";
        }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
            net = @"3.5G HSUPA";
        }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
            net = @"2G";
        }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
            net = @"3G";
        }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
            net = @"3G";
        }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
            net = @"3G";
        }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
            net = @"HRPD";
        }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
            net = @"4G";
        }
    }
    return net;
}
+(NSString*)getNetworkType{
    NSString *networkType = nil;
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    switch (type) {
        case 0:
            networkType = @"无网络";
            break;
        case 1:
            networkType = @"2G";
            break;
        case 2:
            networkType = @"3G";
            break;
        case 3:
            networkType = @"4G";
            break;
        case 5:
            networkType = @"WIFI";
            break;
        default:
            networkType = @"检测不到网络";
            break;
    }
    return networkType;
}
+(CGFloat)PointCoefficient{
    if (([[self class]deviceHeigth]<heightForFivethSeries+1)||isIphoneX) {
        return 0.845;
    }
    if ([[self class]deviceHeigth]>heightForSixSeries) {
        return 1.104;
    }
    
    return 1.0;
}
+(NSDictionary *)dealWithURL:(NSString*)url{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *arr = [url componentsSeparatedByString:@"&"];
    for (NSString *itemS in arr) {
        if ([itemS containsString:@"="]) {
            NSArray *itemArr = [itemS componentsSeparatedByString:@"="];
            if ([itemArr count]==2) {
                [dic setObject:itemArr[1] forKey:itemArr[0]];
            }
        }
    }
    return dic;
}
+ (BOOL)isMobilePhoneOrtelePhone:(NSString *)mobileNum {
    if (mobileNum==nil || mobileNum.length ==0) {
        return NO;
    }
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^((13)|(14)|(15)|(17)|(18))\\d{9}$";// @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
//    NSString * PHS = @"^((0\\d{2,3}-?)\\d{7,8}(-\\d{2,5})?)$";// @"^0(10|2[0-5789]-|\\d{3})\\d{7,8}$";
    
//    NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)){
        return YES;
    }
    else{
        return NO;
    }
}
+(void)setGesturePassword:(NSString*)password{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setObject:password forKey:SYCGesturePassword];
    [userdefault synchronize];
}
+(NSString*)getGesturePassword{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *password = [userdefault objectForKey:SYCGesturePassword];
    return password;
}
@end
