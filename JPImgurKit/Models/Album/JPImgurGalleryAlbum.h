//
//  JPImgurGalleryAlbum.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Distributed under the MIT license.
//

#import "JPImgurAlbum.h"
#import "JPImgurVote.h"

@interface JPImgurGalleryAlbum : JPImgurAlbum

@property (nonatomic, readonly) NSInteger ups;
@property (nonatomic, readonly) NSInteger downs;
@property (nonatomic, readonly) NSInteger score;

@property (nonatomic) JPImgurVote vote;

#pragma mark - Load

+ (void)albumWithID:(NSString *)albumID success:(void (^)(JPImgurGalleryAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (instancetype)initWithJSONObject:(NSData *)object;

@end
