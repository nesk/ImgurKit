//
//  JPImgurImage.m
//  JPImgurKit
//
//  Created by Johann Pardanaud on 10/07/13.
//  Distributed under the MIT license.
//

#import "JPImgurImage.h"
#import "JPImgurClient.h"

@implementation JPImgurImage

+ (void)imageWithClient:(JPImgurClient *)client imageID:(NSString *)imageID success:(void (^)(JPImgurImage *))success failure:(void (^)(NSError *))failure
{
    JPImgurImage *image = [JPImgurImage new];
    image.client = client;
    [image loadImageWithID:imageID success:success failure:failure];
}

- (void)loadImageWithID:(NSString *)imageID success:(void (^)(JPImgurImage *))success failure:(void (^)(NSError *))failure
{
    [self checkForUndefinedClient];
    
    NSString *path = [NSString stringWithFormat:@"image/%@", imageID];
    
    [self.client getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setImagePropertiesWithJSONObject:responseObject];
        success(self);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)setImagePropertiesWithJSONObject:(NSData *)object
{
    NSDictionary *data = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
    data = (NSDictionary *)[data objectForKey:@"data"];
    
    _imageID = (NSString *)[data objectForKey:@"id"];
    _title = (NSString *)[data objectForKey:@"title"];
    _description = (NSString *)[data objectForKey:@"description"];
    _datetime = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"datetime"] integerValue]];
    _type = (NSString *)[data objectForKey:@"type"];
    _animated = [[data objectForKey:@"animated"] boolValue];
    _width = [[data objectForKey:@"width"] integerValue];
    _height = [[data objectForKey:@"height"] integerValue];
    _size = [[data objectForKey:@"size"] integerValue];
    _views = [[data objectForKey:@"views"] integerValue];
    _bandwidth = [[data objectForKey:@"bandwidth"] integerValue];
    _deletehash = (NSString *)[data objectForKey:@"deletehash"];
    _link = (NSString *)[data objectForKey:@"link"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"imageID: %@; title: \"%@\"; description: \"%@\"; datetime: %@; type: %@; animated: %d; width: %ld; height: %ld; size: %ld; views: %ld; bandwidth: %ld; deletehash: %@; link: %@",
            _imageID, _title, _description, _datetime, _type, _animated, (long)_width, (long)_height, (long)_size, (long)_views, (long)_bandwidth, _deletehash, _link];
}

@end
