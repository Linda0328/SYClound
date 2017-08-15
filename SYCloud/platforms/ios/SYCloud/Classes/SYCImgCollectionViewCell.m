//
//  SYCImgCollectionViewCell.m
//  SYCloud
//
//  Created by 文清 on 2017/8/12.
//
//

#import "SYCImgCollectionViewCell.h"


@implementation SYCImgCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageV = [[UIImageView alloc]initWithFrame:CGRectInset(self.bounds, 4, 0)];
        _imageV.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_imageV];
    }
    return self;
}

@end
