//
//  SYCSharePlugin.m
//  SYCloud
//
//  Created by 文清 on 2017/8/2.
//
//

#import "SYCSharePlugin.h"
#import "SYCShareModel.h"
@implementation SYCSharePlugin
-(void)share:(CDVInvokedUrlCommand *)command{
    SYCShareModel *shareM = [[SYCShareModel alloc]init];
    
    NSArray *data = [command.arguments firstObject];
}
@end
