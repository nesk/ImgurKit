//
//  IKGalleryAlbum.h
//  ImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Distributed under the MIT license.
//

#import "IKAlbum.h"
#import "IKVote.h"

@class RACSignal;

@interface IKGalleryAlbum : IKAlbum

@property (nonatomic, readonly) NSInteger ups;
@property (nonatomic, readonly) NSInteger downs;
@property (nonatomic, readonly) NSInteger score;

@property (nonatomic) IKVote vote;

#pragma mark - Submit

+ (RACSignal *)submitAlbumWithID:(NSString *)albumID title:(NSString *)title success:(void (^)(NSString *albumID))success failure:(void (^)(NSError *error))failure;
+ (RACSignal *)submitAlbumWithID:(NSString *)albumID title:(NSString *)title terms:(BOOL)terms success:(void (^)(NSString *albumID))success failure:(void (^)(NSError *error))failure;

#pragma mark - Load

+ (RACSignal *)albumWithID:(NSString *)albumID success:(void (^)(IKGalleryAlbum *album))success failure:(void (^)(NSError *error))failure;
- (instancetype)initWithJSONObject:(NSData *)object;

#pragma mark - Remove

+ (RACSignal *)removeAlbumWithID:(NSString *)albumID success:(void (^)(NSString *albumID))success failure:(void (^)(NSError *error))failure;

@end
