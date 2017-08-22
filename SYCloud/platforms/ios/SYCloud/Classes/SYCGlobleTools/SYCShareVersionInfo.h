//
//  SYCShareVersionInfo.h
//  SYCloud
//
//  Created by 文清 on 2017/3/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SYCAliPayModel.h"
#import "SYCWXPayModel.h"
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
@property (nonatomic,copy)NSString *pagePackage;
@property (nonatomic,copy)NSString *indexVersion;

@property (nonatomic,assign)BOOL downPageOrNot;

//扫描
@property (nonatomic,copy)NSString *scanPluginID;
@property (nonatomic,copy)NSString *listenPluginID;
@property (nonatomic,copy)NSString *scanResult;

//定位坐标

@property (nonatomic,copy)NSString *mLatitude;//纬度
@property (nonatomic,copy)NSString *mLongitude;//经度
@property (nonatomic,copy)NSString *mCity;//城市
@property (nonatomic,copy)NSString *mDistrict;//地区
@property (nonatomic,copy)NSString *mStreet;//街道
@property (nonatomic,copy)NSString *mAddrStr;//地址信息
@property (nonatomic,copy)NSString *locationError;

@property (nonatomic,copy)NSString *aliPayPluginID;
@property (nonatomic,strong)SYCAliPayModel *aliPayModel;
@property (nonatomic,copy)NSString *wxPayPluginID;
@property (nonatomic,strong)SYCWXPayModel *wxPayModel;

@property (nonatomic,copy)NSString *paymentID;

@property (nonatomic,copy)NSString *paymentImmedatelyID;
@property (nonatomic,copy)NSString *paymentScanID;
@property (nonatomic,copy)NSString *paymentCodeID;
@property (nonatomic,copy)NSString *paymentSDKID;
//@property (nonatomic,strong)NSMutableArray *presentedVCs;
@property (nonatomic,copy)NSString *thirdPartScheme;

@property (nonatomic,copy)NSString *sharePluginID;

+ (instancetype)sharedVersion;

@end
