//
//  ImgurPartialImage.m
//  ImgurKit
//
//  Created by Johann Pardanaud on 24/07/13.
//  Distributed under the MIT license.
//

#import "IKBasicImage.h"

#import "NSError+ImgurKit.h"
#import "IKClient.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

NSString * const IKUploadedImagesKey = @"IKUploadedImages";

@implementation IKBasicImage;

#pragma mark - Upload one image

+ (RACSignal *)uploadImageWithFileURL:(NSURL *)fileURL success:(void (^)(IKBasicImage *))success failure:(void (^)(NSError *))failure
{
    return [self uploadImageWithFileURL:fileURL title:nil description:nil andLinkToAlbumWithID:nil success:success failure:failure];
}

+ (RACSignal *)uploadImageWithFileURL:(NSURL *)fileURL title:(NSString *)title description:(NSString *)description andLinkToAlbumWithID:(NSString *)albumID success:(void (^)(IKBasicImage *))success failure:(void (^)(NSError *))failure
{
    IKClient *client = [IKClient sharedInstance];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    [parameters setObject:@"file" forKey:@"type"];
    
    // Add used parameters
    
    if(title != nil)
        [parameters setObject:title forKey:@"title"];
    if(description != nil)
        [parameters setObject:description forKey:@"description"];
    if(albumID != nil)
        [parameters setObject:albumID forKey:@"album"];
    
    // Create the request with the file appended to the body

    __block NSError *fileAppendingError = nil;
    
    void (^appendFile)(id<AFMultipartFormData> formData) = ^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:fileURL name:@"image" error:&fileAppendingError];
    };
    
    NSURLRequest *request = [client multipartFormRequestWithMethod:@"POST"
                                                              path:@"image"
                                                        parameters:parameters
                                         constructingBodyWithBlock:appendFile];
    
    // Return a signal that creates and runs the operation

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // If there's a file appending error, we must abort and return the error

        if(fileAppendingError) {
            [subscriber sendError:fileAppendingError];
            if(failure)
                failure(fileAppendingError);

            return nil;
        }

        // Create the operation

        AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            IKBasicImage *image = [[IKBasicImage alloc] initWithJSONObject:responseObject];

            [subscriber sendNext:image];
            [subscriber sendCompleted];
            if(success)
                success(image);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSError *finalError = [NSError errorWithError:error additionalUserInfo:@{ IKHTTPRequestOperationKey: operation }];

            [subscriber sendError:finalError];
            if(failure)
                failure(finalError);
        }];

        [client enqueueHTTPRequestOperation:operation];

        return nil;
    }] replayLast];
}

+ (RACSignal *)uploadImageWithURL:(NSURL *)url success:(void (^)(IKBasicImage *))success failure:(void (^)(NSError *))failure
{
    return [self uploadImageWithURL:url title:nil description:nil filename:nil andLinkToAlbumWithID:nil success:success failure:failure];
}

+ (RACSignal *)uploadImageWithURL:(NSURL *)url title:(NSString *)title description:(NSString *)description filename:(NSString *)filename andLinkToAlbumWithID:(NSString *)albumID success:(void (^)(IKBasicImage *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    [parameters setObject:[url absoluteString] forKey:@"image"];
    [parameters setObject:@"URL" forKey:@"type"];
    
    // Add used parameters
    
    if(title != nil)
        [parameters setObject:title forKey:@"title"];
    if(description != nil)
        [parameters setObject:description forKey:@"description"];
    if(filename != nil)
        [parameters setObject:filename forKey:@"filename"];
    if(albumID != nil)
        [parameters setObject:albumID forKey:@"album"];
    
    // Return a signal that creates and run the operation

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[IKClient sharedInstance] postPath:@"image" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            IKBasicImage *image = [[IKBasicImage alloc] initWithJSONObject:responseObject];

            [subscriber sendNext:image];
            [subscriber sendCompleted];
            if(success)
                success(image);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSError *finalError = [NSError errorWithError:error additionalUserInfo:@{ IKHTTPRequestOperationKey: operation }];

            [subscriber sendError:finalError];
            if(failure)
                failure(finalError);
        }];
        
        return nil;
    }] replayLast];
}

#pragma mark - Upload multiples images

+ (RACSignal *)uploadImagesWithFileURLs:(NSArray *)fileURLs success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    return [self uploadImagesWithFileURLs:fileURLs titles:nil descriptions:nil andLinkToAlbumWithID:nil success:success failure:failure];
}

+ (RACSignal *)uploadImagesWithFileURLs:(NSArray *)fileURLs titles:(NSArray *)titles descriptions:(NSArray *)descriptions andLinkToAlbumWithID:(NSString *)albumID success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSInteger filesNumber = [fileURLs count];

    // Check for invalid number of values

    if( (titles != nil && filesNumber != [titles count]) && (descriptions != nil && filesNumber != [descriptions count]) ) {
        @throw [NSException exceptionWithName:@"ImgurArrayLengthException"
                                       reason:@"There should be as much titles and descriptions as file URLs (or set them to `nil`)"
                                     userInfo:@{ @"fileURLs": fileURLs,
                                                 @"titles": titles,
                                                 @"descriptions": descriptions }];
    }

    // Return a signal that handles all the upload process

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if(filesNumber > 0) {
            __block NSMutableArray *images = [NSMutableArray new];
            RACSignal *uploadQueue = [self uploadImageWithFileURL:fileURLs[0] title:(titles ? titles[0] : nil) description:(descriptions ? descriptions[0] : nil) andLinkToAlbumWithID:albumID success:nil failure:nil];

            for(NSInteger i = 1 ; i < filesNumber ; i++) {
                uploadQueue = [uploadQueue flattenMap:^RACStream *(IKBasicImage *image) {
                    [images addObject:image];
                    return [self uploadImageWithFileURL:fileURLs[i] title:(titles ? titles[i] : nil) description:(descriptions ? descriptions[i] : nil) andLinkToAlbumWithID:albumID success:nil failure:nil];
                }];
            }

            [uploadQueue subscribeNext:^(IKBasicImage *image) {
                [images addObject:image]; // Add the final image

                [subscriber sendNext:images];
                [subscriber sendCompleted];
                if(success)
                    success(images);
            } error:^(NSError *error) {
                NSError *finalError = [NSError errorWithError:error additionalUserInfo:@{ IKUploadedImagesKey: images }];

                [subscriber sendError:finalError];
                if(failure)
                    failure(finalError);
            }];
        }

        return nil;
    }] replayLast];
}

