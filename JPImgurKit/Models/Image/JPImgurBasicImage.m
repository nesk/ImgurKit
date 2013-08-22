//
//  JPImgurPartialImage.m
//  JPImgurKit
//
//  Created by Johann Pardanaud on 24/07/13.
//  Distributed under the MIT license.
//

#import "JPImgurBasicImage.h"
#import "JPImgurClient.h"

@implementation JPImgurBasicImage;

#pragma mark - Upload

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

#pragma mark - Load

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

#pragma mark - Display

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

#pragma mark - Delete

+ (void)deleteImageWithID:(NSString *)imageID success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"image/%@", imageID];
    
    [[JPImgurClient sharedInstance] deletePath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:failure];
}

#pragma mark - Describe

- (NSString *)description
{
    return [NSString stringWithFormat:@"imageID: %@; deletehash: %@; link: %@", _imageID, _deletehash, [_link absoluteString]];
}

@end
