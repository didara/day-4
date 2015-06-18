//
//  PhotoController.h
//  Day 4 tutorial
//
//  Created by Didara Pernebayeva on 18.06.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PhotoController : NSObject

+ (void) imageForPhoto: (NSDictionary *) photo size: ( NSString *) size completion: (void(^) (UIImage *)) completion;



@end
