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

#pragma mark - Loading the album properties

+ (void)albumWithID:(NSString *)albumID success:(void (^)(JPImgurAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"album/%@", albumID];
    
    [[JPImgurClient sharedInstance] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([[self alloc] initWithJSONObject:responseObject]);
    } failure:failure];
}

- (instancetype)initWithJSONObject:(NSData *)object
{
    self = [super initWithJSONObject:object];
    
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
    data = [data objectForKey:@"data"];

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
    
    return self;
}

#pragma mark -

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"%@; title: \"%@\"; description: \"%@\"; datetime: %@; cover: %@; accountURL: \"%@\"; privacy: %@; layout: %@; views: %ld; link: %@; imagesCount: %ld",
            [super description], _title, _description, _datetime, _cover, _accountURL, _privacy, _layout, (long)_views, _link, (long)_imagesCount];
}

@end
