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
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
    data = [data objectForKey:@"data"];
    
    _albumID = [data objectForKey:@"id"];
    _title = [data objectForKey:@"title"];
    _description = [data objectForKey:@"description"];
    _datetime = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"datetime"] integerValue]];
    _cover = [data objectForKey:@"cover"];
    _accountURL = [data objectForKey:@"account_url"];
    _privacy = [data objectForKey:@"privacy"];
    _layout = [data objectForKey:@"layout"];
    _views = [[data objectForKey:@"views"] integerValue];
    _link = [data objectForKey:@"link"];
    _imagesCount = [[data objectForKey:@"images_count"] integerValue];
    _images = [data objectForKey:@"images"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"albumID: %@; title: \"%@\"; description: \"%@\"; datetime: %@; cover: %@; accountURL: \"%@\"; privacy: %@; layout: %@; views: %ld; link: %@; imagesCount: %ld",
            _albumID, _title, _description, _datetime, _cover, _accountURL, _privacy, _layout, (long)_views, _link, (long)_imagesCount];
}

@end
