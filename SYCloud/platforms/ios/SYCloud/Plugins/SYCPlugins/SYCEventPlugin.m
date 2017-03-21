//
//  SYCEventPlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/3/17.
//
//

#import "SYCEventPlugin.h"
#import "SYCEventModel.h"
#import "MJExtension.h"
@implementation SYCEventPlugin
-(void)bind:(CDVInvokedUrlCommand *)command{
    NSArray *eventArr = [command.arguments firstObject];
    //    NSString *eventJson = [command.arguments firstObject];
    //    NSArray *eventArr = [NSJSONSerialization JSONObjectWithData:[eventJson dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    [SYCEventModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    NSArray *eventModelArr = [SYCEventModel mj_objectArrayWithKeyValuesArray:eventArr];
    [self.commandDelegate runInBackground:^{
        for (SYCEventModel *model in eventModelArr) {
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            [userDef setObject:model.event forKey:model.ID];
            [userDef synchronize];
        }
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
    
}
@end
