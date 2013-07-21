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

+ (void)imageWithID:(NSString *)imageID success:(void (^)(JPImgurImage *))success failure:(void (^)(NSError *))failure
{
    [[JPImgurImage alloc] loadImageWithID:imageID success:success failure:failure];
}

- (void)loadImageWithID:(NSString *)imageID success:(void (^)(JPImgurImage *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"image/%@", imageID];
    
    [[JPImgurClient sharedInstance] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setImagePropertiesWithJSONObject:responseObject];
        success(self);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)setImagePropertiesWithJSONObject:(NSData *)object
{
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
    data = [data objectForKey:@"data"];
    
    _imageID = [data objectForKey:@"id"];
    _title = [data objectForKey:@"title"];
    _description = [data objectForKey:@"description"];
    _datetime = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"datetime"] integerValue]];
    _type = [data objectForKey:@"type"];
    _animated = [[data objectForKey:@"animated"] boolValue];
    _width = [[data objectForKey:@"width"] integerValue];
    _height = [[data objectForKey:@"height"] integerValue];
    _size = [[data objectForKey:@"size"] integerValue];
    _views = [[data objectForKey:@"views"] integerValue];
    _bandwidth = [[data objectForKey:@"bandwidth"] integerValue];
    _deletehash = [data objectForKey:@"deletehash"];
    _link = [data objectForKey:@"link"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"imageID: %@; title: \"%@\"; description: \"%@\"; datetime: %@; type: %@; animated: %d; width: %ld; height: %ld; size: %ld; views: %ld; bandwidth: %ld; deletehash: %@; link: %@",
            _imageID, _title, _description, _datetime, _type, _animated, (long)_width, (long)_height, (long)_size, (long)_views, (long)_bandwidth, _deletehash, _link];
}

@end
