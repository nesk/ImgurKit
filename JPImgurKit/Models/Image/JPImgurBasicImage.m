//
//  JPImgurPartialImage.m
//  JPImgurKit
//
//  Created by Johann Pardanaud on 24/07/13.
//  Distributed under the MIT license.
//

#import "JPImgurBasicImage.h"

@implementation JPImgurBasicImage

- (void)setImagePropertiesWithJSONObject:(NSData *)object
{
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
    data = [data objectForKey:@"data"];
    
    _imageID = [data objectForKey:@"id"];
    _deletehash = [data objectForKey:@"deletehash"];
    _link = [NSURL URLWithString:[data objectForKey:@"link"]];
}

#pragma mark - Displaying the image

- (NSURL *)URLWithSize:(JPImgurSize)size
{
    NSString *stringURL = [_link absoluteString];
    NSInteger dotLocation = [stringURL rangeOfString:@"." options:NSBackwardsSearch].location;
    NSString *firstPart = [stringURL substringToIndex:dotLocation];
    NSString *secondPart = [stringURL substringFromIndex:dotLocation];
    
    switch (size) {
        case JPImgurSmallSquare:
            stringURL = [NSString stringWithFormat:@"%@s%@", firstPart, secondPart];
            break;
            
        case JPImgurBigSquare:
            stringURL = [NSString stringWithFormat:@"%@b%@", firstPart, secondPart];
            break;
            
        case JPImgurSmallThumbnail:
            stringURL = [NSString stringWithFormat:@"%@t%@", firstPart, secondPart];
            break;
            
        case JPImgurMediumThumbnail:
            stringURL = [NSString stringWithFormat:@"%@m%@", firstPart, secondPart];
            break;
            
        case JPImgurLargeThumbnail:
            stringURL = [NSString stringWithFormat:@"%@l%@", firstPart, secondPart];
            break;
            
        case JPImgurHugeThumbnail:
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
