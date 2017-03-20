//
//  SYCNavTitleModel.h
//  SYCloud
//
//  Created by 文清 on 2017/3/15.
//
//

#import <Foundation/Foundation.h>
extern NSString *const noneType;
extern NSString *const titleType;
extern NSString *const imageType;
extern NSString *const searchType;
extern NSString *const optionType;
@interface SYCNavTitleModel : NSObject
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong)NSDictionary *value;
@end
