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

+ (void)uploadImageWithFileURL:(NSURL *)fileURL success:(void (^)(JPImgurBasicImage *image))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self uploadImageWithFileURL:fileURL title:nil description:nil andLinkToAlbumWithID:nil success:success failure:failure];
}

+ (void)uploadImageWithFileURL:(NSURL *)fileURL title:(NSString *)title description:(NSString *)description andLinkToAlbumWithID:(NSString *)albumID success:(void (^)(JPImgurBasicImage *image))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    JPImgurClient *client = [JPImgurClient sharedInstance];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    [parameters setObject:@"file" forKey:@"type"];
    
    // Adding used parameters:
    
    if(title != nil)
        [parameters setObject:title forKey:@"title"];
    if(description != nil)
        [parameters setObject:description forKey:@"description"];
    if(albumID != nil)
        [parameters setObject:albumID forKey:@"album"];
    
    // Creating the request:
    
    void (^appendFile)(id<AFMultipartFormData> formData) = ^(id<AFMultipartFormData> formData) {
        NSError *error;
        
        if(![formData appendPartWithFileURL:fileURL name:@"image" error:&error])
            @throw [NSException exceptionWithName:@"FileAppendingError"
                                           reason:error.localizedDescription
                                         userInfo:[NSDictionary dictionaryWithObject:error forKey:@"error"]];
    };
    
    NSURLRequest *request = [client multipartFormRequestWithMethod:@"POST"
                                                              path:@"image"
                                                        parameters:parameters
                                         constructingBodyWithBlock:appendFile];
    
    // Creating the operation:
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([[JPImgurBasicImage alloc] initWithJSONObject:responseObject]);
    } failure:failure];
    
    [client enqueueHTTPRequestOperation:operation];
}

+ (void)uploadImageWithURL:(NSURL *)url success:(void (^)(JPImgurBasicImage *image))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self uploadImageWithURL:url title:nil description:nil filename:nil andLinkToAlbumWithID:nil success:success failure:failure];
}

+ (void)uploadImageWithURL:(NSURL *)url title:(NSString *)title description:(NSString *)description filename:(NSString *)filename andLinkToAlbumWithID:(NSString *)albumID success:(void (^)(JPImgurBasicImage *image))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    [parameters setObject:[url absoluteString] forKey:@"image"];
    [parameters setObject:@"URL" forKey:@"type"];
    
    // Adding used parameters:
    
    if(title != nil)
        [parameters setObject:title forKey:@"title"];
    if(description != nil)
        [parameters setObject:description forKey:@"description"];
    if(filename != nil)
        [parameters setObject:filename forKey:@"filename"];
    if(albumID != nil)
        [parameters setObject:albumID forKey:@"album"];
    
    // Creating the request:
    
    [[JPImgurClient sharedInstance] postPath:@"image" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([[JPImgurBasicImage alloc] initWithJSONObject:responseObject]);
    } failure:failure];
}

#pragma mark - Loading the image properties

+ (void)imageWithID:(NSString *)imageID success:(void (^)(JPImgurImage *image))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"image/%@", imageID];
    
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
    _type = [data objectForKey:@"type"];
    _animated = [[data objectForKey:@"animated"] boolValue];
    _width = [[data objectForKey:@"width"] integerValue];
    _height = [[data objectForKey:@"height"] integerValue];
    _size = [[data objectForKey:@"size"] integerValue];
    _views = [[data objectForKey:@"views"] integerValue];
    _bandwidth = [[data objectForKey:@"bandwidth"] integerValue];
    
    return self;
}

#pragma mark - Visualizing the image properties

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"%@; title: \"%@\"; description: \"%@\"; datetime: %@; type: %@; animated: %d; width: %ld; height: %ld; size: %ld; views: %ld; bandwidth: %ld",
            [super description], _title, _description, _datetime, _type, _animated, (long)_width, (long)_height, (long)_size, (long)_views, (long)_bandwidth];
}

@end
