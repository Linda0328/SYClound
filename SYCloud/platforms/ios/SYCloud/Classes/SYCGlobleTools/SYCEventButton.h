//
//  SYCEventButton.h
//  SYCloud
//
//  Created by 文清 on 2017/3/20.
//
//

#import <UIKit/UIKit.h>
#import "SYCEventModel.h"
@interface SYCEventButton : UIButton
@property (nonatomic,copy)NSString *event;
@property (nonatomic,strong)SYCEventModel *model;
@end
