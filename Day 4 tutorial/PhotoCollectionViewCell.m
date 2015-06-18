//
//  PhotoCollectionViewCell.m
//  Day 4 tutorial
//
//  Created by Didara Pernebayeva on 17.06.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "PhotoController.h"

@implementation PhotoCollectionViewCell

-(instancetype) initWithFrame:(CGRect)frame;
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

-(void)setPhoto:(NSDictionary *)photo
{
    _photo=photo;
    
    [PhotoController imageForPhoto:self.photo size:@"thumbnail" completion:^(UIImage *image) {
        self.imageView.image = image;
        
    }];
    
//    [PhotoController imageForPhoto:self.photo size:@"thumbnail" completion:^void *(UIImage *) {
//        
//    }];
  
}



-(void) downloadImage
{
    
NSLog(@"%@", self.photo);
    NSURL *url = [[NSURL alloc] initWithString: self.photo [@"images"] [@"thumbnail"] [@"url"]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        UIImage *image = [[UIImage alloc] initWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
        
    }];
    [task resume];

}
@end
