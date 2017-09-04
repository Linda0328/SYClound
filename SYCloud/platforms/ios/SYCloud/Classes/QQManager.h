//
//  QQManager.h
//  SYCloud
//
//  Created by 文清 on 2017/8/10.
//
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
@protocol QQManagerDelegate <NSObject>

@optional

//- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;
//
- (void)managerDidRecvQQShowMessageReq:(ShowMessageFromQQReq *)request;
//
//- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;
//
- (void)managerDidRecvQQMessageResponse:(SendMessageToQQResp *)response;

@end
@interface QQManager : NSObject<TencentSessionDelegate,QQApiInterfaceDelegate>//TencentSessionDelegate,
@property (nonatomic, assign) id<QQManagerDelegate> delegate;
+ (instancetype)sharedManager;
@property (nonatomic,strong)TencentOAuth *oauth;
@end
