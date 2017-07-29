//
//  SYCCache.h
//  SYCloud
//
//  Created by 文清 on 2017/7/26.
//
//

#import <Foundation/Foundation.h>

@interface SYCCache : NSObject
-(BOOL)downLoadJSFileWithPageVersion:(NSString*)pageVersion linkURL:(NSString*)pagePackage;
+(NSString*)zipFilePath;
@end
