//
//  IKGalleryImage.h
//  ImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Distributed under the MIT license.
//

#import "IKImage.h"
#import "IKVote.h"

@interface IKGalleryImage : IKImage

@property (nonatomic, readonly) NSString *accountURL;

@property (nonatomic, readonly) NSInteger ups;
@property (nonatomic, readonly) NSInteger downs;
@property (nonatomic, readonly) NSInteger score;

@property (nonatomic) IKVote vote;

#pragma mark - Submit

+ (void)submitImageWithID:(NSString *)imageID title:(NSString *)title success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)submitImageWithID:(NSString *)imageID title:(NSString *)title terms:(BOOL)terms success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Load

+ (void)imageWithID:(NSString *)imageID success:(void (^)(IKGalleryImage *image))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (instancetype)initWithJSONObject:(NSData *)object;

#pragma mark - Remove

+ (void)removeImageWithID:(NSString *)imageID success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
