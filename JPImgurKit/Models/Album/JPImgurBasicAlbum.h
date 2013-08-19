//
//  JPImgurPartialAlbum.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 24/07/13.
//  Distributed under the MIT license.
//

#import <Foundation/Foundation.h>

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

@class AFHTTPRequestOperation, JPImgurBasicImage;

@interface JPImgurBasicAlbum : NSObject

@property (nonatomic, readonly) NSString *albumID;
@property (nonatomic, readonly) NSString *deletehash;

#pragma mark - Creating an album

+ (void)createAlbumWithTitle:(NSString *)title description:(NSString *)description images:(NSArray *)images success:(void (^)(JPImgurBasicAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)createAlbumWithTitle:(NSString *)title description:(NSString *)description images:(NSArray *)images privacy:(JPImgurPrivacy)privacy layout:(JPImgurLayout)layout cover:(JPImgurBasicImage *)cover success:(void (^)(JPImgurBasicAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Deleting an album

+ (void)deleteAlbum:(JPImgurBasicAlbum *)album success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Setting the album properties

+ (instancetype)albumWithID:(NSString *)albumID;
- (instancetype)initWithID:(NSString *)albumID;

- (instancetype)initWithJSONObject:(NSData *)object;

@end
