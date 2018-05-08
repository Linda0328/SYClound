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
#import "AFNetworking.h"
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
static NSString * const SYCPrePayInfo= @"/app/payment/app_pay_info.jhtml?";
static NSString * const SYCGetVerfication = @"/app/common/getCaptcha.jhtml";
static NSString * const SYCLoadWithPassw = @"/app/common/payment_login.jhtml";
static NSString * const SYCLoadWithVerfication = @"/app/common/payment_checkcode.jhtml";
static NSString * const SYCRegister = @"/app/common/register.jhtml";
static NSString * const SYCUploadRegId = @"/app/common/update_token_regid.jhtml";
static NSString * const SYCToken = @"token";

NSString * const SYCIndexJson = @"Index.json";
NSString * const SYCIndexVersion = @"IndexVersion";
NSString * const SYCChannel = @"02";
NSString * const GETRequest = @"GET";
NSString * const POSTRequest = @"POST";

NSString * const resultRequestErrorKey = @"RequestError";
NSString * const resultJsonErrorKey = @"JsonError";
NSString * const resultSuccessKey = @"RequestSucsess";
NSString * const resultErrorKey = @"RequestError";

NSString * const resultCodeKey = @"RequestCode";
NSString * const resultCodeRequestError = @"RequestErrorCode";
NSString * const resultCodeJsonError = @"JsonErrorCode";
NSString * const resultCodeSuccess = @"SucsessCode";

