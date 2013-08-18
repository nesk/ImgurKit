//
//  JPImgurPartialImage.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 24/07/13.
//  Distributed under the MIT license.
//

#import <Foundation/Foundation.h>

// Not using NS_ENUM for backward compatibility with OS X 10.7 and 10.6
typedef enum {
    JPImgurSmallSquareSize,
    JPImgurBigSquareSize,
    JPImgurSmallThumbnailSize,
    JPImgurMediumThumbnailSize,
    JPImgurLargeThumbnailSize,
    JPImgurHugeThumbnailSize
} JPImgurSize;

@class AFHTTPRequestOperation;

@interface JPImgurBasicImage : NSObject

@property (nonatomic, readonly) NSString *imageID;

@property (nonatomic, readonly) NSString *deletehash;
@property (nonatomic, readonly) NSURL *link;

#pragma mark - Uploading an image

+ (void)uploadImageWithFileURL:(NSURL *)fileURL success:(void (^)(JPImgurBasicImage *image))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)uploadImageWithFileURL:(NSURL *)fileURL title:(NSString *)title description:(NSString *)description andLinkToAlbumWithID:(NSString *)albumID success:(void (^)(JPImgurBasicImage *image))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)uploadImageWithURL:(NSURL *)url success:(void (^)(JPImgurBasicImage *image))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)uploadImageWithURL:(NSURL *)url title:(NSString *)title description:(NSString *)description filename:(NSString *)filename andLinkToAlbumWithID:(NSString *)albumID success:(void (^)(JPImgurBasicImage *image))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Setting the image properties

+ (instancetype)imageWithID:(NSString *)imageID;
- (instancetype)initWithID:(NSString *)imageID;

- (instancetype)initWithJSONObject:(NSData *)object;

#pragma mark - Displaying the image

- (NSURL *)URLWithSize:(JPImgurSize)size;

@end
