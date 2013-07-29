//
//  JPImgurPartialImage.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 24/07/13.
//  Distributed under the MIT license.
//

#import <Foundation/Foundation.h>

@interface JPImgurBasicImage : NSObject

@property (nonatomic, readonly) NSString *imageID;

@property (nonatomic, readonly) NSString *deletehash;
@property (nonatomic, readonly) NSURL *link;

#pragma mark -

- (void)setImagePropertiesWithJSONObject:(NSData *)object;

@end