+ (RACSignal *)uploadImagesWithURLs:(NSArray *)urls success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    return [self uploadImagesWithURLs:urls titles:nil descriptions:nil filenames:nil andLinkToAlbumWithID:nil success:success failure:failure];
}

+ (RACSignal *)uploadImagesWithURLs:(NSArray *)urls titles:(NSArray *)titles descriptions:(NSArray *)descriptions filenames:(NSArray *)filenames andLinkToAlbumWithID:(NSString *)albumID success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSInteger urlsNumber = [urls count];

    // Check for invalid number of values

    if( (titles != nil && urlsNumber != [titles count]) && (descriptions != nil && urlsNumber != [descriptions count]) && (filenames != nil && urlsNumber != [filenames count]) ) {
        @throw [NSException exceptionWithName:@"ImgurArrayLengthException"
                                       reason:@"There should be as much titles, descriptions and filenames as file URLs (or set them to `nil`)"
                                     userInfo:@{ @"urls": urls,
                                                 @"titles": titles,
                                                 @"descriptions": descriptions,
                                                 @"filenames": filenames }];
    }

    // Return a signal that handles all the upload process

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if(urlsNumber > 0) {
            __block NSMutableArray *images = [NSMutableArray new];
            RACSignal *uploadQueue = [self uploadImageWithURL:urls[0] title:(titles ? titles[0] : nil) description:(descriptions ? descriptions[0] : nil) filename:(filenames ? filenames[0] : nil) andLinkToAlbumWithID:albumID success:nil failure:nil];

            for(NSInteger i = 1 ; i < urlsNumber ; i++) {
                uploadQueue = [uploadQueue flattenMap:^RACStream *(IKBasicImage *image) {
                    [images addObject:image];
                    return [self uploadImageWithURL:urls[i] title:(titles ? titles[i] : nil) description:(descriptions ? descriptions[i] : nil) filename:(filenames ? filenames[i] : nil) andLinkToAlbumWithID:albumID success:nil failure:nil];
                }];
            }

            [uploadQueue subscribeNext:^(IKBasicImage *image) {
                [images addObject:image]; // Add the final image

                [subscriber sendNext:images];
                [subscriber sendCompleted];
                if(success)
                    success(images);
            } error:^(NSError *error) {
                NSError *finalError = [NSError errorWithError:error additionalUserInfo:@{ IKUploadedImagesKey: images }];

                [subscriber sendError:finalError];
                if(failure)
                    failure(finalError);
            }];
        }
        
        return nil;
    }] replayLast];
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

- (NSURL *)URLWithSize:(ImgurSize)size
{
    NSString *stringURL = [_link absoluteString];
    NSInteger dotLocation = [stringURL rangeOfString:@"." options:NSBackwardsSearch].location;
    NSString *firstPart = [stringURL substringToIndex:dotLocation];
    NSString *secondPart = [stringURL substringFromIndex:dotLocation];
    
    switch (size) {
        case ImgurSmallSquareSize:
            stringURL = [NSString stringWithFormat:@"%@s%@", firstPart, secondPart];
            break;
            
        case ImgurBigSquareSize:
            stringURL = [NSString stringWithFormat:@"%@b%@", firstPart, secondPart];
            break;
            
        case ImgurSmallThumbnailSize:
            stringURL = [NSString stringWithFormat:@"%@t%@", firstPart, secondPart];
            break;
            
        case ImgurMediumThumbnailSize:
            stringURL = [NSString stringWithFormat:@"%@m%@", firstPart, secondPart];
            break;
            
        case ImgurLargeThumbnailSize:
            stringURL = [NSString stringWithFormat:@"%@l%@", firstPart, secondPart];
            break;
            
        case ImgurHugeThumbnailSize:
            stringURL = [NSString stringWithFormat:@"%@h%@", firstPart, secondPart];
            break;
            
        default:
            return nil;
    }
    
    return [NSURL URLWithString:stringURL];
}

#pragma mark - Delete

+ (RACSignal *)deleteImageWithID:(NSString *)imageID success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"image/%@", imageID];

    // Return a signal that creates and runs the operation

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [[IKClient sharedInstance] deletePath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:imageID];
            [subscriber sendCompleted];
            if(success)
                success(imageID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSError *finalError = [NSError errorWithError:error additionalUserInfo:@{ IKHTTPRequestOperationKey: operation }];

            [subscriber sendError:finalError];
            if(failure)
                failure(finalError);
        }];

        return nil;
    }] replayLast];
}

#pragma mark - Describe

- (NSString *)description
{
    return [NSString stringWithFormat:@"imageID: %@; deletehash: %@; link: %@", _imageID, _deletehash, [_link absoluteString]];
}

@end
