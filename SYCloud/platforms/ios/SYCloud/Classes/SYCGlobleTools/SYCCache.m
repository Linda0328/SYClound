//
//  SYCCache.m
//  SYCloud
//
//  Created by 文清 on 2017/7/26.
//
//

#import "SYCCache.h"
#import "SYCSystem.h"
#import "AFNetworking.h"
#import "SSZipArchive.h"
@interface SYCCache()<SSZipArchiveDelegate>

@end
@implementation SYCCache
-(BOOL)downLoadJSFileWithPageVersion:(NSString*)pageVersion linkURL:(NSString*)pagePackage{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *pageVersionLocal = [userdefault objectForKey:PageVersionKey];
    if ([SYCSystem judgeNSString:pageVersionLocal]&&[pageVersion isEqualToString:pageVersionLocal]) {
        return NO;
    }else{
        NSString *url = [[SYCSystem baseURL]stringByAppendingString:pagePackage];
        [self downFileFromServer:url pageVersion:pageVersion];
    }
    return YES;
}
-(void)downFileFromServer:(NSString*)fileURL pageVersion:(NSString*)pagevesion{
    //去掉链接字符串前后的空格
    fileURL = [fileURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //去除链接中文，否则NSURL对象为空
    fileURL = [fileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *pathUrl = [NSURL URLWithString:fileURL];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:pathUrl];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //block的返回值，要求返回一个URL，返回的这个URL就是文件位置的路径
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        path = [path stringByAppendingFormat:@"/%@",response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            NSLog(@"------%@",error);
        }
        //设置下载完成操作
        //filepath是下载文件的位置，可以直接解压，也可以直接使用
        NSString *downloadfilepath = [filePath path];
        if ([SYCSystem judgeNSString:downloadfilepath]) {
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault setObject:pagevesion forKey:PageVersionKey];
            [userdefault synchronize];
            NSString *zipFilePath = [SYCCache zipFilePath];
            [self releaseZipFilesWithUnzipFileAtPath:downloadfilepath Destination:zipFilePath];
        }
        
    }];
    [task resume];
}
+(NSString*)zipFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *zipFilePath = [documentsDirectory stringByAppendingString:@"/zipfile"];
    return zipFilePath;
}
-(void)releaseZipFilesWithUnzipFileAtPath:(NSString *)zipPath Destination:(NSString *)unzipPath{
    NSError *error = nil;
    if ([SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath overwrite:YES password:nil error:&error delegate:self]) {
        NSLog(@"success archive unzipPath----%@",unzipPath);
        NSFileManager *fmanager = [NSFileManager defaultManager];
        NSArray *arr = [fmanager subpathsAtPath:unzipPath];
        NSLog(@"success archive unzipPath---%@",arr);
    }else{
        NSLog(@"failed archive error-----%@",error);
    }
}
#pragma mark ---sszipArchiveDelegate
-(void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo{
    NSLog(@"--即将解压");
}
-(void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(nonnull NSString *)unzippedPath{
    NSLog(@"--完成解压");
}
@end
