//
//  SYCUUID.m
//  SYCloud
//
//  Created by 文清 on 2017/4/22.
//
//

#import "SYCUUID.h"
static const NSString *KEY_UUID = @"KEY_UUID";
static NSString *KEY_IN_KEYCHAIN = @"KEY_IN_KEYCHAIN";
static SYCUUID *UUID = nil;
@implementation SYCUUID
#pragma mark -- 获取UUID
/**
 *此UUID在相同的一个程序里面---相同vindor--相同的设备下是不会改变的
 *此UUID是唯一的，但应用删除再重新安装后会变化，采取的措施是：只获取一次保存在钥匙串中，之后从钥匙串中获取
 **/
+(instancetype)shareUUID{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        UUID = [[super allocWithZone:NULL] init];
        [UUID saveUUID];
    });
    return UUID;
}

-(NSString*)getUUID{
    NSMutableDictionary *readUserPwd = (NSMutableDictionary *)[[self class] load:KEY_IN_KEYCHAIN];
    NSString *UUID = [readUserPwd objectForKey:KEY_UUID];
    NSLog(@"----%@",UUID);
    return UUID;
}
-(void)saveUUID{
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSMutableDictionary *UUIDDic = [NSMutableDictionary dictionary];
    [UUIDDic setObject:identifierStr forKey:KEY_UUID];
    //存
    [[self class] save:KEY_IN_KEYCHAIN data:UUIDDic];
}
#pragma mark --- 查询钥匙串
//查
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}
//存
+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

//取
+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}
//删
+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}
@end
