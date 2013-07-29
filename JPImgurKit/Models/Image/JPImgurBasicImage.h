//
//  JPImgurPartialImage.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 24/07/13.
//  Distributed under the MIT license.
//

#import <Foundation/Foundation.h>

// Not using NS_ENUM for backward compatibility with OS X 10.7 and 10.6
typedef enum {
    JPImgurSmallSquare,
    JPImgurBigSquare,
    JPImgurSmallThumbnail,
    JPImgurMediumThumbnail,
    JPImgurLargeThumbnail,
    JPImgurHugeThumbnail
} JPImgurSize;

@interface JPImgurBasicImage : NSObject

@property (nonatomic, readonly) NSString *imageID;

@property (nonatomic, readonly) NSString *deletehash;
@property (nonatomic, readonly) NSURL *link;

#pragma mark - Setting the image properties

- (void)setImagePropertiesWithJSONObject:(NSData *)object;

#pragma mark - Displaying the image

- (NSURL *)URLWithSize:(JPImgurSize)size;

@end
