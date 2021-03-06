//
//  SYCEventModel.h
//  SYCloud
//
//  Created by 文清 on 2017/3/17.
//
//

#import <Foundation/Foundation.h>
extern NSString *const backType;
extern NSString *const groupType;
@interface SYCEventModel : NSObject
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *event;
@property (nonatomic,copy)NSString *ico;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong)NSArray *group;
@end
