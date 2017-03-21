///
//  HttpRequest.h
//  AutoHome
//
//  Created by zyq on 14-6-4.
//  Copyright (c) 2014年 ShengYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helper)

/**
 *  截断收尾空白字符
 *
 *  @return 截断结果
 */
- (NSString *)trimString;

/**
 *  为指定文件名添加沙盒文档路径
 *
 *  @return 添加沙盒文档路径的完整路径字符串
 */
- (NSString *)appendToDocumentDir;

/**
 *  为指定文件名添加沙盒文档路径
 *
 *  @return 添加沙盒文档路径的完整路径字符串
 */
- (NSURL *)appendToDocumentURL;

/**
 *  对指定字符串进行BASE64编码
 *
 *  @return BASE64编码后的字符串
 */
- (NSString *)base64EncodedString;

/**
 *  对指定BASE64编码的字符串进行解码
 *
 *  @return 解码后的字符串
 */
- (NSString *)base64DecodeString;

/**
 *  在字符串末尾添加日期及时间
 *
 *  @return 添加日期及时间之后的字符串
 */
- (NSString *)appendDateTime;

- (NSString *)MD5Hash;

- (NSString *) URLEncodedString;
- (NSString*) URLDecodedString;
-(NSString *) utf8ToUnicode:(NSString *)string;
-(NSString *) unicodeToUtf8:(NSString *)string;

/**
 * 添加JSON文件到DOCUMENT目录中
 */
+ (NSString *) appendJsonFilePathToDocument:(NSString *) string;

+ (NSDictionary *) stringUrlToDictionary:(NSString *) string;

/**
 #pragma mark 比较特殊字符串，比如：？，（在ios7中比较特殊字符会异常，ios8直接用containsString）
 */
- (BOOL) containsXString:(NSString *) string;

/**
 #pragma mark 添加删除线
 */
- (NSMutableAttributedString *) stringWithStrikethrough:(UIColor *) color;

/**
 #pragma mark 网址拼接，拼接的字符串
 */
- (NSString *) urlAppendWithString:(NSString *) string;

/**
 #pragma mark 获取URL？前面的名称
 *
 */
+ (NSString *) stringUrlWithName:(NSString *) string;

/**
 #pragma mark 计算字符串的Size
 */
+(CGSize)stringWithName:(NSString *)string fontSize:(CGFloat)fontSize;

/**
 #pragma mark 分享 url 解析处理
 */
+(NSString *)socialUrlAnalytical:(NSString *)url;

/**
 #pragma mark 将字符URL转换成NSDictionary
 *
 */
+ (NSDictionary *) stringAppUrlToDictionary:(NSString *) string;

/**
 #pragma mark key是否存在字典中
 *
 */
+(BOOL)isDictContain:(NSDictionary *)dict withStr:(NSString *)key;


@end
