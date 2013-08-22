//
//  JPImgurGalleryImage.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Distributed under the MIT license.
//

#import "JPImgurImage.h"
#import "JPImgurVote.h"

@interface JPImgurGalleryImage : JPImgurImage

@property (nonatomic, readonly) NSString *accountURL;

@property (nonatomic, readonly) NSInteger ups;
@property (nonatomic, readonly) NSInteger downs;
@property (nonatomic, readonly) NSInteger score;

@property (nonatomic) JPImgurVote vote;

#pragma mark - Load

+ (void)imageWithID:(NSString *)imageID success:(void (^)(JPImgurGalleryImage *image))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (instancetype)initWithJSONObject:(NSData *)object;

@end
