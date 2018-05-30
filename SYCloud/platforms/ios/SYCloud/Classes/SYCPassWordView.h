//
//  SYCPassWordView.h
//  SYCloud
//
//  Created by 文清 on 2018/5/22.
//

#import <UIKit/UIKit.h>
//一会要传值的类型
typedef void(^NewBlock)(NSString*);
typedef void(^wrongBlock)(void);
@interface SYCPassWordView : UIView

@property (nonatomic,copy)NSString *password;
//声明block的属性
@property (nonatomic,copy) NewBlock MyBlock;

//声明block方法
- (void)chuanZhi:(NewBlock)block;

//声明block的属性
@property (nonatomic,copy) wrongBlock errBlock;

//声明block方法
- (void)error:(wrongBlock)block;

@end
