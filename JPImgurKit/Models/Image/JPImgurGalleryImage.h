//
//  JPImgurGalleryImage.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Distributed under the MIT license.
//

#import "JPImgurImage.h"

@interface JPImgurGalleryImage : JPImgurImage

@property (nonatomic, readonly) NSString *accountURL;

@property (nonatomic, readonly) NSInteger ups;
@property (nonatomic, readonly) NSInteger downs;
@property (nonatomic, readonly) NSInteger score;

@property (nonatomic) NSInteger vote; // -1 = downvote, +1 = upvote, 0 = user hasn't vote yet

#pragma mark -

+ (void)imageWithID:(NSString *)imageID success:(void (^)(JPImgurGalleryImage *))success failure:(void (^)(NSError *))failure;
- (void)loadImageWithID:(NSString *)imageID success:(void (^)(JPImgurGalleryImage *))success failure:(void (^)(NSError *))failure;
- (void)setImagePropertiesWithJSONObject:(NSData *)object;

@end
