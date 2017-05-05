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
static NSString * const SYVersionParam = @"/app_resources/app/version.json?_";
static NSString * const SYMainParam = @"/app_resources/app/index.json?_";
static NSString * const SYCPswSetOrNot = @"/app/payment/member_pay_password.jhtml?";
static NSString * const SYCPswSet = @"/app/payment/init_pay_password.jhtml?";
static NSString * const SYCPayImmediately = @"/app/payment/member_pay_type.jhtml?";
static NSString * const SYCPayConfirm= @"/app/payment/confirm_payment.jhtml?";
NSString * const SYCIndexJson = @"Index.json";
NSString * const SYCIndexVersion = @"IndexVersion";
NSString * const SYCChannel = @"02";
NSString * const GETRequest = @"GET";
NSString * const POSTRequest = @"POST";

NSString * const resultRequestError = @"RequestError";
NSString * const resultJsonError = @"JsonError";
NSString * const resultSuccess = @"RequestSucsess";

@implementation SYCHttpReqTool
+(NSDictionary*)VersionInfo{
    NSString *baseURL = [SYCSystem baseURL];
    [SYCSystem imagLoadURL];
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
    [SYCShareVersionInfo sharedVersion].needUpdate = [dic objectForKey:@"needUpdate"];
    [SYCShareVersionInfo sharedVersion].indexVersion = [dic objectForKey:@"indexVersion"];
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
        NSLog(@"---maindata请求出错---%@",[error description]);
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

        NSLog(@"----解析结果--- : %@",dic);
    }
    NSUserDefaults *userf = [NSUserDefaults standardUserDefaults];
    [userf setObject:dic forKey:SYCIndexJson];
    [userf synchronize];
    return dic;
}
+(BOOL)PswSetOrNot{
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"---验证是否有支付密码请求出错---%@",[error description]);
        return nil;
    }
    NSError *err = nil;
    NSLog(@"pswSet : %@",response);
    
    NSString *backData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    backData = [backData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    backData = [backData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    backData = [backData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSLog(@"pswset : %@",backData);
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[backData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"---数据解析出错---%@",[err description]);
    }else{

        NSLog(@"----解析结果--- : %@",dic);
    }
    BOOL need_reset = [[[dic objectForKey:@"result"] objectForKey:@"need_reset"] boolValue];
    return need_reset;
}
+(BOOL)PswSet{
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCPswSet];
    
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [paramDic setObject:[def objectForKey:PayPsw] forKey:@"payPassword"];
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
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"---支付密码请求出错---%@",[error description]);
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
    NSString *code = [dic objectForKey:@"code"];
    if ([code isEqualToString:@"000000"]) {
        return YES;
    }
    return NO;
}
+(NSDictionary*)PayPswResponseUrl:(NSString*)url pswParam:(NSString*)pswParam parmaDic:(NSDictionary*)paramDic{
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",url];
    
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramD = [[self class] commonParam];
    for (NSString *key in [paramDic allKeys]) {
        [paramD setObject:[paramDic objectForKey:key] forKey:key];
    }
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [paramD setObject:[def objectForKey:PayPsw] forKey:pswParam];
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requrl];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"---支付密码输入正确出错---%@",[error description]);
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
    return dic;

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
+(NSDictionary*)ajaxResponseUrl:(NSString*)url requestType:(NSString*)type isSignature:(BOOL)ISsignature parmaDic:(NSMutableDictionary*)params{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
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
    if ([type isEqualToString:GETRequest]) {
        reqUrl = [reqUrl stringByAppendingFormat:@"%@%@",@"?",paramStr];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqUrl]];
    request.HTTPMethod = type;
    request.timeoutInterval = 10.0f;
    if ([type isEqualToString:POSTRequest]) {
        request.HTTPBody = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"---a确出错---%@",[error description]);
        [result setObject:[error description] forKey:resultRequestError];
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
        [result setObject:[err description] forKey:resultJsonError];
        NSLog(@"---数据解析出错---%@",[err description]);
    }else{
         [result setObject:dic forKey:resultSuccess];
        NSLog(@"----解析结果--- : %@",dic);
    }
    
    return result;

}

+(NSDictionary*)payImmediatelyInfo:(NSString*)token payAmount:(NSString*)amount{
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCPayImmediately];
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
    [paramDic setObject:token forKey:@"token"];
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"---面对面支付请求出错---%@",[error description]);
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
    return dic;
}
+(NSDictionary*)payImmediatelyConfirm:(SYCPayOrderConfirmModel*)payConfirm prePayOrder:(BOOL)isPreOrder{
    NSString *baseURL = [SYCSystem baseURL];
    NSString *reqUrl = [baseURL stringByAppendingFormat:@"%@",SYCPayConfirm];
    NSString *param = [[NSString alloc]init];
    NSMutableDictionary *paramDic = [[self class] commonParam];
    [paramDic setObject:payConfirm.assetType forKey:@"assetType"];
    [paramDic setObject:payConfirm.assetNo forKey:@"assetNo"];
    [paramDic setObject:payConfirm.payPassword forKey:@"payPassword"];
    [paramDic setObject:payConfirm.token forKey:@"token"];
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"---面对面支付确认请求出错---%@",[error description]);
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
    return dic;
}
@end
