//
//  JPImgurPartialAlbum.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 24/07/13.
//  Distributed under the MIT license.
//

#import <Foundation/Foundation.h>

@interface JPImgurBasicAlbum : NSObject

@property (nonatomic, readonly) NSString *albumID;
@property (nonatomic, readonly) NSString *deletehash;

#pragma mark - Setting the album properties

+ (instancetype)albumWithID:(NSString *)albumID;
- (instancetype)initWithID:(NSString *)albumID;

- (instancetype)initWithJSONObject:(NSData *)object;

@end
