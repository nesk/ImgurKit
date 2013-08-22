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

#pragma mark - Create

+ (void)createAlbumWithTitle:(NSString *)title description:(NSString *)description imageIDs:(NSArray *)imageIDs success:(void (^)(JPImgurBasicAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)createAlbumWithTitle:(NSString *)title description:(NSString *)description imageIDs:(NSArray *)imageIDs privacy:(JPImgurPrivacy)privacy layout:(JPImgurLayout)layout cover:(JPImgurBasicImage *)cover success:(void (^)(JPImgurBasicAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Load

- (instancetype)initWithJSONObject:(NSData *)object;

#pragma mark - Delete

+ (void)deleteAlbumWithID:(NSString *)albumID success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
