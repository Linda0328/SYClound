//
//  WXApiManager.h
//  SYCloud
//
//  Created by 文清 on 2017/6/10.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
@protocol WXApiManagereDelegate <NSObject>
@optional
- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;
@end

@interface WXApiManager : NSObject

@property (nonatomic,assign)id<WXApiManagereDelegate>delegate;

+(instancetype)sharedManager;
@end
