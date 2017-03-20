//
//  SYCNavigationBarModel.h
//  SYCloud
//
//  Created by 文清 on 2017/3/15.
//
//

#import <Foundation/Foundation.h>

@interface SYCNavigationBarModel : NSObject
@property (nonatomic,copy)NSString *url;
@property (nonatomic,strong)NSDictionary *title;
@property (nonatomic,strong)NSArray *leftBtns;
@property (nonatomic,strong)NSArray *rightBtns;
@end
