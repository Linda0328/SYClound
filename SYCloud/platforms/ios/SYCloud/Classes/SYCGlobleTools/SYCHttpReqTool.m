//
//  SYCHttpReqTool.m
//  SYCloud
//
//  Created by 文清 on 2017/3/13.
//
//

#import "SYCHttpReqTool.h"
#import "SYCSystem.h"
#import "SYCShareVersionInfo.h"
#import "NSString+Helper.h"
static NSString * const SYVersionParam = @"/app_resources/app/version.json?_";
static NSString * const SYMainParam = @"/app_resources/app/index.json?_";
NSString * const SYCIndexJson = @"Index.json";
NSString * const SYCIndexVersion = @"IndexVersion";
@implementation SYCHttpReqTool
+(NSDictionary*)VersionInfo{
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@%@",SYVersionParam,[SYCSystem secondsForNow]];
    NSURL *url = [NSURL URLWithString:reqUrl];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
   
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"---版本信息请求出错---%@",[error description]);
        return nil;
    }
    NSError *err = nil;
    NSLog(@"responseMain : %@",response);
    NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSLog(@"backDataMain : %@",backData);
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"---数据解析出错---%@",[err description]);
    }else{
        NSLog(@"----解析结果--- : %@",dic);
    }
    [SYCShareVersionInfo sharedVersion].pageVersion = [dic objectForKey:@"pageVersion"];
    [SYCShareVersionInfo sharedVersion].indexVersion = [dic objectForKey:@"indexVersion"];
    NSUserDefaults *userf = [NSUserDefaults standardUserDefaults];
    NSString *indexV = [userf objectForKey:SYCIndexVersion];
    if(![SYCSystem judgeNSString:indexV]){
        [userf setObject:[dic objectForKey:@"indexVersion"] forKey:SYCIndexVersion];
        [userf synchronize];
    }
    return dic;
    
}
+(NSDictionary*)MainData{
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@%@",SYMainParam,[SYCSystem secondsForNow]];
//    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYMainParam];
    NSURL *url = [NSURL URLWithString:reqUrl];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"---版本信息请求出错---%@",[error description]);
        return nil;
    }
    NSError *err = nil;
    NSLog(@"responseMain : %@",response);
    
    NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSLog(@"backDataMain : %@",backData);

    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"---数据解析出错---%@",[err description]);
    }else{
//        NSString *indexJson = [NSString appendJsonFilePathToDocument:SYCIndexJson];
//        [backData writeToFile:indexJson atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"----解析结果--- : %@",dic);
    }
    NSUserDefaults *userf = [NSUserDefaults standardUserDefaults];
    [userf setObject:dic forKey:SYCIndexJson];
    [userf synchronize];
    return dic;
    
}

@end
