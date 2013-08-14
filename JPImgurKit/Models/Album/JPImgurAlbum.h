//
//  JPImgurAlbum.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Distributed under the MIT license.
//

#import "JPImgurBasicAlbum.h"

@class AFHTTPRequestOperation, JPImgurBasicImage;

// Not using NS_ENUM for backward compatibility with OS X 10.7 and 10.6
typedef enum {
    JPImgurDefaultPrivacy,
    JPImgurPublicPrivacy,
    JPImgurHiddenPrivacy,
    JPImgurSecretPrivacy
} JPImgurPrivacy;

typedef enum {
    JPImgurDefaultLayout,
    JPImgurBlogLayout,
    JPImgurGridLayout,
    JPImgurHorizontalLayout,
    JPImgurVerticalLayout
} JPImgurLayout;

@interface JPImgurAlbum : JPImgurBasicAlbum

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *description;
@property (nonatomic, readonly) NSDate *datetime;
@property (nonatomic) NSString *cover;

@property (nonatomic, readonly) NSString *accountURL;

@property (nonatomic) NSString *privacy;
@property (nonatomic) NSString *layout;

@property (nonatomic, readonly) NSInteger views;
@property (nonatomic, readonly) NSString *link;

@property (nonatomic, readonly) NSInteger imagesCount; // Optional: can be set to NSNotFound
@property (nonatomic) NSArray *images; // Optional: can be set to nil

#pragma mark - Uploading an image

+ (void)createAlbumWithTitle:(NSString *)title description:(NSString *)description images:(NSArray *)images success:(void (^)(JPImgurBasicAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)createAlbumWithTitle:(NSString *)title description:(NSString *)description images:(NSArray *)images privacy:(JPImgurPrivacy)privacy layout:(JPImgurLayout)layout cover:(JPImgurBasicImage *)cover success:(void (^)(JPImgurBasicAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Loading the album properties

+ (void)albumWithID:(NSString *)albumID success:(void (^)(JPImgurAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (instancetype)initWithJSONObject:(NSData *)object;

@end
