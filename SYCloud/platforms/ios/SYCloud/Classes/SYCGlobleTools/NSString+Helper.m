//
//  HttpRequest.h
//
//
//  Created by zyq on 14-6-4.
//  Copyright (c) 2014年 ShengYuan. All rights reserved.
//

#import "NSString+Helper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Helper)

- (NSString *)trimString
{
    // 截断字符串中的所有空白字符（空格,\t,\n,\r）
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)appendToDocumentDir
{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    return [docDir stringByAppendingPathComponent:self];
}

- (NSURL *)appendToDocumentURL
{
    return [NSURL fileURLWithPath:[self appendToDocumentDir]];
}

- (NSString *)base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodeString
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)appendDateTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"%@%@", self, str];
}


- (NSString *)MD5Hash
{
	const char *cStr = [self UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, (unsigned int)strlen(cStr), result);
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]];
}

//+ (NSString*)encryptMD5String:(NSString*)string
//{
//    
//    const char *cStr = [string UTF8String];
//    
//    unsigned char result[32];
//    
//    CC_MD5( cStr, strlen(cStr),result);
//    
//    NSMutableString *hash =[NSMutableString string];
//    
//    for (int i = 0; i < 16; i++)
//        
//        [hash appendFormat:@"%02X", result[i]];
//    
//    return [hash uppercaseString];//此方法输出的是大写，若想要以小写的方式输出，则只需要将最后一行代码改为return [hash lowercaseString];
//    
//}


- (NSString *) URLEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8));
    return encodedString;
}
- (NSString*)URLDecodedString
{
    NSString *result = ( NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                             (CFStringRef)self,
                                                                                                             CFSTR(""),
                                                                                                             kCFStringEncodingUTF8));
    return result;
}
#pragma mark - 图文转字符串（utf8转Unicode）
-(NSString *) utf8ToUnicode:(NSString *)string
{
    NSUInteger length = [string length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++) {
        unichar _char = [string characterAtIndex:i];
        //判断是否为英文和数字
        if (_char <= '9' && _char >= '0') {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }else if(_char >= 'a' && _char <= 'z')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }else if(_char >= 'A' && _char <= 'Z')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }else
        {
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
        }
        
    }
    return s;
}
#pragma mark - 图文转字符串（Unicode转utf8）
-(NSString *) unicodeToUtf8:(NSString *)string
{
    NSString *tempStr1 = [string stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"" withString:@"\\"];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    //NSLog(@"Output = %@", returnStr);
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
    
}

/**
 * #pragma mark 文件目录名称 ：HOME.JSON
 * 添加JSON文件到DOCUMENT目录中
 */
+ (NSString *) appendJsonFilePathToDocument:(NSString *) string{
    NSArray *dirs =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[dirs objectAtIndex:0] stringByAppendingPathComponent:string];
}

/**
 #pragma mark 将字符URL转换成NSDictionary
 *
 */
+ (NSDictionary *) stringUrlToDictionary:(NSString *) string {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    NSRange range = [string rangeOfString:@"?"];
    if (range.length != 0) {
        NSString *params = [string substringFromIndex:range.location+1];
        for (NSString *param in [params componentsSeparatedByString:@"&"]) {
            NSRange index = [param rangeOfString:@"="];
            if (index.length != 0) {
                NSString *key = [param substringToIndex:index.location];
                NSString *value = [param substringFromIndex:index.location+1];
                [dic setObject:value forKey:key];
            }
        }
    }
    
    return dic;
}

/**
 #pragma mark 获取URL？前面的名称
 *
 */
+ (NSString *) stringUrlWithName:(NSString *) string {
    NSRange range = [string rangeOfString:@"?"];
    if (range.length != 0) {
        return [string substringToIndex:range.location];
    }else{
        return string;
    }
}

/**
 #pragma mark 比较字符比较特殊字符串，比如：？，（在ios7中比较特殊字符会异常，ios8直接用containsString）
 */
- (BOOL) containsXString:(NSString *) string {
    NSRange range = [self rangeOfString:string];
    return range.length != 0;
}

/**
 #pragma mark 网址拼接，拼接的字符串
 */
- (NSString *) urlAppendWithString:(NSString *) string {
    if ([self containsXString:@"?"]) {
        return [NSString stringWithFormat:@"%@&%@", self, string];
    } else {
        return [NSString stringWithFormat:@"%@?%@", self, string];
    }
}

/**
 #pragma mark 添加删除线
 */
- (NSMutableAttributedString *) stringWithStrikethrough:(UIColor *) color{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:self];
    [attribute addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, [self length])];
    [attribute addAttribute:NSStrikethroughColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, [self length])];
    return attribute;
}

/**
 #pragma mark 计算字符串的Size
 */
+(CGSize)stringWithName:(NSString *)string fontSize:(CGFloat)fontSize{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize stringSize =[string boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return stringSize;
}

#pragma mark - ******** 分享 url 解析处理
/**
 #pragma mark 分享 url 解析处理
 */
//+(NSString *)socialUrlAnalytical:(NSString *)url{
//    NSDictionary *urlParams = [NSString stringUrlToDictionary:url];
//    NSString *productId = [urlParams objectForKey:@"productId"];
//    NSString *param = @"";
//    NSString *categoryId = [urlParams objectForKey:@"categoryId"];
//    NSString *warehouse = [urlParams objectForKey:@"warehouse"];
//    if ([ productId ]) {
//        if (IsStrEmpty(param)){
//            param = [NSString stringWithFormat:@"productId=%@",productId];
//        }else{
//            param = [NSString stringWithFormat:@"&productId=%@",productId];
//        }
//    }else if (!IsStrEmpty(categoryId)) {
//        if (IsStrEmpty(param)){
//            param = [NSString stringWithFormat:@"categoryId=%@",categoryId];
//        }else{
//            param = [NSString stringWithFormat:@"&categoryId=%@",categoryId];
//        }
//    }else if (!IsStrEmpty(warehouse)) {
//        if (IsStrEmpty(param)){
//            param = [NSString stringWithFormat:@"warehouse=%@",warehouse];
//        }else{
//            param = [NSString stringWithFormat:@"&warehouse=%@",warehouse];
//        }
//    }
//    NSString *newUrl = [NSString stringWithFormat:@"%@?%@",[NSString stringUrlWithName:url],param];
//    return newUrl;
//}


/**
 #pragma mark 将字符URL转换成NSDictionary
 *
 */
+ (NSDictionary *) stringAppUrlToDictionary:(NSString *) string {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    NSRange range = [string rangeOfString:@"//"];
    if (range.length != 0) {
        NSString *params = [string substringFromIndex:range.location+1];
        for (NSString *param in [params componentsSeparatedByString:@"&"]) {
            NSRange index = [param rangeOfString:@"="];
            if (index.length != 0) {
                NSString *key = [param substringToIndex:index.location];
                NSString *value = [param substringFromIndex:index.location+1];
                [dic setObject:value forKey:key];
            }
        }
    }
    
    return dic;
}

/**
 #pragma mark key是否存在字典中
 *
 */
+(BOOL)isDictContain:(NSDictionary *)dict withStr:(NSString *)key{
    if(dict == nil) {
        return false;
    }
    NSArray *array = [dict allKeys];
    for (NSString *str in array) {
        if ([str isEqualToString:key]) {
            return true;
        }
    }
    return false;
}

@end
