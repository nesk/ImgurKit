//
//  IKAlbum.h
//  ImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Distributed under the MIT license.
//

#import "IKBasicAlbum.h"

@class RACSignal;

@interface IKAlbum : IKBasicAlbum

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *description;
@property (nonatomic, readonly) NSDate *datetime;
@property (nonatomic) NSString *cover;

@property (nonatomic, readonly) NSString *accountURL;

@property (nonatomic) NSString *privacy;
@property (nonatomic) NSString *layout;

@property (nonatomic, readonly) NSInteger views;
@property (nonatomic, readonly) NSString *link;

@property (nonatomic, readonly) NSInteger imagesCount; // Optional: can be set to NSNotFound
@property (nonatomic) NSArray *images; // Optional: can be set to nil

#pragma mark - Load

+ (RACSignal *)albumWithID:(NSString *)albumID success:(void (^)(IKAlbum *album))success failure:(void (^)(NSError *error))failure;
- (instancetype)initWithJSONObject:(NSData *)object error:(NSError *__autoreleasing *)error;

@end
