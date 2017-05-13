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
static NSString * const SYCloudTestBaseURL = @"http://yun.test.shengyuan.cn:7360"; //测试服务器
static NSString * const SYCloudLocalBaseURLJW = @"http://172.16.0.143:7360"; //本地服务器
static NSString * const SYCloudLocalBaseURLTH = @"http://172.16.0.140:7360";
static NSString * const SYCloudFormalBaseURL = @"http://yun.shengyuan.cn:7360"; //正式服务器
static NSString * const SYCloudImageLoadBaseURL = @"http://yun.img.shengyuan.cn"; //正式服务器
NSString * const bundleID = @"com.sycloud.SYCloud";
NSString * const BDAppKay = @"ixLnp9iaDmKMD49N1OVmAsEMpQznxZST";
NSString *const loadToken = @"LoadToken";
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

NSString *const paySuccessNotify = @"paySuccess";

NSString *const PayImmedateNotify = @"PayImmedateNotify";
static CGFloat heightForSixSeries = 568;
NSString *const payAndShowNotify = @"showPayResult";
NSString *const dismissPswNotify = @"dismissPsw";
NSString *const selectPaymentNotify = @"selectPaymentNotify";
NSString *const payment_SuccessCode = @"0000";
NSString *const payment_SuccessMessage = @"支付成功";
NSString *const payment_FailCode = @"1000";
NSString *const payment_FailMessage = @"支付失败";
NSString *const payment_CancelCode = @"2000";
NSString *const payment_CancelMessage = @"支付取消";
@implementation SYCSystem
+(NSString*)baseURL{
    NSString *baseURL = nil;
    #ifdef DEBUG
//    baseURL = SYCloudLocalBaseURLJW;
//    baseURL = SYCloudLocalBaseURLTH;
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
            if (i == 0) {
                paramStr = [NSString stringWithFormat:@"%@%@",allKey[i],parm];
            }else{
                paramStr = [paramStr stringByAppendingFormat:@"%@%@",allKey[i],parm];
            }
            
        }
        
    }
    paramStr = [paramStr stringByAppendingString:SecureSecrit];
    //防止中文乱码
    paramStr = [paramStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"------------parameter----------%@",paramStr);
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
    if ([[self class]deviceHeigth]>heightForSixSeries) {
        return 1.104;
    }
    return 1.0;
}
@end
