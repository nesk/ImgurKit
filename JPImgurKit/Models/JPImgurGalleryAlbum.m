//
//  JPImgurGalleryAlbum.m
//  JPImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Distributed under the MIT license.
//

#import "JPImgurGalleryAlbum.h"
#import "JPImgurClient.h"

@implementation JPImgurGalleryAlbum

+ (void)albumWithClient:(JPImgurClient *)client albumID:(NSString *)albumID success:(void (^)(JPImgurGalleryAlbum *))success failure:(void (^)(NSError *))failure
{
    JPImgurGalleryAlbum *album = [JPImgurGalleryAlbum new];
    album.client = client;
    [album loadAlbumWithID:albumID success:success failure:failure];
}

- (void)loadAlbumWithID:(NSString *)albumID success:(void (^)(JPImgurGalleryAlbum *))success failure:(void (^)(NSError *))failure
{
    [self checkForUndefinedClient];
    
    NSString *path = [NSString stringWithFormat:@"gallery/album/%@", albumID];
    
    [self.client getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setAlbumPropertiesWithJSONObject:responseObject];
        success(self);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)setAlbumPropertiesWithJSONObject:(NSData *)object
{
    [super setAlbumPropertiesWithJSONObject:object];
    
    NSDictionary *data = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
    data = (NSDictionary *)[data objectForKey:@"data"];
    
    _ups = [[data objectForKey:@"ups"] integerValue];
    _downs = [[data objectForKey:@"downs"] integerValue];
    _score = [[data objectForKey:@"score"] integerValue];
    
    NSString *vote = (NSString *)[data objectForKey:@"vote"];
    if([vote isEqualToString: @"up"])
        _vote = 1;
    else if ([vote isEqualToString:@"down"])
        _vote = -1;
    else
        _vote = 0;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"%@; ups: %ld; downs: %ld; score: %ld; vote: %ld",
            [super description], (long)_ups, (long)_downs, (long)_score, (long)_vote];
}

@end
