//
//  JPImgurImage.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 10/07/13.
//  Copyright (c) 2013 Johann PARDANAUD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPImgurImage : NSObject

@property (readonly) NSString *imageId;

@property NSString *title;
@property NSString *description;
@property (readonly) NSDate *datetime;

@property (readonly) NSString *type;
@property (readonly) BOOL animated;

@property (readonly) NSInteger width;
@property (readonly) NSInteger height;
@property (readonly) NSInteger size;

@property (readonly) NSInteger views;
@property (readonly) NSInteger bandwidth;

@property (readonly) NSString *deletehash;
@property (readonly) NSString *link;

@end
