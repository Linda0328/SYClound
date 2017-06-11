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
#import "SYCUUID.h"
static NSString * const SYVersionParam = @"/app/common/version.jhtml?_";
static NSString * const SYMainParam = @"/app_resources/app/index.json?_";
static NSString * const SYCPswSetOrNot = @"/app/payment/member_pay_password.jhtml?";
static NSString * const SYCPswSet = @"/app/payment/init_pay_password.jhtml?";
static NSString * const SYCPayImmediately = @"/app/payment/member_pay_type.jhtml?";
static NSString * const SYCPayScan = @"/app/payment/qr_pay_info.jhtml?";
static NSString * const SYCPayCode = @"/app/payment/member_pay_info.jhtml?";
static NSString * const SYCPayConfirm= @"/app/payment/confirm_payment.jhtml?";
static NSString * const SYCCaptchaForYKT= @"/app//card/remoteCaptcha.jhtml?";
static NSString * const SYCBlindYKT= @"/app/card/bindCard.jhtml?";
NSString * const SYCIndexJson = @"Index.json";
NSString * const SYCIndexVersion = @"IndexVersion";
NSString * const SYCChannel = @"02";
NSString * const GETRequest = @"GET";
NSString * const POSTRequest = @"POST";

NSString * const resultRequestErrorKey = @"RequestError";
NSString * const resultJsonErrorKey = @"JsonError";
NSString * const resultSuccessKey = @"RequestSucsess";

NSString * const resultCodeKey = @"RequestCode";
NSString * const resultCodeRequestError = @"RequestErrorCode";
NSString * const resultCodeJsonError = @"JsonErrorCode";
NSString * const resultCodeSuccess = @"SucsessCode";

