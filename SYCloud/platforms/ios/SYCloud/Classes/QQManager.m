//
//  QQManager.m
//  SYCloud
//
//  Created by 文清 on 2017/8/10.
//
//

#import "QQManager.h"
#import "SYCSystem.h"
@implementation QQManager
#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static QQManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[QQManager alloc] init];
    });
    return instance;
}
#pragma mark --- TencentLoginDelegate
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{

}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{

}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{

}
#pragma mark --- QQApiInterfaceDelegate
//处理来自qq的请求
- (void)onReq:(QQBaseReq *)req{

}
//处理来自qq的响应
-(void)onResp:(QQBaseResp *)resp{
    if([resp isKindOfClass:[SendMessageToQQResp class]]){
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvQQMessageResponse:)]) {
            SendMessageToQQResp *messageResp = (SendMessageToQQResp *)resp;
            [_delegate managerDidRecvQQMessageResponse:messageResp];
        }
    }
   
}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response{

}
@end
