//
//  SYCCacheURLProtocol.m
//  SYCloud
//
//  Created by 文清 on 2017/7/26.
//
//

#import "SYCCacheURLProtocol.h"
#import "SYCCache.h"
#import "SYCSystem.h"
#import "SYCShareVersionInfo.h"
NSString * const kresource = @"/app_resources/";
NSString * const kCacheJSPath = @"/app_resources/1.0.5/js";
NSString * const kCacheStylePath = @"/app_resources/1.0.5/style";
NSString * const requestMarked = @"requestMarked";
@interface SYCCacheURLProtocol ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@property (nonatomic, strong)NSURLConnection *connection;
@property (nonatomic, strong)NSMutableData *responseData;
@end
@implementation SYCCacheURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest*)Request
{
    //测试环境不做缓存处理
    if (![SYCShareVersionInfo sharedVersion].formal) {
        return NO;
    }
    NSURL* theUrl = [Request URL];
    if ([[theUrl absoluteString] containsString:kCacheJSPath]||[[theUrl absoluteString] containsString:kCacheStylePath]) {
        if ([NSURLProtocol propertyForKey:requestMarked inRequest:Request])
            return NO;
        return YES;
    }
    return NO;
}

+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest*)request
{
    //    NSLog(@"%@ received %@", self, NSStringFromSelector(_cmd));
    return request;
}

- (void)startLoading
{
    // NSLog(@"%@ received %@ - start", self, NSStringFromSelector(_cmd));
    NSMutableURLRequest *mutableRequest = [[self request]mutableCopy];
    //给我们处理过的请求设置一个标识符，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:requestMarked inRequest:mutableRequest];
    NSURL* url = [[self request] URL];
    if ([[url absoluteString] containsString:kCacheJSPath]||[[url absoluteString] containsString:kCacheStylePath]) {
        NSFileManager *fmanager = [NSFileManager defaultManager];
        NSString *filePath = [SYCCacheURLProtocol completePathForsource:[url absoluteString]];
        NSData *data = [fmanager contentsAtPath:filePath];
        if ([SYCSystem judgeNSString:filePath]&&[fmanager fileExistsAtPath:filePath]&&data) {
            NSString *mimeType = nil;
            if ([filePath hasSuffix:@"css"]) {
                mimeType = @"text/css";
            }
           [self sendResponseWithResponseCode:200 data:data mimeType:mimeType];
        }else{
           self.connection = [NSURLConnection connectionWithRequest:mutableRequest delegate:self];
        }
        
    }
}
+(NSString*)completePathForsource:(NSString*)urlPath{
    NSArray *arr = [urlPath componentsSeparatedByString:@"?"];
    if ([arr count]==2) {
        NSString *first = [arr firstObject];
        NSRange range = [first rangeOfString:kresource];
        NSString *subfilePath = [first substringFromIndex:range.location];
        NSString *path = [SYCCache zipFilePath];
        return [path stringByAppendingString:subfilePath];
    }
    return nil;
}
- (void)stopLoading
{
    // do any cleanup here
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest*)requestA toRequest:(NSURLRequest*)requestB
{
    return NO;
}

- (void)sendResponseWithResponseCode:(NSInteger)statusCode data:(NSData*)data mimeType:(NSString*)mimeType
{
    if (mimeType == nil) {
        mimeType = @"text/plain";
    }
    NSHTTPURLResponse* response = [[NSHTTPURLResponse alloc] initWithURL:[[self request] URL] statusCode:statusCode HTTPVersion:@"HTTP/1.1" headerFields:@{@"Content-Type" : mimeType}];
    
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    if (data != nil) {
        [[self client] URLProtocol:self didLoadData:data];
    }
    [[self client] URLProtocolDidFinishLoading:self];
}
#pragma mark --- NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [[self client]URLProtocol:self didFailWithError:error];
}
#pragma mark --- NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.responseData = [[NSMutableData alloc]init];
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
    [[self client] URLProtocol:self didLoadData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [[self client] URLProtocolDidFinishLoading:self];
}
@end