@implementation SYCHttpReqTool
+(NSDictionary*)VersionInfo{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    [SYCSystem imagLoadURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@%@",SYVersionParam,[SYCSystem secondsForNow]];
    NSURL *url = [NSURL URLWithString:reqUrl];
    reqUrl = [reqUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
   
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        [result setObject:[error description] forKey:resultRequestErrorKey];
        resultCode = resultCodeRequestError;
        NSLog(@"---版本信息请求出错---%@",[error description]);
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
        [result setObject:[err description] forKey:resultJsonErrorKey];
        resultCode = resultCodeJsonError;
        NSLog(@"---数据解析出错---%@",[err description]);
    }else{
        [SYCShareVersionInfo sharedVersion].pageVersion = [dic objectForKey:@"pageVersion"];
        [SYCShareVersionInfo sharedVersion].needUpdate = [[dic objectForKey:@"needUpdate"] boolValue];
        [SYCShareVersionInfo sharedVersion].indexVersion = [dic objectForKey:@"indexVersion"];
        [result setObject:dic forKey:resultSuccessKey];
        NSLog(@"----解析结果--- : %@",dic);
    }
    [result setObject:resultCode forKey:resultCodeKey];
    
    return result;
    
}
+(NSDictionary*)MainData{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@%@",SYMainParam,[SYCSystem secondsForNow]];
//    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYMainParam];
    NSURL *url = [NSURL URLWithString:reqUrl];
    reqUrl = [reqUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        [result setObject:[error description] forKey:resultRequestErrorKey];
        resultCode = resultCodeRequestError;
        NSLog(@"---maindata请求出错---%@",[error description]);
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
        [result setObject:[err description] forKey:resultJsonErrorKey];
        resultCode = resultCodeJsonError;
        NSLog(@"---maindata数据解析出错---%@",[err description]);
    }else{
        NSString *indexJson = [NSString appendJsonFilePathToDocument:SYCIndexJson];
        [backData writeToFile:indexJson atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSUserDefaults *userf = [NSUserDefaults standardUserDefaults];
        NSString *indexV = [userf objectForKey:SYCIndexVersion];
        if(![SYCSystem judgeNSString:indexV]){
            [userf setObject:[SYCShareVersionInfo sharedVersion].indexVersion forKey:SYCIndexVersion];
            [userf synchronize];
        }
        [result setObject:dic forKey:resultSuccessKey];
        NSLog(@"----解析结果--- : %@",dic);
    }
    [result setObject:resultCode forKey:resultCodeKey];
    NSUserDefaults *userf = [NSUserDefaults standardUserDefaults];
    [userf setObject:dic forKey:SYCIndexJson];
    [userf synchronize];
    return result;
}
+(void)PswSetOrNot:(void (^)(NSString *resultCode,BOOL resetPsw))completionHandler{
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCPswSetOrNot];
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
    NSString *signature = [SYCSystem sinagureForReq:paramDic];
    [paramDic setObject:signature forKey:@"_signdata"];
    for (NSString *key in [paramDic allKeys]) {
        if ([[paramDic allKeys]indexOfObject:key] == [[paramDic allKeys] count]-1) {
            param = [param stringByAppendingFormat:@"%@=%@",key,[paramDic objectForKey:key]];
        }else{
            param = [param stringByAppendingFormat:@"%@=%@&",key,[paramDic objectForKey:key]];
        }
    }
    NSURL *url = [NSURL URLWithString:reqUrl];
    reqUrl = [reqUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (error) {
//        NSLog(@"---验证是否有支付密码请求出错---%@",[error description]);
//        return nil;
//    }
//    NSError *err = nil;
//    NSLog(@"pswSet : %@",response);
    NSURLSession *shareSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 网络请求完成之后就会执行，NSURLSession自动实现多线程
        NSLog(@"%@",[NSThread currentThread]);
        BOOL need_reset = NO;
        if (data && (error == nil)) {
            
            // 网络访问成功
            NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSLog(@"pswset : %@",backData);
            NSError *err = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                NSLog(@"---数据解析出错---%@",[err description]);
                resultCode = resultCodeJsonError;
            }else{
                NSLog(@"----解析结果--- : %@",dic);
                need_reset = [[[dic objectForKey:@"result"] objectForKey:@"need_reset"] boolValue];
            }
        } else {
            // 网络访问失败
            NSLog(@"error=%@",error);
            resultCode = resultCodeRequestError;
        }
        if (completionHandler) {
            completionHandler(resultCode,need_reset);
        }
        
    }];
    [dataTask resume];
}
+(void)PswSet:(NSString*)psw completion:(void (^)(NSString *, BOOL))completionHandler{
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCPswSet];
    
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
   
    [paramDic setObject:psw forKey:@"payPassword"];
    NSString *signature = [SYCSystem sinagureForReq:paramDic];
    [paramDic setObject:signature forKey:@"_signdata"];
    for (NSString *key in [paramDic allKeys]) {
        if ([[paramDic allKeys]indexOfObject:key] == [[paramDic allKeys] count]-1) {
            param = [param stringByAppendingFormat:@"%@=%@",key,[paramDic objectForKey:key]];
        }else{
            param = [param stringByAppendingFormat:@"%@=%@&",key,[paramDic objectForKey:key]];
        }
        
    }
    NSURL *url = [NSURL URLWithString:reqUrl];
    reqUrl = [reqUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (error) {
//        NSLog(@"---支付密码请求出错---%@",[error description]);
//    }
//    NSError *err = nil;
//    NSLog(@"responseMain : %@",response);
//    
//    NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//    NSLog(@"backDataMain : %@",backData);
//    
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
//    if (err) {
//        NSLog(@"---数据解析出错---%@",[err description]);
//    }else{
//        
//        NSLog(@"----解析结果--- : %@",dic);
//    }
//    NSString *code = [dic objectForKey:@"code"];
//    if ([code isEqualToString:@"000000"]) {
//        return YES;
//    }
    NSURLSession *shareSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 网络请求完成之后就会执行，NSURLSession自动实现多线程
        NSLog(@"%@",[NSThread currentThread]);
         BOOL success = NO;
        if (data && (error == nil)) {
            // 网络访问成功
            NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSLog(@"pswset : %@",backData);
            NSError *err = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                NSLog(@"---数据解析出错---%@",[err description]);
                resultCode = resultCodeJsonError;
            }else{
                NSLog(@"----解析结果--- : %@",dic);
                NSString *code = [dic objectForKey:@"code"];
                if ([code isEqualToString:@"000000"]) {
                   success = YES;
                }else{
                   success = NO;
                }
            }
           
        } else {
            // 网络访问失败
            NSLog(@"error=%@",error);
            resultCode = resultCodeRequestError;
        }
        if (completionHandler) {
            completionHandler(resultCode,success);
        }
        
    }];
    [dataTask resume];

}
+(void)PayPswResponseUrl:(NSString*)url pswParam:(NSString*)pswParam password:(NSString*)password parmaDic:(NSDictionary*)paramDic completion:(void (^)(NSString *resultCode,BOOL success,NSString *msg,NSDictionary *successDic))completionHandler{
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",url];
    
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramD = [[self class] commonParam];
    for (NSString *key in [paramDic allKeys]) {
        [paramD setObject:[paramDic objectForKey:key] forKey:key];
    }
    
    [paramD setObject:password forKey:pswParam];
    NSString *signature = [SYCSystem sinagureForReq:paramD];
    [paramD setObject:signature forKey:@"_signdata"];
    for (NSString *key in [paramD allKeys]) {
        if ([[paramD allKeys]indexOfObject:key] == [[paramD allKeys] count]-1) {
            param = [param stringByAppendingFormat:@"%@=%@",key,[paramD objectForKey:key]];
        }else{
            param = [param stringByAppendingFormat:@"%@=%@&",key,[paramD objectForKey:key]];
        }
        
    }
    NSURL *requrl = [NSURL URLWithString:reqUrl];
    reqUrl = [reqUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requrl];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (error) {
//        NSLog(@"---支付密码输入正确出错---%@",[error description]);
//        return nil;
//    }
//    NSError *err = nil;
//    NSLog(@"responseMain : %@",response);
//    
//    NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//    NSLog(@"backDataMain : %@",backData);
//    
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
//    if (err) {
//        NSLog(@"---数据解析出错---%@",[err description]);
//    }else{
//        
//        NSLog(@"----解析结果--- : %@",dic);
//    }
    
    NSURLSession *shareSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 网络请求完成之后就会执行，NSURLSession自动实现多线程
        NSLog(@"%@",[NSThread currentThread]);
        BOOL success = NO;
        NSString *message = nil;
        NSDictionary *dic = nil;
        if (data && (error == nil)) {
            // 网络访问成功
            NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSLog(@"pswset : %@",backData);
            NSError *err = nil;
            dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                NSLog(@"---数据解析出错---%@",[err description]);
                resultCode = resultCodeJsonError;
            }else{
                NSLog(@"----解析结果--- : %@",dic);
                NSString *code = [dic objectForKey:@"code"];
                if ([code isEqualToString:@"000000"]) {
                    success = YES;
                }else{
                    success = NO;
                    message = [dic objectForKey:@"msg"];
                }
            }
            
        } else {
            // 网络访问失败
            NSLog(@"error=%@",error);
            resultCode = resultCodeRequestError;
        }
        if (completionHandler) {
            completionHandler(resultCode,success,message,dic);
        }
        
    }];
    [dataTask resume];

}
+(NSMutableDictionary*)commonParam{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[SYCShareVersionInfo sharedVersion].token forKey:@"token"];
    [param setObject:[SYCShareVersionInfo sharedVersion].appVersion forKey:@"_version"];
    [param setObject:SYCChannel forKey:@"_channel"];
    [param setObject:[SYCSystem getNetworkType] forKey:@"_network"];
    [param setObject:[[SYCUUID shareUUID] getUUID] forKey:@"_regid"];
    [param setObject:[SYCSystem secondsForNow] forKey:@"_timestanp"];
    return param;
}
+(void)ajaxResponseUrl:(NSString*)url requestType:(NSString*)type isSignature:(BOOL)ISsignature parmaDic:(NSMutableDictionary*)params completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler{
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",url];
    NSLog(@"------%@---",params);
    if (ISsignature) {
        NSString *signature = [SYCSystem sinagureForReq:params];
        [params setObject:signature forKey:@"_signdata"];
    }
    NSString *paramStr = [[NSString alloc]init];
    for (NSString *key in [params allKeys]) {
        if ([[params allKeys]indexOfObject:key] == [[params allKeys] count]-1) {
            paramStr = [paramStr stringByAppendingFormat:@"%@=%@",key,[params objectForKey:key]];
        }else{
            paramStr = [paramStr stringByAppendingFormat:@"%@=%@&",key,[params objectForKey:key]];
        }
    }
    if ([type isEqualToString:GETRequest]) {
        reqUrl = [reqUrl stringByAppendingFormat:@"%@%@",@"?",paramStr];
    }
    reqUrl = [reqUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    reqUrl = [reqUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqUrl]];
    request.HTTPMethod = type;
    request.timeoutInterval = 10.0f;
    if ([type isEqualToString:POSTRequest]) {
        request.HTTPBody = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    }
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (error) {
//        NSLog(@"---a确出错---%@",[error description]);
//        [result setObject:[error description] forKey:resultRequestErrorKey];
//        return nil;
//    }
//    NSError *err = nil;
//    NSLog(@"responseMain : %@",response);
//    
//    NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//    NSLog(@"backDataMain : %@",backData);
//    
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
//    if (err) {
//        [result setObject:[err description] forKey:resultJsonErrorKey];
//        NSLog(@"---数据解析出错---%@",[err description]);
//    }else{
//         [result setObject:dic forKey:resultSuccessKey];
//        NSLog(@"----解析结果--- : %@",dic);
//    }
    NSURLSession *shareSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 网络请求完成之后就会执行，NSURLSession自动实现多线程
        NSLog(@"%@",[NSThread currentThread]);
        
        NSDictionary *dic = nil;
        if (data && (error == nil)) {
           
            // 网络访问成功
            NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSLog(@"pswset : %@",backData);
            NSError *err = nil;
            dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                NSLog(@"---数据解析出错---%@",[err description]);
                resultCode = resultCodeJsonError;
               [result setObject:[err description] forKey:resultJsonErrorKey];
            }else{
                NSLog(@"----解析结果--- : %@",dic);
                [result setObject:dic forKey:resultSuccessKey];
            }
        } else {
            // 网络访问失败
            NSLog(@"error=%@",error);
            resultCode = resultCodeRequestError;
            [result setObject:[error description] forKey:resultRequestErrorKey];
        }
        if (completionHandler) {
            completionHandler(resultCode,result);
        }
    }];
    [dataTask resume];
}

