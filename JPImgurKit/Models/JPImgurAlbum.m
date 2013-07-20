//
//  JPImgurAlbum.m
//  JPImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Distributed under the MIT license.
//

#import "JPImgurAlbum.h"
#import "JPImgurClient.h"

@implementation JPImgurAlbum

+ (void)albumWithClient:(JPImgurClient *)client albumID:(NSString *)albumID success:(void (^)(JPImgurAlbum *))success failure:(void (^)(NSError *))failure
{
    JPImgurAlbum *album = [JPImgurAlbum new];
    album.client = client;
    [album loadAlbumWithID:albumID success:success failure:failure];
}

- (void)loadAlbumWithID:(NSString *)albumID success:(void (^)(JPImgurAlbum *))success failure:(void (^)(NSError *))failure
{
    [self checkForUndefinedClient];
    
    NSString *path = [NSString stringWithFormat:@"album/%@", albumID];
    
    [self.client getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setAlbumPropertiesWithJSONObject:responseObject];
        success(self);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)setAlbumPropertiesWithJSONObject:(NSData *)object
{
    NSDictionary *data = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
    data = (NSDictionary *)[data objectForKey:@"data"];
    
    _albumID = (NSString *)[data objectForKey:@"id"];
    _title = (NSString *)[data objectForKey:@"title"];
    _description = (NSString *)[data objectForKey:@"description"];
    _datetime = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"datetime"] integerValue]];
    _cover = (NSString *)[data objectForKey:@"cover"];
    _accountURL = (NSString *)[data objectForKey:@"account_url"];
    _privacy = (NSString *)[data objectForKey:@"privacy"];
    _layout = (NSString *)[data objectForKey:@"layout"];
    _views = [[data objectForKey:@"views"] integerValue];
    _link = (NSString *)[data objectForKey:@"link"];
    _imagesCount = [[data objectForKey:@"images_count"] integerValue];
    _images = (NSArray *)[data objectForKey:@"images"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"albumID: %@; title: \"%@\"; description: \"%@\"; datetime: %@; cover: %@; accountURL: \"%@\"; privacy: %@; layout: %@; views: %ld; link: %@; imagesCount: %ld",
            _albumID, _title, _description, _datetime, _cover, _accountURL, _privacy, _layout, (long)_views, _link, (long)_imagesCount];
}

@end
