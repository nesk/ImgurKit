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
    IKDefaultPrivacy,
    IKPublicPrivacy,
    IKHiddenPrivacy,
    IKSecretPrivacy
} IKPrivacy;

typedef enum {
    IKDefaultLayout,
    IKBlogLayout,
    IKGridLayout,
    IKHorizontalLayout,
    IKVerticalLayout
} IKLayout;

@class AFHTTPRequestOperation, RACSignal, IKBasicImage;

@interface IKBasicAlbum : NSObject

@property (nonatomic, readonly) NSString *albumID;
@property (nonatomic, readonly) NSString *deletehash;

#pragma mark - Create

+ (RACSignal *)createAlbumWithTitle:(NSString *)title description:(NSString *)description imageIDs:(NSArray *)imageIDs success:(void (^)(IKBasicAlbum *album))success failure:(void (^)(NSError *error))failure;
+ (RACSignal *)createAlbumWithTitle:(NSString *)title description:(NSString *)description imageIDs:(NSArray *)imageIDs privacy:(IKPrivacy)privacy layout:(IKLayout)layout cover:(IKBasicImage *)cover success:(void (^)(IKBasicAlbum *album))success failure:(void (^)(NSError *error))failure;

#pragma mark - Load

- (instancetype)initWithJSONObject:(NSData *)object;

#pragma mark - Delete

+ (RACSignal *)deleteAlbumWithID:(NSString *)albumID success:(void (^)(NSString *albumID))success failure:(void (^)(NSError *error))failure;

@end