+(void)payImmediatelyInfoWithpayAmount:(NSString*)amount completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler{
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCPayImmediately];
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
    
    [paramDic setObject:amount forKey:@"payAmount"];
    NSString *signature = [SYCSystem sinagureForReq:paramDic];
    [paramDic setObject:signature forKey:@"_signdata"];
    for (NSString *key in [paramDic allKeys]) {
        if ([[paramDic allKeys]indexOfObject:key] == [[paramDic allKeys] count]-1) {
            param = [param stringByAppendingFormat:@"%@=%@",key,[paramDic objectForKey:key]];
        }else{
            param = [param stringByAppendingFormat:@"%@=%@&",key,[paramDic objectForKey:key]];
        }
        
    }
    NSURL *url = [NSURL URLWithString:reqUrl];
    reqUrl = [reqUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (error) {
//        NSLog(@"---面对面支付请求出错---%@",[error description]);
//        
//    }
//    NSError *err = nil;
//    NSLog(@"responseMain : %@",response);
//    
//    NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//    NSLog(@"backDataMain : %@",backData);
//    
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
//    if (err) {
//        NSLog(@"---数据解析出错---%@",[err description]);
//    }else{
//        
//        NSLog(@"----解析结果--- : %@",dic);
//    }
    NSURLSession *shareSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 网络请求完成之后就会执行，NSURLSession自动实现多线程
        NSLog(@"%@",[NSThread currentThread]);
        
        NSDictionary *dic = nil;
        if (data && (error == nil)) {
            
            // 网络访问成功
            NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSLog(@"pswset : %@",backData);
            NSError *err = nil;
            dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                NSLog(@"---数据解析出错---%@",[err description]);
                resultCode = resultCodeJsonError;
                [result setObject:[err description] forKey:resultJsonErrorKey];
            }else{
                NSLog(@"----解析结果--- : %@",dic);
                [result setObject:dic forKey:resultSuccessKey];
            }
        } else {
            // 网络访问失败
            NSLog(@"error=%@",error);
            resultCode = resultCodeRequestError;
            [result setObject:[error description] forKey:resultRequestErrorKey];
        }
        if (completionHandler) {
            completionHandler(resultCode,result);
        }
    }];
    [dataTask resume];
}
+(void)payScanInfoWithQrcode:(NSString*)qrcode completion:(void (^)(NSString *, NSMutableDictionary *))completionHandler{
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCPayScan];
   
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
    [paramDic setObject:qrcode forKey:@"qrCode"];
    NSString *signature = [SYCSystem sinagureForReq:paramDic];
    [paramDic setObject:signature forKey:@"_signdata"];
    for (NSString *key in [paramDic allKeys]) {
        if ([[paramDic allKeys]indexOfObject:key] == [[paramDic allKeys] count]-1) {
            param = [param stringByAppendingFormat:@"%@=%@",key,[paramDic objectForKey:key]];
        }else{
            param = [param stringByAppendingFormat:@"%@=%@&",key,[paramDic objectForKey:key]];
        }
        
    }
    NSURL *url = [NSURL URLWithString:reqUrl];
    reqUrl = [reqUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (error) {
//        NSLog(@"---扫码支付请求出错---%@",[error description]);
//        return nil;
//    }
//    NSError *err = nil;
//    NSLog(@"responseMain : %@",response);
//    
//    NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//    NSLog(@"backDataMain : %@",backData);
//    
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
//    if (err) {
//        NSLog(@"---数据解析出错---%@",[err description]);
//    }else{
//        
//        NSLog(@"----解析结果--- : %@",dic);
//    }
//    return dic;
    NSURLSession *shareSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 网络请求完成之后就会执行，NSURLSession自动实现多线程
        NSLog(@"%@",[NSThread currentThread]);
        
        NSDictionary *dic = nil;
        if (data && (error == nil)) {
            
            // 网络访问成功
            NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSLog(@"pswset : %@",backData);
            NSError *err = nil;
            dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                NSLog(@"---数据解析出错---%@",[err description]);
                resultCode = resultCodeJsonError;
                [result setObject:[err description] forKey:resultJsonErrorKey];
            }else{
                NSLog(@"----解析结果--- : %@",dic);
                [result setObject:dic forKey:resultSuccessKey];
            }
        } else {
            // 网络访问失败
            NSLog(@"error=%@",error);
            resultCode = resultCodeRequestError;
            [result setObject:[error description] forKey:resultRequestErrorKey];
        }
        if (completionHandler) {
            completionHandler(resultCode,result);
        }
    }];
    [dataTask resume];
}
+(void)payScanInfoWithPaycode:(NSString*)payCode completion:(void (^)(NSString *, NSMutableDictionary *))completionHandler{
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCPayCode];
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
    [paramDic setObject:payCode forKey:@"payBarcode"];
    NSString *signature = [SYCSystem sinagureForReq:paramDic];
    [paramDic setObject:signature forKey:@"_signdata"];
    for (NSString *key in [paramDic allKeys]) {
        if ([[paramDic allKeys]indexOfObject:key] == [[paramDic allKeys] count]-1) {
            param = [param stringByAppendingFormat:@"%@=%@",key,[paramDic objectForKey:key]];
        }else{
            param = [param stringByAppendingFormat:@"%@=%@&",key,[paramDic objectForKey:key]];
        }
        
    }
    NSURL *url = [NSURL URLWithString:reqUrl];
    reqUrl = [reqUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (error) {
//        NSLog(@"---付款码支付请求出错---%@",[error description]);
//        return nil;
//    }
//    NSError *err = nil;
//    NSLog(@"responseMain : %@",response);
//    
//    NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//    NSLog(@"backDataMain : %@",backData);
//    
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
//    if (err) {
//        NSLog(@"---数据解析出错---%@",[err description]);
//    }else{
//        
//        NSLog(@"----解析结果--- : %@",dic);
//    }
//    return dic;
    NSURLSession *shareSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 网络请求完成之后就会执行，NSURLSession自动实现多线程
        NSLog(@"%@",[NSThread currentThread]);
        
        NSDictionary *dic = nil;
        if (data && (error == nil)) {
            
            // 网络访问成功
            NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSLog(@"pswset : %@",backData);
            NSError *err = nil;
            dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                NSLog(@"---数据解析出错---%@",[err description]);
                resultCode = resultCodeJsonError;
                [result setObject:[err description] forKey:resultJsonErrorKey];
            }else{
                NSLog(@"----解析结果--- : %@",dic);
                [result setObject:dic forKey:resultSuccessKey];
            }
        } else {
            // 网络访问失败
            NSLog(@"error=%@",error);
            resultCode = resultCodeRequestError;
            [result setObject:[error description] forKey:resultRequestErrorKey];
        }
        if (completionHandler) {
            completionHandler(resultCode,result);
        }
    }];
    [dataTask resume];
}
+(void)payImmediatelyConfirm:(SYCPayOrderConfirmModel*)payConfirm prePayOrder:(BOOL)isPreOrder completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler{
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCPayConfirm];
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
    [paramDic setObject:payConfirm.assetType forKey:@"assetType"];
    [paramDic setObject:payConfirm.assetNo forKey:@"assetNo"];
    [paramDic setObject:payConfirm.payPassword forKey:@"payPassword"];
    
    if (isPreOrder) {
        [paramDic setObject:payConfirm.partner forKey:@"partner"];
        [paramDic setObject:payConfirm.prepayId forKey:@"prepayId"];
    }else{
        [paramDic setObject:payConfirm.merchantId forKey:@"merchantId"];
        [paramDic setObject:payConfirm.orderSubject forKey:@"orderSubject"];
        [paramDic setObject:payConfirm.payAmount forKey:@"payAmount"];
    }
    NSString *signature = [SYCSystem sinagureForReq:paramDic];
    [paramDic setObject:signature forKey:@"_signdata"];
    for (NSString *key in [paramDic allKeys]) {
        if ([[paramDic allKeys]indexOfObject:key] == [[paramDic allKeys] count]-1) {
            param = [param stringByAppendingFormat:@"%@=%@",key,[paramDic objectForKey:key]];
        }else{
            param = [param stringByAppendingFormat:@"%@=%@&",key,[paramDic objectForKey:key]];
        }
        
    }
    NSURL *url = [NSURL URLWithString:reqUrl];
    reqUrl = [reqUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (error) {
//        NSLog(@"---面对面支付确认请求出错---%@",[error description]);
//        return nil;
//    }
//    NSError *err = nil;
//    NSLog(@"responseMain : %@",response);
//    
//    NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//    NSLog(@"backDataMain : %@",backData);
//    
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
//    if (err) {
//        NSLog(@"---数据解析出错---%@",[err description]);
//    }else{
//        
//        NSLog(@"----解析结果--- : %@",dic);
//    }
//    return dic;
    NSURLSession *shareSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 网络请求完成之后就会执行，NSURLSession自动实现多线程
        NSLog(@"%@",[NSThread currentThread]);
        
        NSDictionary *dic = nil;
        if (data && (error == nil)) {
            
            // 网络访问成功
            NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSLog(@"pswset : %@",backData);
            NSError *err = nil;
            dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                NSLog(@"---数据解析出错---%@",[err description]);
                resultCode = resultCodeJsonError;
                [result setObject:[err description] forKey:resultJsonErrorKey];
            }else{
                NSLog(@"----解析结果--- : %@",dic);
                [result setObject:dic forKey:resultSuccessKey];
            }
        } else {
            // 网络访问失败
            NSLog(@"error=%@",error);
            resultCode = resultCodeRequestError;
            [result setObject:[error description] forKey:resultRequestErrorKey];
        }
        if (completionHandler) {
            completionHandler(resultCode,result);
        }
    }];
    [dataTask resume];
}
+(void)getCaptchaforblindYKTwithCardNo:(NSString*)cardNo completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler{
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCCaptchaForYKT];
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
    [paramDic setObject:cardNo forKey:@"cardNo"];
    NSString *signature = [SYCSystem sinagureForReq:paramDic];
    [paramDic setObject:signature forKey:@"_signdata"];
    NSLog(@"------绑定一卡通获取验证码--------%@",paramDic);
    for (NSString *key in [paramDic allKeys]) {
        if ([[paramDic allKeys]indexOfObject:key] == [[paramDic allKeys] count]-1) {
            param = [param stringByAppendingFormat:@"%@=%@",key,[paramDic objectForKey:key]];
        }else{
            param = [param stringByAppendingFormat:@"%@=%@&",key,[paramDic objectForKey:key]];
        }
        
    }
    NSURL *url = [NSURL URLWithString:reqUrl];
    reqUrl = [reqUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (error) {
//        NSLog(@"---获取一卡通验证码请求出错---%@",[error description]);
//        return nil;
//    }
//    NSError *err = nil;
//    NSLog(@"responseMain : %@",response);
//    
//    NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//    NSLog(@"backDataMain : %@",backData);
//    
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
//    if (err) {
//        NSLog(@"---数据解析出错---%@",[err description]);
//    }else{
//        
//        NSLog(@"----解析结果--- : %@",dic);
//    }
//    return dic;
    NSURLSession *shareSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 网络请求完成之后就会执行，NSURLSession自动实现多线程
        NSLog(@"%@",[NSThread currentThread]);
        
        NSDictionary *dic = nil;
        if (data && (error == nil)) {
            
            // 网络访问成功
            NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSLog(@"pswset : %@",backData);
            NSError *err = nil;
            dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                NSLog(@"---数据解析出错---%@",[err description]);
                resultCode = resultCodeJsonError;
                [result setObject:[err description] forKey:resultJsonErrorKey];
            }else{
                NSLog(@"----解析结果--- : %@",dic);
                [result setObject:dic forKey:resultSuccessKey];
            }
        } else {
            // 网络访问失败
            NSLog(@"error=%@",error);
            resultCode = resultCodeRequestError;
            [result setObject:[error description] forKey:resultRequestErrorKey];
        }
        if (completionHandler) {
            completionHandler(resultCode,result);
        }
    }];
    [dataTask resume];
}
+(void)blindYKTwithCardNo:(NSString*)cardNo captcha:(NSString*)captcha completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler{
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCBlindYKT];
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
    [paramDic setObject:cardNo forKey:@"cardNo"];
    [paramDic setObject:captcha forKey:@"captcha"];
    NSString *signature = [SYCSystem sinagureForReq:paramDic];
    [paramDic setObject:signature forKey:@"_signdata"];
    for (NSString *key in [paramDic allKeys]) {
        if ([[paramDic allKeys]indexOfObject:key] == [[paramDic allKeys] count]-1) {
            param = [param stringByAppendingFormat:@"%@=%@",key,[paramDic objectForKey:key]];
        }else{
            param = [param stringByAppendingFormat:@"%@=%@&",key,[paramDic objectForKey:key]];
        }
        
    }
    NSURL *url = [NSURL URLWithString:reqUrl];
    reqUrl = [reqUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *shareSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 网络请求完成之后就会执行，NSURLSession自动实现多线程
        NSLog(@"%@",[NSThread currentThread]);
        
        NSDictionary *dic = nil;
        if (data && (error == nil)) {
            
            // 网络访问成功
            NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSLog(@"pswset : %@",backData);
            NSError *err = nil;
            dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                NSLog(@"---数据解析出错---%@",[err description]);
                resultCode = resultCodeJsonError;
                [result setObject:[err description] forKey:resultJsonErrorKey];
            }else{
                NSLog(@"----解析结果--- : %@",dic);
                [result setObject:dic forKey:resultSuccessKey];
            }
        } else {
            // 网络访问失败
            NSLog(@"error=%@",error);
            resultCode = resultCodeRequestError;
            [result setObject:[error description] forKey:resultRequestErrorKey];
        }
        if (completionHandler) {
            completionHandler(resultCode,result);
        }
    }];
    [dataTask resume];
}
-(NSDictionary*)postRequestUrl:(NSString*)requestUrl withParam:(NSString*)param{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSString *resultCode = resultCodeSuccess;
    
    NSURL *url = [NSURL URLWithString:requestUrl];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"---a确出错---%@",[error description]);
        [result setObject:[error description] forKey:resultRequestErrorKey];
        resultCode = resultCodeRequestError;
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
        [result setObject:[err description] forKey:resultJsonErrorKey];
        NSLog(@"---数据解析出错---%@",[err description]);
        resultCode = resultCodeJsonError;
    }else{
        [result setObject:dic forKey:resultSuccessKey];
        NSLog(@"----解析结果--- : %@",dic);
    }
    [result setObject:resultCode forKey:resultCodeKey];
    return result;

}
@end
