//
//  SYCShareVersionInfo.h
//  SYCloud
//
//  Created by 文清 on 2017/3/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface SYCShareVersionInfo : NSObject
@property (nonatomic,copy)NSString *remoteUrl;
@property (nonatomic,copy)NSString *imageUrl;
@property (nonatomic,copy)NSString *regId;
@property (nonatomic,copy)NSString *systemType;
//获取app本地版本信息
@property (nonatomic,copy)NSString *appVersion;
@property (nonatomic,copy)NSString *appVersionName;
@property (nonatomic,copy)NSString *lastAppVersion;
@property (nonatomic,copy)NSString *lastAppVersionName;

@property (nonatomic,copy)NSString *token;
@property (nonatomic,assign)BOOL needUpdate;
@property (nonatomic,assign)BOOL needPush;
@property (nonatomic,assign)BOOL formal;
@property (nonatomic,copy)NSString *localPath;

//verison 接口获取数据
@property (nonatomic,copy)NSString *pageVersion;
@property (nonatomic,copy)NSString *indexVersion;


//扫描
@property (nonatomic,copy)NSString *scanPluginID;
@property (nonatomic,copy)NSString *listenPluginID;
@property (nonatomic,copy)NSString *scanResult;

//定位坐标

@property (nonatomic,copy)NSString *mLatitude;
@property (nonatomic,copy)NSString *mLongtitude;
@property (nonatomic,copy)NSString *locationError;

+ (instancetype)sharedVersion;

@end
