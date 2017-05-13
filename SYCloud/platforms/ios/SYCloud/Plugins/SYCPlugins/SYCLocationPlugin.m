
//
//  SYCLoactionPlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/3/17.
//
//

#import "SYCLocationPlugin.h"
#import <CoreLocation/CoreLocation.h>
#import "SYCShareVersionInfo.h"
#import "SYCSystem.h"
#import "NSObject+JsonExchange.h"
@implementation SYCLocationPlugin
-(void)position:(CDVInvokedUrlCommand *)command{
//    NSString *success = [command.arguments firstObject];
//    NSString *fail = [command.arguments objectAtIndex:1];
    NSLog(@"user location mCity = %@,mDistrict = %@,mStreet = %@,mAddrStr = %@",[SYCShareVersionInfo sharedVersion].mCity,[SYCShareVersionInfo sharedVersion].mDistrict,[SYCShareVersionInfo sharedVersion].mStreet,[SYCShareVersionInfo sharedVersion].mAddrStr);
    NSDictionary *locationDic = @{@"mLatitude":[SYCShareVersionInfo sharedVersion].mLatitude,
                                  @"mLongitude":[SYCShareVersionInfo sharedVersion].mLongitude,
                                  @"mCity":[SYCShareVersionInfo sharedVersion].mCity,
                                  @"mmDistrict":[SYCShareVersionInfo sharedVersion].mDistrict,
                                  @"mStreet":[SYCShareVersionInfo sharedVersion].mStreet,
                                  @"mAddrStr":[SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].mAddrStr]?[SYCShareVersionInfo sharedVersion].mAddrStr:@"无"};
    NSString *jsonStr = [locationDic JSONString];
    [self.commandDelegate runInBackground:^{
//        if ([SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].locationError]) {
//            CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[SYCShareVersionInfo sharedVersion].locationError];
//            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
//        }else{
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsonStr];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
//        }
        
    }];
}
@end
