//
//  SYCPassWordModel.h
//  SYCloud
//
//  Created by 文清 on 2017/4/22.
//
//

#import <Foundation/Foundation.h>

@interface SYCPassWordModel : NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *psw;
@property(nonatomic,strong)NSDictionary *param;
@end
