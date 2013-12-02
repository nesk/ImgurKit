//
//  IKGalleryImage.h
//  ImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Distributed under the MIT license.
//

#import "IKImage.h"
#import "IKVote.h"

@class RACSignal;

@interface IKGalleryImage : IKImage

@property (nonatomic, readonly) NSString *accountURL;

@property (nonatomic, readonly) NSInteger ups;
@property (nonatomic, readonly) NSInteger downs;
@property (nonatomic, readonly) NSInteger score;

@property (nonatomic) IKVote vote;

#pragma mark - Submit

+ (RACSignal *)submitImageWithID:(NSString *)imageID title:(NSString *)title success:(void (^)(NSString *imageID))success failure:(void (^)(NSError *error))failure;
+ (RACSignal *)submitImageWithID:(NSString *)imageID title:(NSString *)title terms:(BOOL)terms success:(void (^)(NSString *imageID))success failure:(void (^)(NSError *error))failure;

#pragma mark - Load

+ (RACSignal *)imageWithID:(NSString *)imageID success:(void (^)(IKGalleryImage *image))success failure:(void (^)(NSError *error))failure;
- (instancetype)initWithJSONObject:(NSData *)object;

#pragma mark - Remove

+ (RACSignal *)removeImageWithID:(NSString *)imageID success:(void (^)(NSString *imageID))success failure:(void (^)(NSError *error))failure;

@end
