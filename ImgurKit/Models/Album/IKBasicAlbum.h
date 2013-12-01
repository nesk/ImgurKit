//
//  ImgurPartialAlbum.h
//  ImgurKit
//
//  Created by Johann Pardanaud on 24/07/13.
//  Distributed under the MIT license.
//

#import <Foundation/Foundation.h>

// Not using NS_ENUM for backward compatibility with OS X 10.7
typedef enum {
    ImgurDefaultPrivacy,
    ImgurPublicPrivacy,
    ImgurHiddenPrivacy,
    ImgurSecretPrivacy
} ImgurPrivacy;

typedef enum {
    ImgurDefaultLayout,
    ImgurBlogLayout,
    ImgurGridLayout,
    ImgurHorizontalLayout,
    ImgurVerticalLayout
} ImgurLayout;

@class AFHTTPRequestOperation, ImgurBasicImage;

@interface ImgurBasicAlbum : NSObject

@property (nonatomic, readonly) NSString *albumID;
@property (nonatomic, readonly) NSString *deletehash;

#pragma mark - Create

+ (void)createAlbumWithTitle:(NSString *)title description:(NSString *)description imageIDs:(NSArray *)imageIDs success:(void (^)(ImgurBasicAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)createAlbumWithTitle:(NSString *)title description:(NSString *)description imageIDs:(NSArray *)imageIDs privacy:(ImgurPrivacy)privacy layout:(ImgurLayout)layout cover:(ImgurBasicImage *)cover success:(void (^)(ImgurBasicAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Load

- (instancetype)initWithJSONObject:(NSData *)object;

#pragma mark - Delete

+ (void)deleteAlbumWithID:(NSString *)albumID success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
