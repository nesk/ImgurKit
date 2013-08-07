//
//  JPImgurPartialImage.m
//  JPImgurKit
//
//  Created by Johann Pardanaud on 24/07/13.
//  Distributed under the MIT license.
//

#import "JPImgurBasicImage.h"

@implementation JPImgurBasicImage

- (instancetype)initWithJSONObject:(NSData *)object
{
    self = [super init];
    
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
    data = [data objectForKey:@"data"];
    
    _imageID = [data objectForKey:@"id"];
    _deletehash = [data objectForKey:@"deletehash"];
    _link = [NSURL URLWithString:[data objectForKey:@"link"]];
    
    return self;
}

#pragma mark - Displaying the image

- (NSURL *)URLWithSize:(JPImgurSize)size
{
    NSString *stringURL = [_link absoluteString];
    NSInteger dotLocation = [stringURL rangeOfString:@"." options:NSBackwardsSearch].location;
    NSString *firstPart = [stringURL substringToIndex:dotLocation];
    NSString *secondPart = [stringURL substringFromIndex:dotLocation];
    
    switch (size) {
        case JPImgurSmallSquareSize:
            stringURL = [NSString stringWithFormat:@"%@s%@", firstPart, secondPart];
            break;
            
        case JPImgurBigSquareSize:
            stringURL = [NSString stringWithFormat:@"%@b%@", firstPart, secondPart];
            break;
            
        case JPImgurSmallThumbnailSize:
            stringURL = [NSString stringWithFormat:@"%@t%@", firstPart, secondPart];
            break;
            
        case JPImgurMediumThumbnailSize:
            stringURL = [NSString stringWithFormat:@"%@m%@", firstPart, secondPart];
            break;
            
        case JPImgurLargeThumbnailSize:
            stringURL = [NSString stringWithFormat:@"%@l%@", firstPart, secondPart];
            break;
            
        case JPImgurHugeThumbnailSize:
            stringURL = [NSString stringWithFormat:@"%@h%@", firstPart, secondPart];
            break;
            
        default:
            return nil;
    }
    
    return [NSURL URLWithString:stringURL];
}

#pragma mark - Visualizing the image properties

- (NSString *)description
{
    return [NSString stringWithFormat:@"imageID: %@; deletehash: %@; link: %@", _imageID, _deletehash, [_link absoluteString]];
}

@end
