//
//  JPImgurAlbum.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Copyright (c) 2013 Johann PARDANAUD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPImgurAlbum : NSObject

@property (readonly) NSString* albumID;

@property NSString *title;
@property NSString *description;
@property (readonly) NSDate *datetime;
@property NSString *cover;

@property (readonly) NSString *accountURL;

@property NSString *privacy;
@property NSString *layout;

@property (readonly) NSInteger views;
@property (readonly) NSString *link;

@property (readonly) NSInteger imagesCount; // Optional: can be set to NSNotFound
@property NSArray *images; // Optional: can be set to nil

@end
