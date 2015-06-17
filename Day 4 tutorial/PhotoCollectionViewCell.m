//
//  PhotoCollectionViewCell.m
//  Day 4 tutorial
//
//  Created by Didara Pernebayeva on 17.06.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

-( instancetype) initWithFrame:(CGRect)frame;
{
    self= [super initWithFrame:frame];
    
    if (self) {
        self.imageView = [UIImageView new];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}
@end
