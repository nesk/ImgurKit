//
//  ImgurImage.h
//  ImgurKit
//
//  Created by Johann Pardanaud on 10/07/13.
//  Distributed under the MIT license.
//

#import "ImgurBasicImage.h"

@interface ImgurImage : ImgurBasicImage

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *description;
@property (nonatomic, readonly) NSDate *datetime;

@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) BOOL animated;

@property (nonatomic, readonly) NSInteger width;
@property (nonatomic, readonly) NSInteger height;
@property (nonatomic, readonly) NSInteger size;

@property (nonatomic, readonly) NSInteger views;
@property (nonatomic, readonly) NSInteger bandwidth;

#pragma mark - Load

+ (void)imageWithID:(NSString *)imageID success:(void (^)(ImgurImage *image))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (instancetype)initWithJSONObject:(NSData *)object;

@end
