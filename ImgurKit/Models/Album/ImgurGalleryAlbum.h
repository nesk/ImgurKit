//
//  ImgurGalleryAlbum.h
//  ImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Distributed under the MIT license.
//

#import "ImgurAlbum.h"
#import "ImgurVote.h"

@interface ImgurGalleryAlbum : ImgurAlbum

@property (nonatomic, readonly) NSInteger ups;
@property (nonatomic, readonly) NSInteger downs;
@property (nonatomic, readonly) NSInteger score;

@property (nonatomic) ImgurVote vote;

#pragma mark - Submit

+ (void)submitAlbumWithID:(NSString *)albumID title:(NSString *)title success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)submitAlbumWithID:(NSString *)albumID title:(NSString *)title terms:(BOOL)terms success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Load

+ (void)albumWithID:(NSString *)albumID success:(void (^)(ImgurGalleryAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (instancetype)initWithJSONObject:(NSData *)object;

#pragma mark - Remove

+ (void)removeAlbumWithID:(NSString *)albumID success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
