//
//  SYCSystem.m
//  SYCloud
//
//  Created by 文清 on 2017/3/11.
//
//

#import "SYCSystem.h"
#import "SYCShareVersionInfo.h"

static NSString * const SYCloudTestBaseURL = @"http://yun.test.shengyuan.cn:7360"; //测试服务器
static NSString * const SYCloudLocalBaseURLJW = @"http://172.16.0.143:7360"; //本地服务器
static NSString * const SYCloudLocalBaseURLTH = @"http://172.16.0.140:7360";
static NSString * const SYCloudFormalBaseURL = @"http://yun.shengyuan.cn"; //正式服务器
static NSString * const SYCloudImageLoadBaseURL = @"http://storage.shengyuan.cn"; //正式服务器
NSString * const bundleID = @"com.sycloud.SYCloud";
NSString * const BDAppKay = @"ixLnp9iaDmKMD49N1OVmAsEMpQznxZST";
NSString *const loadToken = @"LoadToken";
NSString *const popNotify = @"PushVCandReload";
NSString *const scanNotify = @"PushScanVC";
NSString *const updateNotify = @"updateOrNot";
NSString *const hideNotify = @"hideNotice";
NSString *const loadAppNotify = @"LoadApp";
@implementation SYCSystem
+(NSString*)baseURL{
    NSString *baseURL = nil;
    if (DEBUG) {
//    baseURL = SYCloudLocalBaseURLTH;
      baseURL = SYCloudTestBaseURL;
      [SYCShareVersionInfo sharedVersion].formal = NO;
    }else{
      baseURL = SYCloudFormalBaseURL;
      [SYCShareVersionInfo sharedVersion].formal = YES;
    }
    [SYCShareVersionInfo sharedVersion].remoteUrl = baseURL;
    return baseURL;
}
+(NSString*)imagLoadURL{
    NSString *imagLoadURL = nil;
    //    if (DEBUG) {
    //        imagLoadURL = SYSGIMGloadTestBaseURL;
    //    }else{
    imagLoadURL = SYCloudImageLoadBaseURL;
    //    }
    [SYCShareVersionInfo sharedVersion].imageUrl = imagLoadURL;
    return imagLoadURL;
}
+(NSString*)secondsForNow{
    NSDate *nowDate = [NSDate date];
    NSTimeInterval seconds = [nowDate timeIntervalSince1970];
    NSString *time = [NSString stringWithFormat:@"%f",seconds];
    return time;
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

@end
