//
//  SYCEventModel.h
//  SYCloud
//
//  Created by 文清 on 2017/3/17.
//
//

#import <Foundation/Foundation.h>

@interface SYCEventModel : NSObject
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *ico;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong)NSDictionary *group;
@end
