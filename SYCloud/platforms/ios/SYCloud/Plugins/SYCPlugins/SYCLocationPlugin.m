
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
    NSDictionary *locationDic = @{@"mLatitude":[SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].mLatitude]?[SYCShareVersionInfo sharedVersion].mLatitude:@"无",
                                  @"mLongitude":[SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].mLongitude]?[SYCShareVersionInfo sharedVersion].mLongitude:@"无",
                                  @"mCity":[SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].mCity]?[SYCShareVersionInfo sharedVersion].mCity:@"无",
                                  @"mmDistrict":[SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].mDistrict]?[SYCShareVersionInfo sharedVersion].mDistrict:@"无",
                                  @"mStreet":[SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].mStreet]?[SYCShareVersionInfo sharedVersion].mStreet:@"无",
                                  @"mAddrStr":[SYCSystem judgeNSString:[SYCShareVersionInfo sharedVersion].mAddrStr]?[SYCShareVersionInfo sharedVersion].mAddrStr:@"无"};
    NSString *jsonStr = [locationDic ex_JSONString];
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
