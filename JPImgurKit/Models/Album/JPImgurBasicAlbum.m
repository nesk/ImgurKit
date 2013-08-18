//
//  JPImgurPartialAlbum.m
//  JPImgurKit
//
//  Created by Johann Pardanaud on 24/07/13.
//  Distributed under the MIT license.
//

#import "JPImgurBasicAlbum.h"

@implementation JPImgurBasicAlbum

+ (instancetype)albumWithID:(NSString *)albumID
{
    return [[self alloc] initWithID:albumID];
}

- (instancetype)initWithID:(NSString *)albumID
{
    self = [super init];
    
    _albumID = albumID;
    
    return self;
}

- (instancetype)initWithJSONObject:(NSData *)object
{
    self = [super init];
    
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
    data = [data objectForKey:@"data"];
    
    _albumID = [data objectForKey:@"id"];
    _deletehash = [data objectForKey:@"deletehash"];
    
    return self;
}

#pragma mark -

- (NSString *)description
{
    return [NSString stringWithFormat:@"albumID: %@; deletehash: %@", _albumID, _deletehash];
}

@end
