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
static NSString * const SYCloudLocalBaseURL = @"http://172.16.0.143:7360"; //本地服务器
static NSString * const SYCloudFormalBaseURL = @"http://yun.shengyuan.cn"; //正式服务器

NSString *const loadToken = @"LoadToken";

@implementation SYCSystem
+(NSString*)baseURL{
    NSString *baseURL = nil;
        if (DEBUG) {
    //    baseURL = SYCloudLocalBaseURL;
          baseURL = SYCloudTestBaseURL;
          [SYCShareVersionInfo sharedVersion].formal = NO;
        }else{
          baseURL = SYCloudFormalBaseURL;
          [SYCShareVersionInfo sharedVersion].formal = YES;
        }
    return baseURL;
}
+(NSString*)secondsForNow{
    NSDate *nowDate = [NSDate date];
    NSTimeInterval seconds = [nowDate timeIntervalSince1970];
    NSString *time = [NSString stringWithFormat:@"%f",seconds];
    return time;
}

@end
