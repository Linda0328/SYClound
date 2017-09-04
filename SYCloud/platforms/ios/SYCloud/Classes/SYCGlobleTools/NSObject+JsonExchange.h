//
//  NSObject+JsonExchange.h
//  SYCloud
//
//  Created by 文清 on 2017/4/7.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (JsonExchange)
/**
 *  对象转换为JSONData
 *
 *  @return NSData
 */
- (nullable NSData *)ex_JSONData;

/**
 *  对象转换为JSONString
 *
 *  @return NSString
 */
-(nullable NSString *)ex_JSONString;

/**
 *  将JSONString转换为对象
 *
 *  @param jsonString json字符串
 *
 *  @return 对象
 */
+ (nullable id)ex_objectFromJSONString:(nullable NSString *)jsonString;

/**
 *  将JSONString转换为对象
 *
 *  @param jsonString json字符串
 *
 *  @return 对象
 */
+ (nullable id)ex_objectFromJSONData:(nullable NSData *)jsonData;
@end
