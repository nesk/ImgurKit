//
//  ImgurPartialImage.h
//  ImgurKit
//
//  Created by Johann Pardanaud on 24/07/13.
//  Distributed under the MIT license.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const IKUploadedImagesKey;

// Not using NS_ENUM for backward compatibility with OS X 10.7
typedef enum {
    ImgurSmallSquareSize,
    ImgurBigSquareSize,
    ImgurSmallThumbnailSize,
    ImgurMediumThumbnailSize,
    ImgurLargeThumbnailSize,
    ImgurHugeThumbnailSize
} ImgurSize;

@class AFHTTPRequestOperation, RACSignal;

@interface IKBasicImage : NSObject

@property (nonatomic, readonly) NSString *imageID;

@property (nonatomic, readonly) NSString *deletehash;
@property (nonatomic, readonly) NSURL *link;

#pragma mark - Upload one image

+ (RACSignal *)uploadImageWithFileURL:(NSURL *)fileURL success:(void (^)(IKBasicImage *image))success failure:(void (^)(NSError *error))failure;
+ (RACSignal *)uploadImageWithFileURL:(NSURL *)fileURL title:(NSString *)title description:(NSString *)description andLinkToAlbumWithID:(NSString *)albumID success:(void (^)(IKBasicImage *image))success failure:(void (^)(NSError *error))failure;

+ (RACSignal *)uploadImageWithURL:(NSURL *)url success:(void (^)(IKBasicImage *image))success failure:(void (^)(NSError *error))failure;
+ (RACSignal *)uploadImageWithURL:(NSURL *)url title:(NSString *)title description:(NSString *)description filename:(NSString *)filename andLinkToAlbumWithID:(NSString *)albumID success:(void (^)(IKBasicImage *image))success failure:(void (^)(NSError *error))failure;

#pragma mark - Upload multiples images

+ (RACSignal *)uploadImagesWithFileURLs:(NSArray *)fileURLs success:(void (^)(NSArray *images))success failure:(void (^)(NSError *error))failure;
+ (RACSignal *)uploadImagesWithFileURLs:(NSArray *)fileURLs titles:(NSArray *)titles descriptions:(NSArray *)descriptions andLinkToAlbumWithID:(NSString *)albumID success:(void (^)(NSArray *images))success failure:(void (^)(NSError *error))failure;

+ (RACSignal *)uploadImagesWithURLs:(NSArray *)urls success:(void (^)(NSArray *images))success failure:(void (^)(NSError *error))failure;
+ (RACSignal *)uploadImagesWithURLs:(NSArray *)urls titles:(NSArray *)titles descriptions:(NSArray *)descriptions filenames:(NSArray *)filenames andLinkToAlbumWithID:(NSString *)albumID success:(void (^)(NSArray *images))success failure:(void (^)(NSError *error))failure;

#pragma mark - Load

- (instancetype)initWithJSONObject:(NSData *)object;

#pragma mark - Display

- (NSURL *)URLWithSize:(ImgurSize)size;

#pragma mark - Delete

+ (RACSignal *)deleteImageWithID:(NSString *)imageID success:(void (^)(NSString *imageID))success failure:(void (^)(NSError *error))failure;

@end