@implementation SYCHttpReqTool
+(void)newVersionInfo:(void (^)(NSString *resultCode,NSMutableDictionary *result ))completionHandler{
    __block NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    [SYCSystem imagLoadURL];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *token = [def objectForKey:loadToken];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@%@&%@=%@&%@=%@",SYVersionParam,[SYCSystem secondsForNow],SYCToken,token,@"vcode",SYCVersionCode];
//    NSURL *url = [NSURL URLWithString:reqUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:reqUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *err = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if (err) {
            [result setObject:[err description] forKey:resultJsonErrorKey];
            resultCode = resultCodeJsonError;
        }else{
            [SYCShareVersionInfo sharedVersion].pageVersion = [NSString stringWithFormat:@"%@",[JSON objectForKey:@"pageVersion"]];
            
            [SYCShareVersionInfo sharedVersion].needUpdate = [[JSON objectForKey:@"needUpdate"] boolValue];
            [SYCShareVersionInfo sharedVersion].indexVersion = [NSString stringWithFormat:@"%@",[JSON objectForKey:@"indexVersion"]];
            [SYCShareVersionInfo sharedVersion].pagePackage = [JSON objectForKey:@"pagePackage"];
            [result setObject:JSON forKey:resultSuccessKey];
        }
        [result setObject:resultCode forKey:resultCodeKey];
        if (completionHandler) {
            completionHandler(resultCode,result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        resultCode = resultCodeRequestError;
        [result setObject:[error description] forKey:resultRequestErrorKey];
        if (completionHandler) {
            completionHandler(resultCode,result);
        }
    }];
    
}
+(NSDictionary*)VersionInfo{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    [SYCSystem imagLoadURL];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *token = [def objectForKey:loadToken];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@%@&%@=%@&%@=%@",SYVersionParam,[SYCSystem secondsForNow],SYCToken,token,@"vcode",SYCVersionCode];
    NSURL *url = [NSURL URLWithString:reqUrl];
    reqUrl = [reqUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
   
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        [result setObject:[error description] forKey:resultRequestErrorKey];
        resultCode = resultCodeRequestError;
    }
    NSError *err = nil;
    NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        [result setObject:[err description] forKey:resultJsonErrorKey];
        resultCode = resultCodeJsonError;
        
    }else{
        [SYCShareVersionInfo sharedVersion].pageVersion = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pageVersion"]];
        
        [SYCShareVersionInfo sharedVersion].needUpdate = [[dic objectForKey:@"needUpdate"] boolValue];
        [SYCShareVersionInfo sharedVersion].indexVersion = [NSString stringWithFormat:@"%@",[dic objectForKey:@"indexVersion"]];
        [SYCShareVersionInfo sharedVersion].pagePackage = [dic objectForKey:@"pagePackage"];
        [result setObject:dic forKey:resultSuccessKey];
        
    }
    [result setObject:resultCode forKey:resultCodeKey];
    
    return result;
    
}
+(NSDictionary*)MainData{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"/app_resources/%@/app/index.json?_%@",SYCVersionCode,[SYCSystem secondsForNow]];
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
    if ([SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].token]) {
        [param setObject:[SYCShareVersionInfo sharedVersion].token forKey:@"token"];
    }
    [param setObject:[SYCShareVersionInfo sharedVersion].appVersion forKey:@"_version"];
    [param setObject:SYCChannel forKey:@"_channel"];
    [param setObject:[SYCSystem getNetType] forKey:@"_network"];
    [param setObject:[[SYCUUID shareUUID] getUUID] forKey:@"_regid"];
    [param setObject:[SYCSystem secondsForNow] forKey:@"_timestanp"];
    return param;
}
+(void)newAjaxResponseUrl:(NSString*)url requestType:(NSString*)type isSignature:(BOOL)ISsignature parmaDic:(NSMutableDictionary*)params completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler{
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",url];
    if (ISsignature) {
        NSString *signature = [SYCSystem sinagureForReq:params];
        [params setObject:signature forKey:@"_signdata"];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if ([type isEqualToString:POSTRequest]) {
        [manager POST:reqUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSError *err = nil;
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                resultCode = resultCodeJsonError;
                [result setObject:[err description] forKey:resultJsonErrorKey];
            }else{
                [result setObject:JSON forKey:resultSuccessKey];
            }
            if (completionHandler) {
                completionHandler(resultCode,result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            resultCode = resultCodeRequestError;
            [result setObject:[error description] forKey:resultRequestErrorKey];
            if (completionHandler) {
                completionHandler(resultCode,result);
            }
        }];
    }
    if([type isEqualToString:GETRequest]){
        [manager GET:reqUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSError *err = nil;
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                resultCode = resultCodeJsonError;
                [result setObject:[err description] forKey:resultJsonErrorKey];
            }else{
                [result setObject:JSON forKey:resultSuccessKey];
            }
            if (completionHandler) {
                completionHandler(resultCode,result);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            resultCode = resultCodeRequestError;
            [result setObject:[error description] forKey:resultRequestErrorKey];
            if (completionHandler) {
                completionHandler(resultCode,result);
            }
        }];
    }
}
+(void)ajaxResponseUrl:(NSString*)url requestType:(NSString*)type isSignature:(BOOL)ISsignature parmaDic:(NSMutableDictionary*)params completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler{
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",url];
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

    if ([paramStr containsString:@"+"]) {
        //URL无法对加号进行编码导致http请求时服务器端获取的内容中加号变成空格问题,以及页面链接中文编码处理
        paramStr = [paramStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"+"].invertedSet];
    }
    if ([type isEqualToString:GETRequest]) {
        reqUrl = [reqUrl stringByAppendingFormat:@"%@%@",@"?",paramStr];
    }
    reqUrl = [reqUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqUrl]];
    request.HTTPMethod = type;
    request.timeoutInterval = 10.0f;
    if ([type isEqualToString:POSTRequest]) {
        request.HTTPBody = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSURLSession *shareSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dic = nil;
        if (data && (error == nil)) {
            // 网络访问成功
            NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSLog(@"ajaxResponse : %@",backData);
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
    NSURLSession *shareSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSDictionary *dic = nil;
        if (data && (error == nil)) {
            
            // 网络访问成功
           
            NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
           
            NSError *err = nil;
            dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                
                resultCode = resultCodeJsonError;
                [result setObject:[err description] forKey:resultJsonErrorKey];
            }else{
               
                [result setObject:dic forKey:resultSuccessKey];
            }
        } else {
            // 网络访问失败
           
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
    [paramDic setObject:payConfirm.redPacketId forKey:@"redPacketId"];
    if ([SYCSystem judgeNSString:payConfirm.couponId]) {
        [paramDic setObject:payConfirm.couponId forKey:@"couponId"];
    }
    if ([SYCSystem judgeNSString:payConfirm.prepayId]) {
        [paramDic setObject:payConfirm.prepayId forKey:@"prepayId"];
    }
    if (isPreOrder) {
        [paramDic setObject:payConfirm.partner forKey:@"partner"];
    }else{
        [paramDic setObject:payConfirm.merchantId forKey:@"merchantId"];
        [paramDic setObject:payConfirm.orderSubject forKey:@"orderSubject"];
        [paramDic setObject:payConfirm.payAmount forKey:@"payAmount"];
        [paramDic setObject:payConfirm.exclAmount forKey:@"exclAmount"];
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
+(void)blindYKTwithCardNo:(NSString*)cardNo captcha:(NSString*)captcha prior:(NSString*)prior completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler{
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCBlindYKT];
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
    [paramDic setObject:cardNo forKey:@"cardNo"];
    [paramDic setObject:captcha forKey:@"captcha"];
    [paramDic setObject:prior forKey:@"prior"];
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

+(void)requestPayPluginInfoWithPrepareID:(NSString*)prepareId completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler{
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCPrePayInfo];
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
//    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:prepareId forKey:@"prepayId"];
//    [paramDic setObject:[SYCShareVersionInfo sharedVersion].token forKey:@"token"];
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
+(void)newGetVerficationCodeWithMobile:(NSString*)phoneNum forUseCode:(NSString*)code fromTerminal:(NSString*)terminal completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler{
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCGetVerfication];
    NSMutableDictionary *paramDic = [[self class] commonParam];
    [paramDic setObject:phoneNum forKey:@"mobile"];
    [paramDic setObject:code forKey:@"code"];
    [paramDic setObject:terminal forKey:@"terminal"];
    NSString *signature = [SYCSystem sinagureForReq:paramDic];
    [paramDic setObject:signature forKey:@"_signdata"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:reqUrl parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *err = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if (err) {
            resultCode = resultCodeJsonError;
            [result setObject:[err description] forKey:resultJsonErrorKey];
        }else{
            [result setObject:JSON forKey:resultSuccessKey];
        }
        if (completionHandler) {
            completionHandler(resultCode,result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        resultCode = resultCodeRequestError;
        [result setObject:[error description] forKey:resultRequestErrorKey];
        if (completionHandler) {
            completionHandler(resultCode,result);
        }
    }];
}
+(void)getVerficationCodeWithMobile:(NSString*)phoneNum forUseCode:(NSString*)code fromTerminal:(NSString*)terminal completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler{
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCGetVerfication];
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
    [paramDic setObject:phoneNum forKey:@"mobile"];
    [paramDic setObject:code forKey:@"code"];
    [paramDic setObject:terminal forKey:@"terminal"];
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *shareSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = nil;
        if (data && (error == nil)) {
            NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSLog(@"请求结果-----%@",backData);
            NSError *err = nil;
            dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                resultCode = resultCodeJsonError;
                [result setObject:[err description] forKey:resultJsonErrorKey];
            }else{
                [result setObject:dic forKey:resultSuccessKey];
            }
        } else {
            // 网络访问失败
            resultCode = resultCodeRequestError;
            [result setObject:[error description] forKey:resultRequestErrorKey];
        }
        if (completionHandler) {
            completionHandler(resultCode,result);
        }
    }];
    [dataTask resume];
}
+(void)loadWithMobile:(NSString*)phoneNum password:(NSString*)password regID:(NSString*)regId fromTerminal:(NSString*)systemType completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler{
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCLoadWithPassw];
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
    [paramDic setObject:phoneNum forKey:@"mobile"];
    [paramDic setObject:[SYCSystem md5:password] forKey:@"password"];
    if ([SYCSystem judgeNSString:regId]) {
        [paramDic setObject:regId forKey:@"regId"];
    }
    [paramDic setObject:systemType forKey:@"systemType"];
    NSString *signature = [SYCSystem sinagureForReq:paramDic];
    [paramDic setObject:signature forKey:@"_signdata"];
    for (NSString *key in [paramDic allKeys]) {
        if ([[paramDic allKeys]indexOfObject:key] == [[paramDic allKeys] count]-1) {
            param = [param stringByAppendingFormat:@"%@=%@",key,[paramDic objectForKey:key]];
        }else{
            param = [param stringByAppendingFormat:@"%@=%@&",key,[paramDic objectForKey:key]];
        }
    }
    //URL无法对加号进行编码导致http请求时服务器端获取的内容中加号变成空格问题
    param = [param stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"$*^#<>[\\]^`{|}\"]+"].invertedSet];
    NSURL *url = [NSURL URLWithString:reqUrl];
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
+(void)loadWithMobile:(NSString *)phoneNum verficationCode:(NSString *)captcha regID:(NSString*)regId fromTerminal:(NSString *)systemType completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler{
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCLoadWithVerfication];
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
    [paramDic setObject:phoneNum forKey:@"mobile"];
    [paramDic setObject:captcha forKey:@"captcha"];
    [paramDic setObject:regId forKey:@"regId"];
    [paramDic setObject:systemType forKey:@"systemType"];
    NSString *signature = [SYCSystem sinagureForReq:paramDic];
    [paramDic setObject:signature forKey:@"_signdata"];
    for (NSString *key in [paramDic allKeys]) {
        if ([[paramDic allKeys]indexOfObject:key] == [[paramDic allKeys] count]-1) {
            param = [param stringByAppendingFormat:@"%@=%@",key,[paramDic objectForKey:key]];
        }else{
            param = [param stringByAppendingFormat:@"%@=%@&",key,[paramDic objectForKey:key]];
        }
    }
    //URL无法对加号进行编码导致http请求时服务器端获取的内容中加号变成空格问题
    param = [param stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"$*^#<>[\\]^`{|}\"]+"].invertedSet];
    NSURL *url = [NSURL URLWithString:reqUrl];
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
+(void)registerWithMobile:(NSString *)phoneNum password:(NSString*)password verficationCode:(NSString *)captcha regID:(NSString*)regId fromTerminal:(NSString *)systemType QRCode:(NSString*)qrCode completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler {
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCRegister];
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
    [paramDic setObject:phoneNum forKey:@"mobile"];
    [paramDic setObject:captcha forKey:@"captcha"];
    [paramDic setObject:[SYCSystem md5:password] forKey:@"enPassword"];
    if ([SYCSystem judgeNSString:regId]) {
        [paramDic setObject:regId forKey:@"regId"];
    }
    
    [paramDic setObject:systemType forKey:@"systemType"];
    [paramDic setObject:[SYCSystem judgeNSString:qrCode]?qrCode:@" " forKey:@"qrCode"];
    NSString *signature = [SYCSystem sinagureForReq:paramDic];
    [paramDic setObject:signature forKey:@"_signdata"];
    for (NSString *key in [paramDic allKeys]) {
        if ([[paramDic allKeys]indexOfObject:key] == [[paramDic allKeys] count]-1) {
            param = [param stringByAppendingFormat:@"%@=%@",key,[paramDic objectForKey:key]];
        }else{
            param = [param stringByAppendingFormat:@"%@=%@&",key,[paramDic objectForKey:key]];
        }
    }
    //URL无法对加号进行编码导致http请求时服务器端获取的内容中加号变成空格问题
    param = [param stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"$*^#<>[\\]^`{|}\"]+"].invertedSet];
    NSURL *url = [NSURL URLWithString:reqUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *shareSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = nil;
        if (data && (error == nil)) {
            // 网络访问成功
            NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSLog(@"register : %@",backData);
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
+(void)uploadRegId:(NSString*)regId withToken:(NSString*)token completion:(void (^)(NSString *resultCode,NSMutableDictionary *result))completionHandler{
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __block NSString *resultCode = resultCodeSuccess;
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCRegister];
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
    [paramDic setObject:regId forKey:@"regId"];
    [paramDic setObject:token forKey:SYCToken];
    NSString *signature = [SYCSystem sinagureForReq:paramDic];
    [paramDic setObject:signature forKey:@"_signdata"];
    for (NSString *key in [paramDic allKeys]) {
        if ([[paramDic allKeys]indexOfObject:key] == [[paramDic allKeys] count]-1) {
            param = [param stringByAppendingFormat:@"%@=%@",key,[paramDic objectForKey:key]];
        }else{
            param = [param stringByAppendingFormat:@"%@=%@&",key,[paramDic objectForKey:key]];
        }
    }
    //URL无法对加号进行编码导致http请求时服务器端获取的内容中加号变成空格问题
    param = [param stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"$*^#<>[\\]^`{|}\"]+"].invertedSet];
    NSURL *url = [NSURL URLWithString:reqUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *shareSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = nil;
        if (data && (error == nil)) {
            // 网络访问成功
            NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSLog(@"register : %@",backData);
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
+(NSDictionary*)postRequestUrl:(NSString*)requestUrl withParam:(NSString*)param{
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
