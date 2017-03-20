//
//  SYCShareVersionInfo.m
//  SYCloud
//
//  Created by 文清 on 2017/3/13.
//
//

#import "SYCShareVersionInfo.h"
#import "SYCSystem.h"
@implementation SYCShareVersionInfo
+ (instancetype)sharedVersion{
    static SYCShareVersionInfo *shareVersion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareVersion = [[SYCShareVersionInfo alloc]init];
        shareVersion.systemType = @"1";
        shareVersion.regId = @"";
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        //        shareVersion.appVersionName = [infoDic objectForKey:@"CFBundleDisplayName"];
        shareVersion.appVersionName = [infoDic objectForKey:@"CFBundleShortVersionString"];
        shareVersion.appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        shareVersion.token = [def objectForKey:loadToken];
    });
    return shareVersion;
}

@end